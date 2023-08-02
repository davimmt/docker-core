local config = {
  require("nvim-treesitter.configs").setup({
    "bash",
    "dockerfile",
    "hcl",
    "json",
    "regex",
    "terraform",
    "yaml",
    ensure_installed = {
      "bash",
      "dockerfile",
      "hcl",
      "json",
      "regex",
      "terraform",
      "yaml",
    },
    highlight = { enable = true },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil
    }
  })
}

return config
