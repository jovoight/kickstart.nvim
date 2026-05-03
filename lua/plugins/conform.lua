return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = vim.tbl_extend('force', {
        lua = { 'stylua' },
        python = { 'ruff_format', 'ruff_organize_imports' },
      }, require('lsp.cpp').formatters_by_ft),
      formatters = require('lsp.cpp').formatters,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
