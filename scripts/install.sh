#!/usr/bin/env bash

auto_install() {
    local SDIR="$(realpath "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")"
    local ROOTDIR=$(dirname "$SDIR")

    source "$SDIR/utils.sh"

    if [ ! -f "$ROOTDIR/setup.sh" ]; then
        cp "$SDIR/setup.sh" "$ROOTDIR"
        echo "setup.sh not found. Copied the default setup.sh to the root directory."
    fi

    if [ ! -f "$ROOTDIR/env.sh" ]; then
        cp "$SDIR/env.sh" "$ROOTDIR"
        echo "env.sh not found. Copied the default env.sh to the root directory."
    fi

    if [ ! -d "$ROOTDIR/env" ]; then
        mkdir "$ROOTDIR/env"
        echo "env directory not found. Created the env directory in the root directory."
    fi

    source "$ROOTDIR/setup.sh"

    update_flags_from_arg "$@"

    if [[ $DRY == true ]]; then
        echo "Dry run enabled."
    fi

    if [ $rav1e_enable == true ]; then
        echo "Installing rav1e..."
        source "$SDIR/rav1e.sh" "${rav1e_opts[@]}"
        echo "rav1e installed."
    fi

    if [ $cosmocc_enable == true ]; then
        echo "Installing cosmocc..."
        source "$SDIR/cosmocc.sh" "${cosmocc_opts[@]}"
        echo "cosmocc installed."
    fi

    if [ $ffmpeg_enable == true ]; then
        echo "Installing ffmpeg..."
        if [ $ffmpeg_source_only == true ]; then
            ffmpeg_opts+=(-source-only)
        fi
        source "$SDIR/ffmpeg.sh" "${ffmpeg_opts[@]}"
        echo "ffmpeg installed."
    fi

    source "$ROOTDIR/env.sh"
    echo "All done."
}

auto_install "$@"
