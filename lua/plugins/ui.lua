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
            local constclr = "#5de4c7";
            local spec = {
                github_dark = {
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
                        keyword = "#557bad",
                        number = "#add7ff",
                        -- operator = "",
                        preproc = constclr,
                        regex = "#e2bec6",
                        -- statement = "",
                        string = "#91b4d5",
                        type = typeclr,
                        variable = varclr,
                    }
                }
            }


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
        opts = {}
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

}
