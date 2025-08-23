This documentation doesn't contain information related VIM tutorials.  Instead this doc explains about the configuration's that I use in vim.

**Table of contents**

1.  vim
    - [Vimrc configuration files](#vimrc-configuration-file)
    - [Important vim plugins that I use](#important-vim-plugins-that-i-use)
    - [Setting vim cursor style for insert and normal mode](#setting-vim-cursor-style-for-insert-and-normal-mode)
2.  I3 TWM
    - [Installation of I3 WM in linux system](#installation-of-i3-wm-in-linux-system)
    - [List of plugins that needs to be used along with I3 to make it better](#list-of-plugins-that-needs-to-be-used-along-with-i3-to-make-it-better)
    - [Configuring i3 WM manager like vim like](#configuring-i3-wm-manager-like-vim-like)
    - [To modify i3 Status bar](#to-modify-i3-status-bar)

## Vimrc configuration file

The vimrc configuration file in this repo can be used for all plugins such Visual studio vim, Jetbrains idea vim, Eclipe vrapper, Nvim etc.  Do note that some configurations may not work in emulated Vim plugins.

## Important vim plugins that I use

1. Nerdtree
2. coc vim for installing language servers
3. gruvbox theme
4. vim-gitgutter (currently not in use)

## Setting vim cursor style for insert and normal mode

Add this configuration to get insert cursor in insert mode and block cursor in normal mode. [go to the code](https://github.com/sathishsekarss/Configuration-Files/blob/master/.vimrc#L89)


## Installation of I3 WM in linux system

The I3 Tiling manager can be installed through the linux terminal itself using the basic sudo apt command.

For detailed instructions on how to use I3 Tiling manager always refer to official documentation.

## List of plugins that needs to be used along with I3 to make it better

| Name of the Plugin                                                            | Can it be Installed through Terminal                   |
|-------------------------------------------------------------------------------|---------------------------------------------------|
| Rofi (program launcher, also known as dmenu)                                 | Yes, it can be installed through terminal         |
| Xrandr (mostly prebuilt, used for configuring multiple monitors)             | Not sure                                          |

## Configuring i3 WM manager like vim like

Refer this link to configure i3 WM like vim like

[ Reference link ](https://faq.i3wm.org/question/2294/vim-and-keybinds.1.html)

## To modify i3 Status bar

Check about i3 block config.  It can be easily installed through sudo apt command

[Refernce link](https://vivien.github.io/i3blocks/i3blocks.1.html#_name)

Refer the above link for reference
