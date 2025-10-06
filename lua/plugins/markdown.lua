return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'rmd', 'org', 'norg' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      heading = { sign = false, icons = {} },
      code = { sign = false, width = 'block', right_pad = 1 },
      checkbox = { enabled = true },
      pipe_table = { preset = 'round' },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown', 'rmd' },
        callback = function(ev)
          -- <leader>mr to toggle render for this buffer
          vim.keymap.set('n', '<leader>mr', function()
            require('render-markdown').buf_toggle()
          end, { buffer = ev.buf, desc = 'Markdown: toggle render' })
          -- start in "edit" mode
          require('render-markdown').buf_disable()
        end,
      })
    end,
  },

  {
    'ellisonleao/glow.nvim',
    cmd = 'Glow',
    ft = { 'markdown' },
    opts = { width = 140, height = 50 },
  },

  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      -- Auto-start preview on :MarkdownPreview, don’t open on file open
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },
}
