return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require 'null-ls'
    null_ls.setup {
      debug = true,
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
      },
    }
    vim.keymap.set('n', '<leader>fo', vim.lsp.buf.format, {})
    -- Auto-format cpp files on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.cpp', '*.h' },
      command = 'lua vim.lsp.buf.format()',
    })
  end,
}
