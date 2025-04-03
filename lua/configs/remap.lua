-- <leader> key
vim.g.mapleader = " ";

-- Navigation
vim.keymap.set("n", "<leader>nv", vim.cmd.Ex)

-- Delete into void instead of cpy buffer
vim.keymap.set("x", "<leader>p", "\"_dP");
vim.keymap.set("n", "<leader>d", "\"_d");
vim.keymap.set("v", "<leader>d", "\"_d");

-- Copy to clipboard
vim.keymap.set("n", "<leader>y", "\"+y");
vim.keymap.set("v", "<leader>y", "\"+y");


-- Insert mode with indentation
vim.keymap.set('n', "i", function ()
    return string.match(vim.api.nvim_get_current_line(), '%g') == nil and "cc" or 'i'
end, { expr=true, noremap=true });


