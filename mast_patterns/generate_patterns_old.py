import os
import sys

def main():
    print('Pattern Generator for MAST 1.3.7.8')
    exe_path = '..\\mast_analysis\\exe\\mast_analysis.exe'
    
    generateCommands = False
    executeCommands = False
    
    if len(sys.argv) == 3 and sys.argv[1] != '-x':
        generateCommands = True
        executeCommands = True
        examplesListFile = sys.argv[1]
        examplesCommandsFile = sys.argv[2]
    elif len(sys.argv) == 4 and sys.argv[1] == '-o':
        generateCommands = True
        executeCommands = False
        examplesListFile = sys.argv[2]
        examplesCommandsFile = sys.argv[3]
    elif len(sys.argv) == 3 and sys.argv[1] == '-x':
        generateCommands = False
        executeCommands = True
        examplesCommandsFile = sys.argv[2]
    else:
        print('Error : Command line error')
    
    def isMultiprocessor(filename):
        nProcessors = 0
        for line in open(filename).readlines():
            if ('Processing_Resource (' in line) and ('--' not in line):
                nProcessors = nProcessors + 1
        return (nProcessors > 1)
            
    def isEDFexample(filename):
        for line in open(filename).readlines():
            if ('EDF' in line.upper()) and ('--' not in line): return True
        return False
        
    def EDF_command(options):
        optionsList = options.split('_')
        isLocal = ('local' in options)
        optString = ' holistic' + (isLocal and ('_local_edf') or ('_global_edf')) + ' -c'
        if len(optionsList) == 2:
            return optString
        else:
            optString2 = ' -p -t ' + optionsList[-1] + (isLocal and '_local' or '_global')
            return optString + optString2
        
    def FP_command(options):
        dict = {'ho':'holistic', 'obu':'offset_based', 'obo':'offset_based_optimized',
                'rm':'classic_rm', 'vp':'varying_priorities'}
        optionList = options.split('_')
        if len(optionList) == 1:
            return ' ' + dict[optionList[0]] + ' -c'
        else:
            return ' ' + dict[optionList[0]] + ' -c -p'
    
    EDF_analysis = ['ho_local', 'ho_global']
    EDF_assig = ['_pd', '_npd', '_hosda', '']
    EDF_options = [analysis + assig for analysis in EDF_analysis for assig in EDF_assig]
    
    FP_analysis = ['ho', 'obu', 'obo', 'rm', 'vp']
    FP_assig = ['_pa', '']
    FP_options = [analysis + assig for analysis in FP_analysis for assig in FP_assig]
    
    if generateCommands:
        # Build commands list
        f = open(examplesListFile)
        commands = []
        for element in [element.rstrip('\n') for element in f.readlines()]:
            if isEDFexample('.\\examples\\' + element): 
                for option in EDF_options: 
                    command = exe_path + EDF_command(option) + ' ' + '.\\examples\\' + element + ' ' + \
                        '.\\patterns\\' + element.replace('.txt','') + '_' + option + '.txt'
                    commands.append(command)                
                
            else: #FP system
                for option in FP_options: 
                    command = exe_path + FP_command(option) + ' ' + '.\\examples\\' + element + ' ' + \
                        '.\\patterns\\' + element.replace('.txt','') + '_' + option + '.txt'
                    commands.append(command)
        f.close()
        
        #2 Write commands list 
        f = open(examplesCommandsFile,'w')
        for command in commands:
            f.write(command+'\n')
        f.close()
    
    if executeCommands:
        #3 Execute commands list
        f = open(examplesCommandsFile)
        for command in f.readlines():
            print('Running :'+command)
            os.system(command)
    
    
if __name__ == '__main__':
    main()
    


