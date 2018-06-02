package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Player extends CharacterBase
{
	private var dashTimer:Float = 0;
	private var dashDir:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		
		makeGraphic(64, 64, FlxColor.WHITE);
		
		maxVelocity.y = 320;
		acceleration.y = 800;
		drag.x = maxVelocity.x * 4;
		
		bulletArray = playerBulletArray;
		
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		controls();	
		FlxG.watch.addQuick("acc", acceleration);
		FlxG.watch.addQuick("vel", velocity);
		FlxG.watch.addQuick("On beat: ", onBeat);
		
		super.update(elapsed);
	
	}
	
	private function controls():Void
	{
		var _left:Bool = FlxG.keys.anyPressed([LEFT, J]);
		var _right:Bool = FlxG.keys.anyPressed([RIGHT, L]);
		var _jump:Bool = FlxG.keys.justPressed.SPACE;
		var _dash:Bool = FlxG.keys.justPressed.X;
		var _shoot:Bool = FlxG.keys.justPressed.Z;
		
		var movement:Float = 0;
		
		if (_right)
		{
			movement += speed;
			facing = FlxObject.RIGHT;
			dashDir = 1;
		}
		if (_left)
		{
			movement -= speed;
			dashDir = -1;
			facing = FlxObject.LEFT;
		}
		
		if (dashTimer <= 0)
		{
			velocity.x = movement;
			
			if (FlxG.keys.justPressed.SHIFT)
			{
				dashTimer = 0.3;
			}
		}
		else
		{
			velocity.x = dashDir * speed * 3.25;
			dashTimer -= FlxG.elapsed;
			velocity.y = 0;
		}
		
		if (_jump)
		{
			velocity.y = -maxVelocity.y * 0.8;
			FlxG.log.add("jump" + FlxG.random.int(0, 100));
		}
		
		if (_shoot)
			attack(Bullet.PLAYER);
	}
}