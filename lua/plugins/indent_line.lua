return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    ---@module 'ibl'
    ---@type ibl.config
    opts = {
      indent = {
        char = '⎪',
        highlight = { "CursorColumn", "Whitespace" },
      },
      whitespace = {
        highlight = { "CursorColumn", "Whitespace" },
        remove_blankline_trail = false,
      },
      scope = { enabled = false },
    },
  },
}
