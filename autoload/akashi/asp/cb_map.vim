" @returns {t_dict}
function! akashi#asp#cb_map#create() abort
  return {}
endfunction

" @params {t_dict} cb_map
" @params {t_string} id
" @params {t_func} cb expects (RETVAL) => void where Type(RETVAL) == t_any
" @returns {t_dict}
function! akashi#asp#cb_map#insert(cb_map, id, cb) abort
    let a:cb_map[a:id] = a:cb
    return a:cb_map
endfunction

" @params {t_dict} cb_map
" @params {t_string} id
" @noreturns
function! akashi#asp#cb_map#remove(cb_map, id) abort
    call remove(a:cb_map, a:id)
endfunction

" @params {t_dict} cb_map
" @params {t_string} id
" @returns {t_dict} result
function! akashi#asp#cb_map#get(cb_map, id) abort
    if has_key(a:cb_map, a:id)
        return akashi#result#ok(get(a:cb_map, a:id))
    else
        return akashi#result#err({})
    endif
endfunction
