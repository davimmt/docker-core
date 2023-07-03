--
-- Custom mapping configurations
-- 
-- Check argument supplied to nvim.
vim.cmd "autocmd StdinReadPre * let s:std_in=1"
-- Start Telescope in find_files mode if no files arguments.
vim.cmd "autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | execute 'Telescope find_files' | endif"
-- If argument is a folder, cd to directory and start Telescope in find_files mode.
vim.cmd "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'cd '.argv()[0] | execute 'Telescope find_files' | endif"

-- NERDTree shortcuts
vim.keymap.set('n', '<leader>n', ':NERDTreeToggle<CR>')
vim.keymap.set('n', '<leader>nf', ':NERDTreeFocus<CR>')
-- Close the tab if NERDTree is the only window remaining in it.
vim.cmd "autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"
-- Exit Vim if NERDTree is the only window remaining in the only tab.
vim.cmd "autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"

-- Close with Q
vim.keymap.set("n", "Q", ":q!<CR>")

-- GitHub Copilot setup
-- vim.g.copilot_node_command = "~/.local/node-v16.15.0-linux-x64/bin/node"

-- Install terraform-ls and tflint
require'lspconfig'.terraformls.setup{}
require'lspconfig'.tflint.setup{}
-- Config to recognize hcl and terraform filetype
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

-- Automatically format *.tf and *.tfvars files with terraform fmt on save and align settings.
-- vim.cmd([[let g:terraform_fmt_on_save=1]])
-- vim.cmd([[let g:terraform_align=1]])

-- Terraform alias in normal mode.
vim.keymap.set("n", "<leader>tfi", ":split term://terraform init<cr>G")
vim.keymap.set("n", "<leader>tfv", ":split term://terraform validate<cr>G")
vim.keymap.set("n", "<leader>tfp", ":split term://terraform plan<cr>G")
vim.keymap.set("n", "<leader>tfa", ":split term://terraform apply -auto-approve<cr>G")

--
-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'hashivim/vim-terraform',
  -- 'github/copilot.vim',

  { 'neoclide/coc.nvim', branch = 'release' },
  { 'mg979/vim-visual-multi', branch = 'master' },

  { 'preservim/nerdtree', dependencies = {
      'Xuyuanp/nerdtree-git-plugin',
      'PhilRunninger/nerdtree-buffer-ops',
      'PhilRunninger/nerdtree-visual-selection',
      -- 'ryanoasis/vim-devicons',
      -- 'tiagofumo/vim-nerdtree-syntax-highlight',
      -- 'scrooloose/nerdtree-project-plugin',
    },
  },
}
