local M = {}
local Path = require("plenary.path")
local Config = require("py-bazel").plugin_config
local uv = vim.loop

function M.update_config(config, dirs)
	local pyright_config = { extraPaths = {} }
	if Config.global_pyright_config ~= nil then
		if Path.exists(Path:new(Config.global_pyright_config)) then
			pyright_config = vim.fn.json_decode(Path:new(Config.global_pyright_config):read()) or {}
		end
	end
	if Path.exists(config) then
		pyright_config = vim.tbl_deep_extend("force", pyright_config, vim.fn.json_decode(config:read()) or {})
	end
	if pyright_config.extraPaths == nil then
		pyright_config.extraPaths = {}
	end
	for _, dir in pairs(dirs) do
		if not vim.tbl_contains(pyright_config.extraPaths, dir) then
			table.insert(pyright_config.extraPaths, dir)
		end
	end
	Path:new(config):write(vim.fn.json_encode(pyright_config), "w")
end

function M.set_local_config(config, config_target)
	local target_path = Path:new(config_target)
	local stat = uv.fs_stat(config_target)
	if Path.exists(target_path) and stat ~= nil and stat.nlink == 0 then
		target_path:rename({ new_name = config_target .. ".bak" })
	end
	return vim.fn.system({ "ln", "-sf", config:absolute(), config_target })
end

return M
