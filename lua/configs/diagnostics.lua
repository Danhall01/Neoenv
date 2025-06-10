local hl_type = { [1] = "Error", [2] = "Warn", [3] = "Info", [4] = "Hint" };
local diagnostic_sign = {
    [0] = '-',
    [1] = 'W',
    [2] = ' ',
    [3] = "󰰂 ",
}

-- Format virtual text (float + inline)
vim.diagnostic.config({
    virtual_text = {
        -- If more than 3 errors, show number instead (after 3 signs)
        prefix = function(_, i, total)
            if total ~= nil and total > 3 and i > 3 then
                return i == 3 + 1 and string.format("[%d]", total) or "";
            end
            return '■';
        end,
        format = function(diagnostic)
            return string.format("[%s] %s: %s (%s)", diagnostic_sign[diagnostic.severity], diagnostic.code,
                diagnostic.message, diagnostic.source)
        end
    },
    underline = true,
    float = {
        show_header = true,
        format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
        end,
        prefix = function(diagnostic)
            return string.format("[%s]\t", diagnostic_sign[diagnostic.severity] or ""),
                "DiagnosticVirtualText" .. (hl_type[diagnostic.severity] or "");
        end,
        border = "rounded",
        style = "",
        focusable = false,
        source = "if_many",
    },
    jump = {
        float = true,
    }
});

-- Register autocmds (auto format + auto notify)
vim.api.nvim_create_augroup("lsp_qol", { clear = true, });
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    desc = "Sends notifications of all warnings and errors upon writing to buffer",
    group = "lsp_qol",
    pattern = { "*.*" },
    callback = function(_)
        local diagnostics = vim.diagnostic.get(0, {
            severity = {
                vim.diagnostic.severity.ERROR,
                --vim.diagnostic.severity.WARN,
            }
        });

        -- Analysis info which shows amount of warnings and errors
        local analytics_msg = tostring(#diagnostics) .. " error(s)";
        local analytics_severity = 3;

        local warningc = #vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.WARN } });
        if warningc > 0 then
            analytics_msg = analytics_msg .. "\n" .. tostring(warningc) .. " warning(s)";
        end
        if warningc + #diagnostics > 0 then
            vim.notify(analytics_msg, analytics_severity, { title = "Code Analysis" });
        end

        -- Send the error messages as notifications
        for _, diagnostic in ipairs(diagnostics) do
            vim.notify(diagnostic.message, 4,
                {
                    title = string.format("%s (%s:%s)", diagnostic.code, diagnostic.lnum + 1,
                        diagnostic.col + 1)
                });
        end
    end,
});
vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Automatically format upon save (Uses clang-format if it can)",
    group = "lsp_qol",
    pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.lua" },
    callback = function(_)
        vim.lsp.buf.format({ async = false });
    end
});
