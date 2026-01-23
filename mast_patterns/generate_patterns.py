import os
import sys

def isMultiprocessor(filename):
    nProcessors = 0
    for line in open(filename).readlines():
        if ('Processing_Resource' in line) and ('--' not in line):
            nProcessors = nProcessors + 1
    return (nProcessors > 1)
            
def isEDFexample(filename):
    for line in open(filename).readlines():
        if ('EDF' in line.upper()) and ('--' not in line): return True
    return False

def main():
    exePath = '..\\..\\..\\CTR\\mast-bin-win-1-3-8-0\\mast_analysis.exe'
    examplesFilePath = '.\\examples\\examples_list.txt'
    analysisFP = {'holistic':'ho', 'offset_based':'ou', 'offset_based_optimized':'ob'}
    assigEDF = ['pd_%s', 'npd_%s', 'hosda_%s']
    deadlinesEDF = ['local','global']
    
    fExamples = open(examplesFilePath)
    fOut = open('.\\patterns\\commands.txt','w')
    for exampleName in [exampleName.rstrip('\n') for exampleName in fExamples.readlines()]:
        if isMultiprocessor('.\\examples\\' + exampleName):
            #EDF System
            if isEDFexample('.\\examples\\' + exampleName):
                for type in deadlinesEDF:
                    #Analysis Only
                    fOut.write(exePath + ' holistic_%s_edf'%type + ' -c -v ' + '.\\examples\\' + exampleName + ' ')
                    fOut.write('.\\patterns\\' + exampleName[:-4] + '_' + 'ho_%s'%type + '.txt\n')
                    #Analysis + Assig
                    for theAssig in assigEDF:
                        fOut.write(exePath + ' holistic_%s_edf'%type + ' -c -v -p -t ' + theAssig%type + ' ')
                        fOut.write('.\\examples\\' + exampleName + ' ' + '.\\patterns\\' + exampleName[:-4] + '_' + 'ho_')
                        fOut.write(theAssig%type + '.txt\n')                  
            
            #FP System
            else:
                for tool, short in analysisFP.items():
                    #Analysis Only
                    fOut.write(exePath + ' ' + tool + ' -c -v ' + '.\\examples\\' + exampleName + ' ')
                    fOut.write('.\\patterns\\' + exampleName[:-4] + '_' + short + '.txt\n')
                    #Analysis + Assig
                    fOut.write(exePath + ' ' + tool + ' -c -v -p -t hopa ' + '.\\examples\\' + exampleName + ' ')
                    fOut.write('.\\patterns\\' + exampleName[:-4] + '_' + short + '_pa.txt\n')
    fOut.close()

if __name__ == '__main__':
    main()