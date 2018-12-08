#!/usr/bin/python

from lxml import etree
import sys
from sort import sortTree

usage = '''
fmtxml.py <filepath ...>

Reads an xml file and pretty prints it back into the file.
If the xml file is not valid xml an exception is thrown.
The toplevel XML elements are sorted for easy diffing.

'''


if len(sys.argv) < 2:
    print(usage)
    exit(1)

parser = etree.XMLParser(remove_blank_text=True)
for filename in sys.argv[1:]:
    with open(filename, 'r') as f:
        try:
            tree = etree.parse(f,parser)
        except etree.XMLSyntaxError as e:
            sys.stderr.write("error parsing file {}: {}\n".format(filename, e))
            continue

    sortTree(tree)

    # Remove any tail whitespace
    for element in tree.iter():
        element.tail = None

    with open(filename, 'wb') as f:
        tree.write(f, pretty_print=True, encoding="UTF-8", xml_declaration=True)
