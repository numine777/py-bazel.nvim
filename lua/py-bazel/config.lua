local M = {}
local Path = require("plenary.path")

function M.update_config(config, dirs)
    local pyright_config = { extraPaths = {} }
	if Path.exists(config) then
		pyright_config = vim.fn.json_decode(config:read())
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

function M.set_local_config(config, workspace_root)
	return vim.fn.system({ "ln", "-sf", config:absolute(), workspace_root })
end

return M
