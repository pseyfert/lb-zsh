# lb-zsh
zsh goodies for LHCb

## target audience
A collection of zsh completion functions to make everyday life of zsh users in
[LHCb](http://lhcb-public.web.cern.ch/lhcb-public/) easier.

The focus is analysts who use 5% of the options 95% of the time. Experts who
need all options of all tools may want to do a bit more.

## what's shipped and what's not
The package should not contain general zsh features which are useful outside of
LHCb as well. Instead it is planned to contain only features which are useful
to LHCb users only.

A border line case is the completion for `root`.

# helpful pointers

When developing the completions,
[this howto](https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org)
was of great help.

stackoverflow/stackexchange posts which helped:
 * http://stackoverflow.com/questions/4824590/propagate-all-arguments-in-a-bash-shell-script
 * http://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
 * http://stackoverflow.com/questions/2953646/how-to-declare-and-use-boolean-variables-in-shell-script
 * http://stackoverflow.com/questions/8742783/returning-value-from-called-function-in-shell-script
 * http://unix.stackexchange.com/questions/67898/using-the-not-equal-operator-for-string-comparison

