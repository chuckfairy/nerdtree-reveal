" Reveal in file finder for cross platforms
" Author: Chuck Fairy (http://chuckfairy.com/)


" IFNDEF
if exists("g:loaded_nerdtree_reveal")
    finish
endif
let g:loaded_nerdtree_reveal = 1


" Add menu to NERD

call NERDTreeAddMenuItem({
            \ 'text': '(r)eveal in file finder',
            \ 'shortcut': 'r',
            \ 'callback': 'NERDTreeRevealInFileFinder',
            \ })


" Get default file finder for operating system

function! g:NERDTreeGetDefaultFileFinder()

    "If has setting set use that
    if exists("g:NERDTreeFileFinderProgram")
        return g:NERDTreeFileFinderProgram
    elseif has("gui_mac") || has("mac")
        return "open"
    elseif has("win32") || has("win64")
        return "explorer.exe"
    else
        " Assume everything else is linux
        return "xdg-open"
    endif
endfunction


" Main function to run command and rerender NERD

function! NERDTreeRevealInFileFinder()
    let curNode = g:NERDTreeFileNode.GetSelected()
    let finderProgram = g:NERDTreeGetDefaultFileFinder()

    let cmd = finderProgram . ' ' . curNode.path.str({'escape': 1})

    if cmd != ''
        let success = system(cmd)
        call NERDTreeRender()
    else
        echo "Aborted"
    endif
endfunction
