import subprocess
import os
import difflib
import sys

def sameResults(left,right):
    fLeft = open(left)              #original file
    fRight = open(right)            #new file
    s = difflib.SequenceMatcher(None, fLeft.readlines()[6:], fRight.readlines()[6:])
    fLeft.close()
    fRight.close()
    return (s.ratio() == 1.0)

def writeParamFile(kind):
    if kind == 'pd' or kind == 'npd':
        f = open("assignment_parameters_template.txt")
        fn = open("assignment_parameters.txt","w")
        for line in f.readlines():
            fn.write(line.replace('user',kind))
        fn.close()
        f.close()
        
def toMixed(line):
    exePath = "..\\mast_analysis\\exe\\mast_analysis.exe"
    lineIn = line.split()
    lineOut = []
    lineOut.append(exePath)               #1 executable path
    #2 analysis tool (only need to change in edf)
    #if 'edf' in lineIn[1]:      lineOut.append('holistic')
    #else:                       lineOut.append(lineIn[1])
    if 'holistic' in lineIn[1]: lineOut.append('holistic')
    elif lineIn[1] == 'offset_based': lineOut.append('offset_based_approx')
    elif lineIn[1] == 'offset_based_optimized': lineOut.append('offset_based_approx_w_pr')
        
    lineOut.append('-c -v -f 2')
    if 'local' in lineIn[1]:    lineOut.append('-l')
    if '-p' in lineIn:          lineOut.append('-p -t hospa')
    #if '-t' in lineIn:
    #    tool = lineIn[lineIn.index('-t')+1]     #if npd or pd, create parameters file
    #    writeParamFile(tool.split('_')[0])
    lineOut.append(lineIn[-2])          #Example filename
    lineOut.append(lineIn[-1].replace('patterns','test_mixed'))
    return ' '.join(lineOut)


def main():
    runOnlyNew = False
    
    if len(sys.argv) > 1:
        if sys.argv[1] == '-n':
            runOnlyNew = True
        
    fComm = open(".\\patterns\\commands.txt")
    fCommMixed = open(".\\test_mixed\\commands.txt",'w')
    fLogOrig = open(".\\patterns\\log.txt","w")
    fLogMixed = open(".\\test_mixed\\log.txt","w")
    fResults = open(".\\test_mixed\\results.txt","w")
    
    for line in fComm.readlines():
        if os.path.exists('assignment_parameters.txt'):
            os.remove('assignment_parameters.txt')
        print(os.path.basename(line.split()[-1]),end = '')
        if not runOnlyNew:
            print(" || original", end = '')
            subprocess.call(line.rstrip(),stdout = fLogOrig)
        else:
            print(" || original*", end = '')
        fLogOrig.write('\n************************************************************\n')
        cmdMixed = toMixed(line)
        fCommMixed.write(cmdMixed + '\n')
        print(" new -> ", end = '')
        subprocess.call(cmdMixed,stdout = fLogMixed)
        fLogMixed.write('\n************************************************************\n')
        print(sameResults(line.split()[-1], cmdMixed.split()[-1]))
        saveout = sys.stdout
        sys.stdout = fResults
        
        print('{0:50} ==>    {1:10}'.format(os.path.basename(line.split()[-1]), \
                                          str(sameResults(line.split()[-1], cmdMixed.split()[-1]))))
        sys.stdout = saveout
        
        #fResults.write(os.path.basename(line.split()[-1]) + '\t' +\
        #               str(sameResults(line.split()[-1], cmdMixed.split()[-1])) + '\n')
    
    fComm.close()
    fCommMixed.close()
    fLogOrig.close()
    fLogMixed.close()
    fResults.close()
    
if __name__ == '__main__':
    main()