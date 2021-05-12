if exists('g:loaded_akashi_vim')
    finish
endif

let g:loaded_akashi_vim = 1

" Check availability

if has('nvim')
    call akashi#logger#err('Currently NeoVim is not supported. Your PRs are welcome!')
    finish
endif

if !has('timers') || !has('job') || !has('channel') || !has('lambda')
    call akashi#logger#err('Currently Vim 8 with +timers +job +channel +lambda is required')
    finish
endif

" User Configuration

let g:akashi_max_log_lines = get(g:, 'akashi_max_log_lines', 10000)

" if true, trim log with using the value from `g:akashi_max_log_lines`
let g:akashi_enable_trim_log = get(g:, 'akashi_enable_trim_log', v:true)

let g:akashi_asp_port = get(g:, 'akashi_asp_port', 1234)

" DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4
let g:akashi_asp_log_level = get(g:, 'akashi_asp_log_level', 3)

" Debug Configuration
"
" These global variables are used for testing/debugging purposes.
" Normally, users should not overwrite these variables.

let g:akashi_debug_job_commands_head = get(g:, 'akashi_debug_job_commands_head', [])
let g:akashi_debug_job_env = get(g:, 'akashi_debug_job_env', {})

" Command settings

command! -nargs=1 -bar -complete=file ASPInit call akashi#ASPInit(<q-args>)
command! -nargs=0 -bar ASPTerminate call akashi#ASPTerminate()
command! -nargs=0 -bar ASPPlayerExit call akashi#ASPPlayerExit()
command! -nargs=0 -bar ASPLog call akashi#ASPLog()
command! -nargs=* -bar -complete=customlist,akashi#utils#completionCurrentBufferWords ASPEval call akashi#ASPEval(<q-args>)
command! -nargs=1 -bar ASPSeek call akashi#ASPSeek(<args>)
command! -nargs=1 -bar ASPRSeek call akashi#ASPRSeek(<args>)
command! -nargs=* -bar ASPFrameStep call akashi#ASPFrameStep(<args>)
command! -nargs=* -bar ASPFrameBackStep call akashi#ASPFrameBackStep(<args>)
command! -nargs=0 -bar ASPCurrentTime call akashi#ASPCurrentTime()
command! -nargs=0 -bar ASPToggleFullscreen call akashi#ASPToggleFullscreen()
command! -nargs=0 -bar ASPTogglePlayState call akashi#ASPTogglePlayState()
