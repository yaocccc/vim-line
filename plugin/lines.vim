if exists('s:loaded') | finish | endif
let s:loaded = 1

let g:line_mode_map=get(g:, 'line_mode_map', { "n": "NORMAL", "v": "VISUAL", "V": "V-LINE", "\<c-v>": "V-CODE", "i": "INSERT", "R": "R", "r": "R", "Rv": "V-REPLACE", "c": "CMD-IN", "s": "SELECT", "S": "SELECT", "\<c-s>": "SELECT", "t": "TERMINAL"})

let s:line_statusline_enable = get(g:, 'line_statusline_enable', 1)
let s:line_tabline_enable = get(g:, 'line_tabline_enable', 1)
let s:line_tabline_show_time = get(g:, 'line_tabline_show_time', 1)
let s:line_tabline_show_pwd = get(g:, 'line_tabline_show_pwd', 1)
let s:line_modi_mark = get(g:, 'line_modi_mark', '+')
let s:line_pwd_suffix = get(g:, 'line_pwd_suffix', '/')
let s:line_dclick_interval = get(g:, 'line_dclick_interval', 100)
let s:line_statusline_getters = get(g:, 'line_statusline_getters', [])
let s:line_unnamed_filename = get(g:, 'line_unnamed_filename', '[unnamed]')

hi LineColor1 ctermbg=24
hi LineColor2 ctermbg=238
hi LineColor3 ctermbg=25
hi LineColor4 ctermbg=NONE

augroup lines
    au!
    if s:line_statusline_enable == 1
        set laststatus=2
        au VimEnter * call SetStatusline()
    endif
    if s:line_tabline_enable == 1
        set showtabline=2
        let g:tabline_head = s:line_tabline_show_pwd ? substitute($PWD, '\v(.*/)*', '', 'g') . s:line_pwd_suffix : 'BUFFER'
        if s:line_tabline_show_time
            au VimEnter * call SetTablineTimer()
        endif
        au BufEnter,BufWritePost,TextChanged,TextChangedI * call SetTabline()
    endif
augroup END

func! SetStatusline(...)
    let &statusline = '%#LineColor1# %{g:line_mode_map[mode()]} %#LineColor4#'
    for getter in s:line_statusline_getters
        let &statusline .= ' %#LineColor2#%{'.getter.'()}%#LineColor4#'
    endfor
    let &statusline .= '%=%#LineColor1# %{GetPathName()} %#LineColor4# %#LineColor1# %4P %L %l %v %#LineColor4#'
endf

func! SetTabline(...)
    let &tabline = '%#LineColor1# %{g:tabline_head} %#LineColor4#'
    let l:i = 1
    while l:i <= bufnr('$')
        if bufexists(l:i) && buflisted(l:i)
            let &tabline .= '%' . l:i . '@Clicktab@'
            let &tabline .= i == bufnr('%') ? ' %#LineColor3# ' : ' %#LineColor2# '
            let l:name = (len(fnamemodify(bufname(l:i), ':t')) ? fnamemodify(bufname(l:i), ':t') : s:line_unnamed_filename) . (getbufvar(l:i, '&mod') ? s:line_modi_mark : '')
            let &tabline .=  l:name . ' %#LineColor4#%X'
        endif
        let l:i += 1
    endwhile
    if s:line_tabline_show_time == 1
        let &tabline .= ' %<%=%#LineColor1# %{strftime("%p%I:%M")} %#LineColor4#'
    endif
endf

func! Clicktab(minwid, clicks, button, modifiers) abort
    let l:timerID = get(s:, 'clickTabTimer', 0)
    if a:clicks == 1 && a:button is# 'l'
        if l:timerID == 0
            let s:clickTabTimer = timer_start(100, 'SwitchTab')
            let l:timerID = s:clickTabTimer
        endif
    elseif a:clicks == 2 && a:button is# 'l'
        silent execute 'bd' a:minwid
        let s:clickTabTimer = 0
        call timer_stop(l:timerID)
        call SetTabline()
    endif
    let s:minwid = a:minwid
    let s:timerID = l:timerID
    func! SwitchTab(...)
        silent execute 'buffer' s:minwid
        let s:clickTabTimer = 0
        call timer_stop(s:timerID)
    endf
endf

func! SetTablineTimer()
    let l:remain_second = 60 - strftime("%S")
    call timer_start(remain_second * 1000, 'SetTablineTimerAndSetTabline')
    func! SetTablineTimerAndSetTabline(...)
        call SetTabline()
        call timer_start(60 * 1000, 'SetTabline', { 'repeat': 9999 })
    endf
endf

func! GetPathName()
    let l:name = substitute(expand('%'), $PWD . '/', '', '')
    let l:name = substitute(l:name, $HOME, '~', '')
    let l:name = len(l:name) ? l:name : s:line_unnamed_filename
    return l:name
endf
