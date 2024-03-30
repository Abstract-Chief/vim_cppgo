let g:BaseCompilerLibs=""
let g:BaseCompilerFlags="-Wall -g"
let g:BaseCompilerUserPath=expand('~')."/.NcompUserLibrary.data"

function ParseAutoLibrary()
    try
        let l:file=readfile(g:BaseCompilerUserPath)
        let l:result=[]
        for item in l:file
            if stridx(item,":")!=-1
                call add(l:result, split(item,":"))
            endif
        endfor
        return l:result
    catch
        return []
    endtry
endfunction

function BaseCompilerToHeaderName(header_name)
    let l:header_name2 = substitute(a:header_name,' ','','g')
    if len(l:header_name2)==0 || stridx(l:header_name2,":")!=-1
        return ""
    endif
    if stridx(l:header_name2,".h")==-1
        return l:header_name2.".h"
    endif
    return l:header_name2
endfunction

function AddCompLib(header_name, flag)
    let l:header_name2 = BaseCompilerToHeaderName(a:header_name)
    if(l:header_name2=="")
        echo "Error header name"
        return
    endif
    let l:file=ParseAutoLibrary()
    let l:check=-1
    for index in range(0,len(l:file)-1)
        if l:file[index][0] == l:header_name2
            if l:file[index][1] == a:flag
                echo "This library has already been added"
                return 
            endif 
            let l:check=index
            break
        endif
    endfor
    if l:check!=-1
        echo "You want replace ".l:file[l:check][0]." flag (".l:file[l:check][1].") --> (".a:flag.")"
        let l:input=input("(Y/N)> ")
        if l:input ==# "N"
            return
        endif
        let l:file[l:check][1]=a:flag
    else
        call add(l:file, [l:header_name2, a:flag])
    endif
    let l:lines = []
    for item in l:file
        call add(l:lines, item[0] . ":" . item[1])
    endfor
    call writefile(l:lines, g:BaseCompilerUserPath)
endfunction

function FindInFlagsBaseCompiler(flags,name)
   for id in a:flags
      if id[0] == a:name
         return 1
      endif
   endfor
   return 0
endfunction
function BaseCompilerNameToPatter(header_name)
   return "^#include\\s*<".a:header_name.">"
endfunction
function BaseCompilerSearch(header_name)
   execute 'w!'
   call systemlist('grep "'.BaseCompilerNameToPatter(a:header_name).'" < '.expand("~")."/".expand("%")) 
   if v:shell_error
      return 0
   endif
   return 1

endfunction
function! GetAutoCompileFlags()
   let l:result=""
   let l:flags=[["math.h","m"],["curses.h","curses"],["ncurses.h","ncurses"],["pthread.h","pthread"],["netdb.h","net"]]
   let l:user_flags=ParseAutoLibrary()
   for item in l:user_flags
      if FindInFlagsBaseCompiler(l:flags,item[0])==0
         call add(l:flags,item)
      endif
   endfor
   for item in l:flags
      if BaseCompilerSearch(item[0])==1
         let l:result=l:result."-l".item[1]." "
      endif
   endfor
   return l:result
endfunction 
function! GetLibsCompiler()
    try
        let l:file=readfile(GetNameWithPoint())
        echo l:file
        return l:file[1]
    catch
        return g:BaseCompilerLibs
    endtry
endfunction

function! GetFlagsCompiler()
    try
        let l:file=readfile(GetNameWithPoint())[0]
        if l:file==""
            return g:BaseCompilerFlags
        endif
        return l:file
    catch
        return g:BaseCompilerFlags
    endtry
endfunction

function! GetCompileCommand()
    let l:file=readfile(GetNameWithPoint())
    if len(l:file)>2
       if l:file[2]!="-"
          return l:file[2]
       endif
    endif
    let l:filename=bufname()
    let l:type=GetTypeFromName(l:filename)
    let l:name=fnamemodify(l:filename, ':t:r')
    let l:comp="gcc"
    if l:type!="c" && l:type!="cpp"
        echo "dont support this filetype"
        return "null"
    endif
    if l:type=="cpp"
        let l:comp="g++"
    endif

    return l:comp ." ". GetFlagsCompiler() ." ". l:filename . " -o " . l:name ." ". GetLibsCompiler()." ".GetAutoCompileFlags() 
endfunction

function! SaveInfoCompiler(path, n, str)
    try
        let l:lines = readfile(a:path)
    catch
        let l:lines=["","","",""]
    endtry
    for ind in range(0,4)
       call add(l:lines,"")
    endfor
    let l:lines[a:n]=a:str
    call writefile(l:lines[0:a:n],a:path)
endfunction

function! GetNameWithPoint()
    let l:path=expand('%:p')
    let l:path_parts = split(l:path, '/')
    let l:last_file = l:path_parts[-1]
    return substitute(l:path, '/'.l:last_file, '/.compiler_' . l:last_file, 'g')
endfunction

function! SetFlagsCompiler(str)
   call SaveInfoCompiler(GetNameWithPoint(),0,a:str)
endfunction

function! SetLibCompiler(str)
   call SaveInfoCompiler(GetNameWithPoint(),1,a:str)
endfunction
function SetMakefile()
   echo "write the compilation target in your makefile"
   let l:input=input("> ")
   while len(l:input)==0
      let l:input=input("> ")
   endwhile
   call SaveInfoCompiler(GetNameWithPoint(),2,"make ".l:input)
   echo "\n"
   echo "executable file coming from compilation"
   let l:input=input("> ")
   while len(l:input)==0
      let l:input=input("> ")
   endwhile
   call SaveInfoCompiler(GetNameWithPoint(),3,l:input)
endfunction
function UnsetMakefile()
   call SaveInfoCompiler(GetNameWithPoint(),2,"-")
   call SaveInfoCompiler(GetNameWithPoint(),3,"-")
endfunction

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
    let l:file=readfile(GetNameWithPoint())
    if len(l:file)>3
       if l:file[3]!="-"
          let l:name=l:file[3]
       endif
    endif
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
    if len(l:file)>3
       if l:file[3]!="-"
          let l:name=l:file[3]
       endif
    endif
    silent! execute "NeoDebug"
    call timer_start(1100, {-> feedkeys("file ".l:name."\<CR>", 'i')})
    call timer_start(1450, {-> feedkeys("start\<CR>", 'i')})
    "silent! execute "!rm ".l:name
endfunction

