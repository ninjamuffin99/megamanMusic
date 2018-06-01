package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.addons.tile.FlxTilemapExt;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _bulletsPlayer:FlxTypedGroup<Bullet>;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemapExt;
	
	private var _song:FlxSound;
	private var lastBeat:Float;
	private var oldBeat:Float;
	private var totalBeats:Float = 0;
	
	private var safeZoneOffset:Float = 0;
	//  how many frames you have to hit note
	private var safeFrames:Int = 13;
	private var canHit:Bool = false;
	
	override public function create():Void
	{
		songInit();
		
		_bulletsPlayer = new FlxTypedGroup<Bullet>();
		add(_bulletsPlayer);
		
		_player = new Player(10, 10, _bulletsPlayer);
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
		oldBeat = 0;
	}
	
	private function finishSong():Void
	{
		_song.time = 0;
		lastBeat = 0;
		oldBeat = 0;
		totalBeats = 0;
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
		
		_player.onBeat = canHit;
		
		super.update(elapsed);
		
		FlxG.collide(_player, _mWalls);
		_player.alpha -= 0.05;
		
		if (safeZoneOffset == 0)
		{
			safeZoneOffset = elapsed * (safeFrames / 2) * 1000;
			FlxG.log.add("Safe offset: " + safeZoneOffset);
			FlxG.log.add(elapsed);
		}
	}
	
	// gets called every frame
	private function songHandling():Void
	{
		Conductor.songPosition = _song.time;
		var beatDelta:Float = Conductor.songPosition - lastBeat;
		
		//	SHOUTOUTS TO FermiGames MVP MVP
		if (Conductor.songPosition > lastBeat + Conductor.crochet - safeZoneOffset || Conductor.songPosition < lastBeat + safeZoneOffset) 
		{
			canHit = true;
			
			// every beat 	
			if (Conductor.songPosition > lastBeat + Conductor.crochet)
			{
				oldBeat = lastBeat;
				lastBeat += Conductor.crochet;
				_player.alpha = 1;
				totalBeats += 1;
			}
		}
		else
			canHit = false;

		
		
		FlxG.watch.addQuick("beats delta" , Conductor.songPosition - lastBeat);
		FlxG.watch.addQuick("Can Hit: ", canHit);
		FlxG.watch.addQuick("Total Beats: ", totalBeats);
	}
}
