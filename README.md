<div align="center">

# Py-Bazel.nvim
##### Bazel support for python projects in neovim

<div align="left">

## Requirements
* pyright lsp
* ripgrep
* plenary.nvim plugin
* lspconfig.nvim plugin

## Installation
Using packer
```lua
use({
    "numine777/py-bazel.nvim", 
    config = function() 
        require("py-bazel").setup(<your_config>)
    end,
})
```

## Configuration
```lua
default config = {
    -- Path marker for directories that contain python libraries 
    library_path_marker = nil,
    -- Path marker for pip dependencies within the external directory
    pip_deps_marker = nil,
    -- Root markers for Bazel build files
    lsp_root_markers = { "BUILD.bazel", "BUILD" },
    -- Root markers for monorepo workspace
    workspace_root_markers = { "WORKSPACE", "WORKSPACE.bazel" },
}
```
