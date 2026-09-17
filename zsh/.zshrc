export ZSH="$HOME/.oh-my-zsh/"

ZSH_THEME="arda-forged"

plugins=(
	git
	zsh-autosuggestions
	archlinux
	fzf-tab
	zsh-syntax-highlighting
	web-search
	sudo
)

source $ZSH/oh-my-zsh.sh

[[ -f "$HOME/.alias" ]] && . "$HOME/.alias"

command -v fzf >/dev/null && source <(fzf --zsh)
export PATH="$HOME/Dotfiles/scripts:$PATH"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠋⣰⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣾⣿⠀⠀⠶⣽⠖⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⢠⣷⣶⣶⣶⣶⣶⣶⣾⣿⣿⣤⣤⣤⣥⣤⣤⣴⣶⡀⠀⠀⠀
# ⣠⡴⠿⠋⠀⠀⣀⣤⠶⠶⢾⣿⣿⣤⢤⣤⣀⠀⠉⠉⠻⣷⡄⠀⠀
# ⠀⠀⠀⠀⠀⣾⣿⠁⠀⠀⢸⣿⣿⠀⠀⠈⢻⣿⡄⠀⠀⠀⠉⠲⠄
# ⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⢸⣿⣿⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠘⠿⢶⣤⣤⣼⣿⣿⣤⣀⣤⡾⠟⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⢻⣿⡿⠻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⢀⣴⣾⠋⠀⢸⣿⡇⠀⠈⠳⣦⡀⠀⠀⠀⠀⠀⠀⠀
# ⠤⠤⣤⣶⣾⡿⠟⠁⠀⠀⢸⣿⡇⠀⠀⠀⠙⢿⣶⣄⡀⠀⠀⠀⠀
# ⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠉⠙⠛⠒⠒⠀⠀
# ⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⢸⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠙⠶⠛⠀⠀⢸⣿⣿⣷⣄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡿⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⣶⣷⣄⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
