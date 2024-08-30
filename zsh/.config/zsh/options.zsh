setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt histappend                                               # Don't erase history
setopt inc_append_history                                       # Add immediately
setopt share_history                                            # Share history between session/terminals
setopt list_packed           # Compactly display completion list
setopt auto_remove_slash     # Automatically remove trailing / in completions
setopt auto_param_slash      # Automatically append trailing / in directory name completion to prepare for next completion
setopt mark_dirs             # Append trailing / to filename expansions when they match a directory
setopt list_types            # Display file type identifier in list of possible completions (ls -F)
unsetopt menu_complete       # When completing, instead of displaying a list of possible completions and beeping. Don't insert the first match suddenly.
setopt auto_list             # Display a list of possible completions with ^I (when there are multiple candidates for completion, display a list)
setopt auto_menu             # Automatic completion of completion candidates in order by hitting completion key repeatedly
setopt auto_param_keys       # Automatically completes bracket correspondence, etc.
setopt auto_resume           # Resume when executing the same command name as a suspended process

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
