let s:cb_data_cb_key_name = 'akashi_priv_cb'
let s:cb_data_ctx_key_name = 'akashi_priv_ctx'

" @params {t_func} cb expects (RETVAL) => void where Type(RETVAL) == t_any
" @params {t_any} ctx
" @returns {t_dict}
function! s:cb_data(cb, ctx) abort
    let l:res = {}
    let l:res[s:cb_data_cb_key_name] = a:cb
    let l:res[s:cb_data_ctx_key_name] = a:ctx
    return l:res
endfunction

" @returns {t_dict}
function! akashi#asp#cb_map#create() abort
  return {}
endfunction

" @params {t_dict} cb_map
" @params {t_string} id
" @params {t_func} cb expects (RETVAL) => void where Type(RETVAL) == t_any
" @params {t_any} ctx
" @returns {t_dict}
function! akashi#asp#cb_map#insert(cb_map, id, cb, ctx) abort
    let a:cb_map[a:id] = s:cb_data(a:cb, a:ctx)
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
" @returns {t_dict} cb_data
function! akashi#asp#cb_map#get(cb_map, id) abort
    if has_key(a:cb_map, a:id)
        return akashi#result#ok(get(a:cb_map, a:id))
    else
        return akashi#result#err({})
    endif
endfunction

" @params {t_dict} cb_data
" @params {t_func} cb expects (RETVAL) => void where Type(RETVAL) == t_any
function! akashi#asp#cb_map#get_cb(cb_data) abort
    return a:cb_data[s:cb_data_cb_key_name]
endfunction

" @params {t_dict} cb_data
" @params {t_any}
function! akashi#asp#cb_map#get_ctx(cb_data) abort
    return a:cb_data[s:cb_data_ctx_key_name]
endfunction
