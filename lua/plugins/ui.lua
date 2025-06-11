return {
    -- Themes
    { -- Used by "LuaLine"
        'olivercederborg/poimandres.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('poimandres').setup {
                disable_background = true, -- disable background
            }
        end,
        init = function()
            -- vim.cmd("colorscheme poimandres")
        end
    },
    {
        'projekt0n/github-nvim-theme',
        lazy = false,
        priority = 1000,
        dependensies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            --local Color = require('github-theme.lib.color')

            local opts = {
                transparent = true,
                styles = {
                    comments = "italic",
                    functions = "bold"
                },
            }

            -- "Mint skyline" - Nick // @Creator Daniel Häll
            local spec = {
                github_dark = {
                    syntax = {
                        --bracket = "#900000",
                        --builtin0 = "#900000",
                        --builtin1 = "#900000",
                        --builtin2 = "#900000",
                        comment = "#7390aa",
                        conditional = "#135048",
                        const = "#31EAEA",
                        --dep = "#900000",
                        --field = "#900000",
                        func = "#399AA8",
                        --ident = "#900000",
                        keyword = "#9A67FF",
                        number = "#31EAEA",
                        --operator = "#900000",
                        preproc = "#6C58A6",
                        regex = "#e2bec6",
                        --statement = "#900000",
                        string = "#91b4d5",
                        type = "#26867d",
                        variable = "#A9CAE9",
                    },
                },
            };
            require('github-theme').setup({
                options = opts,
                specs = spec,
            })
        end,
        init = function()
            vim.cmd("colorscheme github_dark")
            --vim.api.nvim_set_hl(0, "normal", {fg = "#2C8A86", bg="NONE"}); -- Default colors
            vim.api.nvim_set_hl(0, "@lsp.typemod.macro.globalscope.c", { fg="#6D35A9", bg="none" }); -- Macro
            vim.api.nvim_set_hl(0, "@lsp.type.variable", {fg="#A9CAE9"})

            vim.api.nvim_set_hl(0, "cStorageClass", {fg = "#1D8A99"}); -- E.g static 

            vim.api.nvim_set_hl(0, "@lsp.typemod.class.filescope.c", { fg="#7153AC" }); -- struct / class
            vim.api.nvim_set_hl(0, "@lsp.typemod.property.classScope.c", {fg="#86B3DF"}); -- class.property (Higher order in c/c++)
            vim.api.nvim_set_hl(0, "@lsp.type.property", {fg="#86B3DF"}); -- table.property

            vim.api.nvim_set_hl(0, "@lsp.typemod.function.definition.c", {fg="#025A66"}); -- ... fname(...){}
            vim.api.nvim_set_hl(0, "@lsp.typemod.parameter.functionScope.c", {fg="#81B6EA"}); -- ...(type Param)
        end
    },

    -- Inline colors
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = { -- set to setup table
        },
        keys = {
            { "<leader>ct", function() vim.cmd("ColorizerToggle") end,           mode = 'n', desc = "Toggle inline colors" },
        },
    },

    -- Devicons (Nerdfont icons)
    {
        "nvim-tree/nvim-web-devicons",
    },

    -- Indentation visualiser
    {
        "lukas-reineke/indent-blankline.nvim",
        dependensies = {
            "nvim-treesitter/nvim-treesitter",
        },
        priority = 0,
        lazy = false,
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
        config = function()
            require("ibl").setup {
                indent = { char = { '┆', '▎', } },
                scope = { enabled = true },
            }
        end
    },

    -- Notification addon
    {
        "rcarriga/nvim-notify",
        dependensies = {},
        priority = 0,
        lazy = false,
        config = function()
            require("notify").setup({
                background_color = "NotifyBackground",
                fps = 165,
                timeout = 5000,
                top_down = true,
                render = "default",
                stages = "slide",
            });
        end,
        init = function()
            vim.notify = require("notify");

            vim.api.nvim_create_augroup("notify", { clear = true });
            vim.api.nvim_create_autocmd({ "BufLeave", "BufEnter" }, {
                desc = "Clear notify history when leaving / entering a new buffer",
                pattern = "*.*",
                group = "notify",
                callback = function(_)
                    vim.notify.clear_history();
                end
            });
        end
    },

    -- LuaLine
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        priority = 0,
        dependensies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                icons_enabled = true,
                -- theme = "horizon",
                theme = "github_dark",
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                }
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {},
                lualine_x = { "encoding", "filetype" },
                lualine_y = { "lsp_status", "progress" },
                lualine_z = { "location", "fileformat" }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {
                lualine_a = { "filename" },
                lualine_b = { function()
                    local context = require("nvim-treesitter").statusline(
                        {
                            indicator_size = 800,
                            type_patterns = { "class", "function", "method", "interface", "type_spec", "table", "if_statement", "for_in_statement" },
                            separator = "  ",
                        }
                    );
                    if not context then return "" end;
                    if context == "" then return "global" end;
                    return context;
                end },
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        },
    },

}
