
if exists("b:current_syntax")
  finish
endif

syntax clear

syntax match uniteN3337SectionTitle '^\s\+[0-9.]\+\s\+[^\[]\+\[[a-z.]\+]$'
" syntax match uniteN3337Footer       '^\s\+§[0-9\.]\+\s\+\d\+$'
syntax match uniteN3337Header       '^\s*c ISO\/IEC\s\+N3337$'
syntax region uniteN3337Example      start='\[ Example:$' end='end example \]'


highlight default link uniteN3337SectionTitle  Type
" highlight default link uniteN3337Footer       Comment
highlight default link uniteN3337Header        Comment
highlight default link uniteN3337Example       Constant


let b:current_syntax = 'unite-n3337'
