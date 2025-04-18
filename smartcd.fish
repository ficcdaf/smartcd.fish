status is-interactive; or exit

# necessary because we want to use fish's
# cd wrapper function, _not_ the builtin cd!
if not functions -q __cd_orig
    functions --copy cd __cd_orig
end

function cd --wraps=cd --description "Change directory. No args goes to git root or $HOME. If already there, return to previous location."
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
        else
            __cd_orig -
        end
    end
end
