#put the following line (with the correct path) in your ~/.zshrc
#fpath=(/path/to/lb-zsh $fpath)

## _gnu_generic parses the --help output, such that `root-config -<tab>` will
#show the possible options and their explanation
compdef _gnu_generic root
compdef _gnu_generic root-config

# beyond the option completion, root should be called for .root files and .C
# files only (please no .py, .txt, .jpg, ...
# but directory paths should also be allowed
compctl -g '*(-/) *(root|C)' + g '*(-/)' root

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

# when you're in /afs/cern.ch/user/f/foobar/cmtuser/Project_vVVrRR/Phys/DecayTreeTuple/options/mysubdir...
# i.e. anywhere in a subdirectory of a SetupProject.sh project, set up what you're working with
# > SetupProject GUESS
alias -g 'GUESS'='$(pwd | sed "s/.*cmtuser\/\([^\/]*\)_\([^\/]*\).*/\1 \2/")'

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
PROMPT="[${GAUDIAPPNAME} ${GAUDIAPPVERSION}] ${ORGPROMPT}"
fi

# load the run() function from zshrun
# FIXME: path where zshrun actually is...
source ~/lb-zsh/zshrun
