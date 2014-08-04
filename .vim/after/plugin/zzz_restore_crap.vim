" Strip buffer of trailing whitespaces
" vimwiki highjacks this, so we need to set this here.
"
nnoremap <silent> <leader>ws :%s/\v\s+$//<cr>
