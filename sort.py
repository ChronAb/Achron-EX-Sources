
elementSort = {
        'AIScripts': {'tag':'Name','prefix':'Script'},
        'Sounds': {'tag':'Name','prefix':'Sound'},
        'EffectsResources': {'tag':'Name','prefix':''},
        'GlobalGameResources': {'tag':'Name','prefix':''},
        'TimelineStatistics': {'tag':'Name','prefix':''},
        'ActionStepModifiers': {'tag':'Name','prefix':''},
        'ObjectClasses': {'tag':'Name','prefix':''},
        #'UnitLists': '', # Ignore Unit lists for now
}

def strip_prefix(text, prefix):
    if text.startswith(prefix):
        return text[len(prefix):]
    return text

def key(e, tag, prefix):
    if len(prefix) > 0:
        node = e.find(tag) 
        if node is None:
            return 0
        v = node.text
        if v is None:
            return 0
        v = strip_prefix(v, prefix)
        return int(v)
    else:
        node = e.find(tag) 
        if node is None:
            return ''
        v = node.text
        if v is None:
            return ''
        return v

def sortTree(tree):
    for element, info in elementSort.items():
        elements = tree.find(element)
        if elements is not None:
            elements[:] = sorted(elements, key=lambda e: key(e, info['tag'], info['prefix']))



