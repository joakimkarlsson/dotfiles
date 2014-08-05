function! CountCharacterInString(chr, str)
    return strlen(substitute(a:str, "[^" . a:chr .  "]", "",  "g"))
endfunction

function! ToggleUnderscoreAndSpace(str)
    let underscores = CountCharacterInString("\_", a:str)
    let spaces = CountCharacterInString("\ ", a:str)

    if spaces > underscores
        return substitute(a:str, " ", "_", "g")
    else
        return substitute(a:str, "_", " ", "g")
    endif

endfunction

" When naming test methods in describe_it, I like to start with using normal
" sentences with spaces for names as this is easier to type.
"
" e.g.: 
" @describe
" def player has started the game():
"
" Using the mapping below on the 'def ...' line, this will be changed to valid python:
"
" @describe
" def player_has_started_the_game():
"
" Running the mapping again on the 'def ...' line will restore the spaces.
" This can be useful if I want to go back and change the name of the test.
nnoremap <buffer> <silent> <LocalLeader>_ :s/\vdef (.*)\(/\= "def " . ToggleUnderscoreAndSpace(submatch(1)) . "("/<cr>:let @/ = ""<cr>
