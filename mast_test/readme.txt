
	MAST_TEST QUICK README


1. Introduction
--------------

	MAST_TEST tests whether two different versions of MAST, a reference 
	and a test version, obtain the same results over a series of examples 
	with all possible analysis+assignment combinations

	
2. Requirements
---------------

	Python 2.6+ (not compatible with Python 3.0+). Tested with Python 2.7

	
2. Files Included and folder structure
--------------------------------------

	- test.py		: Main script
	- translate.py	: Variables for the translation between versions of MAST
	+ examples		: Contains the MAST examples that are going to be tested
	+ reference		: Reference MAST results are saved here
	+ test			: Test MAST results are saved here


3. Configuration
----------------

	MAST Paths Configuration:
	-------------------------
	
	Before using MAST_TEST, make sure that the MAST executable paths are 
	correct. These are specified inside "test.py" with these two variables:
		- reference_exe_path	: MAST reference executable path	
		- test_exe_path			: MAST test executable path

	Current limitation : The reference MAST version number must be 1.3.8.X, 
	and the test version must be 1.4.X.X

	
3. Usage
--------

	Save in the "examples" directory the MAST description files of the 
	systems to use in the test.

	Run in the command line: python test.py
	
	Results are shown in the standard output and "results.txt" file
	
	
	

	


