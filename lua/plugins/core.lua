return {
    -- ALE: lsp + Linting / Fixing

    -- LSP-Config: LSP
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        priority = 100,
        dependencies = {
            "saghen/blink.cmp",
        },
        opts = {
            servers = {
                lua_ls = {
                    on_init = function(client)
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                            return
                        end

                        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                -- (most likely LuaJIT in the case of Neovim)
                                version = 'LuaJIT'
                            },
                            -- Make the server aware of Neovim runtime files
                            workspace = {
                                checkThirdParty = false,
                                --library = {
                                -- vim.env.VIMRUNTIME,
                                -- Depending on the usage, you might want to add additional paths here.
                                -- "${3rd}/luv/library",
                                -- "${3rd}/busted/library",
                                -- }
                                library = vim.api.nvim_get_runtime_file("", true),
                                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                -- library = vim.api.nvim_get_runtime_file("", true)
                            }
                        })
                    end,
                    settings = {
                        Lua = {}
                    }
                },
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=gnu",
                    },
                    init_options = {
                        fallbackFlags = { "-Wall", "-Wextra", "-Wpedantic", },
                    },
                },
                cmake = {
                    cmd = {
                        "cmake-language-server",
                    },
                    init_options = {
                        buildDirectory = "build",
                    },
                },
            },
        },
        config = function(_, opts)
            local lspconfig = require("lspconfig");
            local signs = { Error = '-', Warn = 'W', Info = ' ', Hint = "󰰂 " };

            for server, config in pairs(opts.servers) do
                config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities);
                lspconfig[server].setup(config);
            end

            -- Update leftmost symbol for diagnostic
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type;
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl });
            end
        end,
        keys = {
            { "<C-j>", function() vim.diagnostic.jump({ count = -1, float = true }); end, mode = 'n', desc = "Jump to next error" },
            { "<C-k>", function() vim.diagnostic.jump({ count = 1, float = true }); end,  mode = 'n', desc = "Jump to previous error" },
            {
                "<C-w>",
                function()
                    local valid_filetypes = { 'c', "cpp", 'h', "hpp" };
                    local found = false;
                    for _, filetype in ipairs(valid_filetypes) do
                        if string.find(vim.bo.filetype, filetype, 1, true) then
                            found = true;
                            break;
                        end
                    end
                    if not found then
                        vim.notify("Cannot swap header-source files outside of C/C++", 4,
                            { title = "Invalid filetype for operation", })
                        return;
                    end
                    vim.cmd("ClangdSwitchSourceHeader");
                end,
                mode = 'n',
                desc = "Swap between .h and .c files"
            },

            --{ "D",          function() vim.lsp.buf.definition(); end,      mode = 'n', desc = "Go to definition" },
            { "<leader>gd", function() vim.lsp.buf.declaration(); end,    mode = 'n', desc = "Go to declaration" },
            --{ "T",          function() vim.lsp.buf.type_definition(); end, mode = 'n', desc = "Go to type definition" },
            { "I",          function() vim.lsp.buf.implementation(); end, mode = 'n', desc = "Go to implementation" },
            --{ "F",          function() vim.lsp.buf.references(); end,      mode = 'n', desc = "Find all references" },
            { "K",          function() vim.lsp.buf.hover(); end,          mode = 'n', desc = "Open window with information of hovered element" },

            { "<F2>",       function() vim.lsp.buf.rename(); end,         mode = 'n', desc = "Rename hovered element" },
            { "<leader>ca", function() vim.lsp.buf.code_action(); end,    mode = 'n', desc = "Attempt to fix problem under hover" },
        },
    },
    -- Auto-Completion
    {
        "saghen/blink.cmp",
        -- Optional snippets
        dependencies = {
            "rafamadriz/friendly-snippets",
            "xzbdmw/colorful-menu.nvim",
        },
        version = '*',
        lazy = false,
        priority = 100,
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                preset = "default",
                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = false,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'normal',

                kind_icons = {
                    Text = '󰉿',
                    Method = '󰊕',
                    Function = '󰊕',
                    Constructor = '󰒓',

                    Field = '󰜢',
                    Variable = '󰆦',
                    Property = '󰖷',

                    Class = '󱡠',
                    Interface = '󱡠',
                    Struct = '󱡠',
                    Module = '󰅩',

                    Unit = '󰪚',
                    Value = '󰦨',
                    Enum = '󰦨',
                    EnumMember = '󰦨',

                    Keyword = '󰻾',
                    Constant = '󰏿',

                    Snippet = '󱄽',
                    Color = '󰏘',
                    File = '󰈔',
                    Reference = '󰬲',
                    Folder = '󰉋',
                    Event = '󱐋',
                    Operator = '󰪚',
                    TypeParameter = '󰬛',
                },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "lazydev", 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    }
                }
            },

            -- Custom
            completion = {
                list = {
                    selection = {
                        preselect = function()
                            return vim.fn.mode() == 'i';
                        end,
                        auto_insert = false
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                    treesitter_highlighting = true,
                    window = {
                        border = "double",
                        winblend = 0,
                        scrollbar = false,
                    }
                },
                ghost_text = { enabled = true, show_with_selection = true, show_without_selection = false },
                menu = {
                    enabled = true,
                    border = "rounded",
                    winblend = 0,
                    scrollbar = false,
                    auto_show = true,
                    winhighlight =
                    "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                    draw = {
                        treesitter = { "lsp" },
                        padding = 2,
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                width = { fill = true, max = 60 },
                                text = function(ctx)
                                    local highlights_info = require("colorful-menu").blink_highlights(ctx)
                                    if highlights_info ~= nil then
                                        -- Or you want to add more item to label
                                        return highlights_info.label
                                    else
                                        return ctx.label
                                    end
                                end,
                                highlight = function(ctx)
                                    local highlights = {}
                                    local highlights_info = require("colorful-menu").blink_highlights(ctx)
                                    if highlights_info ~= nil then
                                        highlights = highlights_info.highlights
                                    end
                                    for _, idx in ipairs(ctx.label_matched_indices) do
                                        table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                                    end
                                    -- Do something else
                                    return highlights
                                end,
                            },
                        },
                    }
                },
            }
        },
        opts_extend = { "sources.default" },
    },
    -- Extended colors for blink.cmp
    {
        "xzbdmw/colorful-menu.nvim",
        lazy = false,
        config = function()
            -- You don't need to set these options.
            require("colorful-menu").setup({
                ls = {
                    lua_ls = {
                        extra_info_hl = "@comment",
                        align_type_to_right = true,
                        -- Maybe you want to dim arguments a bit.
                        arguments_hl = "@comment",
                    },
                    clangd = {
                        -- Such as "From <stdio.h>".
                        extra_info_hl = "@comment",
                        -- Similar to the same setting of gopls.
                        align_type_to_right = true,
                        -- the hl group of leading dot of "•std::filesystem::permissions(..)"
                        import_dot_hl = "@comment",
                    },

                    -- If true, try to highlight "not supported" languages.
                    fallback = true,
                },
                -- If the built-in logic fails to find a suitable highlight group,
                -- this highlight is applied to the label.
                fallback_highlight = "@variable",
                -- If provided, the plugin truncates the final displayed text to
                -- this width (measured in display cells). Any highlights that extend
                -- beyond the truncation point are ignored. When set to a float
                -- between 0 and 1, it'll be treated as percentage of the width of
                -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
                -- Default 60.
                max_width = 60,
            });
        end,
    },
    -- Extended LUA support for Blink.cmp
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                "nvim-dap-ui",
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        lazy = false,
        config = true,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        priority = 100,
        config = function()
        end,
        keys = {},
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
                callback = function() vim.treesitter.start() end,
            })
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo.indentexpr = "v:vim.require'nvim-treesitter'.indentexpr()"
        end,
        build = function()
            vim.cmd("TSUpdate");
            require("nvim-treesitter").install { 'c', "lua", "vim", "vimdoc" }
        end,
    },

    -- Telescope / search box
    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        lazy = false,
        priority = 100,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "BurntSushi/ripgrep",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        keys = {
            --- Navigation
            { "<leader>nf", function() require("telescope.builtin").find_files() end,                                   mode = 'n', desc = "Navigate files with telescope" },
            { "<leader>ns", function() require("telescope.builtin").live_grep() end,                                    mode = 'n', desc = "Search cwd with live grep" },
            { "<leader>ns", function() require("telescope.builtin").grep_string() end,                                  mode = 'v', desc = "Grabs the currently selected area into the search" },
            { "<leader>hk", function() require("telescope.builtin").keymaps() end,                                      mode = 'n', desc = "Get current keymaps (Help)" },

            --- LSP
            { "F",          function() require("telescope.builtin").lsp_references() end,                               mode = 'n', desc = "Get all references through telescope" },
            { "D",          function() require("telescope.builtin").lsp_definitions() end,                              mode = 'n', desc = "Find definition, open telescope if there are multiple" },
            { "<leader>D",  function() require("telescope.builtin").lsp_type_definitions() end,                         mode = 'n', desc = "Find type definitions, open telescope if multiple" },

            --- Git
            { "<leader>gb", function() require("telescope.builtin").git_branches() end,                                 mode = 'n', desc = "List all branches with telescope" },

            --- Misc
            { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols({ symbols = "function" }) end, mode = 'n', desc = "Lists functions from treesitter" },
            { "<leader>ts", function() require("telescope.builtin").lsp_document_symbols({}) end,                       mode = 'n', desc = "Lists all lsp symbols from treesitter" },
        },
    },
    -- Telescope dependencies
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
    },


    -- CMake Workflow
    {
        "Civitasv/cmake-tools.nvim",
        dependencies = {
            "stevearc/overseer.nvim",
            "akinsho/toggleterm.nvim",
        },
        lazy = false,
        priority = 100,
        opts = {
            cmake_generate_options = {
                "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
                "-DCMAKE_C_COMPILER=clang",
            },

            cmake_build_directory = function()
                local osys = require("cmake-tools.osys");
                if osys.iswin32 then
                    return "build\\${variant:buildType}"
                end
                return "build/${variant:buildType}"
            end,
            cmake_dap_configuration = { -- debug settings for cmake
                name = "cpp",
                type = "lldb",
                request = "launch",
                stopOnEntry = false,
                runInTerminal = true,
                console = "integratedTerminal",
            },

            cmake_executor = {
                name = "terminal",
                default_opts = {
                    terminal = {
                        split_size = 10,
                    },
                },
            },

            cmake_runner = {
                default_opts = {
                    terminal = {
                        split_size = 10,
                    },
                },
            },
        },
        keys = {
            { "<F4>",         function() vim.cmd("CMakeRun"); end,             mode = 'n', desc = "CMake-tools: Build and run program" },
            { "<leader><F5>", function() vim.cmd("CMakeDebugCurrentFile") end, mode = 'n', desc = "CMake-tools: Start debugger from current file" },
            { "<leader><F2>", function() vim.cmd("CMakeSelectBuildType") end,  mode = 'n', desc = "CMake-tools: Select target configuration for CMake" },
        },
    },
    {
        "stevearc/overseer.nvim",
        lazy = false,
        priority = 100,
        opts = {},
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        lazy = false,
        priority = 100,
        opts = {

        }
    },

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        priority = 100,
        config = function()
            local dap = require("dap")
            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb-dap', -- adjust as needed, must be absolute path
                name = 'lldb'
            }
            dap.configurations.c = {
                {
                    name = 'Launch',
                    type = 'lldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},
                },
            }
            dap.configurations.cpp = dap.configurations.c;
            dap.configurations.rust = dap.configurations.c;
        end,
        keys = {
            { "<leader>db",  function() require("dap").toggle_breakpoint(); end, mode = 'n', desc = "dap: Set breakpoint" },
            -- { "<leader>dc",  function() require("dap").toggle_breakpoint(); end,                                     mode = 'n', desc = "dap: Set conditional breakpoint" },

            { "<F5>",        function() require("dap").continue(); end,          mode = 'n', desc = "dap: Continue execution" },
            { "<shift><F5>", function() require("dap").restart(); end,           mode = 'n', desc = "dap: Restart execution" },

            { "<F10>",       function() require("dap").step_over(); end,         mode = 'n', desc = "dap: Step over" },
            { "<F11>",       function() require("dap").step_into(); end,         mode = 'n', desc = "dap: Step into" },
            { "<F12>",       function() require("dap").step_out(); end,          mode = 'n', desc = "dap: Step out" },

            { "<leader>ds",  function() require("dap.ui.widgets").hover(); end,  mode = 'n', desc = "dap: Inspect" },
        },
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = false,
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        priority = 100,
        opts = {
            enabled = true,
            -- only_first_definition = false,
            -- all_references = true,

            --virt_text_pos = "eol",
            -- comment = true,
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = false,
        priority = 100,
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        opts = {

        },
        config = function()

        end
    },




}
