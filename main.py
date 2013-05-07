#!/usr/bin/python
#-*- coding:utf8 -*-

from pyswip.prolog import Prolog
from pyswip.easy import *
PROLOG_FILE = "tangram.pl"

def solve():
    prolog.consult(PROLOG_FILE)
    shapes = "coucou"
    draw = "banane"

    result = list(prolog.query("L=%s,D=%s, tangram(L,D,A)" %(shapes,draw)))
    print result

def main():
    solve()

if __name__ == "__main__":
    prolog = Prolog()
    main()

