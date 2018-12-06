
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



