let s:akashi_default_log_header = '[akashi.vim] '

" @params {t_string} msg
" @params {t_string} loglevel
" @params {t_string} header
" @noreturns
function! s:printLog(msg, loglevel, header) abort
    if a:loglevel ==# 'err'
        echohl ErrorMsg
    elseif a:loglevel ==# 'warn'
        echohl WarningMsg
    else
        echohl None
    endif

    echo a:header . a:msg

    echohl None
endfunction

" @params {t_list} arglist
" @returns {t_string}
function! s:getLogHeader(arglist) abort
    return get(a:arglist, 0, s:akashi_default_log_header)
endfunction

" @params {t_string} msg
" @params {t_list} ...
" @noreturns
function! akashi#logger#info(msg, ...) abort
    call s:printLog(a:msg, 'info', s:getLogHeader(a:000))
endfunction

" @params {t_string} msg
" @params {t_list} ...
" @noreturns
function! akashi#logger#warn(msg, ...) abort
    call s:printLog(a:msg, 'warn', s:getLogHeader(a:000))
endfunction

" @params {t_string} msg
" @params {t_list} ...
" @noreturns
function! akashi#logger#err(msg, ...) abort
    call s:printLog(a:msg, 'err', s:getLogHeader(a:000))
endfunction
