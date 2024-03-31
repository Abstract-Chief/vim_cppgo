source user.vim
source module.vim
function! CompileMe()
    let l:path=expand('%:p')
    let l:command=GetCompileCommand()
    if l:command=="null"
        return "null"
    endif
    echo "compilation command:    ".l:command
    echo "\\/\\/\\/\\/"
    execute "!".l:command
    return l:command
endfunction

function! RunMe_Compiler()
    let l:name=fnamemodify(bufname(), ':t:r')
    if CompileMe()=="null"
        return "null"
    endif
    try
       let l:file=readfile(GetNameWithPoint())
       if len(l:file)>3
          if l:file[3]!="-"
             let l:name=l:file[3]
          endif
       endif
    catch
       echo "not found setting file"
    endtry 
    execute "!./".l:name
    silent! execute "!rm ".l:name
endfunction

function! DebugMe_Compiler()
    let l:name=fnamemodify(bufname(), ':t:r')
    silent! let l:r = CompileMe()
    if r=="null"
       return "null"
    endif
    let l:file=readfile(GetNameWithPoint())
    try
       if len(l:file)>3
          if l:file[3]!="-"
             let l:name=l:file[3]
          endif
       endif
    catch
       echo "not found setting file"
    endtry 
    silent! execute "NeoDebug"
    call timer_start(1100, {-> feedkeys("file ".l:name."\<CR>", 'i')})
    call timer_start(1450, {-> feedkeys("start\<CR>", 'i')})
    "silent! execute "!rm ".l:name
endfunction

