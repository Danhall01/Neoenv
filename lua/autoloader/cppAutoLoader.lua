-- @param
-- path : string, expanded path to file
-- extention : string
--
-- @ return value
-- string : formatted value for a header guard
local function create_header_guard(path, extention)
    local fpath = vim.fn.fnamemodify(path, ':p:.:r') .. extention;
    fpath = string.gsub(fpath, "[^%w_]", '_');
    fpath = string.upper(fpath);
    return string.format([[
#ifndef _%s_
#define _%s_



#endif /* _%s_ */]]
, fpath, fpath, fpath);
end

-- Group Creation
vim.api.nvim_create_augroup('C/C++', { clear = true });


-- Behaviour
vim.api.nvim_create_autocmd('InsertEnter', {
	desc = "Enabled colorcolumn for .c .cpp .h .hpp files when using insert mode.",
	group = 'C/C++',
	pattern = {'*.c','*.cpp','*.h','*.hpp'},
	callback = function()
		vim.opt.colorcolumn = "100";
	end,
});
vim.api.nvim_create_autocmd('InsertLeave', {
	desc = "Removes the colorcolumn when leaving insert mode.",
	group = 'C/C++',
	pattern = {'*'},
	callback = function()
		vim.opt.colorcolumn = "";
	end,
});

-- Template creation
vim.api.nvim_create_autocmd('BufNewFile', {
	desc = "Automatically creates a header guard for .h and .hpp files.",
	group = 'C/C++',
	pattern = {'*.h', '*.hpp'},
	callback = function()
        local fpath = vim.fn.expand('<afile>');
        local dir = vim.fn.fnamemodify(fpath, ':p');
        local f = io.open(dir, 'w+');
        if not f then return end
        f:write(create_header_guard(dir, '.' .. vim.fn.fnamemodify(fpath, ':e')));
        f:close();
	end,
});
vim.api.nvim_create_autocmd('BufNewFile', {
    desc = "Automatically includes the related .h file.",
    group = 'C/C++',
    pattern = {'*.c'},
    callback = function()
        local fpath = vim.fn.expand('<afile>');
        local dir = vim.fn.fnamemodify(fpath, ':p');

        local f = io.open(dir, 'w+');
        local includePath = vim.fn.fnamemodify(fpath, ':t:r') .. '.h';
        if not f then return end
        f:write("#include \"" .. includePath .. "\"\n");
        f:close();
    end
});
vim.api.nvim_create_autocmd('BufNewFile', {
    desc = "Automatically includes the related .hpp file.",
    group = 'C/C++',
    pattern = {'*.cpp'},
    callback = function()
        local fpath = vim.fn.expand('<afile>');
        local dir = vim.fn.fnamemodify(fpath, ':p');

        local f = io.open(dir, 'w+');
        local includePath = vim.fn.fnamemodify(fpath, ':t:r') .. '.hpp';
        if not f then return end
        f:write("#include \"" .. includePath .. "\"\n");
        f:close();
    end
});
