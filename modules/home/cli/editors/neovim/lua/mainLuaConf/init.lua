-- Note: Various, non-plugin config
require("mainLuaConf.opts_and_keys")

require("lze").register_handlers(require("lzextras").lsp)

-- General Plugins
require("mainLuaConf.plugins")
require("mainLuaConf.plugins.colorscheme")

-- LSP and Completion
require("mainLuaConf.LSPs")

if nixCats("debug") then
    require("mainLuaConf.debug")
end
if nixCats("test") then
    require("mainLuaConf.test")
end
if nixCats("lint") then
    require("mainLuaConf.lint")
end
if nixCats("format") then
    require("mainLuaConf.format")
end