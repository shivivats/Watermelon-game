# Watermelon Game

A clone of the Suika Game aimed for Android platforms. Made using Godot.

I'm using this as a project to learn Godot with.

"Notable" stuff I implemented/used:
(really just a godot feature list)

- RigidBodies, StaticBodies, Areas, CollisionShapes, CollisionPolygons, WorldBoundaries, etc
- `set_deferred` and `call_deferred` on bodies to properly work with the physics system
- Sprites, Fonts, (Audio and SFX todo)
- Autoloading scenes, setting node references correctly in `_ready` or `enter_tree`
- Preloading scenes and sprites
- Custom signals (for eg, to update the score text label)
- etc.