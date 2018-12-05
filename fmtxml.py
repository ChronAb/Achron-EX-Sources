#!/usr/bin/python

from lxml import etree
import sys

usage = '''
fmtxml.py <filepath ...>

Reads an xml file and pretty prints it back into the file.
If the xml file is not valid xml an exception is thrown.
The toplevel XML elements are sorted for easy diffing.

'''


if len(sys.argv) < 2:
    print(usage)
    exit(1)

elementSort = {
        'AIScripts': 'Name',
        'Sound': 'Name',
        'EffectsResources': 'Name',
        'GlobalGameResources': 'Name',
        'TimelineStatistics': 'Name',
        #'UnitLists': '', # Ignore Unit lists for now
        'ActionStepModifiers': 'Name',
        'ObjectClasses': 'Name',
}

def key(e, sortKey):
    node = e.find(sortKey) 
    if node is None:
        return ''
    v = node.text
    if v is None:
        return ''
    return v

def sortTree(tree):
    for element, sortKey in elementSort.items():
        elements = tree.find(element)
        if elements is not None:
            elements[:] = sorted(elements, key=lambda e: key(e, sortKey))



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
