" @returns {t_dict}
function! akashi#asp#log#init() abort
    return {'body': [] }
endfunction

" @params {t_dict} log
" @params {t_string} line
" @noreturns
function! akashi#asp#log#append(log, line) abort
    if g:akashi_enable_trim_log && len(a:log['body']) >= g:akashi_max_log_lines
        let a:log['body'] = [a:line]
    else
        let a:log['body'] += [a:line]
    endif
endfunction

" @params {t_dict} log
" @noreturns
function! akashi#asp#log#show(log) abort
    echo join(a:log['body'], "\n")
endfunction
