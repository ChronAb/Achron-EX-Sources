#!/usr/bin/python
from lxml import etree
import sys

usage = '''
fixup.py <filepath ...>

Updates the specified xml file by wrapping known elements in their parent element.
Unknown elements are preserved.

'''

if len(sys.argv) < 2:
    sys.stderr.write(usage)
    exit(1)

elementParents = {
        'AIScript': 'AIScripts',
        'Sound': 'Sounds',
        'EffectsResource': 'EffectsResources',
        'GlobalGameResource': 'GlobalGameResources',
        'TimelineStatistic': 'TimelineStatistics',
        'UnitList': 'UnitLists',
        'ActionStepModifier': 'ActionStepModifiers',
        'ObjectClass': 'ObjectClasses',
}


parser = etree.XMLParser(remove_blank_text=True)

for filename in sys.argv[1:]:
    with open(filename, 'r') as f:
        tree = etree.parse(f, parser)
    dom = tree.getroot()
    elementRoots = {}
    for k, v in elementParents.items():
        root = dom.find(v)
        if root is None:
            root = etree.Element(v)
            dom.append(root)
        elementRoots[v] = root
    for child in dom:
        if child.tag in elementParents:
            root = elementRoots[elementParents[child.tag]]
            dom.remove(child)
            root.append(child)
        # else ignore

    with open(filename, 'wb') as f:
        tree.write(f, pretty_print=True, encoding="UTF-8", xml_declaration=True)

