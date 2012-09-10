#!/usr/bin/python

import sys
import yaml
import os
import types

CREATED_FILES = []
CREATED_FOLDERS = []

def main(argv):
    
    if len(argv) == 0:
        print 'Type "' + sys.argv[0] + ' --help" for instructions on how to call this script properly.'
    elif len(argv) == 1 and argv[0] == "--help":
        printHelp()
    else:
        packageFlag = False
        outputFlag = False
        
        packageDirectory = ""
        outputDirectory = ""
        modelFiles = []

        for arg in argv:
            if packageFlag == True:
                packageDirectory = arg
                packageFlag = False
            elif outputFlag == True:
                outputDirectory = arg
                outputFlag = False
            else:
                if arg == '-P' or arg == '-p':
                    packageFlag = True
                elif arg == '-O' or arg == '-o':
                    outputFlag = True
                else:
                    modelFiles.append(arg)

        if len(modelFiles) == 0:
            print "Script terminated.\n"
            print 'Type "Modi.py --help" for instructions on how to call this script properly.'
        else:
            packageForCode = packageDirectory
            packages = packageDirectory.split('.')
            packageDirectory = ""
            for package in packages:
                packageDirectory += package + "/"
                
            classesDirectory = os.path.abspath(outputDirectory + "/" + packageDirectory)
            createDirectory(classesDirectory)
            
            
            for model in modelFiles:
                generateClassesFromModel(model, classesDirectory, packageForCode)


def generateClassesFromModel(model, directory, package):
    try:
        stream = open(model, 'r')
        
        yamlData = yaml.load_all(stream)
        
        for classData in yamlData:
            for className in classData:
                createMachineClass(directory, package, className, classData)
                createHumanClass(directory, package, className, classData)
                
    except yaml.YAMLError, exc:
        if hasattr(exc, 'problem_mark'):
            mark = exc.problem_mark
            print "Error in YAML file: %s (Line %s, Column %s)" % (path, mark.line + 1, mark.column + 1)
        cleanAndExit()
    except IOError as e:
        print "I/O error({0}): {1}".format(e.errno, e.strerror)
        cleanAndExit()
    

def createHumanClass(directory, package, className, classData):

    global CREATED_FILES
    classPath = directory + "/" + className + ".as"
    
    if not os.path.exists(classPath):
        try:
            file = open(classPath, "w")
            """CREATED_FILES.append(classPath)"""
            try:
                file.write("package " + package + "\n{\n\tpublic class " + className + " extends _" + className + "\n\t{\n")
                file.write("\n\t\tpublic function " + className + "()\n\t\t{\n")
                file.write("\n\t\t}\n\n\t}\n\n}")
            finally:
                file.close()
        except IOError:
            print "Error occoured while opening or reading file: \n" + classPath
            cleanAndExit()


