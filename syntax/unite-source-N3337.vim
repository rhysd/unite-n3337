if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

syntax match uniteN3337SectionTitle     /^\s\+[0-9.]\+\s\+[^\[]\+\[[a-z.]\+]$/
syntax region uniteN3337Example         start='\[ Example:' end='end[ \n]\s*example \]' contains=uniteN3337ExampleNotice,uniteN3337Footer,uniteN3337Header
syntax region uniteN3337Note            start='\[ Note:' end='end[ \n]\s*note \]' contains=uniteN3337NoteNotice,uniteN3337Footer,uniteN3337Header
syntax match uniteN3337ExampleNotice    /Example:/ contained
syntax match uniteN3337NoteNotice       /Note:/ contained
syntax match uniteN3337Item             /—/

if has('conceal')
    syntax match uniteN3337Footer           /^\s*§\s[0-9\.]\+\s\+\d\+$/ conceal
    syntax match uniteN3337Header           /^\s*c ISO\/IEC\s\+N3337$/ conceal
else
    syntax match uniteN3337Footer           /^\s*§\s[0-9\.]\+\s\+\d\+$/
    syntax match uniteN3337Header           /^\s*c ISO\/IEC\s\+N3337$/
endif

highlight default link uniteN3337SectionTitle  Title
highlight default link uniteN3337Example       Comment
highlight default link uniteN3337Note          Comment
highlight default link uniteN3337ExampleNotice TabLine
highlight default link uniteN3337NoteNotice    TabLine
highlight default link uniteN3337Item          Question
highlight default link uniteN3337Footer        Ignore
highlight default link uniteN3337Header        Ignore


let b:current_syntax = 'unite-source-N3337'
