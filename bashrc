

export PATH=~/.desk/bin:$PATH

export HISTCONTROL=ignoreboth

for f in ~/.desk/bashrc.d/*.sh; do
  source $f
done

# common configs for both inside and outside desks
source ~/.desk/bashrc_common

if [ -z "$DESK_ENV" ]; then
  true
else
  ## settings for inside desk

  export HISTTIMEFORMAT="%F %T "
  export HISTFILE="${HOME}/.desk/.bash_history_${DESK_NAME}"

  PS1="$PS1 \\n[ $DESK_NAME] "
  source $DESK_ENV

  # configs for inside desks
  [ -r ~/.desk/bashrc_indesk ] && source ~/.desk/bashrc_indesk
fi 

