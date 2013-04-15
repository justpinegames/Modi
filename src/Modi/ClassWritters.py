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

        self.write("package " + self.package + "\n{\n    public class " + self.className + " extends _" + self.className + "\n    {\n")
        self.write("\n        public function " + self.className + "()\n        {\n")
        self.write("\n        }\n\n    }\n\n}")

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
        self.write("    import Modi.*;\n\n")
        self.write("    import flash.utils.Dictionary;\n")
        
        # User can specify his own imports.
        if "imports" in self.classData:
            self.write("\n")

            imports = self.classData["imports"]
            for userImport in imports:
                self.write("    import " + userImport + ";\n")

        superClass = "ManagedObject"
        if "super" in self.classData:
            superClass = self.classData["super"]
        self.write("\n    public class _" + self.className + " extends " + superClass + "\n    {\n")

    def writeAttributeNamesInArray(self):
        self.write("        public static const ATTRIBUTES:Array = [");
        for attributeName in self.classData:
            if not isReservedWord(attributeName):
                self.write("\"" + attributeName + "\", ")
        self.write("];\n");

    def writeAttributeTypes(self):
        self.write("        public static const ATTRIBUTE_TYPES:Array = [");
        for attributeName in self.classData:
            if not isReservedWord(attributeName):
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
            if not isReservedWord(attributeName):
                self.write("        public static const ATTRIBUTE_" + toUppercaseWithUnderscores(attributeName) + ":String = \"" + attributeName + "\";\n")
        self.write("\n")

    def writeEnumValues(self):
        for attributeName in self.classData:
            attributeData = self.classData[attributeName]
            if type(attributeData) == dict and "values" in attributeData:
                enum = attributeData["values"]
                enumValues = ""
                for value in enum:
                    self.write("        public static const " + toUppercaseWithUnderscores(attributeName) + "_" + toUppercaseWithUnderscores(str(value)) + ":String = \"" + str(value) + "\";\n")
                    enumValues += "\"" + value + "\", "
                self.write("        public static const " + toUppercaseWithUnderscores(attributeName) + "_ENUM_ARRAY:Array = [" + enumValues + "];\n\n");

    def writeAttributes(self):
        for attributeName in self.classData:
            if not isReservedWord(attributeName):
                attributeData = self.classData[attributeName]
                attributeType = attributeData
                if "Managed" in attributeData:
                    attributeType = getModiClass(attributeData)
                elif type(attributeData) == dict:
                    if "type" in attributeData:
                        attributeType = attributeData["type"]
                    else:
                        attributeType = "String"
                self.write("        private var _" + attributeName + ":" + attributeType + ";\n")

    def writeConstructor(self):
        self.write("\n        public function _" + self.className + "()\n        {\n")
        self.write("            this.registerAttributes(ATTRIBUTES, ATTRIBUTE_TYPES);\n")
        self.write("\n")
        
        for attributeName in self.classData:
            attributeData = self.classData[attributeName]
            if type(attributeData) == dict:
                if "default" in attributeData:
                    if "values" in attributeData:
                        self.write("            _" + attributeName + " = " + toUppercaseWithUnderscores(attributeName) + "_" + toUppercaseWithUnderscores((attributeData["default"])) + ";\n")
                    elif "type" in attributeData:
                        if attributeData["type"] == "String":
                            self.write("            _" + attributeName + " = \"" + str(attributeData["default"]) + "\";\n")
                        elif attributeData["type"] == "ManagedValue":
                            self.write("            _" + attributeName + " = new ManagedValue(" + str(attributeData["default"]) + ");\n")
                        elif attributeData["type"] == "Boolean":
                            self.write("            _" + attributeName + " = " + str(attributeData["default"]).lower() + ";\n")
                        else:
                            self.write("            _" + attributeName + " = " + str(attributeData["default"]) + ";\n")
            elif attributeData == "Array":
                self.write("            _" + attributeName + " = [];\n")

        self.write("\n")

        for attributeName in self.classData:
            attributeData = self.classData[attributeName]
            if "Managed" in attributeData and not isReservedWord(attributeName):
                modiClass = getModiClass(attributeData)

                if modiClass == "ManagedObjectId":
                    self.write("            _" + attributeName + " = ManagedObjectId.UNDEFINED;\n")
                else:
                    self.write("            _" + attributeName + " = new " + modiClass + "();\n")

                if modiClass == "ManagedArray":
                    elementType = getManagedArrayElementType(attributeData)
                    if elementType != "ManagedObject":
                        if isModiClass(elementType):
                            self.write("            _" + attributeName + '.childType = "Modi.' + elementType + '";\n')
                        else:
                            childType = ""

                            # User can specify his own package.
                            if elementType.find(".") != -1:
                                childType = elementType
                            # If no package is specified, package that was given as parameter to the script will be used.
                            else:
                                # If there is some package, dot must be appended before class name.
                                if self.package != "":
                                    childType = self.package + "." + elementType
                                else:
                                    childType = elementType

                            self.write("            _" + attributeName + '.childType = "' + childType + '";\n')
        self.write("        }\n\n")

    def writeGettersAndSetters(self):
        for attributeName in self.classData:
            if not isReservedWord(attributeName):
                attributeData = self.classData[attributeName]
                attributeType = attributeData
                if "Managed" in attributeData:
                    attributeType = getModiClass(attributeType)
                elif type(attributeData) == dict:
                    if "type" in attributeData:
                        attributeType = attributeData["type"]
                    else:
                        attributeType = "String"

                self.write("        public final function set " + attributeName + "(" + attributeName + ":" + attributeType + "):void\n        {\n")
                self.write("            if (!this.allowChange(ATTRIBUTE_" + toUppercaseWithUnderscores(attributeName) + ", _" + attributeName + ", " + attributeName + "))\n")
                self.write("            {\n                return;\n            }\n\n            ")
                self.write("this.willChange(ATTRIBUTE_" + toUppercaseWithUnderscores(attributeName) + ", _" + attributeName + ", " + attributeName + ");\n\n            ")
                self.write("var oldValue:" + attributeType + " = _" + attributeName + ";\n\n            ")
                self.write("_" + attributeName + " = " + attributeName + ";\n\n            ")
                self.write("this.wasChanged(ATTRIBUTE_" + toUppercaseWithUnderscores(attributeName) + ", oldValue, _" + attributeName + ");\n        }\n\n")
                
                self.write("        public final function get " + attributeName + "():" + attributeType + "\n        {\n            ")
                self.write("return _" + attributeName + ";\n        }\n\n")
                
                self.write("        public final function set " + attributeName.capitalize() + "DirectUnsafe("+ attributeName + ":" + attributeType)
                self.write("):void\n        {\n            _" + attributeName + " = " + attributeName + ";\n        }\n\n")
        self.write("    }\n}")

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
    modiClasses = ["ManagedArray", "ManagedValue", "ManagedPoint", "ManagedObjectId"]
    for modiClass in modiClasses:
        if modiClass == className:
            return True
    return False

def isReservedWord(word):
    reservedWords = ["super", "imports"]
    for reservedWord in reservedWords:
        if reservedWord == word:
            return True
    return False
