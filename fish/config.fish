set -g theme_display_git yes
set -g theme_display_git_dirty no
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_stashed_verbose yes
set -g theme_display_git_default_branch yes
set -g theme_git_default_branches master main
set -g theme_git_worktree_support yes
set -g theme_use_abbreviated_branch_name no
set -g theme_display_vagrant yes
set -g theme_display_docker_machine no
set -g theme_display_k8s_context yes
set -g theme_display_hg yes
set -g theme_display_virtualenv yes
set -g theme_display_nix no
set -g theme_display_ruby no
set -g theme_display_node yes
set -g theme_display_user ssh
set -g theme_display_hostname ssh
set -g theme_display_vi no
set -g theme_display_date yes
set -g theme_display_cmd_duration yes
set -g theme_title_display_process yes
set -g theme_title_display_path yes
set -g theme_title_display_user yes
set -g theme_title_use_abbreviated_path no
set -g theme_date_format "+%a %H:%M:%S"
set -g theme_date_timezone Asia/Calcutta
set -g theme_avoid_ambiguous_glyphs yes
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes
set -g theme_show_exit_status yes
set -g theme_display_jobs_verbose no
set -g theme_color_scheme gruvbox
set -g theme_newline_cursor yes
set -g theme_newline_prompt '>> '
set -g fish_prompt_pwd_dir_length 0

if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
    cat ~/.cache/ags/user/generated/terminal/sequences.txt
end

zoxide init fish | source

alias pamcan=pacman
alias cd=z
alias playultra="mangohud gamemoderun DRI_PRIME=1 ~/Games/ULTRAKILL.Build\ 14344626/ULTRAKILL/ULTRAKILL.exe"
alias playultranew="mangohud gamemoderun DRI_PRIME=1 ~/Games/ULTRAKILL.Patch.16b/game/ULTRAKILL.exe"
alias playgta="mangohud gamemoderun ~/Downloads/runasdate/RunAsDate.exe"
alias playminecraft="mangohud gamemoderun DRI_PRIME=1 java -jar ~/Downloads/minecraft/TLauncher.v10/TLauncher.jar"
alias lg=lazygit
alias cat=bat
alias ls=exa
alias :q=exit
alias :ex="chmod +x"
alias snvim="sudo -E nvim"
alias nn="$(which nvim)"
alias :c=qalc
alias :f="nvim ~/.config/fish/config.fish"
alias :t="nvim ~/misc/playground/test/test.cpp"
alias :tc="g++ ~/misc/playground/test/test.cpp -o testsi"
alias :tr="bash -c /home/s1dd/misc/playground/test/testsi"
alias :rw="zen-browser ~/Documents/collegestuff/Resume.pdf"
alias :r="okular ~/Documents/collegestuff/Resume.pdf"
alias :v="nvim ~/.local/share/fish/fish_history"
alias :foot="nvim ~/.config/foot/foot.ini"
alias :fnh='env fish_history=(random) fish --init-command "set_color yellow; echo -e \\"\\n*** Fish history is DISABLED for this session ***\\n\\"; set_color normal"'
alias :fh='nvim ~/.local/share/fish/fish_history'

set -x EDITOR nvim
set -x FZF_DEFAULT_OPTS "
  --color=bg+:#1d2021,bg:#282828,spinner:#d79921
  --color=hl:#fabd2f,hl+:#fe8019
  --color=fg:#ebdbb2,header:#d3869b
  --color=info:#83a598,pointer:#fabd2f
  --color=marker:#d79921,prompt:#b8bb26
  --color=fg+:#ebdbb2,preview-bg:#3c3836,preview-fg:#ebdbb2
  --color=border:#665c54"

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end
source /home/s1dd/.config/fish/completions/inLimbo.fish
source /home/s1dd/.config/fish/fstack.fish
source /home/s1dd/.config/fish/serve.fish

# Created by `pipx` on 2025-02-20 17:20:10
set PATH $PATH /home/s1dd/.local/bin
