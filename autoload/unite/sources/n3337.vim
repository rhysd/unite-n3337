scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" source definition "{{{
let s:source = {
    \   "name" : "n3337",
    \   "description" : "quick look into N3337, Working Draft standard for C++ which is the nearest to ISO/IEC 14882/2011.",
    \   "default_action" : {'common' : 'n3337'},
    \   "syntax" : "uniteSource__N3337",
    \   "action_table" : {},
    \   "hooks" : {},
    \}

function! unite#sources#n3337#define()
    return s:source
endfunction
"}}}

" helpers "{{{
function! s:system(...) "{{{
    let cmd = join(a:000, ' ')
    try
        call vimproc#system(cmd)
    catch
        call system(cmd)
    endtry
endfunction
"}}}

" get script local ID {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID
"}}}
"}}}

" check variables on init hook "{{{
function! s:check_variables_on_init(args,context)

    " use is_multiline or not
    let g:unite_n3337_is_multiline = get(g:, "unite_n3337_is_multiline", 0)

    " use indents of sections or not
    let g:unite_n3337_indent_section = get(g:, "unite_n3337_indent_section", 0)

    " check data dir  {{{
    if !isdirectory(g:unite_data_directory."/n3337")
        call mkdir(g:unite_data_directory."/n3337","p")
    endif
    "}}}

    if !exists('g:unite_n3337_txt')
        " check g:unite_n3337_pdf {{{
        " If you don't have PDF file, get it from http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf
        if !exists('g:unite_n3337_pdf') || !filereadable(g:unite_n3337_pdf)
            call unite#print_error("Get N3337 PDF file from http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf and set its path to g:unite_n3337_pdf.")
            return
        endif
        "}}}

        " check g:unite_n3337_txt {{{
        if !filereadable(g:unite_data_directory.'/n3337/n3337.txt')
            if !executable('pdftotext')
                call unite#print_error("Install pdftotext command, or set n3337.txt location to g:unite_n3337_txt")
                return
            endif
            " generate text data of n3337 using pdftotext
            echo "convert pdf to plain-text..."
            call s:system("pdftotext -layout -nopgbrk ".g:unite_n3337_pdf." - > ".g:unite_data_directory."/n3337/n3337.txt")
            echo "done."
        endif
        let g:unite_n3337_txt = g:unite_data_directory."/n3337/n3337.txt"
        "}}}
    endif

endfunction
let s:source.hooks.on_init = function(s:SID.'check_variables_on_init')
"}}}

function! s:cache_sections() "{{{
    let n3337 = readfile(g:unite_n3337_txt)
    let sections = []

    for linum in range(1,len(n3337))
        let idx = linum - 1
        let match = matchlist(n3337[idx],'^\s*\([0-9.]\+\)\s\+\([^\[]\+\) \[[a-z.]\+]$')
        if !empty(match) && match[2] !~# '^\s\+$'
            call add(sections, linum."\t".match[1]."\t".substitute(match[2], '\s*$','',''))
        endif
    endfor

    call writefile(sections, g:unite_data_directory."/n3337/sections")
endfunction
"}}}

" gather candidates {{{
function! s:cache_and_gather_candidates(args, context)

    " g:unite_n3337_txt must be set by a user or on_init hook.
    if !exists('g:unite_n3337_txt')
        return []
    endif

    if !filereadable(g:unite_data_directory."/n3337/sections")
        call s:cache_sections()
    endif

    " make candidates from cache {{{
    let sections = map( readfile(g:unite_data_directory."/n3337/sections"),"split(v:val,'\t')" )

    if g:unite_n3337_indent_section
        return map(sections, "{
                    \ 'word' : repeat('  ', len(split(v:val[1],'\\.'))-1).v:val[1].': '.v:val[2],
                    \ 'is_multiline' : g:unite_n3337_is_multiline,
                    \ 'action__n3337_line' : v:val[0]
                    \ }" )
    else
        return map(sections, "{
                    \ 'word' : v:val[1].repeat(' ', 12-strlen(v:val[1])).': '.v:val[2],
                    \ 'is_multiline' : g:unite_n3337_is_multiline,
                    \ 'action__n3337_line' : v:val[0]
                    \ }" )
    endif
    "}}}

endfunction

let s:source.gather_candidates = function(s:SID.'cache_and_gather_candidates')
"}}}

" original actions {{{
let s:my_action_table = {}
let s:source.action_table = s:my_action_table

function! s:open_and_jump_n3337(line) "{{{
    let bufnr = bufnr(unite#util#escape_file_searching(g:unite_n3337_txt))
    if bufnr != bufnr('%')
        execute "view! ".g:unite_n3337_txt
    endif
    if !exists('b:current_syntax') || b:current_syntax !=# 'n3337'
        setl syntax=unite-source-N3337
        let b:current_syntax = 'n3337'
        setl nowrap nonumber nolist
    endif
    execute a:line
    normal! zz
    return bufnr
endfunction
"}}}

" open action {{{
let s:my_action_table.n3337 = {
            \ 'description' : 'jump to the line of N3337',
            \ }

function! s:open_action(candidate)
    let bufnr = s:open_and_jump_n3337(a:candidate.action__n3337_line)
    call unite#remove_previewed_buffer_list(bufnr)
endfunction
let s:my_action_table.n3337.func = function(s:SID.'open_action')
"}}}

" preview action {{{
let s:my_action_table.preview = {
            \ 'description' : 'preview this section of N3337',
            \ 'is_quit' : 0
            \ }

function! s:preview_action(candidate)
    let preview_windows = filter(range(1, winnr('$')),
          \ 'getwinvar(v:val, "&previewwindow") != 0')

    if empty(preview_windows)
      execute 'pedit! '.g:unite_n3337_txt
      let preview_windows = filter(range(1, winnr('$')),
            \ 'getwinvar(v:val, "&previewwindow") != 0')
    endif

    let winnr = winnr()
    execute preview_windows[0].'wincmd w'
    let bufnr = s:open_and_jump_n3337(a:candidate.action__n3337_line)
    execute winnr.'wincmd w'

    if !buflisted(bufnr)
      call unite#add_previewed_buffer_list(bufnr)
    endif
endfunction
let s:my_action_table.preview.func = function(s:SID.'preview_action')
"}}}

" edit action is the same as n3337 action {{{
let s:my_action_table.edit = s:my_action_table.n3337
"}}}
"}}}

" syntax highlight in unite "{{{
function! s:syntax_candidates(args,context)
    syntax match uniteSource__N3337_Number /\d[0-9\.]*/ contained containedin=uniteSource__N3337 nextgroup=uniteSource__N3337_Separator
    syntax match uniteSource__N3337_Separator /:/ contained containedin=uniteSource__N3337
    highlight default link uniteSource__N3337_Number Type
    highlight default link uniteSource__N3337_Separator Type
endfunction
"}}}

let s:source.hooks.on_syntax = function(s:SID.'syntax_candidates')
let &cpo = s:save_cpo
unlet s:save_cpo
