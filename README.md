# Changes
 @ 03/31/2024

 -added the ability to compile python (the best and fastest programming language in the world)

 @ 30/03/2024
 - adding automatic linking now when connecting headers such as <math.h> <ncurses.h> <pthreads.h> you don’t need to add libraries, this will be done automatically
 - the ability to install your own library links - linking example: AddCompLib(<header_name>,<compilation_flag>) -> AddCompLib("math","m") | AddCompLib("sqlite3.h","sqlite3") after these commands, when using these headers, the corresponding library flags will be added to the compilation

 - adding compilation using makefiles call SetMakefile() | call UnsetMakefile() when executing the first command you will need to enter the target responsible for compilation in the makefile and the binary file in the output

# Install the plugin
 vim plug -> Plug 'Abstract-Chief/vim_cppgo'

# Example configuration for the keys F2 F3 F4
 nnoremap <F<F2>2> :call CompileMe()<C<CR>R> #compilation

 nnoremap <F<F3>3> :call RunMe_Compiler()<C<CR>R> # run file

 nnoremap <F<F4>4> :call DebugMe_Compiler()<C<CR>R> # debug file for debugging add planin 'cpiger/NeoDebug'

# Auxiliary commands
 :call SetMakefile() # setting compilation using a makefile
 :call UnsetMakefile() # return to single compilation

 :call SetLibCompiler($ARG) # $ARG a string containing library connections, for example "-lm"

 :call SetFlagsCompiler(($ARG) # $ARG a string containing compilation flags for example "-Wall -g -Werror"

# Information
 Standard compilation flags -Wall -g
 The compilation names from these functions are local for each file, that is, different files, different flags and libraries
