import sys,os,difflib

def isMultiprocessor(filename):
    nProcessors = 0
    for line in open(filename).readlines():
        if ('Processing_Resource (' in line) and ('--' not in line):
            nProcessors = nProcessors + 1
    return (nProcessors > 1)

def writeParamFile(kind):
    f = open("assignment_parameters_template.txt")
    fn = open("assignment_parameters.txt","w")
    for line in f.readlines():
        fn.write(line.replace('user',kind))
    f.close()
    fn.close()
    
def main():
    
    print('Pattern Test for MAST Mixed (beta)')
    if len(sys.argv) == 3:
        execute = True
        examplesCommandsFile = sys.argv[1]
        pathOut = sys.argv[2]
    elif len(sys.argv) == 4 and sys.argv[1] == '-o':
        execute = False
        examplesCommandsFile = sys.argv[2]
        pathOut = sys.argv[3]
    else:
        print('Error : Argument Error')
        return
    
    if not os.path.exists(pathOut):
        os.mkdir(pathOut)
    
    exe_path = '..\\mast_analysis_mixed\\exe\\mast_analysis.exe'
    
    f = open(examplesCommandsFile)
    if execute:
        f_results = open(pathOut + '\\results.txt','w')
    f_commands = open(pathOut + '\\commands.txt','w')
    
    for temp in f.readlines():
        line = temp.split()
        pattern = line[-1]
        example = line[-2]
        pattern_new = pathOut + '\\' + os.path.split(line[-1])[1]
        
        validAnalysis = {'ho','obu','obo','rm','vp'}
        distrAssig = {'hosda','pd','npd','pa'}
        validTools = {'obo':'offset_based_optimized', 'hosda':'-p -t hospa',
                      'npd':'-p -t hospa', 'global':'','vp':'varying_priorities',
                      'pa':'-p -t hospa','ho':'holistic','pd':'-p -t hospa', 
                      'rm':'classic_rm', 'obu':'offset_based', 'local':'-l'}
        currentToolSet = {x for x in os.path.split(line[-1])[1][0:-4].split('_') if x in validTools.keys()}
        
        #build command line commands
        addedCommands = [validTools[(currentToolSet & validAnalysis).pop()]]
        if 'local' in currentToolSet: addedCommands.append('-l')
        
        if currentToolSet & distrAssig:
            addedCommands.append('-c -x -p -t hospa')
        else:
            addedCommands.append('-c -x')
        
        command = exe_path + ' ' + ' '.join(str(n) for n in addedCommands) + ' ' + \
            example + ' '  + pattern_new
            
        
                 
        if execute and os.path.exists(pattern) and isMultiprocessor(example):
            
            f_commands.write(command + '\n')
            f_results.write(os.path.split(pattern)[1] + '\t')
            f_results.write(str(os.path.exists(pattern)))
            f_results.write('\t\t')
            f_results.write(str(isMultiprocessor(example)))
            
            if os.path.exists('assignment_parameters.txt'):
                os.remove('assignment_parameters.txt')
            p = {'pd','npd'} & currentToolSet
            if p:
                writeParamFile(p.pop())
            os.system(command)
            fp = open(pattern)          #original file
            fn = open(pattern_new)      #new file
            s = difflib.SequenceMatcher(None, fp.readlines()[6:], fn.readlines()[6:])
            fp.close()
            fn.close()
            if s.ratio() == 1.0:
                f_results.write('\tCorrect\n')
            else: 
                f_results.write('\tDifference\n')
        
    if execute:
        f_results.close()
    f_commands.close()
    
if __name__ == '__main__':
    main()