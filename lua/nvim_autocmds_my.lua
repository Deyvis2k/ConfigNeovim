vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    Snacks.notify.info("Saving colorscheme")
    local current_colorscheme = vim.g.colors_name or "default"
    local path = vim.fn.stdpath("data") .. "/last_colorscheme.txt"
    local file = io.open(path, "w")
    if file then
      file:write(current_colorscheme .. "\n")
      file:close()
    else
        local path_ = vim.fn.stdpath("data")
        vim.fn.mkdir(path_, "p")
        local file_ = io.open(path .. "/last_colorscheme.txt", "w")
        if not file_ then
            return
        end
        file_:write(current_colorscheme .. "\n")
        file_:close()
    end
  end,
})


vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ui", "*.xml" },
  callback = function()
    vim.opt_local.autoindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.cindent = false
    vim.opt_local.indentexpr = ""

    vim.keymap.set("i", "<CR>", function()
      local prev_line = vim.fn.getline(vim.fn.line('.'))
      local indent_col = string.find(prev_line, '%S') or 0
      return "\n" .. string.rep(" ", indent_col - 1)
    end, { buffer = true, expr = true })
  end
})
