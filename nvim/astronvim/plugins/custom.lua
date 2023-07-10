--
-- Custom mapping configurations
--
-- Check argument supplied to nvim.
vim.cmd("autocmd StdinReadPre * let s:std_in=1")
-- Start Telescope in find_files mode if no files arguments.
vim.cmd("autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | execute 'Telescope find_files' | endif")
-- If argument is a folder, cd to directory and start Telescope in find_files mode.
vim.cmd(
  "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'cd '.argv()[0] | execute 'Telescope find_files' | endif"
)

-- Close the tab if NERDTree is the only window remaining in it.
vim.cmd("autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif")
-- Exit Vim if NERDTree is the only window remaining in the only tab.
vim.cmd(
  "autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"
)

-- Close with Q
vim.keymap.set("n", "Q", ":q!<CR>")

-- Install terraform-ls and tflint
require("lspconfig").terraformls.setup({})
require("lspconfig").tflint.setup({})

-- Config to recognize hcl and terraform filetype
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

-- Terraform alias in normal mode.
vim.keymap.set("n", "<leader>tfi", ":split term://terraform init<cr>G")
vim.keymap.set("n", "<leader>tfv", ":split term://terraform validate<cr>G")
vim.keymap.set("n", "<leader>tfp", ":split term://terraform plan<cr>G")
vim.keymap.set("n", "<leader>tfa", ":split term://terraform apply -auto-approve<cr>G")

return {
  "tpope/vim-fugitive",
  "tpope/vim-surround",
  "hashivim/vim-terraform",

  { "mg979/vim-visual-multi", branch = "master" },

  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = {
              forward = true,
              wrap = false,
              multi_window = false,
              mode = function(str)
                return "\\<" .. str
              end,
            },
          })
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
}
