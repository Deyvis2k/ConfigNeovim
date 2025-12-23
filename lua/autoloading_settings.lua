local path_colorscheme = vim.fn.stdpath("data") .. "/last_colorscheme.txt"

local file_color_scheme = io.open(path_colorscheme, "r")
if file_color_scheme then
  local scheme = file_color_scheme:read("*l")
  file_color_scheme:close()
  if scheme and scheme ~= "" then
    vim.cmd("colorscheme " .. scheme)
  end
else
    Snacks.notify.error("Error opening file")
end
