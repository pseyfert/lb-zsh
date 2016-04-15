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


compctl -g '*(-/) *(py|opts)' + g '*(-/)' gaudirun.py
compdef _gnu_generic gaudirun.py

