# VIM LINES

simple statusline & tabline plug of vim & nvim

![avatar](./screenshots/line1.png)

## options

```options
default_options
  let g:line_statusline_enable = 1          # statusline on/off
  let g:line_tabline_enable = 1             # tabline    on/off
  let g:line_tabline_show_time = 1          # tabline    show time on/off
  let g:line_tabline_show_pwd = 1           # tabline    show current path on/off
  let g:line_dclick_interval = 100          # tabline    dclick can close buffer
  let g:line_modi_mark = '+'                # tabline    modified mark
  let g:line_pwd_suffix = '/'               # tabline    suffix of current path
  let g:line_statusline_getters = []        # statusline extra some info on statusline getters
  let g:line_mode_map = {"n": "NORMAL",     # statusline mode & display map
                      \  "v": "VISUAL",
                      \  "V": "V-LINE",
                      \  "\<c-v>": "V-CODE",
                      \  "i": "INSERT",
                      \  "R": "R",
                      \  "r": "R",
                      \  "Rv": "V-REPLACE",
                      \  "c": "CMD-IN",
                      \  "s": "SELECT",
                      \  "S": "SELECT",
                      \  "\<c-s>": "SELECT",
                      \  "t": "TERMINAL"}

default_color
  hi LineColor1 ctermbg=24
  hi LineColor2 ctermbg=238
  hi LineColor3 ctermbg=25
  hi LineColor4 ctermbg=NONE

```

![avatar](./screenshots/line2.png)

```usage
if you want to add something to you statusline:

Example:
  let g:line_statusline_getters = ['CocErrCount', 'GitStatus', 'GitInfo']

  coc-diagnostic:
    func! CocErrCount()
        let l:info = get(b:, 'coc_diagnostic_info', {})
        return printf(' E%d ', get(l:info, 'error', 0))
    endf
  vim-gitgutter:
    function! GitStatus()
        let [a,m,r] = GitGutterGetHunkSummary()
        return printf(' +%d ~%d -%d ', a, m, r)
    endfunction
  coc-git:
    func! GitInfo()
        let l:head = get(g:, 'coc_git_status', '')
        let l:head = l:head != '' ? printf(' %s ', l:head) : ''
        let l:status = get(b:, 'coc_git_status', '')
        let l:status = l:status != '' ? printf('%s ', trim(l:status)) : ''
        return l:head . l:status
    endf
  vim-fugitive:
    add 'FugitiveStatusline' to g:line_statusline_getters
  ...
```

## 中文说明(英文不咋地)

```options
默认设置
  let g:line_statusline_enable = 1          # 状态栏 是否开启
  let g:line_tabline_enable = 1             # 标题栏 是否开启
  let g:line_tabline_show_time = 1          # 标题栏 是否开启时间显示
  let g:line_tabline_show_pwd = 1           # 标题栏 是否展示当前目录名
  let g:line_dclick_interval = 100          # 标题栏 双击的间隔(双击可用于关闭buffer)
  let g:line_modi_mark = '+'                # 标题栏 发生变更的buffer的标记
  let g:line_pwd_suffix = '/'               # 标题栏 展示的当前目录名的后缀
  let g:line_statusline_getters = []        # 状态栏 额外展示的内容的获取方法名 以下有部分使用例子
  let g:line_mode_map = {"n": "NORMAL",     # 状态栏 当前模式和显示内容的映射
                      \  "v": "VISUAL",
                      \  "V": "V-LINE",
                      \  "\<c-v>": "V-CODE",
                      \  "i": "INSERT",
                      \  "R": "R",
                      \  "r": "R",
                      \  "Rv": "V-REPLACE",
                      \  "c": "CMD-IN",
                      \  "s": "SELECT",
                      \  "S": "SELECT",
                      \  "\<c-s>": "SELECT",
                      \  "t": "TERMINAL"}

默认颜色设置
  hi LineColor1 ctermbg=24                  # 边上的块的颜色
  hi LineColor2 ctermbg=238                 # 额外信息的块的颜色 & buffer 列表的颜色
  hi LineColor3 ctermbg=25                  # 当前buffer块的颜色
  hi LineColor4 ctermbg=NONE                # 中间间隔的颜色

```

![avatar](./screenshots/line2.png)

```usage
如果你想给你的状态栏添加一些额外内容，请加以下内容添加至你的vim配置中
例子:
  let g:line_statusline_getters = ['CocErrCount', 'GitStatus', 'GitInfo']

  coc-diagnostic: (coc-nvim插件 的 错误数量展示)
    func! CocErrCount()
        let l:info = get(b:, 'coc_diagnostic_info', {})
        return printf(' E%d ', get(l:info, 'error', 0))
    endf

  vim-gitgutter: (知名git插件 该方法可展示buffer中 新增 变更 去除 的行数)
    func! GitStatus()
        let [a,m,r] = GitGutterGetHunkSummary()
        return printf(' +%d ~%d -%d ', a, m, r)
    endf
  coc-git: (coc-git插件 该方法可展示 branch名 以及buffer的 新增 变更 去除 的行数)
    func! GitInfo()
        let l:head = get(g:, 'coc_git_status', '')
        let l:head = l:head != '' ? printf(' %s ', l:head) : ''
        let l:status = get(b:, 'coc_git_status', '')
        let l:status = l:status != '' ? printf('%s ', trim(l:status)) : ''
        return l:head . l:status
    endf

  vim-fugitive: (vim-fugitive插件 提供的 git状态方法, PS: 该方法并不好用)
    添加 'FugitiveStatusline' 到 g:line_statusline_getters 中

  其他: 你可以添加任意其他内容到 g:line_statusline_getters 中，但要注意性能等影响
```

## ENJOY IT
