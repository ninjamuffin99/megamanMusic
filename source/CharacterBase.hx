package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class CharacterBase extends FlxSprite 
{
	private var bulletArray:FlxTypedGroup<Bullet>;
	
	public var justShot:Bool = false;
	public var firerate:Int = 0;
	private var curFirtime:Int = 0;
	public var canFire:Bool = false;
	public var isDead:Bool = false;
	
	//How many hits basically
	private var maxHealth:Float = 10;
	
	public var onBeat:Bool = false;
	
	public var speed:Float = 300;
	
	

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		firingHandling();
		
	}
	
	private function firingHandling():Void
	{
		if (!canFire)
		{
			curFirtime += 1;
		}
		
		if (curFirtime >= firerate)
		{
			canFire = true;
			curFirtime = 0;
		}
	}
	
	/**
	   Shoots, if it can
	   @param	bullType	Either Player, or Bullet
	**/
	public function attack(bullType:String):Void
	{
		if (canFire)
		{
			FlxG.sound.play("assets/sounds/bullet" + FlxG.random.int(1, 3) + ".mp3", 0.13);
			if (bullType == Bullet.ENEMY)
			{
				FlxG.log.add("enemy Fired");
			}
			
			var newBullet = new Bullet(x, y, 800, facing, 10);
		
			if (onBeat)
				newBullet.color = FlxColor.RED;
			
			var newBullet = new Bullet(getMidpoint().x, getMidpoint().y, 1000, 60, 1);
			newBullet.bType = bullType;
			newBullet.velocity.x += velocity.x * 0.2;
			newBullet.velocity.y += velocity.y * 0.2;
			bulletArray.add(newBullet);
			canFire = false;
			
			velocity.x -= newBullet.velocity.x * 0.25;
			velocity.y -= newBullet.velocity.y * 0.25;
		}
	}
}