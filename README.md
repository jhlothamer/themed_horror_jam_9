# Themed Horror Jam 9 - Witching Hour
This game was created for the [Themed Horror Game Jam #9](https://itch.io/jam/themed-horror-game-jam-9). For the jam we had a choice between themes and chose the Witching Hour theme. We also implemented two bonus challenges: witchcraft and familiar.

## Gameplay

The game is loosely inspired by Five Nights at Freddie's. Instead of simply warding off enemies with the camera mechanic, the goal of the game is to complete the witches brew by having one of the characters attend with the cauldron till the brew is complete. Once the brew is finished, it vaporizes and spreads out into the world, ending the attack from zombie hoard and thus winning the game.

Zombies come in waves and are either low, medium or high aggression. Low aggression zombies shamble about the cabin. Medium aggression zombies attack a window or door a few times and then convert to low aggression. High aggression zombies attack relentlessly, breaking down doors or windows, and go for the nearest character. Zombies that are simply wandering outside the cabin (low aggression) will trigger into high aggression when they get close to a broken door or window. So, the player may have a cabin full of a zombies to deal with very quickly.

Not all characters can interact with all stations. (A station is an interact-able thing - like the cauldron, mana pool, doors and windows, wood pile, crystal ball and spellbook.) By default the goblin minions can collect wood from the wood pile in order to effect repairs to doors and windows. They can also tend the potion brewing in the cauldron. The witch can interact with the cauldron, mana pool, crystal ball and spellbook. When the spellbook is activated, this gives the minions the ability to collect mana from the mana pool and increases the rate they stir the cauldron and repair windows and doors. When a character has enough mana, they can shoot zombies with a magic missile. The crystal ball can only ever be used by the witch. This is used to see outside the cabin as well as cast a ward in one of the view directions that will cause up to 5 zombies to retreat.

## Team

|Role |Name |Links |
|-----------------------|-----------------------------------|-------------------------------------------------------------------------------------|
|Designer/Producer |Frank |[https://frankekova.wixsite.com/frankkova](https://frankekova.wixsite.com/frankkova) |
|Developer |Jason Lothamer |[https://jlothamer.itch.io/](https://jlothamer.itch.io/)<br>[https://www.youtube.com/c/JasonLothamer](https://www.youtube.com/c/JasonLothamer) |
|Lead Artist |Lindsey "Kit" Kitsis ilikethepixies|[https://ilikethepixies.itch.io/](https://ilikethepixies.itch.io/) |
|Composer/Sound Designer|John David Young |[https://linktr.ee/johndavidyoung/](https://linktr.ee/johndavidyoung/)<br>[https://jdymusic.itch.io/](https://jdymusic.itch.io/) |
|Artist |Matrix |[https://www.instagram.com/cosmos336699/](https://www.instagram.com/cosmos336699/) |


## License

All game code in this repository is licensed under the MIT License. All art is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

Artists are indicated in the file's name as a suffix. (E.g. cauldron_matrix.gltf by Matrix.)

An art file including "\_frank\_" indicates that our designer/producer worked on the rigging and animation of the character model. All rigging and animations were done using [Mixamo](https://www.mixamo.com/).
<br>

|Suffix |Team Member |
|--------------|-----------------------------------|
|ilikethepixies|Lindsey "Kit" Kitsis ilikethepixies|
|jdymusic |John David Young |
|matrix |Matrix |

## Development
This game was created using the Godot Engine 3.5.1. It makes use of my Godot Starter Project and Godot Helper Pack as well as some notable additions that may make their way into those projects at a later date.

### Sound Level Manager
The sound level manager tracks and sets the volume of AudioStreamPlayer[2D|3D] nodes. Together with the Sound Management Dialog, those settings can be modified and saved to be re-applied on later game sessions. This was created to solve the issue of balancing sound levels of sound effects and music in the game, giving non-developers a way to do so themselves without requiring the developer to make the modification, do a build, and the non-developer doing the test all over again. After the sound levels have been set in this way, the file generated is given to the developer to then update the volume settings in the game to make them permanent. (It's possible to just maintain that file in the game and have the settings re-applied for players too.)

### 3D Progress Bar
The asset library has a 3D health bar at the time of this writing. However, rather than the bar shrinking and growing from the left, it shrinks and grows from the middle. This is not the usual way progress bars or health bars operate. The 3D progress bar created for this project works as expected (shrink/grow from left).

### Random Point Plane
The Godot navigation facilities (mesh instance and server) were used to define areas of travel for characters in the game. However, a way to pick a random point in a sub-area was needed for wandering modes of the enemies. In order to do this the easiest, the CSGPolygon node is used. Turned on it's side and viewed from above, it's easy to draw a polygon on the x-z plane. This polygon is decomposed into triangles when the game starts. When a random point in the area is needed, a triangle is chosen at random and then a point in that triangle is created. This is more efficient for areas that are not simple rectangles aligned with the global axis. Otherwise, it may take several tries at generating a random point and then testing if that point is in the area.







