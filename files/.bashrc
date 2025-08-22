#
# ~/.bashrc
#

[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PIP_BREAK_SYSTEM_PACKAGES=1
export PS1="\[\e[38;5;255m\]\u\[\e[0m\]\[\e[38;5;244m\]@\[\e[0m\]\[\e[38;5;214m\]\h\[\e[0m\] \[\e[38;5;111m\]\w\[\e[0m\] \[\e[38;5;\$(if [[ \$? == 0 ]]; then echo \"40\"; else echo \"196\"; fi)m\]❯\[\e[0m\] "
export JAVA_HOME=/usr/lib/jvm/default-runtime
export PATH=$PATH:$JAVA_HOME/bin
