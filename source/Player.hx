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

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(90, 90, FlxColor.WHITE);
		
		maxVelocity.set(120, 320);
		acceleration.y = 800;
		drag.x = maxVelocity.x * 4;
		
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.D)
		{
			velocity.x = 60;
		}
		if (FlxG.keys.pressed.A)
		{
			velocity.x = -60;
		}
	}
	
}