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
            local Color = require('github-theme.lib.color')

            local opts = {
                transparent = true,
                styles = {
                    comments = "italic",
                    functions = "bold"
                },
            }

            -- "Mint skyline" - Nick // @Creator Daniel Häll
            local typeclr = "#26867d";
            local varclr = "#add7ff";
            local constclr = "#9A67FF";
            local spec = {
                github_dark = {
                    red = "#C43022",


                    bg1 = "#454551",
                    bg0 = "#1B1B2D",


                    syntax = {
                        -- bracket = "",
                        builtin0 = varclr,
                        builtin1 = typeclr,
                        builtin2 = constclr,
                        comment = "#7390aa",
                        -- conditional = "",
                        const = constclr,
                        -- field = "",
                        func = "#01f9c6",
                        -- ident = "",
                        keyword = "#5F8CE6",
                        number = "#DDC697",
                        -- operator = "",
                        preproc = constclr,
                        regex = "#e2bec6",
                        -- statement = "",
                        string = "#91b4d5",
                        type = typeclr,
                        variable = varclr,
                    },

                    inactive = "bg0",
                },
            };

            require('github-theme').setup({
                options = opts,
                specs = spec,
            })
        end,
        init = function()
            vim.cmd("colorscheme github_dark")
        end
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
                theme = "poimandres",
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
