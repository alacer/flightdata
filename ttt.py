#!/usr/local/bin/python
__author__ = 'Alan Wagner'
#  
#
import sys
import scipy.io
import re
#thefile = "tail/687200109081110"
#thefile = "tail/687200107041258"

def main(argv):

    thedict = scipy.io.loadmat(argv[0],appendmat=True,)	
    count = 0
    #print " Header {}  Version {}  globals {} --- numvariables {}".format(thedict['__header__'],thedict['__version__'],thedict['__globals__'],len(thedict.keys()))
    #print thedict.keys()
    for key in thedict.keys():
        if key == '__header__' or key == '__version__' or key == '__globals__':
            continue
        thearray =  thedict[key]
        try:
            print "{},{},{}".format(re.sub('\'u', '', thearray[0][0][4][0]),len(thearray[0][0][0]),thearray[0][0][1][0][0]),
            for i in range(len(thearray[0][0][0])-1):
                print ",{}".format(thearray[0][0][0][0][0]),
            print ",{}".format(thearray[0][0][0][-1][0])    
        except IndexError:
            print "Error {}".format(key)
        count = count+1
        if count > 200 :
            break


if __name__ == "__main__":
    main(sys.argv[1:])
