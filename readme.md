

Pixel Perfect:
320 x 180 
viewport
keep


# Cliches

# To-Do

-[x] Legs!
-[x] No-weapon mode
-[x] Idle arm animations
-[x] Run arm animations
-[x] Punch animation
-[x] Weapon grabbing logic
-[x] Sword grabbable
-[ ] Weapon throwing logic
-[ ] Sword bullet

## Brain storming
Exploding Barrels
Infinite Inventory
Preboss savepoints
Healing chickens
Infinite ammo
Fetch the thing quest
Spikes
Acid pools
Audiologs?
Typical story about cristals, and evil entity that comes every now and then, the one hero and stuff.

# GDD
## Shoot them up, but with swords

> Be Smart, less feature and more fun gameplay

- Quest systems: All quests are fetch quests, the only thing that changes is the object target name (green macguffin, super macguffin) and the way its presented.
- Exploding Barrels, period.
- Healing chickens, period.

## Features

- Weapon stack:
	- Every grabbed weapon enters the stack
	- Player the weapon on the bottom
	- Player can throw the weapon thus lowering the stack and changing to the next


- Equipment system:
	- Equipment stuff add modifiers to weapons, actions and types? perhaps not

## Game Loop

- Hub town area
	- Player gets quests which are ALL fetch quests. The quests offer additional roguelike challenges. Reward is money I guess
	- Shop. Traditional roguelike reroll 3 items shop. It sells weapons and equipment
	- NPCs. Just jokes all day long
- Dungeon
	- Combat rooms
	- Elite combat rooms
	- Shop room -> 3 item choose no reroll
	- Equipment room -> choose one, weapons too
	- Money mini game room
	- Fetch quest room -> quests never fail, they just pile up on a quest list. The player can find any item of the fetch quest on any run.
	- Death bargain -> play minigame against death NPC. if the player wins, the next death the player just restarts full hp. If the player looses, then he looses all his stuff minus the current weapon.
- Death
	- If player dies, he looses everything but the current weapon
	- Goes back to Hub town
- Boss
	- Traditional boss fight. That's it ;)


## Weapons

- Sword
	- semicircle attack area
	- sweep attack
	- mid damage
	- close range
	- mid speed
	- pushback

	- Throw:
		- mid damage
		- pushback  x 2

- Pike 
	- linear attack area
	- stab attack
	- mid damage
	- mid range
	- slow speed
	
	- Throw:
		- double damage
		- pushback
		- increase attack speed

- Axe
	- semicircle attack area
	- sweep attack
	- high damage -> high crit chance
	- close range
	- slow speed
	- pushback x 2

	- Throw:
		- double crit damage
		- pushback

- Bow
	- linear attack area
	- stab attack
	- mid damage
	- long range
	- mid speed

	- Throw:
		- low damage
		- pushback
		- increase next weapons crit change

- Knife 
	- linear attack area
	- stab attack
	- mid damage, high crit 
	- close range
	- fast

	- Throw:
		- mid damage
		- next weapon gains throw damage

- Fire rod
	- small bullet area
	- Shoot everal bullets that rain on area
	- low damage per bullet, burned status
	- mid speed

	- Throw
		- Explodes big area, does burned 

- Shuriken
	- quarter circle attack area
	- sweep attack
	- mid damage
	- close range
	- fast

	- Throw:
		- mid damage
		- Gain damage for every other shuriken on stack
		

- Boomerang
	- small bullet area
	- sweep attack
	- low damage
	- close range
	- fast

	- Throw
		- double damage
		- goes around and back to player to the stack

## Equipment
- Everytime a weapon is thrown, next weapon gains damage for an amount of time
- Everytime a weapons is picked, current weapon gains damage for an amount of time
- Everytime a weapon is thrown, gain HP
- Everytime a weapons is picked, gain HP


## Weapon upgrades (Perhaps?)

- Burn enemies
- Freeze enemies
- Poison enemies
- Triggers
	- Raise attack every time an enemy dies
	- Raise attack every time the player receives damage
## Enemies

- Regular swarm enemies
- Bosses -> important?!?!

## Scenery

Arena like combat areas. Add obstacles and find other interesting mechanics to have per room

