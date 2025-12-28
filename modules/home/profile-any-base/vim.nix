{ pkgs, ... }:
{
  home.packages = [ pkgs.vim ];

  home.file.".vimrc".text = ''
    set nocompatible
    filetype plugin indent on
    syntax enable

    set incsearch
    set ignorecase smartcase

    set autoindent smartindent
    set smarttab
    set indentexpr=
    set expandtab shiftwidth=4 tabstop=4

    silent !mkdir -p ~/.local/state/vim/backup ~/.local/state/vim/swap ~/.local/state/vim/undo
    silent !find ~/.local/state/vim -type f -mtime +30 -delete
    set viminfo+=n~/.local/state/vim/info
    set backup backupdir=~/.local/state/vim/backup//
    set swapfile directory=~/.local/state/vim/swap//
    set undofile undodir=~/.local/state/vim/undo//
    let g:netrw_home='~/.local/state/vim'
  '';
}
