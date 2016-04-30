#put the following line (with the correct path) in your ~/.zshrc
#fpath=(/path/to/lb-zsh $fpath)

compdef _gnu_generic root
compdef _gnu_generic root-config

compctl -g '*(-/) *(root|C)' + g '*(-/)' root

#below only drafted
compdef _gnu_generic dst-dump
compdef _gnu_generic dst-explorer

compctl -g '*(-/) *(dst|mdst)' + g '*(-/)' dst-dump
compctl -g '*(-/) *(dst|mdst)' + g '*(-/)' dst-explorer
compctl -g '*(-/) *(dst|mdst)' + g '*(-/)' bender

compctl -g '*(-/) *(py|opts)' + g '*(-/)' gaudirun.py
compdef _gnu_generic gaudirun.py

# when you're in /afs/cern.ch/user/f/foobar/cmtuser/Project_vVVrRR/Phys/DecayTreeTuple/options/mysubdir...
# i.e. anywhere in a subdirectory of a SetupProject.sh project, set up what you're working with
# > SetupProject GUESS
alias -g 'GUESS'='$(pwd | sed "s/.*cmtuser\/\([^\/]*\)_\([^\/]*\).*/\1 \2/")'

source ~/lb-zsh/zshrun
