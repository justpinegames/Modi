#!/usr/bin/python

import sys
import yaml
import os
import types


def isNumeric(value):
    numericTypes = ["int", "float", "long", "complex"]
    for numericType in numericTypes:
        if type(value) == eval(numericType):
            return True
    return False

test = "dsadsad " + str(10)
print test



