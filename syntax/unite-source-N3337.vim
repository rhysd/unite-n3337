if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

syntax match uniteN3337SectionTitle '^\s\+[0-9.]\+\s\+[^\[]\+\[[a-z.]\+]$'
syntax match uniteN3337Footer       '^\s\+§\s[0-9\.]\+\s\+\d\+$'
syntax match uniteN3337Header       '^\s*c ISO\/IEC\s\+N3337$'
syntax region uniteN3337Example     start='\[ Example:' end='end[ \n]\s*example \]'
syntax region uniteN3337Note        start='\[ Note:' end='end[ \n]\s*note \]'
syntax match uniteN3337Item         '—'


highlight default link uniteN3337SectionTitle  Title
highlight default link uniteN3337Footer        Ignore
highlight default link uniteN3337Header        Ignore
highlight default link uniteN3337Example       Comment
highlight default link uniteN3337Note          Comment
highlight default link uniteN3337Item          Question


let b:current_syntax = 'unite-source-N3337'
