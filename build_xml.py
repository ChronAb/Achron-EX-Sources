#!/usr/bin/python

'''
build_xml.py is a script to reconstruct the Achron.ocs.xml file from all the source files in this repo.

The sources files are organized by race/unit/concept, this aides makeing changes as it provides some organization to the sources,
making it eaiser to find and make approapirate edits.

However these files to need to be combined into a single large file Achron.ocs.xml that can be compiled by the game moding tools.

Therefore each source XML file can contain the 8 toplevel elements:

    AIScripts
    Sounds
    EffectsResources
    GlobalGameResources
    TimelineStatistics
    UnitLists
    ActionStepModifiers
    ObjectClasses

The subelements from each source file will be combined into the single Achron.ocs.xml.
'''

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

# For now each source file must be listed here
# Evenatually we can use glob */*.xml to find all the XML files,
# but this explicit list makes development easier for now as not all files are safe XML yet.
filenames = [
#   'Grekim/Achrons Grekim.xml',
   'Grekim/Cuttle.xml',
   'Grekim/Gargantuan.xml',
   'Grekim/Ghost.xml',
   'Grekim/Octoligo Angry.xml',
   'Grekim/Octoligo Weapons.xml',
   'Grekim/Octoligo.xml',
   'Grekim/Octopod.xml',
   'Grekim/Octo.xml',
   'Grekim/Pharoligo.xml',
   'Grekim/Pharopod.xml',
   'Grekim/Pharo.xml',
   'Grekim/Primordial.xml',
   'Grekim/Sepiligo.xml',
   'Grekim/Sepipod.xml',
   'Grekim/Sepi.xml',
#   'Grekim/xOcto 120.xml',
#   'Grekim/xOcto 180.xml',
#   'Grekim/xOctoligo.xml',
#   'Grekim/xOctopod.xml',
#   'Grekim/xPharo.xml',
#   'Grekim/xSepi.xml',
]


# Parse each file and append its top level elements to the achon tree.
for f in filenames:
    dom = etree.parse(f, parser).getroot()
    for element, root in elementRoots.items():
        parent = dom.find(element)
        if parent is not None:
            for child in parent:
                root.append(child)

# Write out the Achron.ocs.xml file
with open('Achron.ocs.xml', 'wb') as f:
    etree.ElementTree(achron).write(f, pretty_print=True, encoding="UTF-8", xml_declaration=True)
