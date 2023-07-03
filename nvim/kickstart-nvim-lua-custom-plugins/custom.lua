-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

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

return {
  'tpope/vim-fugitive',
  'tpope/vim-surround',

  { 'neoclide/coc.nvim', branch = 'master' },
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
