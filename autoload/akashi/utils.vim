" @params {t_string} argstr
" @params {t_string} cmdatr
" @params {t_number} cursorpos
" @returns {t_list}
function! akashi#utils#completionCurrentBufferWords(argstr, cmdstr, cursorpos) abort
    let l:pattern = '\(\<' . a:argstr . '[^ (=]*\>\)'
    let l:res = []
    call substitute(join(getline(1, '$'),"\n"), l:pattern, '\=add(l:res, submatch(0))', 'g')
    return l:res
endfunction
