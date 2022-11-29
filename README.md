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
```
use({
    "numine777/py-bazel.nvim", 
    config = function() 
        require("py-bazel").setup(<your_config>)
    end,
})
```

## Configuration
```
default config = {
	library_path_marker = nil,
	lsp_root_markers = { "BUILD.bazel", "BUILD" },
	workspace_root_markers = { "WORKSPACE", "WORKSPACE.bazel" },
}
```
