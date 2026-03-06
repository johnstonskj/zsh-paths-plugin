# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name paths
# @brief Simple functions for managing PATH, MANPATH and FPATH.
# @repository https://github.com/johnstonskj/zsh-paths-plugin
#
#

############################################################################
# @name PATH
# @description Modification functions for the execution PATH/path 
#   variable/array.

function path_append {
    if [[ ":${PATH}:" != *":${1}:"* ]]; then
        export PATH=${PATH}:${1}
    fi
}
@zplugins_remember_fn paths path_append

function path_append_if_exists {
    if [[ -d "${1}" ]]; then
        path_append "${1}"
    fi
}
@zplugins_remember_fn paths path_append_if_exists

function path_prepend {
    if [[ ":${PATH}:" != *":${1}:"* ]]; then
        export PATH="${1}:${PATH}"
    fi
}
@zplugins_remember_fn paths path_prepend

function path_prepend_if_exists {
    if [[ -d "${1}" ]]; then
        path_prepend "${1}"
    fi
}
@zplugins_remember_fn paths path_prepend_if_exists

############################################################################
# @name MANPATH
# @description Modification functions for MANPATH variable.

function man_path_append {
    if [[ ":$MANPATH:" != *":${1}:"* ]]; then
        export MANPATH="${MANPATH}:${1}"
    fi
}
@zplugins_remember_fn paths man_path_append

function man_path_append_if_exists {
    if [[ -d "${1}" ]]; then
        man_path_append "${1}"
    fi
}
@zplugins_remember_fn paths man_path_append_if_exists

############################################################################
# @name FPATH
# @description Modification functions for the function path FPATH/fpath 
#   variable/array.

function function_path_append {
    if [[ ":${FPATH}:" != *":${1}:"* ]]; then
        export FPATH="${FPATH}:${1}"
    fi
}
@zplugins_remember_fn paths  function_path_append

function function_path_append_if_exists {
    if [[ -d "${1}" ]]; then
        function_path_append "${1}"
    fi
}
@zplugins_remember_fn paths  function_path_append_if_exists

############################################################################
# @name Source
# @description Conditional source function.

function source_if_exists {
    # Don't bother to source zero-length files
    if [[ -s "${1}" ]]; then
        source "${1}"
    fi
}
@zplugins_remember_fn paths source_if_exists