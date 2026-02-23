Start background server: `nvim --listen ~/.cache/nvim/server.pipe`
Remotely execute keyboard inputs on that server (sleep to make sure server has started) `sleep 2 && nvim --server ~/.cache/nvim/server.pipe --remote-send '<Space>sf'`
Get the UI state with: `nvim --server ~/.cache/nvim/server.pipe --remote-ui`
Restart nvim server command (use after each config code change): `pkill -f "nvim --listen" && nvim --listen ~/.cache/nvim/server.pipe &`
If you need to read the docs / implementation of a specific plugin look at: `~/.local/share/nvim/lazy`
