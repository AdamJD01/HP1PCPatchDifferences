//=============================================================================
// Fire Seeds base class
// These are expelled by the Fire Seed Plant class (FireSeedPlant.uc)
//=============================================================================

//class FireSeeds extends basechar;
class FireSeeds extends projectile;

#exec MESH  MODELIMPORT MESH=FireSeedMesh MODELFILE=..\hprops\models\FireSeed.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=FireSeedMesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=FireSeedAnims ANIMFILE=..\hprops\models\FireSeed.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=FireSeedMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=FireSeedMesh ANIM=FireSeedAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=FireSeedAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=FireSeedTex0  FILE=..\hprops\TEXTURES\fireseed_128.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=FireSeedMesh NUM=0 TEXTURE=FireSeedTex0

// Original material [0] is [Material #25] SkinIndex: 0 Bitmap: fireseed_128.bmp  Path: D:\Harry Potter\Art\Objects\Fireseed Challenge 

/*#exec MESH  MODELIMPORT MESH=FlipendoVaseBronzeShardMesh MODELFILE=..\hprops\models\FlipendoVaseBronzeShard.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=FlipendoVaseBronzeShardMesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=FlipendoVaseBronzeShardAnims ANIMFILE=..\hprops\models\FlipendoVaseBronzeShard.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=FlipendoVaseBronzeShardMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=FlipendoVaseBronzeShardMesh ANIM=FlipendoVaseBronzeShardAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=FlipendoVaseBronzeShardAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=FlipendoVaseBronzeShardTex0  FILE=..\hprops\TEXTURES\fvbrzbrk_64.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=FlipendoVaseBronzeShardMesh NUM=0 TEXTURE=FlipendoVaseBronzeShardTex0
*/

var()	float				fTemperature;
var()	float				fTemperatureSafeToTouch;

var()	int					iMinInitialVelocity;
var()	int					iMaxInitialVelocity;

var()	int					iDamage;

var		FSSeedSmoke			Smoke;
var		FSSeedFire			Fire;
var		Rotator				SeedSpin;
var		vector				PreviousLocation;
var		vector				Direction;
var		float				TimeSinceSpawned;
var float fPickupFlyTime;

var baseHarry playerHarry;

state landedstate
{
	function tick(float deltatime)
	{
		fTemperature -= deltatime;

//		if (fTemperature < 0)
		if (fTemperature < fTemperatureSafeToTouch)
		{
			if (Fire != none)
			{
				Fire.Shutdown();
				Fire = none;
			}

			if (Smoke != none)
			{
				Smoke.Shutdown();
				smoke = none;
			}
			// seed dissolves away

			// Need a bigger radius where we can pick up the seed
			if (vsize(playerHarry.location - location) < 70)
			{
				GotoState('PickupSeed');
			}
		}
		else
		{
			if (vsize(playerHarry.location - location) < 70)
			{
				// too hot, cause damage to harry
				if( !playerHarry.IsInState('hit') )
				{
					// AE:
					PlaySound(sound'HPSounds.magic_sfx.fireseed_hot');

					playerHarry.TakeDamage( iDamage, none, Location, Vect(0,0,0), '');
				
					playerHarry.Velocity = Vect(0,0,0);
					playerHarry.Acceleration = Vect(0,0,0);
				}
			}
		}

	}

	function BeginState()
	{
		foreach allActors(class'baseHarry', playerHarry)
		{
			break;
		}
	}

	function Touch(actor other)
	{
		if (other.IsA('BaseHarry'))
		{
			if (fTemperature < fTemperatureSafeToTouch)
			{
				playerHarry=baseHarry(other);	//needed for the pickup state
				// can pick the seed up safely
				GotoState('PickupSeed');
			}
			else
			{
				// too hot, cause damage to harry
				if( !other.IsInState('hit') )
				{
					// AE:
					PlaySound(sound'HPSounds.magic_sfx.fireseed_hot');

					other.TakeDamage( iDamage, none, Location, Vect(0,0,0), '');
				
					other.Velocity = Vect(0,0,0);
					other.Acceleration = Vect(0,0,0);
				}
			}
		}
	}
}
state pickupSeed
{
	event tick(float delta)
		{
		local vector dest;
		fPickupFlyTime-=delta;

		Move((playerharry.CameraToWorld(vect(-0.4,0.75,150))-location)/(fPickupFlyTime/delta));
		}

	begin:
		if (Fire != none)
		{
			Fire.Shutdown();
		}
		if (Smoke != none)
		{
			Smoke.Shutdown();
		}
		disable('touch');
		bCollideWorld=false;

		// AE:
		PlaySound(sound'HPSounds.magic_sfx.Fireseed_pickup2');

//		PlaySound(sound'HPSounds.magic_sfx.pickup_fireseed');
		fPickupFlyTime=0.25;

//		BaseHud(playerharry.MyHUD).ShowSeeds();
		while(fPickupFlyTime>0)
			{
			sleep(0.1);
			}
		
		playerharry.AddSeeds(1);
//		BaseHud(playerharry.MyHUD).DebugValA = baseHarry(other).iFireSeedCount;
		destroy();
}

