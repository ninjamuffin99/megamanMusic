package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Bullet extends FlxSprite 
{
	private var life:Float = 3;
	private var speed:Float;
	public var dir:Int;
	public var damage:Float;

	public function new(?X:Float=0, ?Y:Float=0, Speed:Float, Direction:Int, Damage:Float) 
	{
		super(X, Y);
		
		
		makeGraphic(32, 18);
		
		speed = Speed;
		dir = Direction;
		damage = Damage;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (dir == FlxObject.LEFT)
		{
			velocity.x = -speed;
		}
		if (dir == FlxObject.RIGHT)
		{
			velocity.x = speed;
		}
		
		life -= FlxG.elapsed;
		if (life < 0)
		{
			kill();
		}
		
	}
	
}