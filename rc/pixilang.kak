# Pixilang support for Kakoune
# TeddyDD 2019

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.pixi$ %{
    set-option buffer filetype pixilang
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=pixilang %{
    require-module pixilang
    set-option window comment_line '//'
    set-option window static_words %opt{pixilang_static_words}

    # cleanup trailing whitespaces when exiting insert mode
    hook window ModeChange insert:.* -group pixilang-trim-indent %{ try %{ execute-keys -draft <a-x>s^\h+$<ret>d } }
    hook window InsertChar \n -group pixilang-indent pixilang-indent-on-new-line
    hook window InsertChar \{ -group pixilang-indent pixilang-indent-on-opening-curly-brace
    hook window InsertChar \} -group pixilang-indent pixilang-indent-on-closing-curly-brace

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window pixilang-.+ }
}

hook -group pixilang-highlight global WinSetOption filetype=pixilang %{
    add-highlighter window/pixilang ref pixilang
    hook -once -always window WinSetOption filetype=.* %{
        remove-highlighter window/pixilang
    }
}

# Options
# ‾‾‾‾‾‾‾

declare-option -docstring 'Path to Pixilang executabe' str pixilang_path 'pixilang' 

provide-module pixilang %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/pixilang regions
add-highlighter shared/pixilang/code default-region group
add-highlighter shared/pixilang/double_string region '"' (?<!\\)(\\\\)*" fill string
add-highlighter shared/pixilang/comment_line region '//' $ fill comment
add-highlighter shared/pixilang/code/locals regex "\$\w+" 0:variable
add-highlighter shared/pixilang/code/operators regex '%|/|div|\*|\+|-|>>|<<|==?|!=|<|>|<=|>=|\||\^|&|\|\||&&' 0:operator
add-highlighter shared/pixilang/code/numbers regex '\b([0#][xb]?)?[\dA-F]+(\.?\d+)?\b' 0:value
add-highlighter shared/pixilang/code/labels regex '^\w+:' 0:module

