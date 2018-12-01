#!/usr/bin/python

from lxml import etree
import sys

usage = '''
fmtxml.py <filepath ...>

Reads an xml file and pretty prints it back into the file.
If the xml file is not valid xml an exception is thrown.

'''

parser = etree.XMLParser(remove_blank_text=True)

if len(sys.argv) < 2:
    print(usage)
    exit(1)

for filename in sys.argv[1:]:
    with open(filename, 'r') as f:
        try:
            dom = etree.parse(f,parser)
        except etree.XMLSyntaxError as e:
            sys.stderr.write("error parsing file {}: {}\n".format(filename, e))
            continue

    with open(filename, 'wb') as f:
        dom.write(f, pretty_print=True, encoding="UTF-8", xml_declaration=True)
