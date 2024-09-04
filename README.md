# Watermelon Game

A clone of the Suika Game aimed towards Android. Made using Godot.

I used this as a project to learn Godot. Why this game specifically? Because my girlfriend is addicted to it, and I'd been wanting to learn Godot for a while.

**Warning:** some assets used in this project, namely the `icon`, the `splash screen`, and the `secret message scene`, are not commited to source control due to me not wanting to make them public. Omit or replace them if you intend to use this project's source.

### Random notes:
- Refactored from using tap to drop to double-tap to drop. The tap would always be registered even when the user was dragging to move the drop location, making it annoying to play the game. Also tried to implement a drop button, but that was deemed unintuitive.
- Autoloading and checking in `_process` to get other variable references in the autoloaded variable. This is a very dirty workaround, and there are probably better ways. Will look into it more.
- "Make sub-object new" in inherited scenes took me a while to find, and I could've avoided a lot of pain had I found it earlier.
- UI implementations are pretty straightforward, but I almost didn't use them (aimed to simply not have a start screen and all that). But I'm glad I did.
- I tried to implement a glass shader for the box but couldn't really figure it out. Also, the shader wasn't updating in real-time in my editor as it was in everyone's tutorials, and I couldn't find out why. I'll give it another shot in the future, maybe with a different project.

### Godot stuff I implemented/used:

- RigidBodies, StaticBodies, Areas, CollisionShapes, CollisionPolygons, WorldBoundaries, etc
- `set_deferred` and `call_deferred` on bodies to properly work with the physics system
- Sprites, Fonts, (Audio and SFX todo)
- Autoloading scenes, setting node references correctly in `_ready` or `_enter_tree`
- Preloading scenes and sprites
- Custom signals (for e.g., to update the score text label)
- Time slow at game end (also kept in mind to adjust any timer durations accordingly)
- UI such as the start screen, the game over message, etc.
- `@export` to set values via editor (also on inherited scenes)
- World Environment to use post-processing effects
- etc...

### TO-DO:
- Add credits in the game.
- Add a pause menu.
- Add BGM and SFX
- Better ending screen
- Add a settings menu to adjust volumes, toggle the drop button (and other things?)
- Add a glass shader to the box
- Play around more with World Environment effects
- Implement the "leveling" algorithm of the original Suika game (or at least give some motion to the fruits even when they're sitting in the box)


### Credits:
- Suika Game for the mechanics and the fruit assets
- [Fruit Game - Free Asset Pack by apps2amigos on itch.io](https://apps2amigos.itch.io/fruit-game-free-asset-pack)
- [Backgrounds by ramses2099 on OpenGameArt.org](https://opengameart.org/content/background-12)
- [the intricacies of suika games shitty physics engine actually create a lot of risk reward that differentiates it from the other suika clones](https://cohost.org/wowperfect/post/3428499-the-intricacies-of-s)
- [How does scoring work in Suika Game? - StackExchange](https://gaming.stackexchange.com/questions/405265/how-does-scoring-work-in-suika-game)
