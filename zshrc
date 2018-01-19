#put the following line (with the correct path) in your ~/.zshrc
#fpath=(/path/to/lb-zsh $fpath)

## _gnu_generic parses the --help output, such that `root-config -<tab>` will
#show the possible options and their explanation
compdef _gnu_generic root-config

# dst-dump, dst-explorer, and bender have well written help messages, too
compdef _gnu_generic dst-dump
compdef _gnu_generic dst-explorer
compdef _gnu_generic bender

# dst-dump, dst-explorer, and bender are used on dst files, which may be in other directories
compctl -g '*(-/) *(dst|mdst)' + g '*(-/)' dst-dump
compctl -g '*(-/) *(dst|mdst)' + g '*(-/)' dst-explorer
compctl -g '*(-/) *(dst|mdst)' + g '*(-/)' bender

# gaudirun.py runs .py files
compctl -g '*(-/) *(py|opts)' + g '*(-/)' gaudirun.py
compdef _gnu_generic gaudirun.py

# execute .py script with ganga or just start it
compctl -g '*(-/) *(py)' + g '*(-/)' ganga
compdef _gnu_generic ganga

# when you're in /afs/cern.ch/user/f/foobar/cmtuser/Project_vVVrRR/Phys/DecayTreeTuple/options/mysubdir...
# i.e. anywhere in a subdirectory of a SetupProject.sh project, set up what you're working with
# > SetupProject GUESS
# > Lbglimpse <searchterm> GUESS
# > Lbglimpse <searchterm> GUESSAGAIN
guess() {
  [[ -n ${GAUDIAPPNAME} ]] && echo ${GAUDIAPPNAME} ${GAUDIAPPVERSION} || \
    pwd | sed "s/.*cmtuser\/\([^\/]*\)_\([^\/]*\).*/\1 \2/" | sed "s/Dev//" | \grep " v" || \
    lb-run -l DaVinci | sed "s/ .*//" | sort -r -V | uniq | python /afs/cern.ch/user/p/pseyfert/lb-zsh/mysort.py | head -1 | sed "s/^/DaVinci /"
}
alias -g 'GUESS'='$(guess)'
alias -g 'OLDGUESS'='$(pwd | sed "s/.*cmtuser\/\([^\/]*\)_\([^\/]*\).*/\1 \2/" | sed "s/Dev//" )'
alias -g 'GUESSAGAIN'='${GAUDIAPPNAME} ${GAUDIAPPVERSION}'
alias -g 'EOS'='root://eoslhcb.cern.ch/'

# expand PROMPT by current project, but don't pile up modifications
# http://www.nparikh.org/unix/prompt.php#zsh
# http://stackoverflow.com/questions/307503/whats-the-best-way-to-check-that-environment-variables-are-set-in-unix-shellscr
if [ -z $ORGPROMPT ]
then
export ORGPROMPT=${PROMPT}
fi
if [ -z $GAUDIAPPNAME ]
then
PROMPT="${ORGPROMPT}"
else
PROMPTPREFIX="[${GAUDIAPPNAME}/${GAUDIAPPVERSION}] "
PROMPT="${PROMPTPREFIX}${ORGPROMPT}"
fi

# load the run() function from zshrun
# FIXME: path where zshrun actually is...
source ~/lb-zsh/zshrun

# eos quota alias for "normal people"
alias EOS_user_quota='EOS_MGM_URL=root://eosuser.cern.ch eos quota | head -6 | tail -2'

setopt complete_aliases

_SetupAlias() {
  _arguments '1:version:->listversions'

  case $state in
    (listversions)
      local -a versionlist
      #  upon "SetupDaVinci<TAB> one sees
      #  echo "the words is" $words
      #  > "The words is SetupDaVinci"
      #  echo "the line is" $line
      #  > "The line is"
      #  echo "words 0   is" $words[0]
      #  > "words 0   is"
      #  echo "words 1   is" $words[1]
      #  > "words 1   is SetupDaVinci"
      #  echo "words 2   is" $words[-1]
      #  > "words 2   is"
      #
      #  grep out the project name from the end of SetupFOOBARPROJECT
      local word=$(echo $words[1] | sed "s/Setup//")
      #  then call "SetupProject.sh" instead of "SetupDaVinci" (avoid messing with aliases)
      versionlist=($(SetupProject.sh $word --list-versions | sed "s/ .*//" | sort -r | uniq))
      _describe -V 'project versions' versionlist
      ;;
  esac
}

