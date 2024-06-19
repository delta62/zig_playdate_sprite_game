#!/usr/bin/env bash

zig translate-c \
    -lc \
    -D_NO_CRT_STDIO_INLINE \
    -DTARGET_EXTENSION \
    -DTARGET_SIMULATOR \
    "${HOME}/.local/share/playdate-sdk/C_API/pd_api.h"