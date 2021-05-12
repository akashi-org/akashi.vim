let s:result_value_key_name = 'akashi_priv_result'
let s:result_err_key_name = 'akashi_priv_err'

" @params {t_any} value
" @params {t_bool} err
" @returns {t_dict} result
function! s:result(value, err) abort
    let l:res = {}
    let l:res[s:result_value_key_name] = a:value
    let l:res[s:result_err_key_name] = a:err
    return l:res
endfunction

" @params {t_any} value
" @returns {t_dict} result
function! akashi#result#ok(value) abort
    return s:result(a:value, v:false)
endfunction

" @params {t_dict} res
" @returns {t_bool}
function! akashi#result#isOk(res) abort
    return !a:res[s:result_err_key_name]
endfunction

" @params {t_any} value
" @returns {t_dict} result
function! akashi#result#err(value) abort
    return s:result(a:value, v:true)
endfunction

" @params {t_dict} res
" @returns {t_bool}
function! akashi#result#isErr(res) abort
    return a:res[s:result_err_key_name]
endfunction

" @params {t_dict} res
" @returns {t_any}
function! akashi#result#unwrap(res) abort
    return a:res[s:result_value_key_name]
endfunction

" @params {t_dict} res
" @params {t_any} default
" @returns {t_any}
function! akashi#result#unwrapOr(res, default) abort
    return akashi#result#isOk(a:res) ? akashi#result#unwrap(a:res) : a:default
endfunction