evaluate-commands %sh{
	types="INT|INT8|INT16|INT32|INT64|FLOAT|FLOAT32|FLOAT64|PIXEL"
	flags="CFLAG_INTERP|GL_MIN_LINEAR|GL_MAG_LINEAR|GL_NICEST|GL_NO_XREPEAT"
    flags="${flags}|GL_NO_YREPEAT|GL_NO_ALPHA|RESIZE_INTERP1|RESIZE_INTERP2"
    flags="${flags}|RESIZE_UNSIGNED_INTERP2|RESIZE_COLOR_INTERP1|RESIZE_COLOR_INTERP2"
    flags="${flags}|COPY_NO_AUTOROTATE|COPY_CLIPPING|INT_SIZE|FLOAT_SIZE|INT_MAX|COLORBITS"
    flags="${flags}|Z_NO_COMPRESSION|Z_BEST_SPEED|Z_BEST_COMPRESSION|Z_DEFAULT_COMPRESSION"
    flags="${flags}|FORMAT_RAW|FORMAT_JPEG|FORMAT_PNG|FORMAT_GIF|FORMAT_WAVE|FORMAT_AIFF"
    flags="${flags}|FORMAT_PIXICONTAINER|LOAD_FIRST_FRAME|GIF_GRAYSCALE|GIF_DITHER|JPEG_H1V1"
    flags="${flags}|JPEG_H2V1|JPEG_H2V2|JPEG_TWOPASS|ORANGE|BLACK|WHITE|YELLOW|RED|GREEN"
    flags="${flags}|BLUE|TOP|BOTTOM|LEFT|RIGHT|EFF_NOISE|EFF_SPREAD_LEFT|EFF_SPREAD_RIGHT"
    flags="${flags}|EFF_SPREAD_UP|EFF_SPREAD_DOWN|EFF_HBLUR|EFF_VBLUR|EFF_COLOR|GL_POINTS"
    flags="${flags}|GL_LINE_STRIP|GL_LINE_LOOP|GL_LINES|GL_TRIANGLE_STRIP|GL_TRIANGLE_FAN"
    flags="${flags}|GL_TRIANGLES|GL_ZERO|GL_ONE|GL_SRC_COLOR|GL_ONE_MINUS_SRC_COLOR"
    flags="${flags}|GL_DST_COLOR|GL_ONE_MINUS_DST_COLOR|GL_SRC_ALPHA|GL_ONE_MINUS_SRC_ALPHA"
    flags="${flags}|GL_DST_ALPHA|GL_ONE_MINUS_DST_ALPHA|GL_SRC_ALPHA_SATURATE|GL_MAX_TEXTURE_SIZE"
    flags="${flags}|GL_MAX_VERTEX_ATTRIBS|GL_MAX_VERTEX_UNIFORM_VECTORS|GL_MAX_VARYING_VECTORS"
    flags="${flags}|GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS|GL_MAX_TEXTURE_IMAGE_UNITS"
    flags="${flags}|GL_MAX_FRAGMENT_UNIFORM_VECTORS|GL_SHADER_SOLID|GL_SHADER_GRAD"
    flags="${flags}|GL_SHADER_TEX_ALPHA_SOLID|GL_SHADER_TEX_ALPHA_GRAD|GL_SHADER_TEX_RGB_SOLID"
    flags="${flags}|GL_SHADER_TEX_RGB_GRAD|GL_SCREEN|GL_ZBUF|AUDIO_FLAG_INTERP2|MIDI_PORT_READ"
    flags="${flags}|MIDI_PORT_WRITE|EVT|EVT_TYPE|EVT_FLAGS|EVT_TIME|EVT_X|EVT_Y|EVT_KEY"
    flags="${flags}|EVT_SCANCODE|EVT_PRESSURE|EVT_UNICODE|EVT_MOUSEBUTTONDOWN|EVT_MOUSEBUTTONUP"
    flags="${flags}|EVT_MOUSEMOVE|EVT_TOUCHBEGIN|EVT_TOUCHEND|EVT_TOUCHMOVE|EVT_BUTTONDOWN"
    flags="${flags}|EVT_BUTTONUP|EVT_SCREENRESIZE|EVT_QUIT|EVT_FLAG_SHIFT|EVT_FLAG_CTRL"
    flags="${flags}|EVT_FLAG_ALT|EVT_FLAG_MODE|EVT_FLAG_MODS|EVT_FLAG_DOUBLECLICK|KEY_MOUSE_LEFT"
    flags="${flags}|KEY_MOUSE_MIDDLE|KEY_MOUSE_RIGHT|KEY_MOUSE_SCROLLUP|KEY_MOUSE_SCROLLDOWN"
    flags="${flags}|KEY_BACKSPACE|KEY_TAB|KEY_ENTER|KEY_ESCAPE|KEY_SPACE|KEY_F1|KEY_F2|KEY_F3"
    flags="${flags}|KEY_F4|KEY_F5|KEY_F6|KEY_F7|KEY_F8|KEY_F9|KEY_F10|KEY_F11|KEY_F12|KEY_UP"
    flags="${flags}|KEY_DOWN|KEY_LEFT|KEY_RIGHT|KEY_INSERT|KEY_DELETE|KEY_HOME|KEY_END|KEY_PAGEUP"
    flags="${flags}|KEY_PAGEDOWN|KEY_CAPS|KEY_SHIFT|KEY_CTRL|KEY_ALT|KEY_MENU|KEY_UNKNOWN"
    flags="${flags}|QA_NONE|QA_CLOSE_VM|THREAD_FLAG_AUTO_DESTROY|M_E|M_LOG2E|M_LOG10E"
    flags="${flags}|M_LN2|M_LN10|M_PI|M_2_SQRTPI|M_SQRT2|M_SQRT1_2|OP_MIN|OP_MAX|OP_MAXABS"
    flags="${flags}|OP_SUM|OP_LIMIT_TOP|OP_LIMIT_BOTTOM|OP_ABS|OP_SUB2|OP_COLOR_SUB2|OP_DIV2"
    flags="${flags}|OP_H_INTEGRAL|OP_V_INTEGRAL|OP_H_DERIVATIVE|OP_V_DERIVATIVE|OP_H_FLIP"
    flags="${flags}|OP_V_FLIP|OP_ADD|OP_SADD|OP_COLOR_ADD|OP_SUB|OP_SSUB|OP_COLOR_SUB|OP_MUL"
    flags="${flags}|OP_SMUL|OP_MUL_RSHIFT15|OP_COLOR_MUL|OP_DIV|OP_COLOR_DIV|OP_AND|OP_OR"
    flags="${flags}|OP_XOR|OP_LSHIFT|OP_RSHIFT|OP_EQUAL|OP_LESS|OP_GREATER|OP_COPY|OP_COPY_LESS"
    flags="${flags}|OP_COPY_GREATER|OP_BMUL|OP_EXCHANGE|OP_COMPARE|OP_MUL_DIV|OP_MUL_RSHIFT"
    flags="${flags}|OP_SIN|OP_SIN8|OP_RAND|SMP_INFO_SIZE|SMP_DEST|SMP_DEST_OFF|SMP_DEST_LEN"
    flags="${flags}|SMP_SRC|SMP_SRC_OFF_H|SMP_SRC_OFF_L|SMP_SRC_SIZE|SMP_LOOP|SMP_LOOP_LEN"
    flags="${flags}|SMP_VOL1|SMP_VOL2|SMP_DELTA|SMP_FLAGS|SMP_FLAG_INTERP2|SMP_FLAG_INTERP4"
    flags="${flags}|SMP_FLAG_PINGPONG|SMP_FLAG_REVERSE|CCONV_DEFAULT|CCONV_CDECL|CCONV_STDCALL"
    flags="${flags}|CCONV_UNIX_AMD64|CCONV_WIN64|FOPEN_MAX|SEEK_CUR|SEEK_END|SEEK_SET|EOF|STDIN"
    flags="${flags}|STDOUT|STDERR|PIXILANG_VERSION|OS_NAME|ARCH_NAME|LANG_NAME|CURRENT_PATH"
    flags="${flags}|USER_PATH|TEMP_PATH|OPENGL"

	globals="WINDOW_XSIZE|WINDOW_YSIZE|WINDOW_SAFE_AREA_X"
	globals="${globals}|WINDOW_SAFE_AREA_Y|WINDOW_SAFE_AREA_W|WINDOW_SAFE_AREA_H|FPS|PPI"
	globals="${globals}|UI_SCALE|UI_FONT_SCALE"

	props="file_format|sample_rate|channels|loop_start|loop_len|loop_type"
	props="${props}|frames|frame|fps|play|repeat|start_time|start_frame"

    functions="new|remove|remove_with_alpha|resize|rotate|convert_type|clean|clone|copy"
    functions="${functions}|get_size|get_xsize|get_ysize|get_esize|get_type|get_flags|set_flags"
    functions="${functions}|reset_flags|get_prop|set_prop|remove_props|show_memory_debug_messages"
    functions="${functions}|zlib_pack|zlib_unpack|num_to_str|str_to_num|strcat|strcmp|strlen|strstr"
    functions="${functions}|sprintf|printf|fprintf|logf|get_log|get_system_log|load|fload|save|fsave"
    functions="${functions}|get_real_path|new_flist|remove_flist|get_flist_name|get_flist_type|flist_next"
    functions="${functions}|get_file_size|remove_file|rename_file|copy_file|create_directory|set_disk0"
    functions="${functions}|get_disk0|fopen|fopen_mem|fclose|fputc|fputs|fwrite|fgetc|fgets|fread"
    functions="${functions}|feof|fflush|fseek|ftell|setxattr|frame|vsync|set_pixel_size|get_pixel_size"
    functions="${functions}|set_screen|get_screen|set_zbuf|get_zbuf|clear_zbuf|get_color|get_red|get_green"
    functions="${functions}|get_blue|get_blend|transp|get_transp|clear|dot|dot3d|get_dot|get_dot3d|line"
    functions="${functions}|line3d|box|fbox|pixi|triangles3d|sort_triangles3d|set_key_color|get_key_color"
    functions="${functions}|set_alpha|get_alpha|print|get_text_xsize|get_text_ysize|set_font|get_font"
    functions="${functions}|effector|color_gradient|split_rgb|split_ycbcr|set_gl_callback|remove_gl_data"
    functions="${functions}|gl_draw_arrays|gl_blend_func|gl_bind_framebuffer|gl_bind_texture|gl_get_int"
    functions="${functions}|gl_get_float|gl_new_prog|gl_use_prog|gl_uniform|gl_uniform_matrix|pack_frame"
    functions="${functions}|unpack_frame|create_anim|remove_anim|clone_frame|remove_frame|play|stop"
    functions="${functions}|t_reset|t_rotate|t_translate|t_scale|t_push_matrix|t_pop_matrix|t_get_matrix"
    functions="${functions}|t_set_matrix|t_mul_matrix|t_point|set_audio_callback|get_audio_sample_rate"
    functions="${functions}|enable_audio_input|get_note_freq|midi_open_client|midi_close_client"
    functions="${functions}|midi_get_device|midi_open_port|midi_reopen_port|midi_close_port|midi_get_event"
    functions="${functions}|midi_get_event_time|midi_next_event|midi_send_event|start_timer|get_timer"
    functions="${functions}|get_year|get_month|get_day|get_hours|get_minutes|get_seconds|get_ticks"
    functions="${functions}|get_tps|sleep|get_event|set_quit_action|thread_create|thread_destroy"
    functions="${functions}|mutex_create|mutex_destroy|mutex_lock|mutex_trylock|mutex_unlock|op_cn"
    functions="${functions}|op_cc|op_ccn|generator|wavetable_generator|sampler|envelope2p|gradient|fft"
    functions="${functions}|new_filter|remove_filter|reset_filter|init_filter|apply_filter|replace_values"
    functions="${functions}|copy_and_resize|file_dialog|prefs_dialog|open_url|dlopen|dlclose|dlsym|dlcall"
    functions="${functions}|system|argc|argv|exit"

    keywords="if|else|while|fn|include|halt|go(to)?|ret|continue|break(all)?"

	printf %s\\n "declare-option str-list pixilang_static_words ${flags} ${types} ${globals} ${functions}" | tr '|' ' '

    printf %s "
		add-highlighter shared/pixilang/code/types     regex '\b(${types})\b' 0:type
		add-highlighter shared/pixilang/code/global    regex '\b(${globals})\b' 0:builtin
		add-highlighter shared/pixilang/code/functions regex '\b(${functions})\b' 0:function
		add-highlighter shared/pixilang/code/keywords  regex '\b(${keywords})\b' 0:keyword
    "
}

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden pixilang-indent-on-new-line %~
    evaluate-commands -draft -itersel %=
        # preserve previous line indent
        try %{ execute-keys -draft \;K<a-&> }
        # indent after lines ending with { or (
        try %[ execute-keys -draft k<a-x> <a-k> [{(]\h*$ <ret> j<a-gt> ]
        # cleanup trailing white spaces on the previous line
        try %{ execute-keys -draft k<a-x> s \h+$ <ret>d }
        # align to opening paren of previous line
        try %{ execute-keys -draft [( <a-k> \A\([^\n]+\n[^\n]*\n?\z <ret> s \A\(\h*.|.\z <ret> '<a-;>' & }
        # copy // comments prefix
        try %{ execute-keys -draft \;<c-s>k<a-x> s ^\h*\K/{2,} <ret> y<c-o>P<esc> }
    =
~

define-command -hidden pixilang-indent-on-opening-curly-brace %[
    # align indent with opening paren when { is entered on a new line after the closing paren
    try %[ execute-keys -draft -itersel h<a-F>)M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
]

define-command -hidden pixilang-indent-on-closing-curly-brace %[
    # align to opening curly brace when alone on a line
    try %[ execute-keys -itersel -draft <a-h><a-k>^\h+\}$<ret>hms\A|.\z<ret>1<a-&> ]
]

define-command pixilang-run %{
	evaluate-commands %sh{
		if [ "$kak_modified" = "true" ]
		then
			file="$(mktemp ${TMPDIR:-/tmp}/pixi-XXXXXX.pixi)"
			echo "write -sync ${file}"
		else
			file="${kak_buffile}"
		fi
		( "$kak_opt_pixilang_path" "$file" ) </dev/null >/dev/null 2>&1 &
	}
}

§ # module pixilang ------
