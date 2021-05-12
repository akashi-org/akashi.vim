" script global states
let s:akashi_job = get(s:, 'akashi_job', v:none)
let s:akashi_log = get(s:, 'akashi_log', akashi#asp#log#init())
let s:akashi_cb_map = get(s:, 'akashi_cb_map', akashi#asp#cb_map#create())

" @params {t_channel} channel
" @params {t_string} msg
" @noreturns
function! s:ASPJobOutCallback(channel, msg) abort
    call akashi#asp#log#append(s:akashi_log, a:msg)
endfunction

" @params {t_channel} channel
" @params {t_string} msg
" @noreturns
function! s:ASPJobErrCallback(channel, msg) abort
    call akashi#asp#log#append(s:akashi_log, a:msg)
endfunction

" @params {t_channel} channel
" @noreturns
function! s:ASPJobCloseCallback(channel) abort
endfunction

" @params {t_job} job
" @params {t_number} exit_status
" @noreturns
function! s:ASPJobExitCallback(job, exit_status) abort
    if a:exit_status != 0
        call akashi#logger#err('ASP Process exits with error code {' . a:exit_status . '}')
    endif
    let s:akashi_job = v:none
endfunction

" @params {t_channel} channel
" @params {t_string} msg
" @noreturns
function! s:ASPChannelCallback(channel, msg) abort
    let l:resp_dict = akashi#message#parseResponse(a:msg)

    if has_key(l:resp_dict, 'result') && type(l:resp_dict['result']['value']) != v:t_bool
        let l:method_cb = akashi#asp#cb_map#get(s:akashi_cb_map, l:resp_dict['id'])
        if akashi#result#isOk(l:method_cb)
            call akashi#result#unwrap(l:method_cb)(l:resp_dict['result']['value'])
            call akashi#asp#cb_map#remove(s:akashi_cb_map, l:resp_dict['id'])
        endif
    endif

    if has_key(l:resp_dict, 'error')
        call akashi#logger#err(l:resp_dict['error']['data'])
    endif

    call akashi#channel#close(a:channel)
endfunction

" @noreturns
function! akashi#ASPLog() abort
    call akashi#asp#log#show(s:akashi_log)
endfunction

" @params {t_string} configPath
" @noreturns
function! akashi#ASPInit(configPath) abort
    if s:akashi_job !=# v:none
      call akashi#logger#err('ASP Process already exists')
      return
    endif

    let s:akashi_log = akashi#asp#log#init()
    let s:akashi_cb_map = akashi#asp#cb_map#create()

    let l:job_options = {}
    let l:job_options.out_cb = function('s:ASPJobOutCallback')
    let l:job_options.err_cb = function('s:ASPJobErrCallback')
    let l:job_options.close_cb = function('s:ASPJobCloseCallback')
    let l:job_options.exit_cb = function('s:ASPJobExitCallback')

    let l:job_commands = []
    if empty(g:akashi_debug_job_commands_head)
        let l:job_commands = ['akashi-cli', 'kernel', '-c', a:configPath]
    else
        let l:job_commands = g:akashi_debug_job_commands_head + [a:configPath]
    endif

    if empty(g:akashi_debug_job_env)
        let l:job_options.env = {'AK_LOGLEVEL': g:akashi_asp_log_level}
    else
        let l:job_options.env = g:akashi_debug_job_env
    endif

    let s:akashi_job = akashi#result#unwrapOr(
        \ akashi#job#create(l:job_commands, l:job_options),
        \ v:none)

    call akashi#logger#info('ASP Process launched')
endfunction

" @params {t_string} elem_name defaults to ''
" @noreturns
function! akashi#ASPEval(...) abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif
    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))

    let l:currentFilePath = resolve(expand('%:p'))
    let l:elem_name = get(a:, 1, '')
    let l:request = akashi#message#request('12', 'general/eval', [l:currentFilePath, l:elem_name])
    call akashi#channel#send(l:channel, l:request)
endfunction

" @params {t_number} seek_sec
" @noreturns
function! akashi#ASPSeek(seek_sec) abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif

    if a:seek_sec < 0
        call akashi#logger#err('Negative sec not available')
        return
    endif

    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))
    let l:request = akashi#message#request('12', 'media/seek', [a:seek_sec, 1])
    call akashi#channel#send(l:channel, l:request)
endfunction

" @params {t_number} seek_sec
" @noreturns
function! akashi#ASPRSeek(seek_sec) abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif
    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))
    let l:request = akashi#message#request('12', 'media/relative_seek', [a:seek_sec, 1])
    call akashi#channel#send(l:channel, l:request)
endfunction

" @noreturns
function! akashi#ASPFrameStep(...) abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif

    let l:count = get(a:, 1, 1)
    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))
    let l:request = akashi#message#request('12', 'media/frame_step', {})
    call akashi#channel#send(l:channel, l:request)
endfunction

" @noreturns
function! akashi#ASPFrameBackStep(...) abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif

    let l:count = get(a:, 1, 1)
    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))
    let l:request = akashi#message#request('12', 'media/frame_back_step', {})
    call akashi#channel#send(l:channel, l:request)
endfunction

" @params {t_list} time
" @noreturns
function! s:ASPCurrentTimeCallback(time) abort
    let l:float_time = a:time[0] / (a:time[1] * 1.0)
    call akashi#logger#info('Current time copied to clipboard: ' . string(l:float_time))
    let @+ = 'Second(' . a:time[0] . ', ' . a:time[1] . ')'
endfunction

" @noreturns
function! akashi#ASPCurrentTime() abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif

    let l:count = get(a:, 1, 1)
    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))

    let l:asp_id = akashi#asp#id#create('current_time')
    call akashi#asp#cb_map#insert(s:akashi_cb_map, l:asp_id, function('s:ASPCurrentTimeCallback'))
    let l:request = akashi#message#request(l:asp_id, 'media/current_time', {})
    call akashi#channel#send(l:channel, l:request)
endfunction


" @noreturns
function! akashi#ASPToggleFullscreen() abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif
    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))
    let l:request = akashi#message#request('12', 'media/toggle_fullscreen', {})
    call akashi#channel#send(l:channel, l:request)
endfunction

" @noreturns
function! akashi#ASPTogglePlayState() abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif
    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))
    let l:request = akashi#message#request('12', 'gui/click', ['play_btn'])
    call akashi#channel#send(l:channel, l:request)
endfunction

" @noreturns
function! akashi#ASPPlayerExit() abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP channel found')
        return
    endif
    let l:channel = akashi#result#unwrap(akashi#channel#create('localhost:' . g:akashi_asp_port, function('s:ASPChannelCallback')))
    let l:request = akashi#message#request('12', 'general/terminate', {})
    call akashi#channel#send(l:channel, l:request)
endfunction

" @noreturns
function! akashi#ASPTerminate() abort
    if s:akashi_job ==# v:none
        call akashi#logger#err('No ASP process found')
        return
    endif
    call akashi#job#destroy(s:akashi_job)
    let s:akashi_job = v:none
endfunction
