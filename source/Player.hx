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
class Player extends FlxSprite 
{
	private var bulletArray:FlxTypedGroup<Bullet>;
	
	public var justShot:Bool = false;
	private var speed:Float = 200;
	private var rateOfFire:Int = 1;
	private var fireCoutner:Int = 0;
	public var onBeat:Bool = false;
	
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
		
		shooting(_shoot);
	}
	
	private function shooting(shootBtn:Bool):Void
	{
		var _shoot:Bool = shootBtn;
		
		justShot = false;
		if (_shoot)
		{
			fireCoutner += 1;
			if (fireCoutner >= rateOfFire)
			{
				fireCoutner = 0;
				justShot = true;
				attack();
			}
		}
	}
	
	private function attack():Void
	{
		switch(facing)
		{
			case FlxObject.RIGHT:
				
		}
		
		var newBullet = new Bullet(x, y, 800, facing, 10);
		
		if (onBeat)
			newBullet.color = FlxColor.RED;
		
		
		bulletArray.add(newBullet);
	}
	
}