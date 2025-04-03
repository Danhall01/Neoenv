vim.api.nvim_create_augroup('Config', { clear = true });

-- Editor Style
vim.opt.background = 'dark';
vim.opt.termguicolors = true;

-- Behaviour
vim.opt.autoread = true;
vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "CursorHoldI", "FocusGained"}, {
    desc = "Reloads buffer on update",
    pattern = {'*'},
    group = 'Config',
    command = "if mode() != 'c' | checktime | endif",
});
vim.opt.autowriteall = true;
vim.opt.confirm = true;
vim.opt.mouse = 'a';
vim.opt.mousehide = true;
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.scrolloff = 6;

-- Code Styling
vim.opt.autoindent = true;
vim.opt.expandtab = true;
vim.opt.shiftwidth = 4;
vim.opt.softtabstop = 4;
vim.opt.tabstop = 4;
