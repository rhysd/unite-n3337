scriptencoding utf-8

" check variables {{{

" check g:unite_n3337_pdf {{{
" If you don't have PDF file, get it from http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf
if !exists('g:unite_n3337_pdf') && !exists('g:unite_n3337_txt')
    echoerr "get N3337 PDF file from http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf and set its path to g:unite_n3337_pdf!"
    finish
endif
"}}}

if !isdirectory(g:unite_data_directory."/n3337")
    call mkdir(g:unite_data_directory."/n3337","p")
endif

" check g:unite_n3337_txt {{{
if !exists('g:unite_n3337_txt')

    if !filereadable(g:unite_data_directory.'/n3337/n3337.txt')
        if !executable('pdftotext')
            echoerr "Install pdftotext command, or set n3337.txt location to g:unite_n3337_txt"
            finish
        endif
        " generate text data of n3337 using pdftotext
        execute "!pdftotext -layout -nopgbrk ".g:unite_n3337_pdf." - > ".g:unite_data_directory."/n3337/n3337.txt"
    endif

    let g:unite_n3337_txt = g:unite_data_directory."/n3337/n3337.txt"

endif
"}}}

let g:unite_n3337_is_multiline = get(g:, "unite_n3337_is_multiline", 0)
"}}}


let s:save_cpo = &cpo
set cpo&vim

let s:source = {
    \   "name" : "n3337",
    \   "description" : "quick look into N3337, Working Draft standard for C++ which is the nearest to ISO/IEC 14882/2011.",
    \   "default_action" : {'*' : 'action__n3337_lines'},
    \   "action_table" : {},
    \}

function! s:source.gather_candidates(args, context) " {{{

    " contract section titles {{{
    if !filereadable(g:unite_data_directory."/n3337/sections")
        let n3337 = readfile(g:unite_n3337_txt)
        let sections = []

        for linum in range(1,len(n3337))
            let idx = linum - 1
            let match = matchlist(n3337[idx],'^\s*\([0-9.]\+\)\s\+\([^\[]\+\)\[[a-z.]\+]$')
            if !empty(match) && match[2] !~# '^\s\+$'
                call add(sections, linum."\t".match[1]."\t".substitute(match[2], '\s*$','',''))
            endif
        endfor

        call writefile(sections, g:unite_data_directory."/n3337/sections")
    endif
    "}}}

    " make candidates "{{{
    let sections = map( readfile(g:unite_data_directory."/n3337/sections"),"split(v:val,'\t')" )

    return map(sections, "{
    \ 'word' : v:val[1].repeat(' ', 15-strlen(v:val[1])).': '.v:val[2],
    \ 'is_multiline' : g:unite_n3337_is_multiline,
    \ 'source__n3337_line' : v:val[0]
    \ }" )
"}}}

endfunction
"}}}

" original action {{{
let s:my_action_table = {}

" main action {{{
let s:my_action_table.action__n3337_lines = {
            \ 'description' : 'jump to the line of N3337',
            \ }
function! s:my_action_table.action__n3337_lines.func(candidate)
    execute "view +".a:candidate.source__n3337_line." ".g:unite_n3337_txt
    setl syntax=unite-source-N3337
    setl nowrap nonumber
endfunction
"}}}

" preview action {{{
let s:my_action_table.preview = {
            \ 'description' : 'preview this title of N3337',
            \ 'is_quit' : 0
            \ }
function! s:my_action_table.preview.func(candidate)

    let buflisted = buflisted(
                \ unite#util#escape_file_searching(
                \ g:unite_n3337_txt))
    execute "pedit +".a:candidate.source__n3337_line." ".g:unite_n3337_txt

    if !buflisted
        call unite#add_previewed_buffer_list(
                    \ bufnr(unite#util#escape_file_searching(
                    \       g:unite_n3337_txt)))
    endif

endfunction
"}}}

let s:source.action_table = s:my_action_table
"}}}

function! unite#sources#n3337#define()
    return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
