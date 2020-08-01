if exists('s:loaded')
  finish
endif
let s:loaded = 1

let s:line_statusline_enable=get(g:, 'line_statusline_enable', 1)
let s:line_tabline_enable=get(g:, 'line_tabline_enable', 1)

augroup lines
    au!
    if s:line_statusline_enable == 1
        set laststatus=2
        au VimEnter * call SetStatusline()
    endif
    if s:line_tabline_enable == 1
        set showtabline=2
        au VimEnter * call SetTablineTimer()
        au BufEnter,BufWritePost,TextChanged,TextChangedI * call SetTabline()
    endif
augroup END

let g:line_mode_map=get(g:, 'line_mode_map', { "n": "NORMAL", "v": "VISUAL", "V": "V-LINE", "\<c-v>": "V-CODE", "i": "INSERT", "R": "R", "r": "R", "Rv": "V-REPLACE", "c": "CMD-IN", "s": "SELECT", "S": "SELECT", "\<c-s>": "SELECT", "t": "TERMINAL"})
let s:line_modi_mark = get(g:, 'line_modi_mark', '+')
let s:line_dclick_interval = get(g:, 'line_dclick_interval', 100)

hi LineColor1 ctermbg=24
hi LineColor2 ctermbg=238
hi LineColor3 ctermbg=25
hi LineColor4 ctermbg=NONE

func! SetStatusline(...)
    let &statusline = '%#LineColor1# %{g:line_mode_map[mode()]} %#LineColor4# %#LineColor2# %{GetErrCount()} %#LineColor4# %#LineColor2#%{GetGitInfo()}%#LineColor4#%=%#LineColor1# %{GetPathName()} %#LineColor4# %#LineColor1# %4P %L %l %#LineColor4#'
    func! GetErrCount()
        let l:info = get(b:, 'coc_diagnostic_info', {})
        return 'E' . get(l:info, 'error', 0)
    endf
    func! GetGitInfo()
        let l:head = get(g:, 'coc_git_status', '')
        let l:head = l:head != '' ? printf(' %s ', l:head) : ''
        let l:status = get(b:, 'coc_git_status', '')
        let l:status = l:status != '' ? printf(' %s ', l:status) : ''
        return l:head . l:status
    endf
    func! GetPathName()
        let l:name = substitute(expand('%'), $PWD . '/', '', '')
        let l:name = substitute(l:name, $HOME, '~', '')
        let l:name = len(l:name) ? l:name : '[未命名]'
        return l:name
    endf
endf

func! SetTabline(...)
    let &tabline = '%#LineColor1# BUFFER %#LineColor4#'
    let l:i = 1
    while l:i <= bufnr('$')
        if bufexists(l:i) && buflisted(l:i)
            let &tabline .= '%' . l:i . '@Clicktab@'
            let &tabline .= i == bufnr('%') ? ' %#LineColor3# ' : ' %#LineColor2# '
            let l:name = (len(fnamemodify(bufname(l:i), ':t')) ? fnamemodify(bufname(l:i), ':t') : '[未命名]') . (getbufvar(l:i, '&mod') ? s:line_modi_mark : '')
            let &tabline .=  l:name . ' %#LineColor4#%X'
        endif
        let l:i += 1
    endwhile
    let &tabline .= ' %<%=%#LineColor1# %{strftime("%p%I:%M")} %#LineColor4#'
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
