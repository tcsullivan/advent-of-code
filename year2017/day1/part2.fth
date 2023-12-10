: captcha s" 123123" ;

: solve-captcha ( captcha... -- n )
  dup pad !
  0 tuck do
  over i + c@ dup
  3 pick i pad @ 2/ + pad @ mod + c@
  = if [char] 0 - + else drop then loop nip ;

captcha solve-captcha . cr bye
