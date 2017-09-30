" Reveal in file finder for cross platforms
" Author: Chuck Fairy (http://chuckfairy.com/)
"
" Globals
" g:NERDTreeFileManagerProgram " Override of all
" g:NERDTreeFileManagerProgramLinux
" g:NERDTreeFileManagerProgramMac
" g:NERDTreeFileManagerProgramWindows


" IFNDEF
if exists("g:loaded_nerdtree_reveal")
    finish
endif

let g:loaded_nerdtree_reveal = 1


" MacVim already built in

if has("gui_macvim")
    finish
endif


" Add menu to NERD

call NERDTreeAddMenuItem({
            \ 'text': '(r)eveal in file manager',
            \ 'shortcut': 'r',
            \ 'callback': 'NERDTreeRevealInFileManager',
            \ })


" Get default file finder for operating system

function! g:NERDTreeGetDefaultFileManager()

    " If has setting set use that

    if exists("g:NERDTreeFileManagerProgram")
        return g:NERDTreeFileManagerProgram

    if has("unix") && exists("g:NERDTreeFileManagerProgramLinux")
        return g:NERDTreeFileManagerProgramLinux

    if has("win32") || has("win64") && exists("g:NERDTreeFileManagerProgramMac")
        return g:NERDTreeFileManagerProgramMac

    if (  has("win32") || has("win64") ) && exists("g:NERDTreeFileManagerProgramWindows")
        return g:NERDTreeFileManagerProgramWindows


    " Mac
    elseif has("gui_mac") || has("mac")
        return "open"

    " Windows default explorer
    elseif has("win32") || has("win64")
        return "explorer.exe"

    " Assume everything else is linux
    else
        return "xdg-open"

    endif

endfunction


" Main function to run command and rerender NERD

function! NERDTreeRevealInFileManager()
    let curNode = g:NERDTreeDirNode.GetSelected()
    let finderProgram = g:NERDTreeGetDefaultFileManager()

    let cmd = finderProgram . ' ' . curNode.path.str( { 'escape': 1 } )

    if cmd != ''
        let success = system( cmd )
        call NERDTreeRender()
    else
        echo "Aborted"
    endif
endfunction
