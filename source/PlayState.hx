package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.addons.tile.FlxTilemapExt;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemapExt;
	
	private var _song:FlxSound;
	private var lastBeat:Float;
	
	override public function create():Void
	{
		songInit();
		
		_player = new Player(10, 10);
		add(_player);
		
		mapInit();
		
		_map.loadEntities(placeEntities, "ENTITIES");
		
		FlxG.camera.zoom = 2;
		FlxG.camera.follow(_player, FlxCameraFollowStyle.PLATFORMER, 0.2);
		
		super.create();
	}
	
	private function songInit():Void
	{
		_song = new FlxSound();
		_song.loadEmbedded("assets/music/52493_newgrounds_51sec.mp3", true, false, finishSong);
		add(_song);
		_song.play();
		
		lastBeat = 0;
	}
	
	private function finishSong():Void
	{
		_song.time = 0;
		lastBeat = 0;
	}
	
	private function mapInit():Void
	{
		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		_mWalls = _map.loadTilemapExt(AssetPaths.colortiles__png, 10, 10, "walls");
		_mWalls.follow();
		
		// tile tearing problem fix
		var levelTiles = FlxTileFrames.fromBitmapAddSpacesAndBorders(AssetPaths.colortiles__png,
			new FlxPoint(10, 10), new FlxPoint(2, 2), new FlxPoint(2, 2));
		_mWalls.frames = levelTiles;
		
		var tempNW:Array<Int> = [5, 9, 10, 13, 15];
		var tempNE:Array<Int> = [6, 11, 12, 14, 16];
		var tempSW:Array<Int> = [7, 17, 18, 21, 23];
		var tempSE:Array<Int> = [8, 19, 20, 22, 24];
		
		_mWalls.setSlopes(tempNW, tempNE, tempSW, tempSE);
		//set tiles steepness
		_mWalls.setGentle([10, 11, 18, 19], [9, 12, 17, 20]);
		_mWalls.setSteep([13, 14, 21, 22], [15, 16, 23, 24]);

		add(_mWalls);
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
	}

	override public function update(elapsed:Float):Void
	{
		
		songHandling();
		
		super.update(elapsed);
		
		FlxG.collide(_player, _mWalls);
		_player.alpha -= 0.05;
		
	}
	
	private function songHandling():Void
	{
		Conductor.songPosition = _song.time;
		//every beat
		if (Conductor.songPosition > lastBeat + Conductor.crochet)
		{
			lastBeat += Conductor.crochet;
			_player.alpha = 1;
		}
	}
}
