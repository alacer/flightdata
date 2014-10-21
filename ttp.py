#!/usr/local/bin/python
__author__ = 'Alan Wagner'
#  
#
import scipy.io
import re
#thefile = "tail/687200109081110"
thefile = "tail/687200107041258"

def main():

    thedict = scipy.io.loadmat(thefile,appendmat=True,)	
    count = 0
    print " Header {}  Version {}  globals {} --- numvariables {}".format(thedict['__header__'],thedict['__version__'],thedict['__globals__'],len(thedict.keys()))
    print thedict.keys()
    for key in thedict.keys():
        if key == '__header__' or key == '__version__' or key == '__globals__':
            continue
        thearray =  thedict[key]
        try:
            re.sub('\'u', '', thearray[0][0][4][0])
            print "{}: ---- Field 0: {}  length {}  Field 1: {}  length {} Other Fields: {}  {}  {} ".format(re.sub('\'u', '', thearray[0][0][4][0]),thearray[0][0][0][0],len(thearray[0][0][0]),
                thearray[0][0][1][0],len(thearray[0][0][1]),thearray[0][0][2],thearray[0][0][3],thearray[0][0][4])

        except IndexError:
            print "Error {}".format(key)
        count = count+1
        if count > 200 :
            break


if __name__ == "__main__":
    main()
