#!/usr/bin/env python

# This is free software; you can redistribute it and/or modify it under the
# terms of MIT free software license as published by the Massachusetts
# Institute of Technology.
#
# Copyright 2014. Pine Studio


import os
import sys
import getopt
import yaml

from class_writters import HumanClassWritter
from class_writters import MachineClassWritter

VERBOSE = False
VERSION = "1.0.1"


def main(argv):
    # If the user does not specify any argument, call print_help to show
    # him how to call the script properly.
    if len(argv) == 0:
        print_help()
        exit()

    # Retrieve the options and arguments from the user input from the command line.
    try:
        opts, args = getopt.gnu_getopt(
            argv, "o:p:hvVO:P:H",
            ["output=", "package=", "help", "version", "verbose"])
    except getopt.GetoptError:
        # If the error occurred while reading the arguments, printhelp will
        # be called and the script will terminate.
        print_help()
        exit()

    # Any argument that is not preceded by a flag is considered as a model.
    model_files = args
    if len(model_files) == 0:
        print_help()
        exit()        

    package = ""
    output_directory = "."

    # Check for any additional options that the user may have specified.
    for opt, arg in opts:
        if opt in ("-h", "-H", "--help"):
            print_help()
        elif opt in ("-o", "-O", "--output"):
            output_directory = arg
        elif opt in ("-p", "-P", "--package"):
            package = arg
        elif opt in ("-V", "--verbose"):
            global VERBOSE
            VERBOSE = True
        elif opt in ("-v", "--version"):
            print_version()

    package_directory = package.replace(".", "/")
    classes_directory = os.path.abspath(output_directory + "/" + package_directory)
    create_directory(classes_directory)

    for model in model_files:
        model_directory = os.path.abspath(model)
        generate_classes_from_model(model_directory, classes_directory, package)


def generate_classes_from_model(model, directory, package):
    try:
        stream = open(model, 'r')
        yaml_data = yaml.load_all(stream)

        for classes_data in yaml_data:
            for class_name in classes_data:
                create_machine_class(
                    directory, package, class_name, classes_data[class_name])
                create_human_class(directory, package, class_name)
    except yaml.YAMLError, exc:
        if hasattr(exc, 'problem_mark'):
            mark = exc.problem_mark
            print "Error in YAML file: %s (Line %s, Column %s)" % (model, mark.line + 1, mark.column + 1)
        exit()
    except IOError as e:
        print "I/O error({0}): {1}".format(e.errno, e.strerror)
        exit()


def create_human_class(directory, package, class_name):
    class_path = directory + "/" + class_name + ".as"
    
    # If the user already generated this human class before, script must NOT override it.
    if not os.path.exists(class_path):
        try:
            human_class_writter = HumanClassWritter(
                open(class_path, "w"), package, class_name, VERBOSE)
            human_class_writter.write_class()
        except IOError:
            print "I/O error({0}): {1}".format(e.errno, e.strerror)
            exit()
        finally:
            human_class_writter.close_file()
            human_class_writter = None


def create_machine_class(directory, package, class_name, class_data):
    class_path = directory + "/_" + class_name + ".as"    

    try:
        machine_class_writter = MachineClassWritter(
            open(class_path, "w"), package, class_name, class_data, VERBOSE)
        machine_class_writter.write_class()
    except IOError:
        print "I/O error({0}): {1}".format(e.errno, e.strerror)
        exit()
    finally:
        machine_class_writter.close_file()
        machine_class_writter = None


def create_directory(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)    


def print_help():
    print "\nScript options:\n"
    print "\t-o, -O, --output"
    print "\t\tDirectory where the class files will be saved."
    print "\t\tThe script will automatically create folders for"
    print "\t\tthese classes if they do not already exist."
    print "\t\tThe script supports both '\\' and '/' as a separator."
    print "\t\tThe output directory does not include package"
    print "\t\tdirectory. Package directory is specified separately"
    print "\t\tusing the --package option.\n"
    print "\t-p, -P, --package"
    print "\t\tPackage that will be included in the class."
    print "\t\tThe script will automatically create folders for"
    print "\t\tthese packages if they do not already exist."
    print "\t\tPackages should be written in the same way as they are"
    print "\t\tin the code, where each package directory is separated"
    print "\t\tby a period.\n"
    print "\t-V, --verbose"
    print "\t\tShow all created classes in the console.\n"
    print "\t-v, --version"
    print "\t\tShow the current version of Modi.\n"
    print "\t-h, -H, --help"
    print "\t\tShow a short usage summary.\n"
    print "Example of use:"
    print "Modi.py Game.yaml Player.yaml -o C:\Projects\Game -p models.game"
    print "            ^          ^                ^                 ^"
    print "         model 1    model 2      output directory   package directory"
    print "\nYou can specify any number of models. Each argument that is not "
    print "preceded by an option is considered as a model. This concrete call "
    print "will create classes for all models in directory 'C:\Projects\Game\models\game'."
    print "Each class will include package 'models.game' on top of it."


def print_version():
    print "Modi version: " + VERSION


if __name__ == "__main__":
    main(sys.argv[1:])

