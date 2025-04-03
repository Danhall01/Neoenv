-- Rebind :make for external terminal usage
vim.api.nvim_create_user_command("TMake", function (argv)
    local height = 20;

    vim.cmd("botright new");
    vim.cmd("resize "..tostring(height))

    vim.cmd("terminal make "..(argv.args or ""));
    vim.wo.number = false;
    vim.wo.relativenumber = false;
    vim.wo.signcolumn = "no";

    vim.cmd("startinsert");
end, {
    force = true,
    desc = "Extends :make command to run in temporary external terminal",
    nargs = '*',
});



