## Design notes

These are the original design notes I wrote when I had the idea.

---

Any campfire in the game can be interacted with. The moment you interact with a _lit_ campfire, it comes under management by this mod and its burn timer starts. These campfires are otherwise untouched. (The alternative to this approach is to replace every campfire in the game with an unlit one, unless NPCs are present, and I don't want to figure that one out.)

You must have a flint and a metal knife in your inventory to light fires. Knowing any fire spell also meets this requirement, Campfire-style. Lighting a campfire that has no wood in it require at least three pieces of firewood in addition to the flint. Flint is distributed to containers and NPCs so it should be fairly easy to find.

If going for high-immersion survival mode design, the realism level of lighting a fire can be cranked up via a few options.

- Consider making flint a ferrocerium-style consumable that only lasts for a fixed number of uses. (Flint IRL is not the consumable; the metal is. But the metal lasts a long long time. Ferrocerium does not last long, though.)
- Make it require a few strikes to get going, more if the knife is not steel.
- Consider _requiring_ a steel object! Iron knives are more friendly to the early game, but also completely unrealistic because it's the carbon that matters. (The game doesn't have high-carbon steel, which is what you want in real life.)
- Consider a middle-game item called a fire striker that works instantly.

Campfires have the following states, each of which is expressed with a distinct mesh:

- _Dead, with burned wood and ashes_: No warmth. Activation cleans out the campfire.
- _Unlit, empty and clean:_ No warmth. Activation requires 3 firewood in inventory.
- _Unlit, with fresh logs:_ No warmth. Activation requires flint/steel or fire spell equipped. (Or maybe just known.)
- _Freshly-started:_ Some warmth. Activation would extinguish the fire. Moves to "dying" state via timer.
- _Burning:_ Warmth. Activation allows adding 2 logs, crafting, sleeping, extinguishing.
- _Roaring fire:_ High warmth. Parallel to the Campfire status when more logs are added. Moves to burning state via timer.
- _Dying:_ Some warmth. Flames are low. Can be reset to "burning" state by adding logs. Moves to burned out state via timer.
- _Burned out:_ Minor warmth, glowing logs, hot ash. Moves to dead state via timer.

This is a super-fancy very successful implementation. A simple first implementation would include the dead/ashes, unlit/logs, and burning states.

If Campfire is present, campfires behave like that mod's fires. The mod achieves this by swapping in Campfire's, uh, campfire object and letting that mod take over.

If Campfire is not present, lit fires offer the following affordances:

- warmth
- cooking
- resting
- wild animals do not attack? (fancy, I like it)
- bandits are attracted? (fancy and dangerous, meh)

Extinguishing fires does not require any equipment. As with Campfire, if the fire has not burned itself out normally, you might get some wood back. (Consider: you always get charcoal back.)

### Interactions with other mods

Consider integrating with JaySerpa's [dynamic activation key](https://www.nexusmods.com/skyrimspecialedition/mods/96273) to switch between stoking/extinguishing & use modes.

Mods that are compatible out of the box:

- [Campfire](https://www.nexusmods.com/skyrimspecialedition/mods/667): 100% integrated.
- [Simple portable cooking](https://www.nexusmods.com/skyrimspecialedition/mods/101233) and similar mods
- CC Survival Mode and [Survival Mode Improved](https://www.nexusmods.com/skyrimspecialedition/mods/78244)

Mods that are supported with an optional patch:

- [Rain extinguishes fires](https://www.nexusmods.com/skyrimspecialedition/mods/80419) (Huge overlap tbh. Does SeaSparrow want to write this one? Heh.)
- do a nexus search to find other interesting mods to support

## Implementation notes

The core of this is going to be arrays of formids for game objects, each of which has the required variations. 1) Make them activatable by using BOS to replace unlit campfires with activatable unlit campfires. 2) On qualified activation, swap in the mesh that depicts the next state.

Maintain a list of state-changed fires with the usual timestamp to indicate last state change. Fuel level is determined from this. Move them to the next appropriate state they hit their timer. Note the implication of timers existing. (Figure out how to do this without using a drawing loop to get tick times. How do people normally do it in mods?)

This mod should be as close to zero configuration as I can make it. When considering a config option, say no.

Some stretch goals: Animations are not in my skillset, but maybe there's something I can use? Animations of interest would be things like setting logs in place, striking flint, kicking dirt onto a campfire.

Interesting generalization: candles, lanterns, fixed torches, etc.

Some nifs of interest:

FXFireWithEmbersHeavy 0x00033da4
FXFireWithEmbersLight 0x00033da9
FXFireWithEmbersLogs01 0x0004318b
FXFireWithEmbersOut 0x0003bd2e

Camping\Campfire01Off.nif

PerkEntryPoint: Activate

shift-E to douse/stoke?
E to cook? idk
