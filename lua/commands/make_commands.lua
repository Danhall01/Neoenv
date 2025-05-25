local function TerminalExec(cmd)
    local height = 20;

    vim.cmd("botright new");
    vim.cmd("resize " .. tostring(height))

    vim.cmd("terminal " .. cmd);
    vim.wo.number = false;
    vim.wo.relativenumber = false;
    vim.wo.signcolumn = "no";

    vim.cmd("startinsert");
end


vim.api.nvim_create_user_command("Term", function(argv)
    TerminalExec((argv.args or ""));
end, {
    force = true,
    desc = "Attempts to execute the given arguments as a shell command into a termporary terminal.",
    nargs = '*',
});



-- TMake: Utilise the 'make' command for external terminal usage
-- Tip: -C build for CMake builds
vim.api.nvim_create_user_command("TMake", function(argv)
    TerminalExec("make " .. (argv.args or ""));
end, {
    force = true,
    desc = "Extends :make command to run in temporary external terminal",
    nargs = '*',
});

vim.api.nvim_create_user_command("Build", function()
    TerminalExec("./build.sh");
end, {
    force = true,
    desc = "Looks for local build.sh file and executes it if found.",
    nargs = 0,
});

vim.api.nvim_create_user_command("Clean", function()
    TerminalExec("./clean.sh");
end, {
    force = true,
    desc = "Looks for local clean.sh file and executes it if found.",
    nargs = 0,
});

vim.api.nvim_create_user_command("Run", function()
    TerminalExec("./run.sh");
end, {
    force = true,
    desc = "Looks for local run.sh file and attempts to execute the code if found.",
    nargs = 0,
});
