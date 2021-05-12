" @params {t_job} job_handle
" @returns {t_string}
function! akashi#job#status(job_handle) abort
    return job_status(a:job_handle)
endfunction

" @params {t_list or t_string} job_commands
" @params {t_dict} user_job_options
" @returns {t_dict} result
function! akashi#job#create(job_commands, user_job_options) abort
    let l:job_options = {'out_io': 'pipe', 'err_io': 'pipe'}
    " let l:job_options.pty = 1
    call extend(l:job_options, a:user_job_options)

    let l:job_handle = job_start(a:job_commands, l:job_options)

    if akashi#job#status(l:job_handle) !=# 'run'
        call akashi#logger#err('Failed to start ASP Process')
        return akashi#result#err(v:none)
    endif

    return akashi#result#ok(l:job_handle)
endfunction

" @params {t_job} job_handle
" @noreturns
function! akashi#job#destroy(job_handle) abort
    call job_stop(a:job_handle, 'term')
    if akashi#job#status(a:job_handle) !=# 'dead'
        let l:timer = timer_start(
            \ 100,
            \ {timer -> [job_stop(a:job_handle, 'kill'), akashi#logger#info('ASP Process successfully killed')] },
            \ {'repeat': 1}
            \ )
        return
    endif

    call akashi#logger#info('ASP Process successfully terminated')
endfunction