compdef _SetupAlias SetupDaVinci
compdef _SetupAlias SetupBrunel
compdef _SetupAlias SetupBender
compdef _SetupAlias SetupErasmus
compdef _SetupAlias SetupUrania
compdef _SetupAlias SetupTesla
compdef _SetupAlias SetupMoore
compdef _SetupAlias SetupGauss
compdef _SetupAlias SetupGanga
compdef _SetupAlias SetupLHCbDirac

# solution suggested by Bart Schaefer in http://www.zsh.org/mla/users/2016/msg00466.html
_expand_alias_and_complete() {
  if [[ -o complete_aliases && -n $aliases[$words[1]] ]]; then
    words[1]=( $aliases[$words[1]] )
    _complete
  else
    return 1
  fi
}
zstyle ':completion:*' completer _complete _expand_alias_and_complete

alias -g 'ZSH'='/afs/cern.ch/user/p/pseyfert/.local/bin/zsh'
MYLBRUN() {
  alias -L > $HOME/.tmpaliases
  lb-run "$@"
  return $?
}
MYZSH() {
  alias -L > $HOME/.tmpaliases
  /afs/cern.ch/user/p/pseyfert/.local/bin/zsh "$@"
  return $?
}
compdef _lb-run MYLBRUN

SCREEN() {
  local ret
  local deletealiasfile=false
  alias -L > $HOME/.screenaliases && deletealiasfile=true
  k5reauth -f -i 3600 -p $(whoami) -k $HOME/tab/$(whoami).keytab -- screen -t ZSH
  ret=$?
  #[[ "$deletealiasfile" == true ]] && rm $HOME/.screenaliases
  return ret
}

CENTSCREEN() {
  alias -L > $HOME/.screenaliases_cent && deletealiasfile=true
  k5reauth -f -i 3600 -p $(whoami) -k $HOME/tab/$(whoami).keytab -- screen -c .screenrc.centos
  return $?
}

if [ -e $HOME/.tmpaliases ]; then
  echo "importing aliases from .tmpaliases"
  source $HOME/.tmpaliases
  rm $HOME/.tmpaliases
elif [[ $TERM == "screen" ]]; then
  echo "importing aliases for screen"
  grep CentOS /etc/redhat-release > /dev/null && source $HOME/.screenaliases_cent || source $HOME/.screenaliases
else
  echo "not importing aliases"
fi

export GANGASCRIPTS='/afs/cern.ch/user/p/pseyfert/gangascripts'

mylxplus() {
  if [ $# -eq 0 ] ; then
    echo "go directly"
    ssh -t lxplus '/afs/cern.ch/user/p/pseyfert/.local-with-etc/bin/zsh'
    return $?
  fi
  for arg ;
  do 
    if [ "${arg:0:1}" != "-" ] ; then
      echo "go to special host"
      echo "go to host" $arg
      ssh -t $@ '/afs/cern.ch/user/p/pseyfert/.local-with-etc/bin/zsh'
      return $?
    fi
  done
  echo "go with arguments"
  ssh -t $@ lxplus '/afs/cern.ch/user/p/pseyfert/.local-with-etc/bin/zsh'
}

export LSB_BJOBS_FORMAT='jobid: stat: queue: job_name:58 submit_time: start_time:'
bkillall() {
  bjobs
  read -q "REPLY?really want to kill all these jobs?" && bkill $(bjobs -noheader -o "jobid")
}

[[ ! -n $X509_VOMS_DIR ]] && export X509_VOMS_DIR=/cvmfs/grid.cern.ch/etc/grid-security/vomsdir
[[ ! -n $X509_CERT_DIR ]] && export X509_CERT_DIR=/cvmfs/grid.cern.ch/etc/grid-security/certificates
