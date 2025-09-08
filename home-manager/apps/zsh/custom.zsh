# =============================================================================
# ALIASES
# =============================================================================

# Nix Commands
alias update="sudo nixos-rebuild switch --flake /home/cameron/.dotfiles"
alias upgrade="cd /home/cameron/.dotfiles && nix flake update && sudo nixos-rebuild switch --flake /home/cameron/.dotfiles"
alias nix-clean="sudo nix-collect-garbage -d && nix-collect-garbage -d"
alias home-clean="home-manager expire-generations -d"
alias nix-orphans="nix store gc && sudo nix store optimise"
alias nix-wipe="sudo nix profile wipe-history"
alias hm-clean-old="home-manager remove-generations old"
alias nix-sys-clean="nix-clean && home-clean && nix-orphans && nix-wipe && hm-clean-old"

# Git Commands
alias gf="git fetch"
alias gco="git checkout"
alias gcm="git commit -m"
alias gpl="git pull"
alias groh='git reset origin/$(git_current_branch) --hard'
alias gm="git merge"

# Taskwarrior Commands
alias tl="task list"
alias ta="task add"
alias td="task done"

# Program Alias
alias code="codium"
alias cat="bat"
alias ls="eza -lT --icons"

# =============================================================================
# GIT FUNCTIONS
# =============================================================================

# Auto-fetch when entering git directories
autoload -U add-zsh-hook
function auto_git_fetch() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Check if we've fetched recently (within last 5 minutes) to avoid excessive fetching
        local git_dir=$(git rev-parse --git-dir 2>/dev/null)
        local fetch_file="$git_dir/.last_fetch"
        local now=$(date +%s)
        local last_fetch=0
        
        if [[ -f "$fetch_file" ]]; then
            last_fetch=$(cat "$fetch_file")
        fi
        
        # Only fetch if it's been more than 300 seconds (5 minutes)
        if (( now - last_fetch > 300 )); then
            echo "Fetching upstream changes..."
            git fetch --quiet
            echo $now > "$fetch_file"
        fi
    fi
}

# Run the function when changing directories
chpwd_functions+=(auto_git_fetch)

function git_current_branch() {
    branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
    if [[ $branch == "" ]]; then
        return
    fi
    
    # Check if we want the prompt format (with "on" and colors)
    if [[ "$1" == "prompt" ]]; then
        echo "%F{default}on %F{blue}$branch "
    else
        echo $branch
    fi
}

function __git_symbols() {
    # Symbols
    local ahead='↑'
    local behind='↓'
    local diverged='↕'
    local no_remote=''
    local staged='+'
    local untracked='U'
    local modified='M'
    local moved='>'
    local deleted='x'
    local stashed='$'

    local output_symbols=''

    local git_status_v
    git_status_v="$(git status --porcelain=v2 --branch --show-stash 2>/dev/null)"

    # Parse branch information
    local ahead_count behind_count

    # AHEAD, BEHIND, DIVERGED
    if echo $git_status_v | grep -q "^# branch.ab " ; then
        # One line of the git status output looks like this:
        # # branch.ab +1 -2
        # In the line below:
        # - we grep for the line starting with # branch.ab
        # - we grep for the numbers and output them on separate lines
        # - we remove the + and - signs
        # - we put the two numbers into variables, while telling read to use a newline as the delimiter for reading
        read -d "\n" -r ahead_count behind_count <<< $(echo "$git_status_v" | grep "^# branch.ab" | grep -o -E '[+-][0-9]+' | sed 's/[-+]//')
        # Show the ahead and behind symbols when relevant
        [[ $ahead_count != 0 ]] && output_symbols+="$ahead"
        [[ $behind_count != 0 ]] && output_symbols+="$behind"
        # Replace the ahead symbol with the diverged symbol when both ahead and behind
        output_symbols="${output_symbols//$ahead$behind/$diverged}"
    fi

    # STASHED
    echo $git_status_v | grep -q "^# stash " && output_symbols+="$stashed"

    # STAGED
    [[ $(git diff --name-only --cached) ]] && output_symbols+="$staged"

    # For the rest of the symbols, we use the v1 format of git status because it's easier to parse.
    local git_status

    symbols="$(git status --porcelain=v1 | cut -c1-2 | sed 's/ //g')"

    while IFS= read -r symbol; do
        case $symbol in
            ??) output_symbols+="$untracked";;
            M) output_symbols+="$modified";;
            R) output_symbols+="$moved";;
            D) output_symbols+="$deleted";;
        esac
    done <<< "$symbols"

    # Remove duplicate symbols - FIXED VERSION
    local unique_symbols=""
    local seen_symbols=""
    for (( i=0; i<${#output_symbols}; i++ )); do
        char="${output_symbols:$i:1}"
        if [[ "$seen_symbols" != *"$char"* ]]; then
            unique_symbols+="$char"
            seen_symbols+="$char"
        fi
    done
    output_symbols="$unique_symbols"

    [[ -n $output_symbols ]] && echo -n " $output_symbols"
}

# Function to display Git status with symbols
function __git_info() {
    local git_info=''
    local git_branch_name=''

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Get the Git branch name
        git_branch_name="$(git symbolic-ref --short HEAD 2>/dev/null)"
        if [[ -n "$git_branch_name" ]]; then
            git_info+="$git_branch_name"
        fi
        # Get the Git status
        git_info+="%F{red}$(__git_symbols)"
        echo "%F{default}on %F{blue}$git_info "
    fi
}


# =============================================================================
# PROMPT FUNCTIONS
# =============================================================================

function __nix_shell_info() {
    if [[ -n "$IN_NIX_SHELL" ]]; then
        local shell_name="nix-shell"
        if [[ -n "$name" ]]; then
            shell_name="$name"
        elif [[ -n "$NIX_SHELL_NAME" ]]; then
            shell_name="$NIX_SHELL_NAME"
        fi
        echo "%F{default}in %F{magenta}${shell_name} "
    fi
}


# =============================================================================
# PROMPT CONFIGURATION
# =============================================================================

setopt PROMPT_SUBST
export PROMPT='%F{yellow}╭─[ %n%F{default}@%F{yellow}%m %F{cyan}%~ $(__git_info)$(__nix_shell_info)%F{yellow}]
%F{yellow}╰─%F{green}❯ %F{default}'


# =============================================================================
# KEYBINDINGS
# =============================================================================

# History search with up/down arrows
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search


# =============================================================================
# MOTD FUNCTION
# =============================================================================

function __show_taskwarrior_motd() {
    if command -v task >/dev/null 2>&1; then
        local pending_tasks=$(task status:pending count 2>/dev/null)
        if [[ $pending_tasks -gt 0 ]]; then
            echo -e "\033[33m📝 Taskwarrior Summary:\033[0m"  # Yellow
            echo -e "\033[36mYou have $pending_tasks pending tasks\033[0m"  # Cyan
            # Show next 3 most urgent tasks
            task next limit:3 2>/dev/null | head -n 5
            echo ""
        else
            echo -e "\033[32m✅ No pending tasks!\033[0m"  # Green
            echo ""
        fi
    fi
}

# Show motd on shell startup
if [[ $SHLVL -eq 1 ]]; then
    __show_taskwarrior_motd
fi