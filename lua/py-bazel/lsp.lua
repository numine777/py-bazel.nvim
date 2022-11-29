local M = {}
local util = require("lspconfig").util
local Config = require("py-bazel").plugin_config

function M.find_bazel_root_marker()
    return util.root_pattern(unpack(Config.lsp_root_markers))(vim.fn.expand("%:p")) or nil
end

return M
