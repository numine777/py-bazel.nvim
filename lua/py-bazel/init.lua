-- We need an autocommand to look for the WORKSPACE root and dynamically add
-- paths to the extraPaths list for pyright configuration.  Ideally, this file
-- should be project specific and be symlinked to the root detected by the LSP
--
-- Initially, this will only support pyright as the LSP

local py_bazel = vim.api.nvim_create_augroup("PY_BAZEL", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.py" },
	callback = function()
		require("py-bazel.paths").find_extra_paths()
	end,
	group = py_bazel,
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	pattern = { "*.py" },
	callback = function()
		require("py-bazel.paths").remove_symlink()
	end,
	group = py_bazel,
})

local defaults = {
	library_path_marker = nil,
	lsp_root_markers = { "BUILD.bazel", "BUILD" },
	workspace_root_markers = { "WORKSPACE", "WORKSPACE.bazel" },
}

local M = {}
local log = require("py-bazel.dev").log

function M.setup(config)
	log.info("setting up py-bazel with config " .. vim.inspect(config or {}))
	M.plugin_config = vim.tbl_deep_extend("force", defaults, config or {})
end

return M
