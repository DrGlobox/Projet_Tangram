from pyswip.prolog import Prolog

def start_script():
    prolog = Prolog()
    prolog.consult("coins.pl")
    
    count = int(raw_input("How many coins (default: 100)? ") or 100)
    total = int(raw_input("What should be the total (default: 500)? ") or 500)
    for i, soln in enumerate(prolog.query("coins(S, %d, %d)." % (count,total))):
        # [1,5,10,50,100]
        S = zip(soln["S"], [1, 5, 10, 50, 100])
        print i,
        for c, v in S:
            print "%dx%d" % (c,v),
        print
    list(prolog.query("coins(S, %d, %d)." % (count,total)))


