-- Tree-sitter without blocking startup and without needing the network.
--  * parsers from pacman (/usr/lib/tree-sitter/*.so) are linked in automatically
--  * highlighting is started per buffer (silently skipped if no parser exists)
--  * set `vim.g.ts_auto_install = true` (e.g. in options.lua) to let it download
--    missing parsers in the background (needs tree-sitter-cli + GitHub access)
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",

  config = function()
    local tools = require("config.tools")
    local site = vim.fn.stdpath("data") .. "/site"

    require("nvim-treesitter").setup({ install_dir = site })

    -- Link parsers installed by pacman (tree-sitter-<lang> packages)
    local parser_dir = site .. "/parser"
    vim.fn.mkdir(parser_dir, "p")
    for _, lang in ipairs(tools.parsers) do
      local system_so = "/usr/lib/tree-sitter/" .. lang .. ".so"
      local dest = parser_dir .. "/" .. lang .. ".so"
      if not tools.has_parser(lang) and vim.uv.fs_stat(system_so) and not vim.uv.fs_lstat(dest) then
        vim.uv.fs_symlink(system_so, dest)
      end
    end

    -- Optional, non-blocking download of whatever is still missing
    if vim.g.ts_auto_install and vim.fn.executable("tree-sitter") == 1 then
      local missing = vim.tbl_filter(function(lang)
        return not tools.has_parser(lang)
      end, tools.parsers)
      if #missing > 0 then
        require("nvim-treesitter").install(missing) -- async: no :wait()
      end
    end

    -- Enable highlighting when a parser is available
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("custom_treesitter_start", { clear = true }),
      callback = function(ev)
        if vim.bo[ev.buf].buftype == "" then
          pcall(vim.treesitter.start, ev.buf)
        end
      end,
    })
  end,
}