auto state() Created
{
	function tick(float deltatime)
	{
		if (vsize(Direction) != 0)
		{
			gotostate('Flying');
		}
	}
}

state Flying
{
	function tick(float deltatime)
	{
		TimeSinceSpawned += deltatime;
		if (vsize(previouslocation - location) > 0.25 || TimeSinceSpawned < 1)
		{
			SetRotation(Rotation + SeedSpin);
		}
		else
		{
			SetPhysics(PHYS_Walking);		
			gotostate('landedstate');
		}

		PreviousLocation = location;

//		velocity *= (1.0 - (deltatime / 5));

//		velocity.z -= 200 * deltaTime;
//		Move(velocity*deltaTime);

		Smoke.Move(location - Smoke.location);
		Fire.Move(location - Fire.location);
	}

	function BeginState()
	{
		local rotator RandRotation;
		// Move the seed through the air, causing damage to anything it hits

/*		RandRotation = rotrand();
		RandRotation.Pitch = RandRotation.Pitch & 0x3fff;
*/
		RandRotation = rotator(Direction);
		RandRotation.yaw = RandRotation.yaw - 2000 + rand(4000);

		velocity = normal( vector( RandRotation )) * (iMinInitialVelocity + rand (iMaxInitialVelocity - iMinInitialVelocity));
		velocity.z = 30 + rand(100);	

		SeedSpin.Pitch = rand(0x3ff);
		SeedSpin.yaw = rand(0x3ff);
		SeedSpin.roll = 0;

		Smoke = spawn(class'FSSeedSmoke', [spawnlocation] location);
		Smoke.SetPhysics(PHYS_Trailer);
		Smoke.setowner(self);
		Smoke.AttachToOwner();
//		Smoke.ParticlesMax = 15;

		Fire = spawn(class'FSSeedFire', [spawnlocation] location);
		Fire.SetPhysics(PHYS_Trailer);
		Fire.setowner(self);
		Fire.AttachToOwner();

		TimeSinceSpawned = 0;
		PlaySound(sound'HPSounds.hub2_sfx.fireseed_seeds_fly');
	}

	function HitWall( vector HitNormal, actor Wall )
	{
/*		if( (HitNormal dot vect(0,0,1)) > 0.8 )
		{
			// Assume we've hit the ground
			SetPhysics(PHYS_None);		
			gotostate('landedstate');
		}
		else
		{*/
			Velocity *= 0.5;
			Velocity = MirrorVectorByNormal( Velocity, HitNormal );
			PlaySound(sound'HPSounds.hub2_sfx.fireseed_seeds_bounce');

//		}
	}

	function Landed( vector HitNormal )
	{
//		Velocity *= 0.5;
		Velocity = MirrorVectorByNormal( Velocity, HitNormal );
		log("landed");
	}

	function Bump(actor other)
	{
//		Velocity = MirrorVectorByNormal( Velocity, HitNormal );
		log("bumped");
	}

	function Touch(actor other)
	{
		if (other.IsA('BaseHarry'))
		{
			// too hot, cause damage to harry
			if( !other.IsInState('hit') )
			{
				other.TakeDamage( iDamage, none, Location, Vect(0,0,0), '');
				
				other.Velocity = Vect(0,0,0);
				other.Acceleration = Vect(0,0,0);
			}
		}
	}
}

//    Mesh=Mesh'HProps.FireSeedMesh'

defaultproperties
{
     fTemperature=10
     fTemperatureSafeToTouch=5
     iMinInitialVelocity=50
     iMaxInitialVelocity=200
     iDamage=5
     Physics=PHYS_Falling
     LifeSpan=0
     Mesh=SkeletalMesh'HPBase.FireSeedMesh'
     CollisionRadius=1
     CollisionHeight=1
     bBounce=True
}
