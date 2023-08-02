local alpha = require "alpha"
local startify = require "alpha.themes.startify"
local dashboard = require "alpha.themes.dashboard"
local icon = require "custom.utils.icons"
local prayer = require "custom.utils.prayers"

startify.section.header.val = icon
startify.section.header.opts.hl = "DashboardHeader"
startify.section.top_buttons.val = {
  startify.button("f", "  Find files" , ":Telescope find_files<CR>"),
  startify.button("s", " Load Last Session" , ":SessionManager load_last_session<CR>"),
}
startify.section.bottom_buttons.val = {
  startify.button("q", "󰅚  Quit NVIM" , ":qa<CR>"),
}
startify.section.footer.val = {
  { type = "text", val = prayer },
}

return alpha.setup(startify.config)

--   dashboard.section.header.val = icon
--   dashboard.section.header.opts.hl = "DashboardHeader"
--
--   dashboard.config.layout[1].val = 1 -- vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
--   dashboard.config.layout[3].val = 2
--   dashboard.config.opts.noautocmd = true
--
--   vim.api.nvim_create_autocmd("User", {
--     once = true,
--     callback = function()
--       -- table.insert(prayer, 1, "")
--       opts.section.footer.val = prayer
--       pcall(vim.cmd.AlphaRedraw)
--     end,
--   })
-- }
