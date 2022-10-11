# Note: for this to do anything, use my starter Dockerfile config (https://gist.github.com/arctic-hen7/10987790b86360820e2790650e289f0b)

# This file contains ZSH configuration for your shell when you interact with a container
# (we wouldn't want any boring `sh` now would we?)
# Please feel free to set up your own ZSH config in here!
# It gets mapped to your `.zshrc` for the root user in the container

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Antigen
source ~/.antigen/antigen.zsh
autoload -U colors && colors
setopt promptsubst
# Set up oh-my-zsh
antigen use oh-my-zsh
# Set up plugins
antigen bundle git
antigen bundle copyfile
antigen bundle dirhistory
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
# Set up our preferred theme
antigen theme romkatv/powerlevel10k
# Run all that config
antigen apply

ZSH_THEME="powerlevel10k/powerlevel10k"
source ${ZSH_CUSTOM}/plugins/kube-ps1/kube-ps1.sh
PROMPT='$(kube_ps1)'$PROMPT

# Set up Ctrl + Backspace and Ctrl + Del so you can move around and backspace faster (try it!)
bindkey '^H' backward-kill-word
bindkey -M emacs '^[[3;5~' kill-word

# Set up aliases
source ~/.zprofile

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable navi shortcut
eval "$(navi widget zsh)"

# Remove less-like outputs
export PAGER=""