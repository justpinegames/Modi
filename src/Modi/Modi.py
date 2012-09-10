#!/usr/bin/python

import os
import sys
import getopt
import yaml

from ClassWritters import HumanClassWritter
from ClassWritters import MachineClassWritter

VERBOSE = False

def main(argv):
    # If the user does not specify any argument, call printHelp to show him how to call the script properly.
    if len(argv) == 0:
        printHelp()

    # Retrieve the options and arguments from the user input from the command line.
    try:
        opts, args = getopt.gnu_getopt(argv, "m:o:p:hvM:O:P:HV", ["model=", "output=", "package=", "help", "verbose"])
    except getopt.GetoptError:
        # If the error occurred while reading the arguments, printhelp will be called and the script will terminate.
        printHelp()
        exit()

    # Any argument that is not preceded by a flag is considered as a model.
    modelFiles = args
    package = ""
    outputDirectory = "."

    # Check for any additional options that the user may have specified.
    for opt, arg in opts:
        if opt in ("-h", "-H", "--help"):
            printHelp()
        elif opt in ("-o", "-O", "--output"):
            outputDirectory = arg
        elif opt in ("-p", "-P", "--package"):
            package = arg
        elif opt in ("-v", "-V", "--verbose"):
            global VERBOSE
            VERBOSE = True

    packageDirectory = package.replace(".", "/")
    classesDirectory = os.path.abspath(outputDirectory + "/" + packageDirectory)
    createDirectory(classesDirectory)

    for model in modelFiles:
        modelDirectory = os.path.abspath(model)
        generateClassesFromModel(modelDirectory, classesDirectory, package)

def generateClassesFromModel(model, directory, package):
    try:
        stream = open(model, 'r')
        yamlData = yaml.load_all(stream)

        for classesData in yamlData:
            for className in classesData:
                createMachineClass(directory, package, className, classesData[className])
                createHumanClass(directory, package, className)
    except yaml.YAMLError, exc:
        if hasattr(exc, 'problem_mark'):
            mark = exc.problem_mark
            print "Error in YAML file: %s (Line %s, Column %s)" % (model, mark.line + 1, mark.column + 1)
        exit()
    except IOError as e:
        print "I/O error({0}): {1}".format(e.errno, e.strerror)
        exit()

def createHumanClass(directory, package, className):
    classPath = directory + "/" + className + ".as"
    
    # If the user already generated this human class before, script must NOT override it.
    if not os.path.exists(classPath):
        try:
            humanClassWritter = HumanClassWritter(open(classPath, "w"), package, className, VERBOSE)
            humanClassWritter.writeClass()
        except IOError:
            print "I/O error({0}): {1}".format(e.errno, e.strerror)
            exit()
        finally:
            humanClassWritter.closeFile()
            humanClassWritter = None

def createMachineClass(directory, package, className, classData):
    classPath = directory + "/_" + className + ".as"    

    try:
        machineClassWritter = MachineClassWritter(open(classPath, "w"), package, className, classData, VERBOSE)
        machineClassWritter.writeClass()

        # FOR DEBUGGING
        # machineClassWritter.writeClassBasics()
        # machineClassWritter.writeAttributeNamesInArray()
        # machineClassWritter.writeAttributeTypes()
        # machineClassWritter.writeAttributeNames()
        # machineClassWritter.writeEnumValues()
        # machineClassWritter.writeAttributes()
        # machineClassWritter.writeConstructor()
        # machineClassWritter.writeGettersAndSetters()
    except IOError:
        print "I/O error({0}): {1}".format(e.errno, e.strerror)
        exit()
    finally:
        machineClassWritter.closeFile()
        machineClassWritter = None

def createDirectory(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)    

def printHelp():
    print "Help."

if __name__ == "__main__":
    main(sys.argv[1:])

