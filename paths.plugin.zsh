# -*- mode: sh; eval: (sh-set-shell "zsh") -*-

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA PATHS
PATHS[_PLUGIN_DIR]="${0:h}"
PATHS[_FUNCTIONS]=""

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `PATHS[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
_paths_remember_fn() {
    emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${PATHS[_FUNCTIONS]}" ]]; then
        PATHS[_FUNCTIONS]="${fn_name}"
    elif [[ ",${PATHS[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        PATHS[_FUNCTIONS]="${PATHS[_FUNCTIONS]},${fn_name}"
    fi
}
_paths_remember_fn _paths_remember_fn

############################################################################
# Public path functions (PATH)
############################################################################

function path_append {
    if [[ ":${PATH}:" != *":${1}:"* ]]; then
        export PATH=${PATH}:${1}
    fi
}
_paths_remember_fn path_append

function path_append_if_exists {
    if [[ -d "${1}" ]]; then
        path_append "${1}"
    fi
}
_paths_remember_fn path_append_if_exists

function path_prepend {
    if [[ ":${PATH}:" != *":${1}:"* ]]; then
        export PATH="${1}:${PATH}"
    fi
}
_paths_remember_fn path_prepend

function path_prepend_if_exists {
    if [[ -d "${1}" ]]; then
        path_prepend "${1}"
    fi
}
_paths_remember_fn path_prepend_if_exists

############################################################################
# Public path functions (MANPATH)
############################################################################

function man_path_append {
    if [[ ":$MANPATH:" != *":${1}:"* ]]; then
        export MANPATH="${MANPATH}:${1}"
    fi
}
_paths_remember_fn man_path_append

function man_path_append_if_exists {
    if [[ -d "${1}" ]]; then
        man_path_append "${1}"
    fi
}
man_path_append_if_exists

############################################################################
# Public path functions (FPATH)
############################################################################

function function_path_append {
    if [[ ":${FPATH}:" != *":${1}:"* ]]; then
        export FPATH="${FPATH}:${1}"
    fi
}
_paths_remember_fn function_path_append

function function_path_append_if_exists {
    if [[ -d "${1}" ]]; then
        function_path_append "${1}"
    fi
}
_paths_remember_fn function_path_append_if_exists

############################################################################
# Public script functions
############################################################################

function source_if_exists {
    # Don't bother to source zero-length files
    if [[ -s "${1}" ]]; then
        source "${1}"
    fi
}

############################################################################
# Unload plugin function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
paths_plugin_unload() {
    emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${PATHS[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done

    # Remove the global data variable.
    unset PATHS

    # Remove self from fpath.
    # shellcheck disable=SC2296
    fpath=("${(@)fpath:#${0:A:h}}")

    # Remove this function.
    unfunction "paths_plugin_unload"
}

true
