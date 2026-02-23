# jordan-nvim

Would recommend beginners start off with nvim kickstart (Thats how I started)
However this configuration is very far from that.

## Philosophy
- Try to use the minimum amount of plugins. From both trusted authors and for things that unreasonable to inline (ex: tree sitter)
- Plugins add complexity but more importantly they also add security risk. 
    - Hopefully neovim can keep inlining things themselves and add better sandboxing support for plugins
- Try to inline the small portion of plugins I use to avoid these problems

## Most important plugins
- Mini for floating file explorer
- Snacks for pickers (Improvement over telescope)
- Blink cmp for completions (improvement over nvim-cmp)
- Flash for jumping around and quickly selecting within a given scope
- Git diff view (self explanatory)

## Things to install first outside of neovim
- fortune (dashboard)
- cowsay (dashboard)
- ripgrep (grugfar, and a couple others)

## TODO
- When next neovim version comes out replace lazy plugin manager with `vim.pack`
