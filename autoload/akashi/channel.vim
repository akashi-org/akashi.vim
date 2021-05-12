" @params {t_string} addr
" @params {t_func} cb
" @returns {t_dict} result
function! akashi#channel#create(addr, cb) abort
    let l:channel_options = {'mode': 'raw'}
    " set sufficient waittime for asp server to launch
    let l:channel_options.waittime = 0
    " set `blocking` by default as for now
    let l:channel_options.noblock = 0
    let l:channel_options.callback = a:cb
    let l:ch_handle = ch_open(a:addr, l:channel_options)

    if ch_status(l:ch_handle) !=# 'open'
        call akashi#logger#err('Failed to start ASP Channel')
        return akashi#result#err(v:none)
    endif

    return akashi#result#ok(l:ch_handle)
endfunction

" @params {t_channel} ch_handle
" @params {t_str} request
" @noreturns
function! akashi#channel#send(ch_handle, request) abort
    call ch_sendraw(a:ch_handle, a:request)
endfunction

" @params {t_channel} ch_handle
" @noreturns
function! akashi#channel#close(ch_handle) abort
    call ch_close(a:ch_handle)
endfunction
