-- Check argument supplied to nvim.
vim.cmd "autocmd StdinReadPre * let s:std_in=1"
-- If argument is a folder, cd to directory and start Telescope in find_files mode.
vim.cmd "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'cd '.argv()[0] | execute 'Telescope find_files' | endif"
