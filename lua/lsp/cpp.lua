local M = {}

local function latest_homebrew_gcc()
  local candidates = vim.fn.glob('/opt/homebrew/bin/g++-*', true, true)
  table.sort(candidates, function(a, b)
    return tonumber(a:match('g%+%+%-(%d+)$') or '0') < tonumber(b:match('g%+%+%-(%d+)$') or '0')
  end)

  local cxx = candidates[#candidates] or '/opt/homebrew/bin/g++-15'
  local major = cxx:match('g%+%+%-(%d+)$') or '15'

  return {
    c = '/opt/homebrew/bin/gcc-' .. major,
    cxx = cxx,
    major = major,
  }
end

local gcc = latest_homebrew_gcc()

M.filetypes = { 'cpp', 'objc', 'objcpp', 'cuda' }

M.extensions = {
  C = 'cpp',
  H = 'cpp',
  cxx = 'cpp',
  hxx = 'cpp',
  cppm = 'cpp',
  cc = 'cpp',
  hh = 'cpp',
  h = 'cpp',
  hpp = 'cpp',
  ixx = 'cpp',
  ['c++'] = 'cpp',
  ['h++'] = 'cpp',
}

M.servers = {
  clangd = {
    filetypes = M.filetypes,
    cmd = {
      'clangd',
      '--query-driver=' .. gcc.cxx .. ',' .. gcc.c .. ',/opt/homebrew/bin/g++-*,/opt/homebrew/bin/gcc-*',
    },
    init_options = {
      fallbackFlags = {
        '-std=c++23',
        '-xc++',
        '-I.',
        '-Iinclude',
        '-Isrc/include',
        '-I../include',
        '-I../src/include',
        '-I../../include',
        '-I../../src/include',
        '-I../../../include',
        '-I../../../src/include',
      },
    },
  },
}

M.formatters_by_ft = {
  cpp = { 'clang-format' },
  objc = { 'clang-format' },
  objcpp = { 'clang-format' },
  cuda = { 'clang-format' },
}

M.formatters = {
  ['clang-format'] = {
    command = '/opt/homebrew/opt/llvm/bin/clang-format',
    prepend_args = { '--style=Google' },
  },
}

function M.setup_filetypes()
  vim.filetype.add {
    extension = M.extensions,
  }
end

return M
