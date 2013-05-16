#!/usr/bin/python

import os
import sys
import getopt
import yaml

from ClassWritters import HumanClassWritter
from ClassWritters import MachineClassWritter

VERBOSE = False
VERSION = "1.0.0"

def main(argv):
    # If the user does not specify any argument, call printHelp to show him how to call the script properly.
    if len(argv) == 0:
        printHelp()

    # Retrieve the options and arguments from the user input from the command line.
    try:
        opts, args = getopt.gnu_getopt(argv, "o:p:hvVO:P:H", ["output=", "package=", "help", "version", "verbose"])
    except getopt.GetoptError:
        # If the error occurred while reading the arguments, printhelp will be called and the script will terminate.
        printHelp()
        exit()

    # Any argument that is not preceded by a flag is considered as a model.
    modelFiles = args
    if len(modelFiles) == 0:
        printHelp()
        exit()        

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
        elif opt in ("-V", "--verbose"):
            global VERBOSE
            VERBOSE = True
        elif opt in ("-v", "--version"):
            printVersion()

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
    help =  "\nScript options:\n\n"
    help += "\t-o, -O, --output\n"
    help += "\t\tDirectory where the class files will be saved.\n"
    help += "\t\tThe script will automatically create folders for\n"
    help += "\t\tthese classes if they do not already exist.\n"
    help += "\t\tThe script supports both '\\' and '/' as a separator.\n"
    help += "\t\tThe output directory does not include package\n"
    help += "\t\tdirectory. Package directory is specified separately\n"
    help += "\t\tusing the --package option.\n\n"
    help += "\t-p, -P, --package\n"
    help += "\t\tPackage that will be included in the class.\n"
    help += "\t\tThe script will automatically create folders for\n"
    help += "\t\tthese packages if they do not already exist.\n"
    help += "\t\tPackages should be written in the same way as they are\n"
    help += "\t\tin the code, where each package directory is separated\n"
    help += "\t\tby a period.\n\n"
    help += "\t-V, --verbose\n"
    help += "\t\tShow all created classes in the console.\n\n"
    help += "\t-v, --version\n"
    help += "\t\tShow the current version of Modi.\n\n"
    help += "\t-h, -H, --help\n"
    help += "\t\tShow a short usage summary.\n\n"
    help += "Example of use:\n"
    help += "Modi.py Game.yaml Player.yaml -o C:\Projects\Game -p models.game\n"
    help += "            ^          ^                ^                 ^\n"
    help += "         model 1    model 2      output directory   package directory\n"
    help += "\nYou can specify any number of models. Each argument that is not preceded by an option is considered as a model."
    help += " This concrete call will create classes for all models in directory 'C:\Projects\Game\models\game'."
    help += " Each class will include package 'models.game' on top of it."
    print help

def printVersion():
    print "Modi version: " + VERSION

if __name__ == "__main__":
    main(sys.argv[1:])

