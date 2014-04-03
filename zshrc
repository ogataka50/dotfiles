echo oga zshrc
# ヒストリの設定
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
#export HISTFILE=~/.hist/history.`date +%y%m%d%H%M`
#HISTFILE=~/.hist/history.`date +%y%m%d%H%M`
export LS_COLORS='di=01;36'

export EDITOR=vim

# デフォルトの補完機能を有効
autoload -U compinit
compinit

# プロンプトのカラー表示を有効
autoload -U colors
colors
    
# 補完するかの質問は画面を超える時にのみに行う
LISTMAX=0

# 補完候補が複数ある時に、一覧表示
setopt auto_list

# cd で pushd
setopt auto_pushd

# コマンドの訂正
#setopt correct

# listの圧縮表示
setopt list_packed

# ビープ音を消す
setopt nolistbeep

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# Ctrl+D では終了しないようになる（exit, logout などを使う）
setopt ignore_eof

# 複数リダイレクト
setopt multios

# シェルのプロセスごとに履歴を共有
setopt share_history

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
#setopt hist_verify

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
#setopt auto_param_slash

# C-s, C-qを無効にする。
setopt NO_flow_control

# ディレクトリスタックに同じディレクトリを追加しないようになる
#setopt pushd_ignore_dup

# rm_star_silent の逆で、10 秒間反応しなくなり、頭を冷ます時間が与えられる
#setopt rm_star_wait

# rm * などの際、本当に全てのファイルを消して良いかの確認しないようになる
#setopt rm_star_silent
    
# ディレクトリスタックに同じディレクトリを追加しないようになる
#setopt pushd_ignore_dup

# rm_star_silent の逆で、10 秒間反応しなくなり、頭を冷ます時間が与えられる
#setopt rm_star_wait

# 先頭がスペースならヒストリーに追加しない。
#setopt hist_ignore_space

# リダイレクトで上書きする事を許可しない。
#setopt no_clobber

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
#setopt hist_ignore_all_dups

# 履歴ファイルに時刻を記録
#setopt extended_history
    
# lsしたときの色を設定
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Ctrl+wで/までの文字列を削除
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# 候補をタブで選択
zstyle ':completion:*default' menu select=1
# 補完で大文字と小文字を区別しないようにしたい(大文字は展開しない)

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#PROMPT='[%n@%m]# '
#RPROMPT='[%~ %T]'
PROMPT="%B%{${fg[green]}%}[%n@%m]%{${reset_color}%}%b"
RPROMPT="%B%{${fg[green]}%}[%~ %T]%{${reset_color}%}%b"

# 最後に打ったコマンドステータス行に
if [ "$TERM" = "screen" ]; then
        chpwd () { echo -n "_`dirs`\\" }
        preexec() {
                # see [zsh-workers:13180]
                # http://www.zsh.org/mla/workers/2000/msg03993.html
                emulate -L zsh
                local -a cmd; cmd=(${(z)2})
                case $cmd[1] in
                        fg)
                                if (( $#cmd == 1 )); then
                                        cmd=(builtin jobs -l %+)
                                else
                                        cmd=(builtin jobs -l $cmd[2])
                                fi
                                ;;
                        %*)
                                cmd=(builtin jobs -l $cmd[1])
                                ;;
                        ssh)
                                if (( $#cmd == 2 )); then
                                        cmd[1]=$cmd[2]
                                fi
                                ;&
                        sudo)
                                if (( $#cmd == 3 )); then
                                        if [ $cmd[2] = "ssh" ]; then
                                              cmd[1]=$cmd[3]
                                        fi
                                fi
                                ;&
                        *)
                                echo -n "k$cmd[1]:t\\"
                                return
                                ;;
                esac

                local -A jt; jt=(${(kv)jobtexts})

                $cmd >>(read num rest
                        cmd=(${(z)${(e):-\$jt$num}})
                        echo -n "^[k$cmd[1]:t\\") 2>/dev/null
        }
        chpwd
fi
