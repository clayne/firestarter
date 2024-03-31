# Firestarter

Firestarter is a Skyrim mod for wilderness campers who'd like to take advantage of the many campfires and campsites in the world. Light, stoke, and then cook on any campfire you find in Skyrim.

It uses [Base Object Swapper](https://www.nexusmods.com/skyrimspecialedition/mods/60805) to replace every campfire in the game with one that can be dynamically lit and extinguished. 100% Campfire compatible.

It is in the implementation phase.

## TODO

- [ ] particles, flame effects, glow effects, and smoke: tune to lifecycle
- [ ] texturing for the unburned log meshes
- [x] Dynamic Activation Key perk
- [x] hook up DAK to trigger cooking on burning fires (or the reverse?)
- [ ] integrate with Campfire mod instead of merely co-existing with it
- [x] play animations for actions if we have them
- [x] translation files
- [ ] extinguish action to get back firewood?
- [ ] settings to control level of "immersion" plus MCM

## What the mod does

Firestarter defines 7 activators with different NIF models. Each activator corresponds with a specific point in a campfire lifecycle:

1. clean: a bare circle of stones
2. fueled: there are logs in the circle, ready to burn
3. kindled: a flame is starting
4. burning: a fire the player can cook on and sleep next to is burning
5. roaring: the player has added more fuel to a burning fire, and is warm even in the coldest night
6. dying: the fuel is running out
7. ashes: there might be some residual warmth, but the player cannot cook any more

A base object swapper config swaps out all in-game campfires with either the _burning_ activator or the _fueled_ activator, if the fire is not burning.

When the player approaches a campfire, they see the E activator. Pressing E does the contextually-chosen next action for the fire: it adds fuel to burning fires, cleans out ashes from dead fires, adds wood to empty campfires, and kindles unlit fires. If the player hold down their Dynamic Activation Key, they see a "Cook" prompt when the fire is hot enough.

If the player has the optional ["Campfire Animations"](https://www.nexusmods.com/skyrimspecialedition/mods/112322) mod installed, they'll see some cooking and other animations.

## Touchpoints

The keyword `FS_Cooking_Capable` is present on activator states that are hot enough to cook with.

The modified Campfire Animations script looks for te keywords `Camping_CampfireCookingShared` or `CraftingCampfire` on furniture to consider if it wants to trigger an animation.

TODO: Campfire mod integrations.

## LICENSE

My intention is to license this mod as free for open source and open for any modifications you wish to make. I do not want to constrain your licensing choices for your plugin beyond requiring that you also open-source it in some way that allows other people to learn from it. So to that end, I am using [The Parity Public License.](https://paritylicense.com) This license requires people who build on top of this source code to share their work with the community, too. In Skyrim modding language, this license allows "cathedral" modding, not "parlor" modding. Please see the text of the license for details.
