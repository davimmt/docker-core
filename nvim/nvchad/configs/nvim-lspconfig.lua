require'lspconfig'.tflint.setup{}
require'lspconfig'.terraformls.setup{}

local config = {
  vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.tf", "*.tfvars"},
    callback = function()
      vim.lsp.buf.format()
    end,
  })
}

return config
