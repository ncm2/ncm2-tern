if get(s:, 'loaded', 0)
    finish
endif
let s:loaded = 1

let g:ncm2_tern#proc = yarp#py3('ncm2_tern')

let g:ncm2_tern#source = extend(
            \ get(g:, 'ncm2_tern#source', {}), {
            \ 'name': 'tern',
            \ 'priority': 9,
            \ 'mark': 'js',
            \ 'early_cache': 1,
            \ 'subscope_enable': 1,
            \ 'scope': ['javascript','javascript.jsx'],
            \ 'word_pattern': '[\w/]+',
            \ 'complete_pattern': ['\.', "require\\s*\\(\\s*['\"][^)'\"]*"],
            \ 'on_complete': 'ncm2_tern#on_complete',
            \ 'on_warmup': 'ncm2_tern#on_warmup',
            \ }, 'keep')

func! ncm2_tern#init()
    call ncm2#register_source(g:ncm2_tern#source)
endfunc

func! ncm2_tern#on_warmup(ctx)
    call g:ncm2_tern#proc.jobstart()
endfunc

func! ncm2_tern#on_complete(ctx)
    call g:ncm2_tern#proc.try_notify('on_complete',
            \ a:ctx,
            \ getline(1, '$'))
endfunc

func! ncm2_tern#error(msg)
    call g:ncm2_tern#proc.error(a:msg)
endfunc
