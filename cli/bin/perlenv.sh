#!/bin/sh

# usage: source perlenv

PERLBASE="$HOME/.local"
export PERLLIB="${PERLBASE}/lib/perl5:${PERLLIB}"
export PERL_LOCAL_LIB_ROOT="${PERLBASE}:${PERL_LOCAL_LIB_ROOT}"
export PERL_MB_OPT="--install_base \"${PERLBASE}\""
export PERL_MM_OPT="INSTALL_BASE=${PERLBASE}"
