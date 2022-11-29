local M = {}
local util = require("lspconfig").util
local log = require("py-bazel.dev").log
local Job = require("plenary.job")
local Path = require("plenary.path")
local Config = require("py-bazel").plugin_config

local data_path = vim.fn.stdpath("data")

local function find_workspace_root()
	return util.root_pattern(unpack(Config.workspace_root_markers))(vim.fn.expand("%:p")) or nil
end

local function find_user_defined_libs(workspace_root)
	local out = {}
	local function process_complete(j, ret_val)
		if ret_val ~= 0 then
			log.error("Failed to find user defined libs with error code " .. ret_val)
			log.error(vim.inspect(j:result()))
			return
		end
		log.info(vim.inspect(out))
	end
	Job:new({
		command = "rg",
		args = {
			"-g",
			"BUILD",
			"-g",
			"BUILD.bazel",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"py_library",
			"-l",
			workspace_root,
		},
		cwd = workspace_root,
		on_start = function()
			print(out, "starting job in " .. workspace_root)
		end,
		on_stderr = function(error, data, _)
			table.insert(out, error)
			table.insert(out, data)
		end,
		on_stdout = function(_, data, _)
			table.insert(out, data)
		end,
		on_exit = process_complete,
	}):sync()
	return out
end

local function find_py_dirs(files)
	local dirs = {}
	for _, file in pairs(files) do
		local dir = vim.fs.dirname(file)
		if Config.library_path_marker ~= nil then
			if Path.exists(Path:new(dir .. "/" .. Config.library_path_marker)) then
				dir = dir .. "/" .. Config.library_path_marker
			end
		else
			log.info("Did not find library path marker")
		end
		log.info(dir)
		table.insert(dirs, dir)
	end
	return dirs
end

local function create_or_get_dir(path)
	if not Path.exists(Path:new(path)) then
		Path:new(path):mkdir()
	end
	return Path:new(path)
end

local function get_cached_config(workspace_root)
	local created = false
	if
		not Path.exists(Path:new(data_path .. "/py-bazel/" .. vim.fs.basename(workspace_root) .. "/pyrightconfig.json"))
	then
		create_or_get_dir(data_path .. "/py-bazel")
		create_or_get_dir(Path:new(data_path .. "/py-bazel/" .. vim.fs.basename(workspace_root)))
		created = true
	end
	return created, Path:new(data_path .. "/py-bazel/" .. vim.fs.basename(workspace_root) .. "/pyrightconfig.json")
end

function M.find_extra_paths()
	local lsp_root = require("py-bazel.lsp").find_bazel_root_marker()
	if lsp_root ~= nil then
		local workspace_root = find_workspace_root()
		if workspace_root == nil then
			log.error("Could not find WORKSPACE root")
			return
		end
		local created, config = get_cached_config(workspace_root)
		if created then
			local files = find_user_defined_libs(workspace_root)
			local dirs = find_py_dirs(files)
			require("py-bazel.config").update_config(config, dirs)
		end
		require("py-bazel.config").set_local_config(config, lsp_root)
	else
		log.info("This does not appear to be a bazel project")
	end
end

function M.remove_symlink()
	local lsp_root = require("py-bazel.lsp").find_bazel_root_marker()
	Path:new(lsp_root .. "/pyrightconfig.json"):rm()
end

return M