def createMachineClass(directory, package, className, classData):

    global CREATED_FILES
    classPath = directory + "/_" + className + ".as"    
    
    try:
        file = open(classPath, "w")
        CREATED_FILES.append(classPath);
        
        try:
        
            file.write("package " + package + "\n{\n")
            file.write("\timport Modi.*;\n\n")
            file.write("\timport flash.utils.Dictionary;\n")
            
            superClass = "ManagedObject"
            
            for attributeName in classData[className]:
                if attributeName == "super":
                    superClass = classData[className][attributeName]
            
            file.write("\n\tpublic class _" + className + " extends " + superClass + "\n\t{\n")
            
            """ --------------------------------------------------------------------------- """
            
            file.write("\t\tpublic static const ATTRIBUTES:Array = [");
            for attributeName in classData[className]:
                if attributeName != "super":
                    file.write("\"" + attributeName + "\", ")
            file.write("];\n\t\tpublic static const ATTRIBUTE_TYPES:Array = [");
            for attributeName in classData[className]:
                if attributeName != "super":
                    attributeData = classData[className][attributeName]
                    attributeType = attributeData
                    if type(attributeData) == dict:
                        if "type" in attributeData:
                            attributeType = attributeData["type"]
                        else:
                            attributeType = "String"
                    if "Managed" in attributeData:
                        attributeType = getCollectionType(attributeData)
                    file.write("\"" + attributeType + "\", ")
            file.write("];\n\n")
            
            for attributeName in classData[className]:
                if attributeName != "super":
                    file.write("\t\tpublic static const ATTRIBUTE_" + attributeName.upper() + ":String = \"" + attributeName + "\";\n")
            
            file.write("\n")
                
            for attributeName in classData[className]:
                attributeData = classData[className][attributeName]
                if type(attributeData) == dict:
                    for key in attributeData:
                        values = attributeData[key]
                        if type(values) == list:
                            for value in values:
                                file.write("\t\tpublic static const " + attributeName.upper() + "_" + str(value).upper() + ":String = \"" + str(value) + "\";\n")
            
            for attributeName in classData[className]:
                attributeData = classData[className][attributeName]
                if type(attributeData) == dict and "values" in attributeData:
                    file.write("\t\tpublic static const " + attributeName.upper() + "_ENUM_ARRAY:Array = [");
                    for key in attributeData:
                        values = attributeData[key]
                        if type(values) == list:
                            for value in values:
                                file.write("\"" + str(value) + "\", ");
                    file.write("];\n\n")
            
            for attributeName in classData[className]:
                if attributeName != "super":
                    attributeData = classData[className][attributeName]
                    attributeType = ""
                    if type(attributeData) == dict:
                        if "values" in attributeData:
                            attributeType = "String"
                        elif "type" in attributeData:
                            attributeType = attributeData["type"]
                    else:
                        attributeType = attributeData
                        if "Managed" in attributeType:
                            attributeType = getCollectionType(attributeData)
                    file.write("\t\tprivate var _" + attributeName + ":" + attributeType + ";\n")
                
            """ --------------------------------------------------------------------------- """
            
            file.write("\n\t\tpublic function _" + className + "()\n\t\t{\n")
            file.write("\t\t\tthis.registerAttributes(ATTRIBUTES, ATTRIBUTE_TYPES);\n")
            
            file.write("\n")
            
            for attributeName in classData[className]:
                attributeData = classData[className][attributeName]
                if type(attributeData) == dict:
                    if "default" in attributeData:
                        if "values" in attributeData:
                            file.write("\t\t\t_" + attributeName + " = " + attributeName.upper() + "_" + str(attributeData["default"]).upper() + ";\n")
                        elif "type" in attributeData:
                            if attributeData["type"] == "String":
                                file.write("\t\t\t_" + attributeName + ' = "' + str(attributeData["default"]) + '";\n')
                            else:
                                file.write("\t\t\t_" + attributeName + " = " + str(attributeData["default"]) + ";\n")

            file.write("\n")

            for attributeName in classData[className]:
                attributeData = classData[className][attributeName]
                if "Managed" in attributeData and attributeName != "super":
                    file.write("\t\t\t_" + attributeName + " = new " + getCollectionType(attributeData) + "();\n")

                    if getChildType(attributeData) != "ManagedObject":
                        if isModiClass(getChildType(attributeData)):
                            file.write("\t\t\t_" + attributeName + '.childType = "Modi.' + getChildType(attributeData) + '";\n')
                        else:
                            packageToAdd = package
                            if package != "":
                                packageToAdd += "."

                            file.write("\t\t\t_" + attributeName + '.childType = "' + packageToAdd + getChildType(attributeData) + '";\n')

            file.write("\t\t}\n\n")

            """ --------------------------------------------------------------------------- """
            
            for attributeName in classData[className]:
                if attributeName != "super":
                    attributeData = classData[className]
                    argumentAndReturnType = ""
                    
                    if type(attributeData[attributeName]) == dict:
                        if "values" in attributeData[attributeName]:
                            argumentAndReturnType = "String"
                        elif "type" in attributeData[attributeName]:
                            argumentAndReturnType = attributeData[attributeName]["type"]
                    else:
                        argumentAndReturnType = attributeData[attributeName]
                        if "Managed" in argumentAndReturnType:
                            argumentAndReturnType = getCollectionType(argumentAndReturnType)

                    file.write("\t\tpublic final function set " + attributeName + "(" + attributeName + ":" + argumentAndReturnType + "):void\n\t\t{\n")
                    file.write("\t\t\tif (!this.allowChange(ATTRIBUTE_" + attributeName.upper() + ", _" + attributeName + ", " + attributeName + "))\n")
                    file.write("\t\t\t{\n\t\t\t\treturn;\n\t\t\t}\n\n\t\t\t")
                    file.write("this.willChange(ATTRIBUTE_" + attributeName.upper() + ", _" + attributeName + ", " + attributeName + ");\n\n\t\t\t")
                    file.write("var oldValue:" + argumentAndReturnType + " = _" + attributeName + ";\n\n\t\t\t")
                    file.write("_" + attributeName + " = " + attributeName + ";\n\n\t\t\t")
                    file.write("this.wasChanged(ATTRIBUTE_" + attributeName.upper() + ", oldValue, _" + attributeName + ");\n\t\t}\n\n")
                    
                    file.write("\t\tpublic final function get " + attributeName + "():" + argumentAndReturnType + "\n\t\t{\n\t\t\t")
                    file.write("return _" + attributeName + ";\n\t\t}\n\n")
                    
                    file.write("\t\tpublic final function set " + attributeName.capitalize() + "DirectUnsafe("+ attributeName + ":" + argumentAndReturnType)
                    file.write("):void\n\t\t{\n\t\t\t_" + attributeName + " = " + attributeName + ";\n\t\t}\n\n")
            
            """ --------------------------------------------------------------------------- """
            
            file.write("\t}\n}")
            
        finally:
            file.close()
    except IOError:
        print "Error occoured while opening or reading file: \n" + classPath
        cleanAndExit()

def isModiClass(className):
    modiClasses = ["ManagedArray", "ManagedMap", "ManagedValue", "ManagedPoint"]
    for modiClass in modiClasses:
        if modiClass == className:
            return True
    

    return False

def isNumeric(value):
    numericTypes = ["int", "float", "long", "complex"]
    for numericType in numericTypes:
        if type(value) == eval(numericType):
            return True
    return False


def getCollectionType(str):
    childType = ""
    counts = True

    for char in str:
        if char == "<":
            counts = False
        if counts:
            childType += char

    return childType;

def getChildType(str):
    childType = "ManagedObject"
    counts = False

    for char in str:
        if char == ">":
            counts = False
        if counts:
            childType += char
        if char == "<":
            childType = ""
            counts = True

    return childType;

    
        
def cleanAndExit():
    
    global CREATED_FILES
    global CREATED_FOLDERS
    
    for file in CREATED_FILES:
        os.remove(file)
    for folder in CREATED_FOLDERS:
        os.rmdir(folder)
    exit()
    
def createDirectory(directory):
    global CREATED_FOLDERS
    if not os.path.exists(directory):
        os.makedirs(directory)
        CREATED_FOLDERS.append(directory)
    
    
def printHelp():
    print "Ovdje ce doc help manual"
        
""" RUN THE SCRIPT WITHOUT FIRST PARAMETER """
if __name__ == "__main__":
    main(sys.argv[1:])
