return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',

  config = function()
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath('data') .. '/site',
    }

    require('nvim-treesitter').install({
      'rust',
      'javascript',
      'python',
      'bash',
      'c',
      'cpp',
      'lua',
      'luadoc',
      'vim',
      'vimdoc',
      'markdown',
      'haskell',
    }):wait(30000)
  end,
}
