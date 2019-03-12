#!/usr/bin/python

WRONG_FILE = 0;
TRUE = 1;
FALSE = 0;
VERBOSE = FALSE;

import sys;
import os;
import re
import time

def getOptions():
	global VERBOSE
	if len(sys.argv) > 2:
		print(sys.argv[2]);
		if sys.argv[2]== "-v" or sys.argv[2] == "-V":
			VERBOSE = TRUE;

def printHere(myText):
	if VERBOSE == TRUE:
		print(myText);

def getFileList():
	"""
	Gets the list of files in the actual folder
	"""
	return os.listdir(".");

def getBaseName():
	"""
	get the base name. if there is no base name, it will return "baseName"
	"""
	if len(sys.argv) > 1:
		return sys.argv[1];
	return "image";
	
def generateName(fileName, baseName, extension, i):
	"""
	Generate the name of the actual file in the following format: year.month.day_baseName_fileNumber_extension
	"""
	if i<10:
		myCounter = "0" + str(i);
	else:
		myCounter = str(i);
	return time.strftime("%Y.%m.%d", time.gmtime(os.path.getmtime(fileName))) + "_" + baseName + "_" + myCounter + extension;
	
def renameFile(oldName, newName):
	"""
	rename a file in the hard drive
	"""
	os.rename(oldName, newName);
	printHere ("The file " + oldName + " has been renamed as " + newName);
	
def getOriginalExtension(fileName):
	"""
	Extracts the extension of the file we are studying
	"""
	extension = WRONG_FILE;
	if len(fileName) >= 4:
		extension = fileName[-4:]; #we get the last 4 chars of the string - to test if it works
		if re.search(".py", extension)  != None or re.search(".exe", extension):
			return WRONG_FILE;
	return ".jpg";

def nameAlreadyExist(newName, fileList):
	"""
	Search for any name that already exist
	"""
	for fileName in fileList:
		if fileName == newName:
			return TRUE;
	return FALSE;
	
def changeNames(fileList):
	"""
	Changes the names of all the jpg, gif or png files
	"""
	baseName = getBaseName();
	i=0;
	for fileName in fileList:
		extension = getOriginalExtension(fileName);
		if extension != WRONG_FILE:
			newName = generateName(fileName, baseName, extension, i);
			if nameAlreadyExist(newName,fileList) == FALSE:
				renameFile(fileName, newName);
			else:
				printHere("ALERT! the name " + newName + " already exists in this folder")
		i=i+1;
		
def executeProgram():
	"""
	Executes the program
	"""
	getOptions();
	fileList = getFileList();
	changeNames(fileList);	

def testHelp():
	"""
	Tests if the user is asking for the help manual
	"""
	if len(sys.argv) > 1:
		if sys.argv[1]== "-?" or sys.argv[1]== "?":
			return TRUE;

def printHelp():
	print("");
	print("This is a program that changes names of all the jpg, png or gif files in the folder it is stored");
	print("The sintax is the following:");
	print("");
	print(" changeName.py [baseName] [-v or -V]");
	print("");
	print("- [baseName] is the new base name that will be used to generate the new names for the files ");
	print("- adding -v as second input parameter makes the program to show you extra information of all the operation it is doing")
	print("");
	print("New names will have the following extructure: year.month.day_baseName_number_extension");
	
"""MAIN PROGRAM"""

if testHelp() == TRUE:
	printHelp();
else:
	executeProgram();



"""
if len(sys.argv) > 1:
	fileToOpen = sys.argv[1];
	print ("renaming the file", fileToOpen);
	i = 0;
	for fileName in os.listdir("."):
		extension = getOriginalExtension(fileName);
		if extension != WRONG_FILE:
			newName = generateName("_imageFile");
			renameFile(fileName, testName);
			i = i + 1;
	#myFile = open(fileToOpen, "w");
	#exec(myFile.read());
else:
	print ("write something to open");

#print ("Number of arguments:", len(sys.argv), 'arguments.');
#print ("Argument List:", str(sys.argv));
#print (sys.argv[1]);
"""

