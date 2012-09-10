#!/usr/bin/python

import types
import re

class HumanClassWritter:
    file = None
    package = ""
    className = ""
    verbose = False

    def __init__(self, file, package, className, verbose):
        self.file = file
        self.package = package
        self.className = className
        self.verbose = verbose

    def write(self, text):
        self.file.write(text)
        if self.verbose:
            print text

    def closeFile(self):
        self.file.close()

    def writeClass(self):
        if (self.verbose):
            print "-------------------------------------------------------------------"
            print "Writing human class: " + self.className + "\n"

        self.write("package " + self.package + "\n{\n\tpublic class " + self.className + " extends _" + self.className + "\n\t{\n")
        self.write("\n\t\tpublic function " + self.className + "()\n\t\t{\n")
        self.write("\n\t\t}\n\n\t}\n\n}")

class MachineClassWritter:
    file = None
    package = ""
    className = ""
    classData = ""
    verbose = False

    def __init__(self, file, package, className, classData, verbose):
        self.file = file
        self.package = package
        self.className = className
        self.classData = classData
        self.verbose = verbose

    def write(self, text):
        self.file.write(text)
        if self.verbose:
            print text

    def closeFile(self):
        self.file.close()

    def writeClass(self):
        if self.verbose:
            print "-------------------------------------------------------------------"
            print "Writing machine class: _" + self.className + "\n"

        self.writeClassBasics()
        self.writeAttributeNamesInArray()
        self.writeAttributeTypes()
        self.writeAttributeNames()
        self.writeEnumValues()
        self.writeAttributes()
        self.writeConstructor()
        self.writeGettersAndSetters()

    def writeClassBasics(self):
        self.write("package " + self.package + "\n{\n")
        self.write("\timport Modi.*;\n\n")
        self.write("\timport flash.utils.Dictionary;\n")
        
        superClass = "ManagedObject"
        if "super" in self.classData:
            superClass = self.classData["super"]
        self.write("\n\tpublic class _" + self.className + " extends " + superClass + "\n\t{\n")

    def writeAttributeNamesInArray(self):
        self.write("\t\tpublic static const ATTRIBUTES:Array = [");
        for attributeName in self.classData:
            if attributeName != "super":
                self.write("\"" + attributeName + "\", ")
        self.write("];\n");

    def writeAttributeTypes(self):
        self.write("\t\tpublic static const ATTRIBUTE_TYPES:Array = [");
        for attributeName in self.classData:
            if attributeName != "super":
                attributeData = self.classData[attributeName]
                attributeType = attributeData
                if "Managed" in attributeData:
                    attributeType = getModiClass(attributeData)
                elif type(attributeData) == dict:
                    if "type" in attributeData:
                        attributeType = attributeData["type"]
                    else:
                        attributeType = "String"
                self.write("\"" + attributeType + "\", ")
        self.write("];\n\n")

    def writeAttributeNames(self):
        for attributeName in self.classData:
            if attributeName != "super":
                self.write("\t\tpublic static const ATTRIBUTE_" + toUppercaseWithUnderscores(attributeName) + ":String = \"" + attributeName + "\";\n")
        self.write("\n")

    def writeEnumValues(self):
        for attributeName in self.classData:
            attributeData = self.classData[attributeName]
            if type(attributeData) == dict and "values" in attributeData:
                enum = attributeData["values"]
                enumValues = ""
                for value in enum:
                    self.write("\t\tpublic static const " + attributeName.upper() + "_" + str(value).upper() + ":String = \"" + str(value) + "\";\n")
                    enumValues += "\"" + value + "\", "
                self.write("\t\tpublic static const " + attributeName.upper() + "_ENUM_ARRAY:Array = [" + enumValues + "];\n\n");

    def writeAttributes(self):
        for attributeName in self.classData:
            if attributeName != "super":
                attributeData = self.classData[attributeName]
                attributeType = attributeData
                if "Managed" in attributeData:
                    attributeType = getModiClass(attributeData)
                elif type(attributeData) == dict:
                    if "type" in attributeData:
                        attributeType = attributeData["type"]
                    else:
                        attributeType = "String"
                self.write("\t\tprivate var _" + attributeName + ":" + attributeType + ";\n")

    def writeConstructor(self):
        self.write("\n\t\tpublic function _" + self.className + "()\n\t\t{\n")
        self.write("\t\t\tthis.registerAttributes(ATTRIBUTES, ATTRIBUTE_TYPES);\n")
        self.write("\n")
        
        for attributeName in self.classData:
            attributeData = self.classData[attributeName]
            if type(attributeData) == dict:
                if "default" in attributeData:
                    if "values" in attributeData:
                        self.write("\t\t\t_" + attributeName + " = " + attributeName.upper() + "_" + str(attributeData["default"]).upper() + ";\n")
                    elif "type" in attributeData:
                        if attributeData["type"] == "String":
                            self.write("\t\t\t_" + attributeName + " = \"" + str(attributeData["default"]) + "\";\n")
                        elif attributeData["type"] == "ManagedValue":
                            self.write("\t\t\t_" + attributeName + " = new ManagedValue(" + str(attributeData["default"]) + ");\n")
                        else:
                            self.write("\t\t\t_" + attributeName + " = " + str(attributeData["default"]) + ";\n")

        self.write("\n")

        for attributeName in self.classData:
            attributeData = self.classData[attributeName]
            if "Managed" in attributeData and attributeName != "super":
                modiClass = getModiClass(attributeData)
                self.write("\t\t\t_" + attributeName + " = new " + modiClass + "();\n")
                if modiClass == "ManagedArray":
                    elementType = getManagedArrayElementType(attributeData)
                    if elementType != "ManagedObject":
                        if isModiClass(elementType):
                            self.write("\t\t\t_" + attributeName + '.childType = "Modi.' + elementType + '";\n')
                        else:
                            packageToAdd = self.package
                            if self.package != "":
                                packageToAdd += "."
                            self.write("\t\t\t_" + attributeName + '.childType = "' + packageToAdd + elementType + '";\n')
        self.write("\t\t}\n\n")

    def writeGettersAndSetters(self):
        for attributeName in self.classData:
            if attributeName != "super":
                attributeData = self.classData[attributeName]
                attributeType = attributeData
                if "Managed" in attributeData:
                    attributeType = getModiClass(attributeType)
                elif type(attributeData) == dict:
                    if "type" in attributeData:
                        attributeType = attributeData["type"]
                    else:
                        attributeType = "String"

                self.write("\t\tpublic final function set " + attributeName + "(" + attributeName + ":" + attributeType + "):void\n\t\t{\n")
                self.write("\t\t\tif (!this.allowChange(ATTRIBUTE_" + toUppercaseWithUnderscores(attributeName) + ", _" + attributeName + ", " + attributeName + "))\n")
                self.write("\t\t\t{\n\t\t\t\treturn;\n\t\t\t}\n\n\t\t\t")
                self.write("this.willChange(ATTRIBUTE_" + toUppercaseWithUnderscores(attributeName) + ", _" + attributeName + ", " + attributeName + ");\n\n\t\t\t")
                self.write("var oldValue:" + attributeType + " = _" + attributeName + ";\n\n\t\t\t")
                self.write("_" + attributeName + " = " + attributeName + ";\n\n\t\t\t")
                self.write("this.wasChanged(ATTRIBUTE_" + toUppercaseWithUnderscores(attributeName) + ", oldValue, _" + attributeName + ");\n\t\t}\n\n")
                
                self.write("\t\tpublic final function get " + attributeName + "():" + attributeType + "\n\t\t{\n\t\t\t")
                self.write("return _" + attributeName + ";\n\t\t}\n\n")
                
                self.write("\t\tpublic final function set " + attributeName.capitalize() + "DirectUnsafe("+ attributeName + ":" + attributeType)
                self.write("):void\n\t\t{\n\t\t\t_" + attributeName + " = " + attributeName + ";\n\t\t}\n\n")
        self.write("\t}\n}")

# Converts attribute name to uppercase with underscores between words.
def toUppercaseWithUnderscores(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).upper()

# TODO: Rewrite this function using regular expressions.
def getManagedArrayElementType(str):
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

# TODO: Rewrite this function using regular expressions.
def getModiClass(str):
    modiClass = ""
    counts = True

    for char in str:
        if char == "<":
            counts = False
        if counts:
            modiClass += char

    return modiClass;

# Returns True if className is one of the Modi classes, false otherwise.
def isModiClass(className):
    modiClasses = ["ManagedArray", "ManagedValue", "ManagedPoint"]
    for modiClass in modiClasses:
        if modiClass == className:
            return True
    return False