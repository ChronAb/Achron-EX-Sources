# Achron-EX-Sources
Achron, EX mod, Source files


These are the guts of the Achron, EX Mod; pulled out and rearranged into a format that makes them slightly more intuitive for a subpar modder (namely me, Chron) to navigate. Hopefully it will make sense to other people too. All the Grekim stuff is in the Grekim folder, all the Human stuff is in the human folder. Stuff that both Grekim and Humans use is mostly in the Common folder... mostly….

**Incidentally... it seems like Github does not like when I try to bring in a folder with hundreds of files in it, so for now I will post them as zip files >> until someone explains to me the proper wway to handle such things.

Within each folder, each of the important units gets its own little xml notebook where most of the magic happens. There’s also a sub folder for ais… and models… and structures’ xmls, because the top folder was too crowded. Hopefully that makes sense.

If you want to make changes and test them live, you’ll need to paste the xml bits back into the Achron.ocs.xml file and the ais bits into the ais_src folder, then recompile. Sorry it’s so inefficient, but I fear I have a strong allergy to professionalism.

There are a few other source documents in addition to these that I shall refrain from posting until someone can present a good case for needing them. E.g. a folder for Vecgir, a folder for a 4th race, and a lot of half arsed, outdated design documentation. I do this because I think without proper context they would cause much more confusion than they would resolve.


So if you want to contribute... What can you do to help:
1. Take a look at the mod in action, make sure you have the sense of what it is trying to accomplish. (Focus on Grekim first, as they are the model I’m trying to work to with CESO.)
2. Start with the low hanging fruit.
3. Tell me what information or resources you need, if you can’t find it in here. I have a feeling I am forgetting some stuff in this repository.
4. Stop making excuses and get to work.
5. Have Fun

What is Achron EX’s “low hanging fruit?”
Same as anything else, but it’s worth repeating: start with small and easy tasks before moving on to big ones.  You’re less likely to waste your time or get frustrated that way. In EX’s case, I’d suggest the following heuristics:
1. Start with Grekim. They are closer to being done, so what’s left to do is smaller and simpler.
2. xml before ais. Even though it’s like looking at a pile of word vomit, the tasks that can be done in xml are mostly A LOT simpler than the stuff requiring resequence.
3. UI before game logic. Basically, the scariest part of any unit’s xml script is its actions list. That’s especially true since I started messing around with them. Adding or removing control shortcuts, objective tooltips, animation rules, unit properties, tags, descriptions… all much easier.
4. Easiest bit of game logic is resource costs. Changing the prices and of things is relatively simple… usually.
5. Forget about balance until after balance discussion. The mod’s unbalanced and will remain so until everything else is done. This is a fact of life.

With that in mind here are some ideas of things people could help out with. It is ordered for easiest to hardest and I’ll try to keep it updated as things develop:
* Make sure all the units’ Move and Attack tooltips match the standard format. (Take a look at how Octo, Sepi, Pharo, Octopod, and Sepipod do things as a model.) Basically Move describes move speed and vision/visibility properties; Attack explains attack pattern and stats.
* Make sure every unit and structure has ACTION_HEAL_NANITE as Action 55, and set to trigger when it has >= Full HP-10
* Make sure every unit and structure has an ACTION_LOW_HP_DIE, usually as Action 41, and set to trigger when it has <= 0.3 x Full HP
* Remove all the hierarchy control systems from every unit, by commenting out the associated ControlShortcut entries. (See Octo, Sepi, Pharo.)
* Update unit description tooltips. The description should explain what role the unit serves and describe any abilities not conveyed by the control bar tooltips.
* Make sure everything dies with proper wreckage behaviors. Almost every structure and vehicle should leave a wreck or have some sort of damage-causing death behavior. In particular there should be no randomization to when and whether a wreck will cause collateral damage. (This was an old feature that needs to be removed.)
* Update Vecgir RPs so they Mine QP and make power like Grekim and Human RPs. (This would be the first step to getting Vecgir back to playable.)
