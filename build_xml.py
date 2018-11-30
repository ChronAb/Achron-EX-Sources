#!/usr/bin/python

from lxml import etree

parser = etree.XMLParser(remove_blank_text=True)
achron = etree.XML('''<?xml version="1.0" ?>
<ResequenceObjectClassSet>
    <AIScripts></AIScripts>
    <Sounds></Sounds>
    <EffectsResources></EffectsResources>
    <GlobalGameResources></GlobalGameResources>
    <TimelineStatistics></TimelineStatistics>
    <UnitLists></UnitLists>
    <ActionStepModifiers></ActionStepModifiers>
    <ObjectClasses></ObjectClasses>
</ResequenceObjectClassSet>''', parser=parser)

elementRoots = {}
for child in achron:
    elementRoots[child.tag] = child

filenames = [
#   'Grekim/Achrons Grekim.xml',
   'Grekim/Cuttle.xml',
#   'Grekim/Gargantuan.xml',
#   'Grekim/Ghost.xml',
#   'Grekim/Octoligo Angry.xml',
#   'Grekim/Octoligo Weapons.xml',
#   'Grekim/Octoligo.xml',
#   'Grekim/Octopod.xml',
#   'Grekim/Octo.xml',
#   'Grekim/Pharoligo.xml',
#   'Grekim/Pharopod.xml',
#   'Grekim/Pharo.xml',
#   'Grekim/Primordial.xml',
#   'Grekim/Sepiligo.xml',
#   'Grekim/Sepipod.xml',
#   'Grekim/Sepi.xml',
#   'Grekim/xOcto 120.xml',
#   'Grekim/xOcto 180.xml',
#   'Grekim/xOctoligo.xml',
#   'Grekim/xOctopod.xml',
#   'Grekim/xPharo.xml',
#   'Grekim/xSepi.xml',
]


for f in filenames:
    dom = etree.parse(f, parser).getroot()
    for element, root in elementRoots.items():
        parent = dom.find(element)
        if parent is not None:
            for child in parent:
                root.append(child)

with open('Achron.ocs.xml', 'wb') as f:
    etree.ElementTree(achron).write(f, pretty_print=True, encoding="UTF-8", xml_declaration=True)
