# Vim Goby syntax highlighting

Goby syntax highlighting for Vim, copied from the official Vim definition, with extra keywords added.

## Installation

From the terminal:

```sh
mkdir -p "$HOME/.vim/syntax"
wget -O "$HOME/.vim/syntax/goby.vim" https://raw.githubusercontent.com/saveriomiroddi/vim-goby-syntax-highlighting/master/goby.vim
echo 'au BufNewFile,BufRead *.gb    setf goby' >> "$HOME/.vim/filetype.vim"
```

This will apply syntax highlighting to all the Goby files (`*.gb`).
