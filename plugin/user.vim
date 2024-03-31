source module.vim
function! SetFlagsCompiler(str)
   call SaveInfoCompiler(GetNameWithPoint(),0,a:str)
endfunction

function! SetLibCompiler(str)
   call SaveInfoCompiler(GetNameWithPoint(),1,a:str)
endfunction

function! SetMakefile()
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

function! UnsetMakefile()
   call SaveInfoCompiler(GetNameWithPoint(),2,"-")
   call SaveInfoCompiler(GetNameWithPoint(),3,"-")
endfunction

function! AddCompLib(header_name, flag)
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




