# Aseprite Animation Importer

> Improve the animation pipeline between Godot and Aseprite by using the animation json as a resource called ```.ason```

## How to use

  - Export animations from aseprite organized with tags.
  - Export Aseprite spritesheet with a ```json``` data file with the extension ```.ason```.
  - Use the ```AsepriteAnimationPlayer``` and add the ```.ason``` resource file and add the spritesheet to a ```Sprite``` node.
  - The sprite and animation player must be on the same tree level, if the sprite's name is different and/or is on a different tree position, change the ```target_sprite_name``` on the Import screen to the path/name of the sprite node.
  - Animations will update everytime the ```.ason``` file updates.
  - If the animations will be used with an ```AnimationTree```, events are created to receive update events: ???

## Frame metadata

  By clicking on any layer on Aseprite and then right clicking on a frame metadata can be added to the cell (recommended to add color to know that the cell has metadata). Several actions can be configured as follows separated by ```;```
  - ```node_name:method_name()``` > execute ```method_name``` on ```node_name```. Parameters are not supported
  - ```node_name:parameter=value``` > Assign the ```value``` to the ```parameter``` on ```node_name```. Valid values are booleans, float and int.
  - The ```node_name``` has to be a child of the ```AsepriteAnimationPlayer``` node that has the ```.ason``` resource.
  - ```node_name``` can contain the path in the node tree in case the node is not a child of the ```AsepriteAnimationPlayer```. Example: ```../sprite:visible=true```.
  

## Aseprite Tag Codes
Aseprite animation tags that start with the following character change the behaviour of the animation import logic:
- Ignore character ```-``` ignores the animation when importing to Godot.
- One shot character ```*``` creates the animation without looping. The default behaviour is using loop.