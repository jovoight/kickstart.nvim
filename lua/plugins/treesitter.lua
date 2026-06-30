return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    commit = 'f8bbc3177d929dc86e272c41cc15219f0a7aa1ac',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function(plugin)
      -- ensure basic parsers are installed
      local parsers = { 'bash', 'c', 'cpp', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query', 'vim', 'vimdoc' }
      local treesitter = require 'nvim-treesitter'
      local plugin_runtime = plugin.dir .. '/runtime'
      if vim.uv.fs_stat(plugin_runtime) then
        vim.opt.runtimepath:prepend(plugin_runtime)
      end

      if type(treesitter.install) ~= 'function' then
        require('nvim-treesitter.configs').setup {
          ensure_installed = parsers,
          sync_install = false,
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        }
        return
      end

      ---@param buf integer
      ---@param language string
      ---@return boolean
      local function treesitter_try_attach(buf, language)
        if not vim.treesitter.language.add(language) then
          return false
        end
        local ok = pcall(vim.treesitter.start, buf, language)
        if not ok then
          return false
        end

        -- enable treesitter-based indentation when an indent query is available
        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
        if has_indent_query then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        return true
      end

      local available_parsers = treesitter.get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          if treesitter_try_attach(buf, language) then
            return
          end

          if vim.tbl_contains(available_parsers, language) then
            -- auto-install on first encounter, then attach when ready
            treesitter.install(language):await(function()
              treesitter_try_attach(buf, language)
            end)
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
