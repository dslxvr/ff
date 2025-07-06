ff() {
    local file_pattern="" folder_pattern=""
    [[ $# -eq 1 ]] && file_pattern=$1
    # additional filter by folder pattern if args >= 2
    [[ $# -ge 2 ]] && {
        file_pattern=$1
        folder_pattern=$2
    }

    # set FF_ROOT if you want to use your own starting dir
    local root="${FF_ROOT:-$HOME}"

    local -a search_cmd
    if command -v fd >/dev/null 2>&1; then
        # drop --exclude '/.*' if you want to include dot-files in root
        # drop -H if you don't want to see hidden at all
        search_cmd=(fd -a -t f -H --exclude '/.*' --exclude venv
            "$file_pattern" "$root")
    else
        # fallback to find (if you don't want to install fd-find)
        search_cmd=(find "$root"
            # similar logic to --exclude in fd
            \( -path "$root/.[^/]*" -o -path '*/venv' \) -prune -o
            -type f -regextype egrep -iregex .*"$file_pattern".* -print)
    fi

    local file
    file=$(
        "${search_cmd[@]}" |
            { [[ $folder_pattern ]] &&
                grep -Fi -- "$folder_pattern" || cat; } |
            while read -r p; do
                rel=$(realpath --relative-to="$PWD" "$p")
                depth=${rel//[^\/]/}
                depth=${#depth}
                printf '%06d\t%s\n' "$depth" "$p"
            done |
            sort -n |
            fzf --no-sort --delimiter='\t' --with-nth=2.. --select-1 --exit-0 |
            cut -f2-
    ) || return
    [[ $file ]] || return

    # set FF_EDITOR to use your editor, otherwise use default/fallback opts
    local editor=${FF_EDITOR:-${VISUAL:-${EDITOR:-}}}
    if [[ -z $editor ]]; then
        # set fallback editor options
        local -a candidates=(
            "code --reuse-window"
            "nvim"
            "vim"
            "micro"
            "vi"
        )
        for candidate in "${candidates[@]}"; do
            local binary=${candidate%% *}
            if command -v "$binary" >/dev/null 2>&1; then
                editor=$candidate
                break
            fi
        done
    fi
    local -a open_cmd
    read -r -a open_cmd <<<"$editor"
    open_cmd+=("$file")
    "${open_cmd[@]}"

    # drop if you don't want to cd into file dir
    cd "${file%/*}"
}