function! CompileMe()
    let l:path=expand('%:p')
    let l:command=split(GetCompileCommand(),"|")
    if l:command[0]=="null"
        return ["null"]
    elseif l:command[0]=="it"
       execute "!".l:command[1]
       return l:command 
    endif
    echo "compilation command:    ".l:command[1]
    echo "\\/\\/\\/\\/"
    execute "!".l:command[1]
    return l:command
endfunction

function! RunMe_Compiler()
   return RunMe_Compiler_DEV(fnamemodify(bufname(), ':t:r'))
endfunction
function! RunMe_Compiler_DEV(name)
    let l:name=a:name
    let l:r=CompileMe()
    if l:r[0]=="null"
        return "null"
    elseif l:r[0]=="it"
       return "it"
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
    return "comp"
endfunction

function! DebugMe_Compiler()
    let l:name=fnamemodify(bufname(), ':t:r')
    silent! let l:r = CompileMe()
    if l:r[0]=="null"
       return "null"
    elseif l:r[0]=="it"
       return
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

