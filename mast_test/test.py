import difflib
from translation import *
import os
import subprocess

#Paths to MAST executables
#Reference executable uses MAST version 1.3.8 command line parameter sintaxis
#Test executable uses MAST version 1.4 command line parameter sintaxis
#Paths can be absolute or relative from Mast_Test folder

reference_exe_path = "/home/mgh/prog/mast-distributions/mast-1-3-8-0/mast-bin-linux-1-3-8-0/mast_analysis" 

test_exe_path = "/home/mgh/prog/mast/mast_analysis/mast_analysis"

def main():

    examples_folder = "examples"
    reference_folder = "reference"
    test_folder = "test"

    #commands generation
    examples_list = os.listdir(examples_folder)
    
    cmd = [[analysis, assign, os.path.join(examples_folder,example)]
        for example in examples_list
        for analysis in analysis_map.keys()
        for assign in assignment_map.keys()]

    #write commands
    write_commands(reference_folder, test_folder, cmd)
    
    #analysis execution
    exe_commands(reference_folder, test_folder)
    
#########


def write_commands(ref_path, test_path, cmd_list):
    fp_ref = open(os.path.join(ref_path,"commands.txt"),"w")
    fp_test = open(os.path.join(test_path,"commands.txt"),"w")
    
    for element in cmd_list:            
        out_fname = "_".join([filename_map[element[0]],
                              filename_map[element[1]],
                              "_" + os.path.basename(element[2])])
        
        fp_ref.write(reference_exe_path + " " + " ".join(element) + \
                     " " + os.path.join(ref_path,out_fname) + "\n")
        
        fp_test.write(test_exe_path + " " + \
                      " ".join([analysis_map[element[0]],
                                assignment_map[element[1]],
                                element[-1]]) + \
                      " " + os.path.join(test_path,out_fname) + "\n")
    fp_ref.close()
    fp_test.close()


def exe_commands(ref_path, test_path):
    fp_cmd_ref = open(os.path.join(ref_path,"commands.txt"),"r")
    fp_cmd_test = open(os.path.join(test_path,"commands.txt"),"r")
    fp_log = open("mast_log.txt","w")
    fp_result = open("results.txt","w")

    ref_lines = fp_cmd_ref.readlines()
    test_lines = fp_cmd_test.readlines()

    if len(ref_lines) != len(test_lines):
        raise Exception("Number of tests mismatch")

    for i in range(len(ref_lines)):

        print os.path.basename(ref_lines[i].rstrip().split()[-1]).ljust(45),
        fp_result.write(os.path.basename(ref_lines[i].rstrip().split()[-1]).ljust(45))

        print "reference".rjust(10),
        fp_result.write("reference".rjust(10))
        subprocess.call(ref_lines[i].rstrip("\n").split(),stdout = fp_log)
        left = ref_lines[i].split()[-1]

        print "test".rjust(6),
        fp_result.write("test".rjust(6))
        subprocess.call(test_lines[i].rstrip("\n").split(),stdout = fp_log)
        right = test_lines[i].split()[-1]

        if areSameResults(left, right):
            print "  OK"
            fp_result.write("  OK\n")
        else:
            print "  Mismatch"
            fp_result.write("  Mismatch\n")

    fp_cmd_ref.close()
    fp_cmd_test.close()
    fp_log.close()
    fp_result.close()


def areSameResults(left,right):
    """Returns True if "left" and "right" MAST result files are equal"""

    try:
        s = difflib.SequenceMatcher(None, open(left).readlines()[6:], open(right).readlines()[6:])
        return (s.ratio() == 1.0)
    except:
        if len(open(left).readlines()) == len(open(right).readlines()):
            return True
        else:
            return False

if __name__ == "__main__":
    main()
