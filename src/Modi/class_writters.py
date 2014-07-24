#!/usr/bin/python

# This is free software; you can redistribute it and/or modify it under the
# terms of MIT free software license as published by the Massachusetts
# Institute of Technology.
#
# Copyright 2014. Pine Studio

import types
import re
from jinja2 import Template


human_template = """package {{package}}
{
    public class {{class_name}} extends _{{class_name}}
    {
        public function {{class_name}}()
        {

        }
    }
}
"""

class HumanClassWritter:
    _file = None
    _package = ""
    _class_name = ""
    _verbose = False

    def __init__(self, file, package, class_name, verbose):
        self._file = file
        self._package = package
        self._class_name = class_name
        self._verbose = verbose

    def close_file(self):
        self._file.close()

    def write_class(self):

        template = Template(human_template, trim_blocks=True, lstrip_blocks=True)
        render = template.render({"package": self._package, "class_name": self._class_name})

        if (self._verbose):
            print "------------------------------------------------------------"
            print "Writing human class: " + self._class_name + "\n"
            print render

        self._file.write(render)


machine_template = """package {{package}}
{
    import Modi.*;
    {% for path in imports %}
    import {{path}};
    {% endfor %}

    public class _{{class_name}} extends {{super_class_name}}
    {
        public static const ATTRIBUTES:Array = [{% for a in attributes %}"{{a.name}}",{% endfor %}];
        public static const ATTRIBUTE_TYPES:Array = [{% for a in attributes %}"{{a.type}}",{% endfor %}];

        {% for a in attributes %}
        public static const ATTRIBUTE_{{a.uname}}:String = "{{a.name}}";
        {% endfor %}

        {% for a in attributes %}
            {% if a.values_|length > 0 %}
                {% for value in a.values_ %}
        public static const {{a.uname}}_{{value.upper()}}:String = "{{value}}";
                {% endfor %}
        public static const {{a.uname}}_ENUM_ARRAY:Array = [{% for value in a.values_ %}{{a.uname}}_{{value.upper()}}, {% endfor %}];
            {% endif %}
        {% endfor %}

        {% for a in attributes %}
        private var _{{a.name}}:{{a.type}};
        {% endfor %}

        public function _{{class_name}}()
        {
            registerAttributes(ATTRIBUTES, ATTRIBUTE_TYPES);

            {% for a in attributes %}
                {% if a.default_value %}
            _{{a.name}} = {{a.default_value}};
                {% endif %}
                {% if a.child_type %}
            _{{a.name}}.childType = "{{a.child_type}}";
                {% endif %}
            {% endfor %}
        }
        {% for a in attributes %}

        public final function set {{a.name}}(value:{{a.type}}):void { dispatchChangeEvent(ATTRIBUTE_{{a.uname}}, _{{a.name}}, _{{a.name}} = value); }
        public final function set {{a.name}}DirectUnsafe(value:{{a.type}}):void { _{{a.name}} = value; }
        public final function get {{a.name}}():{{a.type}} { return _{{a.name}}; }
        {% endfor %}
    }
}
"""


class MachineClassWritter:
    _file = None
    _package = ""
    _class_name = ""
    _class_data = ""
    _verbose = False

    def __init__(self, file, package, class_name, class_data, verbose):
        self._file = file
        self._package = package
        self._class_name = class_name
        self._class_data = class_data
        self._verbose = verbose

    def close_file(self):
        self._file.close()

    def write_class(self):
        imports = []
        if "imports" in self._class_data:
            imports_data = self._class_data["imports"]
            for import_path in imports_data:
                imports.append(import_path)

        super_class = "ManagedObject"
        if "super" in self._class_data:
            super_class = self._class_data["super"]

        ########################################################################

        attributes = []
        for name in self._class_data:
            if is_reserved_word(name):
                continue

            uname = to_uppercase_with_underscores(name)
            data = self._class_data[name]
            type_ = data
            values = []
            default_value = None
            child_type = None

            if "Managed" in data:
                type_ = get_modi_class(data)

                if type_ == "ManagedObjectId":
                    default_value = "ManagedObjectId.UNDEFINED"
                else:
                    default_value = "new " + type_ + "()"

                if type_ == "ManagedArray":
                    element_type = get_managed_array_element_type(data)
                    if element_type != "ManagedObject":
                        if is_modi_class(element_type):
                            child_type = "Modi." + element_type
                        else:
                            # User can specify his own package.
                            if element_type.find(".") != -1:
                                child_type = element_type
                            # If no package is specified, package that was given as parameter to the script will be used.
                            else:
                                # If there is some package, dot must be appended before class name.
                                if self._package != "":
                                    child_type = self._package + "." + element_type
                                else:
                                    child_type = element_type
            elif type(data) == dict:
                if "type" in data:
                    type_ = data["type"]
                else:
                    type_ = "String"

                if "default" in data:
                    defaultValue = data["default"]
                    if "values" in data:
                        default_value = uname + "_" + defaultValue.upper()
                    elif "type" in data:
                        if data["type"] == "String":
                            default_value = "\"" + str(defaultValue) + "\""
                        elif data["type"] == "ManagedValue":
                            default_value = "new ManagedValue(" + str(defaultValue) + ")"
                        elif data["type"] == "Boolean":
                            default_value = str(defaultValue.lower())
                        else:
                            default_value = str(defaultValue)

                if "values" in data:
                    for value in data["values"]:
                        values.append(value)
            elif data == "Array":
                # Array value.
                default_value = "[]"

            hash = {"name": name, "uname": uname, "type": type_, "values_": values}

            if default_value is not None:
                hash["default_value"] = default_value

            if child_type is not None:
                hash["child_type"] = child_type

            attributes.append(hash)

        ########################################################################

        template = Template(machine_template, trim_blocks=True, lstrip_blocks=True)
        render = template.render({
            "package": self._package, "imports": imports,
            "class_name": self._class_name, "super_class_name": super_class,
            "attributes": attributes})

        if self._verbose:
            print "------------------------------------------------------------"
            print "Writing machine class: _" + self._class_name + "\n"
            print render

        self._file.write(render)


# Converts attribute name to uppercase with underscores between words.
def to_uppercase_with_underscores(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).upper()


# TODO: Rewrite this function using regular expressions.
def get_managed_array_element_type(str):
    child_type = "ManagedObject"
    counts = False

    for char in str:
        if char == ">":
            counts = False
        if counts:
            child_type += char
        if char == "<":
            child_type = ""
            counts = True
    return child_type;


# TODO: Rewrite this function using regular expressions.
def get_modi_class(str):
    modi_class = ""
    counts = True

    for char in str:
        if char == "<":
            counts = False
        if counts:
            modi_class += char

    return modi_class;


# Returns True if className is one of the Modi classes, false otherwise.
def is_modi_class(className):
    modi_classes = ["ManagedArray", "ManagedValue", "ManagedPoint", "ManagedObjectId"]
    for modi_class in modi_classes:
        if modi_class == className:
            return True
    return False


def is_reserved_word(word):
    reserved_words = ["super", "imports"]
    for reserved_word in reserved_words:
        if reserved_word == word:
            return True
    return False
