## fuzzy-find-and-edit bash alias helper

### Features
- **Fuzzy select** with **[`fzf`](https://github.com/junegunn/fzf)**
- Works with **[`fd`](https://github.com/sharkdp/fd)** for speed, falls back to `find`
- **Depth-first sort** (shallow paths shown first for quicker hits)
- **Editor auto-detect**: `$FF_EDITOR` -> `$VISUAL` -> `$EDITOR` -> `code/nvim/vim/micro/vi`

### Usage
```bash
ff $file_pattern
ff $file_pattern $folder_pattern
```

### Examples
- Find all `/.*readme.*/i` files, sort by depth from working directory, `cd` into file dir on pressed `Enter` or single match
```bash
ff readme
```
- Find all `Cargo` files (smart case, won't show `cargo-lock`) inside `/.*hel.*/i` folders (will match `hello_world`)
```bash
ff Cargo hel
```

### Setup
- **(REQUIRED) Install `fzf`** https://github.com/junegunn/fzf
- (Recommended) Install `fd-find` https://github.com/sharkdp/fd
- (Optional) Set the starting directory (default "$HOME"). Example: `FF_ROOT="$HOME/projects"`
- (Optional) Set default editor. Example: `FF_EDITOR="code --reuse-window"`
- ***Refer to comments for more info and further editing***

### Installation
```bash
# add the function to bash_aliases
curl -sSL https://raw.githubusercontent.com/dslxvr/ff/refs/heads/master/ff.sh \
    >> ~/.bash_aliases
```