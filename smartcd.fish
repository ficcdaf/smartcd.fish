status is-interactive; or exit

# Ensure original cd is saved once
functions -q __cd_orig; or functions --copy cd __cd_orig

function cd --wraps=cd --description "Change directory. No args goes to git root or $HOME. If already there, return to previous location."
    argparse h/help -- $argv
    if set -q _flag_help
        echo smartcd.fish: Change directories, slightly smarter.
        echo Invoke by running cd. Update with smartcd_update.\n
        echo Usage:
        echo -h/--help: show this menu.
        echo cd [args]: behaves like normal cd.
        echo cd [no-args]: cd to ROOT. If at ROOT, cd to PREV.\n
        echo ROOT = Git repo root '||' "\$HOME".
        echo PREV = Last element of "\$dirprev".
        echo If PREV is outside ROOT, user is prompted first.\n
        echo Author: Daniel Fichtinger '<daniel@ficd.ca>'
        echo Upstream: https://git.sr.ht/~ficd/smartcd.fish
        echo License: ISC
        return 0
    end
    # Skip history in subshells.
    if status --is-command-substitution
        builtin cd $argv
        return $status
    end
    git rev-parse --is-inside-work-tree &>/dev/null
    set -l is_git $status
    if test (count $argv) -ne 0
        __cd_orig $argv
    else
        if test $is_git -eq 0
            set root (git rev-parse --show-toplevel)
        else
            set root ~
        end
        if not test (pwd) = $root
            __cd_orig $root
        else if set -q dirprev
            if string match -q "$root*" "$dirprev[-1]"
                __cd_orig -
            else
                set -l prompt "$dirprev[-1], is outside $root, are you sure? (y/n):"
                while read --nchars 1 -l response --prompt-str="$prompt" or return 1
                    # clear prompt
                    printf "\033[1A\033[2K"
                    switch $response
                        case y Y
                            __cd_orig -
                            break
                        case n N
                            break
                    end
                end
            end
        end
    end
end

function smartcd_update --description "Update smartcd.fish with the latest from the upstream."
    argparse h/help d/dry -- $argv
    if set -q _flag_help
        echo Update smartcd.fish with the latest from upstream.\n
        echo Usage:
        echo -d/--dry to not save the file.
        echo -h/--help to print this screen.\n
        echo Author: Daniel Fichtinger '<daniel@ficd.ca>'
        echo Upstream: https://git.sr.ht/~ficd/smartcd.fish
        echo License: ISC
        return 0
    end
    set -l url https://git.sr.ht/~ficd/smartcd.fish/blob/main/smartcd.fish
    # set -l add "-o $fish_config/conf.d/smartcd.fish"
    not set -q _flag_dry; and set -l add -o $fish_config/conf.d/smartcd.fish
    curl $url $add
    printf "\033[1A\033[2K"
    exec fish
end
