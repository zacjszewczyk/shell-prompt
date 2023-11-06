#!/bin/bash

# Function to set the prompt
set_bash_prompt(){
    # Save last command's return value
    local last_return=$?

    # Fetch the current user and hostname
    local user=$(whoami)
    local hostname=$(hostname -s)

    # Replace the home directory with a tilde
    local directory=$(dirs +0)
    directory=${directory/#$HOME/\~}

    # Check if the user is root or has elevated privileges
    local privilege_char='$'
    if [[ $EUID -eq 0 ]]; then
        privilege_char='#'
    fi

    # Define colors
    local red="\[\033[0;31m\]"
    local bright_green="\[\033[1;32m\]"  # Brighter green color
    local color_reset="\[\033[0m\]"
    local orange="\[\033[0;33m\]"  # ANSI color code for orange
    local light_blue="\[\033[1;34m\]"  # ANSI color code for light blue

    # Set color based on the success of the last command
    local user_at_host="${user}@${hostname}:${directory}"
    if [ $last_return -eq 0 ]; then
        #user_at_host="${bright_green}${user_at_host}${color_reset}"  # Now using brighter green
        user_at_host="${bright_green}${user}${color_reset}@${bright_green}${hostname}${color_reset}:${light_blue}${directory}${color_reset}"
    else
        #user_at_host="${red}${user_at_host}${color_reset}"
        user_at_host="${red}${user}${color_reset}@${red}${hostname}${color_reset}:${light_blue}${directory}${color_reset}"
    fi

    # Git related prompt
    local git_prompt=""
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Get current branch name or use '*' if none
        local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
        branch=${branch:-*}

        if [ "$branch" != "*" ]; then
            # Get the number of commits difference from remote
            local upstream=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
            local local_branch_symbol="L"
            local tracking_info=""
            local status_symbols=""

            if [[ ! -z "$upstream" ]]; then
                local_branch_symbol=""
                # Get tracking information
                local tracking_stat=$(git rev-list --left-right --count HEAD...$upstream 2>/dev/null)
                local ahead=$(echo $tracking_stat | cut -f1 -d' ')
                local behind=$(echo $tracking_stat | cut -f2 -d' ')

                if [[ $ahead -ne 0 ]] && [[ $behind -ne 0 ]]; then
                    tracking_info="↓$behind ↑$ahead"
                elif [[ $ahead -ne 0 ]]; then
                    tracking_info="↑$ahead"
                elif [[ $behind -ne 0 ]]; then
                    tracking_info="↓$behind"
                fi
            fi

            # Get local repository status
            local status=$(git status --porcelain=v1 2> /dev/null | awk '
            { 
                if ($1 == "M" || $1 == "MM" || $1 == "AM" || $1 == "MA") unstaged_changes++;
                else if ($1 == "??") untracked_files++;
                else if ($1 == "A " || $1 == "M ") staged_changes++;
                else if ($1 == "D ") staged_deletes++;
                else if ($1 == "UU" || $1 == "AA" || $1 == "DD") merge_conflicts++;
                else if ($1 == "D" || $1 == "AD" || $1 == "MD") unstaged_deletes++;
            }
            END {
                print " " staged_changes " " merge_conflicts " " unstaged_changes " " unstaged_deletes " " untracked_files
            }')
            
            local staged_changes=$(echo $status | cut -d' ' -f1)
            local merge_conflicts=$(echo $status | cut -d' ' -f2)
            local unstaged_changes=$(echo $status | cut -d' ' -f3)
            local unstaged_deletes=$(echo $status | cut -d' ' -f4)
            local untracked_files=$(echo $status | cut -d' ' -f5)

            # Adding spaces after the symbols
            [[ $staged_changes -ne 0 ]] && status_symbols+="● $staged_changes "
            [[ $merge_conflicts -ne 0 ]] && status_symbols+="✖ $merge_conflicts "
            [[ $unstaged_changes -ne 0 ]] && status_symbols+="✚ $unstaged_changes "
            [[ $unstaged_deletes -ne 0 ]] && status_symbols+="✖ - $unstaged_deletes "
            [[ $untracked_files -ne 0 ]] && status_symbols+="… $untracked_files "

            local stash_count=$(git stash list 2> /dev/null | wc -l | tr -d ' ')
            [[ $stash_count -ne 0 ]] && status_symbols+="⚑ $stash_count "

            # Remove the last space and add a clean state symbol if needed
            status_symbols=${status_symbols% }
            [[ -z $status_symbols ]] && status_symbols="✔"

            # Apply orange color to branch if there are any changes
            local branch_color=""
            if [ "$status_symbols" != "✔" ]; then
                branch_color=$orange
            else
                branch_color=$color_reset
            fi

            git_prompt=" [${branch_color}${branch}${color_reset} $upstream ${local_branch_symbol}${tracking_info}| ${status_symbols}]"
        else
            git_prompt=" [$branch]"
        fi
    fi

    # Construct the PS1
    PS1="${user_at_host}${git_prompt}\n${privilege_char} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

