<div align="center">

# Py-Bazel.nvim
##### Bazel support for python projects in neovim

<div align="left">

## Requirements
* pyright lsp
* ripgrep

## Installation
Using packer
```lua
use({
    "numine777/py-bazel.nvim",
    config = function()
        require("py-bazel").setup(<your_config>)
    end,
    requires = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
    },
})
```

Using lazy
```lua
{
    "numine777/py-bazel.nvim",
    config = function()
        require("py-bazel").setup(<your_config>)
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
    },
}
```
## Configuration
```lua
default config = {
    -- Path marker for directories that contain python libraries
    library_path_marker = nil,
    -- Path marker for pip dependencies within the external directory
    pip_deps_marker = nil,
    -- Path to location for the global pyright config. If not defined, local configs will be used
    global_pyright_config = nil,
    -- Root markers for Bazel build files
    lsp_root_markers = { "BUILD.bazel", "BUILD" },
    -- Root markers for monorepo workspace
    workspace_root_markers = { "WORKSPACE", "WORKSPACE.bazel" },
}
```
Note: if you want to pick up third party (external) python dependencies, you will need
to define `pip_deps_marker`.  This value does tend to vary by repo, so I have opted to
leave the value as nil, which means that only local dependencies will be detected.
