" @params {t_string} id
" @params {t_string} method
" @params {t_any} params
" @returns {t_str}
function! akashi#message#request(id, method, params) abort

    let l:payload = {'jsonrpc': '2.0', 'id': a:id, 'method': a:method}
    if !empty(a:params)
        let l:payload.params = a:params
    endif

    let l:payload_json = json_encode(l:payload)

    let l:CRLF = "\r\n"
    " make sure to have a valid Content-Length
    let l:request = join([
        \ 'POST /asp HTTP/1.1',
        \ 'Host: localhost',
        \ 'Content-type: application/json',
        \ 'Content-Length: ' . strlen(l:payload_json),
        \ '',
        \ l:payload_json], l:CRLF)

    return l:request
endfunction

" @params {t_string} resp
" @returns {t_dict}
function! akashi#message#parseResponse(resp) abort
    let l:lines = split(a:resp, "\n")

    let l:body_index = -1
    for l:idx in range(len(l:lines))
        if strlen(l:lines[l:idx]) == 0
            let l:body_index = l:idx + 1
        endif
    endfor

    return json_decode(l:lines[l:body_index])
endfunction

