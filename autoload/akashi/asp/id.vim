" @params {t_string} head
" @returns {t_string}
function! akashi#asp#id#create(head) abort
    return a:head . '_' . string(localtime())
endfunction
