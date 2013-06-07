#!/usr/bin/python
#-*- coding:utf8 -*-

from pyswip.prolog import Prolog
from pyswip.prolog import Prolog
from pyswip.easy import getList, registerForeign
PROLOG_FILE = "tangram.pl"

def notify(t):
    for i in list(t):
        print "%s  "% i,
    print "\n"
notify.arity = 1



def solve():
    prolog.consult(PROLOG_FILE)
    shapes = "coucou"
    draw = "banane"

    result = list(prolog.query("tangram(\"coucou\",[],A)"))
    print result

def main():
    solve()

if __name__ == "__main__":
    prolog = Prolog()
    main()

