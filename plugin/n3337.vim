let g:unite_n3337_txt = $HOME."/Documents/C++/n3337.txt"
" If you don't have PDF file, get it from http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf
if !exists('g:unite_n3337_pdf') && !exists('g:unite_n3337_txt')
    echoerr "get N3337 PDF file from http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf and set its path to g:unite_n3337_pdf!"
    finish
endif

if !isdirectory($HOME."/.unite/n3337")
    call mkdir($HOME."/.unite/n3337","p")
endif

if !exists('g:unite_n3337_txt')

    if !filereadable($HOME.'/.unite/n3337/n3337.txt')
        if !executable('pdftotext')
            echoerr "Install pdftotext command, or set n3337.txt location to g:unite_n3337_txt"
            finish
        endif
        execute "!pdftotext -layout -nopgbrk ".g:unite_n3337_pdf." - > $HOME/.unite/n3337/n3337.txt"
    endif

    let g:unite_n3337_txt = $HOME."/.unite/n3337/n3337.txt"

endif

if !filereadable($HOME."/.unite/n3337/subjects")
    let n3337 = readfile(g:unite_n3337_txt)
    let subjects = []

    for linum in range(1,len(n3337))
        let idx = linum - 1
        let match = matchlist(n3337[idx],'^\s\+\([0-9.]\+\)\s\+\([^\[]\+\)\[[a-z.]\+]$')
        if !empty(match) && match[2] !~# '^\s\+$'
            call add(subjects, linum."\t".match[1]."\t".substitute(match[2], '\s*$','',''))
        endif
    endfor

    call writefile(subjects, $HOME."/.unite/n3337/subjects")
endif
