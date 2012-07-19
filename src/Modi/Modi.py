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
		
		packageDirectory = "./"
		outputDirectory = "./"
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
		
		try:
			yamlData = yaml.load_all(stream)
			
			for classData in yamlData:
				for className in classData:
					createMachineClass(directory, package, className, classData)
					createHumanClass(directory, package, className, classData)
				
		except yaml.YAMLError:
			print "Model file with name " + model + " is not properly defined!"
			cleanAndExit()
	except IOError:
		print "Could not find model with name " + model + "!"
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
			file.write("\timport Modi.IDeserializator;\n")
			file.write("\timport Modi.ISerializator;\n")
			file.write("\timport Modi.ManagedObject;\n")
			file.write("\timport Modi.ManagedArray;\n")
			file.write("\timport Modi.ManagedMap;\n")
			file.write("\n\tpublic class _" + className + " extends ManagedObject\n\t{\n")
			
			""" --------------------------------------------------------------------------- """
			
			for attributeName in classData[className]:
				file.write("\t\tpublic static const ATTRIBUTE_" + attributeName.upper() + ":String = \"" + attributeName + "\";\n")
				
			file.write("\n")
			
			for attributeName in classData[className]:
				attributeData = classData[className][attributeName]
				if type(attributeData) == dict:
					for key in attributeData:
						values = attributeData[key]
						if type(values) == list:
							for value in values:
								file.write("\t\tpublic static const " + attributeName.upper() + "_" + value.upper() + ":String = \"" + value + "\";\n")
			
			for attributeName in classData[className]:
				attributeData = classData[className][attributeName]
				if type(attributeData) == dict:
					file.write("\t\tpublic static const " + attributeName.upper() + "_ENUM_ARRAY:Array = [");
					for key in attributeData:
						values = attributeData[key]
						if type(values) == list:
							for value in values:
								file.write("\"" + value + "\", ");
					file.write("];\n\n")
			
			for attributeName in classData[className]:
				attributeData = classData[className][attributeName]
				attributeType = ""
				if type(attributeData) == dict:
					attributeType = "String"
				else:
					attributeType = attributeData
					
				file.write("\t\tprivate var _" + attributeName + ":" + attributeType + ";\n")
				
			""" --------------------------------------------------------------------------- """
			
			file.write("\n\t\tpublic function _" + className + "()\n\t\t{\n")
			for attributeName in classData[className]:
				file.write("\t\t\tthis.registerAttribute(ATTRIBUTE_" + attributeName.upper() + ");\n")
			
			file.write("\n")
			
			for attributeName in classData[className]:
				attributeData = classData[className][attributeName]
				if type(attributeData) == dict:
					for key in attributeData:
						value = attributeData[key]
						if type(value) == str and key == "default":
							file.write("\t\t\t_" + attributeName + " = " + attributeName.upper() + "_" + value.upper() + ";\n")
			
			file.write("\t\t}\n\n")
			
			""" --------------------------------------------------------------------------- """
			
			for attributeName in classData[className]:
				attributeData = classData[className]
				argumentAndReturnType = ""
				
				if type(attributeData[attributeName]) == dict:
					argumentAndReturnType = "String"
				else:
					argumentAndReturnType = attributeData[attributeName]
					
				file.write("\t\tpublic function set " + attributeName + "(" + attributeName + ":" + argumentAndReturnType + "):void\n\t\t{\n")
				file.write("\t\t\tif (!this.allowChange(ATTRIBUTE_" + attributeName.upper() + ", this._" + attributeName + ", " + attributeName + "))\n")
				file.write("\t\t\t{\n\t\t\t\treturn;\n\t\t\t}\n\n\t\t\t")
				file.write("this.willChange(ATTRIBUTE_" + attributeName.upper() + ", this._" + attributeName + ", " + attributeName + ")\n\n\t\t\t")
				file.write("this._" + attributeName + " = " + attributeName + ";\n\n\t\t\t")
				file.write("this.hasChanged(ATTRIBUTE_" + attributeName.upper() + ", this._" + attributeName + ", " + attributeName + ")\n\t\t}\n\n")
				
				file.write("\t\tpublic function get " + attributeName + "():" + argumentAndReturnType + "\n\t\t{\n\t\t\t")
				file.write("return this._" + attributeName + ";\n\t\t}\n\n")
				
				file.write("\t\tpublic function set " + attributeName.capitalize() + "DirectUnsafe("+ attributeName + ":" + argumentAndReturnType)
				file.write("):void\n\t\t{\n\t\t\tthis._" + attributeName + " = " + attributeName + ";\n\t\t}\n\n")
			
			""" --------------------------------------------------------------------------- """
			
			file.write("\t\tpublic override function serialize(serializator:ISerializator):void\n\t\t{\n")
			for attributeName in classData[className]:
				attributeData = classData[className][attributeName]
				attributeType = attributeData
				if type(attributeData) == dict:
					attributeType = "String"
				file.write("\t\t\twriteUnindentified(\"" + attributeName + "\", this." + attributeName + ", \"" + attributeType + "\", serializator);\n")
			file.write("\t\t}\n\n")
			
			file.write("\t\tpublic override function deserialize(deserializator:IDeserializator):void\n\t\t{\n")
			for attributeName in classData[className]:
				attributeData = classData[className][attributeName]
				attributeType = attributeData
				if type(attributeData) == dict:
					attributeType = "String"
				file.write("\t\t\tthis." + attributeName + " = readUnindentified(\"" + attributeName + "\", \"" + attributeType + "\", deserializator);\n");
			file.write("\t\t}\n\n")
			
			file.write("\t}\n}")
			
		finally:
			file.close()
	except IOError:
		print "Error occoured while opening or reading file: \n" + classPath
		cleanAndExit()

def createEnumClassFile(machineDirectory, className, classData):

	global CREATED_FILES
	classPath = machineDirectory + "/" + className.capitalize() + "Enum.as"	
	
	try:
		file = open(classPath, "w")
		CREATED_FILES.append(classPath);
		
		try:
			file.write("package\n{\n\tpublic class " + className.capitalize() + "Enum\n\t{\n")
			
			for key in classData:
				values = classData[key]
				if type(values) == list:
					for value in values:
						file.write("\t\tpublic static const " + value.upper() + ":String = \"" + value.upper() + "\";\n")
				else:
					file.write("\t\tpublic static const DEFAULT:String = \"" + values.upper() + "\";\n")
				
			file.write("\t}\n}")
		finally:
			file.close()
			
	except IOError:
		print "Error occoured while opening or reading file: \n" + classPath
		cleanAndExit()
	
		
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
