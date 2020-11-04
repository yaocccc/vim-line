# VIM CLINES

simple statusline & tabline

![avatar](./line.png)

## options

```options
default_options
  let g:line_modi_mark = '+'
  let g:line_pwd_suffix = '/'
  let g:line_statusline_enable = 1
  let g:line_tabline_enable = 1
  let g:line_tabline_show_time = 1
  let g:line_tabline_show_pwd = 1
  let g:line_dclick_interval = 100

default_color
  hi LineColor1 ctermbg=24
  hi LineColor2 ctermbg=238
  hi LineColor3 ctermbg=25
  hi LineColor4 ctermbg=NONE

statusline diagnostic count base on coc
statusline git status base on coc-git
please sure you have install coc & coc-git
```
