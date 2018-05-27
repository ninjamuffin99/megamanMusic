package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite 
{

	private var speed:Float = 200;
	private var dashTimer:Float = 0;
	private var dashDir:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(64, 64, FlxColor.WHITE);
		
		maxVelocity.y = 320;
		acceleration.y = 800;
		drag.x = maxVelocity.x * 4;
		
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
		var movement:Float = 0;
		
		if (FlxG.keys.pressed.D)
		{
			movement += speed;
			dashDir = 1;
		}
		if (FlxG.keys.pressed.A)
		{
			movement -= speed;
			dashDir = -1;
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
		
		
		
		if (FlxG.keys.justPressed.SPACE)
		{
			velocity.y = -maxVelocity.y * 0.8;
			FlxG.log.add("jump" + FlxG.random.int(0, 100));
		}
	}
	
}