-- Import config moduls
require("config.options")
require("config.keymaps")
require("config.autocmd")
require("config.tools") -- external tool list + :ToolsCheck

-- Import lazy.nvim
require("core.bootstrap")
require("core.lazy")
