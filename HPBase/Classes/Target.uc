//===============================================================================
//  [FlowerVase] 
//===============================================================================

class target extends ParticleFX;

#exec MESH  MODELIMPORT MESH=ModTarget1Mesh MODELFILE=models\ModTarget1.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=ModTarget1Mesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=ModTarget1Anims ANIMFILE=models\ModTarget1.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=ModTarget1Mesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=ModTarget1Mesh ANIM=ModTarget1Anims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=ModTarget1Anims VERBOSE
#exec OBJ LOAD FILE=..\textures\HP_FX.utx PACKAGE=HPBase.FXPackage
#exec MESHMAP SETTEXTURE MESHMAP=ModTarget1Mesh NUM=1 TEXTURE=HPBase.FXPackage.Target1


// Original material [0] is [Target1] SkinIndex: 0 Bitmap: Target1.bmp  Path: \\Baker\HPotterPC\Art\Texture maps\Kerwin Textures\FX 

var baseharry p;
var vector targetOffset;
var rotator circle; 
var float circlePitch;
var vector moveTarget;
var actor victim;
var float lockTime;
var float previousYaw;

var int TargetPitch;

// This is only used when Harry is in 'TargetLock' mode and cannot turn
var int TargetYaw;

var int			TargetCounter;

var TargetGlow	TargetGlowObjRed;
var TargetGlow	TargetGlowObjBlue;

var Gesture		SpellGesture;
var bool		FXVisible;
var particlefx Winfx;

var	vector		TargetHitLocation;
var	float		TargetSize;

var bool		bNoMove;

auto state seeking
{

	function startup()
	{
		local vector	TraceEnd;
		local rotator	TargetRotation;
		local vector	PivotPoint;

		foreach allActors(class'baseHarry', p)
		{
			if( p.bIsPlayer&& p!=Self)
			{
		
				break;
			}
		}
		TargetCounter = 0;

		bNoMove = true;

//		PlaySound(sound'HPSounds.magic_sfx.spell_aim');

		if (p.bTargettingError && p.cam.IsInState('bossstate'))
		{
			TargetPitch = Rand(8000) - 4000;
			TargetYaw = Rand(4000) - 2000;
		}
		else
		{
			// Find a good pitch to start with
			PivotPoint = p.location;
			PivotPoint.z += p.cam.CameraHeight;

			TraceEnd = Normal(PivotPoint - p.cam.location);

			TargetRotation = rotator(TraceEnd);
			TargetPitch = TargetRotation.Pitch;

//			TargetPitch = 0;
			TargetYaw = 0;
		}

		// @PAB added target glow

/*		if(baseWand(p.weapon).curSpell != class'spelldud')
		{*/
			targetGlowObjRed=spawn(class'targetglow',,,Location);
			targetGlowObjRed.SetColour(255, 0, 0);
			targetGlowObjBlue=spawn(class'targetglow',,,Location);
			targetGlowObjBlue.SetColour(0, 255, 255);
/*		}*/

/*		if (SpellGesture != none)
		{
			log("Spell " $string(SpellGesture.Name));
		}
*/
		// AE:
		StopEffect();
	}

	function touch (actor other)
	{
	//	p.clientmessage ("target touching "$other);
	}


	function HitWall (vector HitNormal, actor Wall)
	{

	//	p.clientmessage ("HITWALL touching "$wall);
	}

	function tick(float Deltatime)
	{
		setTarget(Deltatime);
	}

	function setTarget(float deltatime)
	{
		local rotator		TargetRot;
		local vector		TraceStart;
		local vector		TraceEnd;
		local vector		HitLocation;
		local vector		HitNormal;
		local vector		TargetOffset;
		local vector		Cushion;
		local actor			PossibleVictim;
		local float			Radius;
		local BoundingBox	TargetArea;

		local bool			bEndFound;

		//@PAB test
		local	actor	HitActor;

		Colorstart.base.r=13;
		Colorstart.base.g=108;
		Colorstart.base.b=2;

		ColorEnd.base.r=0;
		ColorEnd.base.g=0;
		ColorEnd.base.b=0;

		victim = none;

		if (p.aformove == 0)
		{
			bNoMove = false;
		}

		if (!p.bLockedOnTarget) // || p.BossTarget == none)
		{
			TargetYaw = 0;
		}
		else
		{
			if(p.SmoothMouseX > 256)
			{
				if (TargetYaw < 16384)
				{
					TargetYaw = TargetYaw + 128;
				}
			}

			if(p.SmoothMouseX < -256)
			{
				if (TargetYaw > -16384)
				{
					TargetYaw = TargetYaw - 128;
				}
			}
		}

		if(p.SmoothMouseY > 256 && TargetPitch < 12000)
		{
			TargetPitch = TargetPitch + p.SmoothMouseY / 8;
		}

		if(p.aformove > 64 && TargetPitch < 12000 && !bNoMove)
		{
			TargetPitch = TargetPitch + 256;
		}

		if((p.SmoothMouseY < -256) && TargetPitch > -8000)
		{
			TargetPitch = TargetPitch + p.SmoothMouseY / 8;
		}

		if((p.aformove < -64) && TargetPitch > -8000 && !bNoMove)
		{
			TargetPitch = TargetPitch - 256;
		}

		if (TargetPitch < -8000)
		{
			TargetPitch = -8000;
		}
		else if (TargetPitch > 12000)
		{
			TargetPitch = 12000;
		}

		TargetRot = p.rotation;
		TargetRot.pitch = TargetPitch;
		TargetRot.yaw = TargetRot.yaw + TargetYaw;

//		BaseHUD(p.MyHUD).DebugVala = TargetPitch;

		TraceStart = p.Location;

		TraceEnd = Vector(TargetRot);
		Cushion = TraceEnd;

		//Right now, this is only used by the Devil's snare level.
		if( p.bExtendedTargetting )
			TraceEnd = TraceEnd * 1024;//512;
		else
			TraceEnd = TraceEnd * 512;

		TraceEnd = TraceEnd + p.Location;

		PossibleVictim = none;

/*		if(baseWand(p.weapon).curSpell== class'spelldud')
		{
			Colorstart.base.r=0;
			Colorstart.base.g=0;
			Colorstart.base.b=0;

			ColorEnd.base.r=0;
			ColorEnd.base.g=0;
			ColorEnd.base.b=0;

			targetGlowObjRed.SetColour(0, 0, 0);
			targetGlowObjBlue.SetColour(0, 0, 0);

			victim = none;
			Cushion = Cushion * 8;

			PossibleVictim = Trace(HitLocation, HitNormal, TraceEnd, TraceStart);

			if (possiblevictim == none)
			{
				HitLocation = TraceEnd;
			}
		}
*/
		foreach TraceActors(class 'actor', HitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
		{
//			log(string(HitActor.name) $" " $vsize(HitLocation - TraceStart));

			if (HitActor.bprojtarget || HitActor.bBlockActors )
			{
				// Found target, 
				PossibleVictim = HitActor;
				break;
			}
		}

		if (PossibleVictim == none)
		{
			// Check for targets with radius

			PossibleVictim = p.ExtendTarget();

			if (PossibleVictim == none)
			{
				PossibleVictim = Trace(HitLocation, HitNormal, TraceEnd, TraceStart);
			}
		}

		if (PossibleVictim != none)
		{
			if (possiblevictim.bprojtarget == true)
			{
/*				Colorstart.base.r=169;
				Colorstart.base.g=5;
				Colorstart.base.b=5;

				ColorEnd.base.r=0;
				ColorEnd.base.g=0;
				ColorEnd.base.b=0;
*/
				victim = possiblevictim;

				TargetArea = victim.GetWorldCollisionBox(true);
				HitLocation = ((TargetArea.Max - TargetArea.Min) / 2) + TargetArea.Min;

				if (possiblevictim.CollideType == CT_Box)
				{
					radius = possiblevictim.CollisionWidth;
				}
				else
				{
					radius = possiblevictim.collisionradius;
				}
				Cushion = Cushion * (radius / 2);
				HitLocation = HitLocation - Cushion;
				victim.Targeted();

				LockOn(victim);

//				baseHUD(p.MyHUD).DebugString = string(possiblevictim.Name);
			}
			else
			{
//				baseHUD(p.MyHUD).DebugString = "no target" $string(possiblevictim.Name);
				SetTargetUnlock();
				TargetGlowObjRed.SetTargetUnlock();
				TargetGlowObjBlue.SetTargetUnlock();
				HitLocation -= Cushion;
			}
		}
		else
		{
//			baseHUD(p.MyHUD).DebugString = "none";

			SetTargetUnlock();
			TargetGlowObjRed.SetTargetUnlock();
			TargetGlowObjBlue.SetTargetUnlock();
			HitLocation = TraceEnd;
			HitLocation -= Cushion;

			SetFloatTarget();
			TargetGlowObjRed.SetFloatTarget();
			TargetGlowObjBlue.SetFloatTarget();
		}

		movesmooth(HitLocation - location);
		TargetGlowObjRed.MoveSmooth(HitLocation - TargetGlowObjRed.location);
		TargetGlowObjBlue.MoveSmooth(HitLocation - TargetGlowObjBlue.location);

/*		BaseHUD(p.MyHUD).DebugValx = HitLocation.x;
		BaseHUD(p.MyHUD).DebugValy = HitLocation.y;
		BaseHUD(p.MyHUD).DebugValz = HitLocation.z;*/
	}

	function LockOn(actor TargetActor)
	{
		local BoundingBox	TargetArea;
		local vector		TargetCentre;
		local float			fTargetWidth;
		local float			fTargetHeight;
		local float			fTargetDepth;

		TargetArea = TargetActor.GetWorldCollisionBox(true);

		TargetCentre = ((TargetArea.Max -  TargetArea.Min) / 2) + TargetArea.Min + TargetActor.CentreOffset;
		fTargetWidth = abs(TargetArea.Max.y - TargetArea.Min.y) * TargetActor.SizeModifier;
		fTargetHeight = abs(TargetArea.Max.z - TargetArea.Min.z) * TargetActor.SizeModifier;
		fTargetDepth = abs(TargetArea.Max.x - TargetArea.Min.x);

		SetTargetLock(fTargetWidth, fTargetHeight, fTargetDepth);
		TargetGlowObjRed.SetTargetLock(fTargetWidth, fTargetHeight, fTargetDepth);
		TargetGlowObjBlue.SetTargetLock(fTargetWidth, fTargetHeight, fTargetDepth);

		baseWand(p.weapon).ChooseSpell(victim.eVulnerableToSpell);

		BaseHUD(p.MyHUD).DebugValY = TargetActor.SizeModifier;

		// Get Spell gesture

		if (baseWand(p.Weapon).curSpell != none && baseWand(p.weapon).curSpell != class'spelldud')
		{
			SpellGesture = baseWand(p.Weapon).curSpell.default.gesture;
		}

		if (FXVisible == false)
		{
			if (victim.isa('basechar'))
			{
				if (basechar(victim).bGestureOnTargeting)
				{
					FXVisible = true;
					DrawSpellFX(TargetCentre, fTargetWidth, fTargetDepth);
				}
				else
				{
					// save location of spell, but don't use it

					TargetHitLocation = TargetCentre;
					TargetSize = fTargetWidth;
				}
			}
			else
			{
				FXVisible = true;
				DrawSpellFX(TargetCentre, fTargetWidth, fTargetDepth);
			}
		}
		else
		{
			// rotate FX
//			RotateSpellFX();
		}
	}

	function RotateSpellFX()
	{
		local rotator SpellRotation;

		SpellRotation = Winfx.Rotation;
		SpellRotation.yaw += 128;
		Winfx.SetRotation(SpellRotation);
	}

	function SetFloatTarget()
	{
		 SourceWidth.Base=50.000000;
	     SourceHeight.Base=50.000000;
		 SourceDepth.Base=50.000000;
	}

	function SetHitTarget()
	{
	}

	function SetTargetLock(float TargetWidth, float TargetHeight, float TargetDepth)
	{
	     ParticlesPerSec.Base=10.000000;
		 SourceWidth.Base=TargetWidth;
	     SourceHeight.Base=TargetHeight;
		 SourceDepth.Base=TargetDepth;
	     AngularSpreadWidth.Base=2.000000;
		 AngularSpreadHeight.Base=2.000000;
	     speed.Base=2.000000;
		 Lifetime.Base=2.000000;
	     ColorStart.Base.R=255;
		 ColorStart.Base.G=255;
		 ColorStart.Base.B=0;
		 ColorEnd.Base.R=255;
		 ColorEnd.Base.G=255;
		 ColorEnd.Base.B=0;
	     SizeWidth.Base=2.000000;
		 SizeWidth.Rand=10.000000;
		 SizeLength.Base=2.000000;
		 SizeLength.Rand=10.000000;
	     SizeEndScale.Base=-0.500000;
		 SpinRate.Base=0.500000;
		 SpinRate.Rand=10.000000;
	     Attraction.X=10.000000;
		 Attraction.Y=10.000000;
		 ParticlesAlive=5;
	     bRotateToDesired=True;
	}

	function SetTargetUnlockStatic()
	{
	     ParticlesPerSec.Base=20.000000;
		 SourceWidth.Base=3.000000;
	     SourceHeight.Base=3.000000;
		 SourceDepth.Base=3.000000;
	     speed.Base=0.000000;
		 Lifetime.Base=0.30000;
	     ColorStart.Base.R=13;
		 ColorStart.Base.G=108;
		 ColorStart.Base.B=2;
		 ColorEnd.Base.R=0;
		 ColorEnd.Base.B=0;
	     SizeWidth.Base=32.000000;
		 SizeLength.Base=32.000000;
	     SizeEndScale.Base=0.750000;
		 SpinRate.Base=4.000000;
		 SpinRate.Rand=-8.000000;
		 ParticlesAlive=10;
	}

	function SetTargetUnlock()
	{
	     ParticlesPerSec.Base=20.000000;
		 SourceWidth.Base=10.000000;
	     SourceHeight.Base=10.000000;
		 SourceDepth.Base=10.000000;
	     AngularSpreadWidth.Base=2.000000;
		 AngularSpreadHeight.Base=2.000000;
	     speed.Base=5.000000;
		 Lifetime.Base=2.000000;
	     ColorStart.Base.R=255;
		 ColorStart.Base.G=255;
		 ColorStart.Base.B=0;
		 ColorEnd.Base.R=255;
		 ColorEnd.Base.G=255;
		 ColorEnd.Base.B=0;
	     SizeWidth.Base=2.000000;
		 SizeWidth.Rand=10.000000;
		 SizeLength.Base=2.000000;
		 SizeLength.Rand=10.000000;
	     SizeEndScale.Base=-0.500000;
		 SpinRate.Base=1.000000;
		 SpinRate.Rand=20.000000;
	     Attraction.X=10.000000;
		 Attraction.Y=10.000000;
		 ParticlesAlive=10;
	     bRotateToDesired=True;



		// AE:
		StopEffect();
	}

	function BeginState()
	{
		circle.pitch=0;
		circle.yaw=0;
		circle.roll=0;

		// @PAB new targetting code
//		TargetPitch = 0;

		//skin=texture'HPBase.FXPackage.Target1';
		locktime=0;
		startup();
	}

	function EndState()
	{
		if (FXVisible)
		{
			// AE:
			StopEffect();
		}
		else if (victim != none)
		{
			if (victim.isa('basechar'))
			{
				if (!basechar(victim).bGestureOnTargeting)
				{
					DrawSpellFX(TargetHitLocation, TargetSize, TargetSize);
					Winfx.ParticlesMax = 200;
				}

/*	BaseHUD(p.MyHUD).Debugstring = string(victim.name);
	BaseHUD(p.MyHUD).DebugVala = TargetSize;
	BaseHUD(p.MyHUD).DebugValx = TargetHitLocation.x;
	BaseHUD(p.MyHUD).DebugValy = TargetHitLocation.y;
	BaseHUD(p.MyHUD).DebugValz = TargetHitLocation.z;

	BaseHUD(p.MyHUD).DebugValx2 = victim.location.x;
	BaseHUD(p.MyHUD).DebugValy2 = victim.location.y;
	BaseHUD(p.MyHUD).DebugValz2 = victim.location.z;*/
			}
		}
	}

/*	begin:
		circle.pitch=0;
		circle.yaw=0;
		circle.roll=0;

		// @PAB new targetting code
//		TargetPitch = 0;

		//skin=texture'HPBase.FXPackage.Target1';
		locktime=0;
		startup();

		
//	seekloop:
//		sleep(0.001);
//	goto 'seekloop';
*/

}

	function DrawSpellFX(vector HitLocation, float TargetSize, float TargetDepth)
	{
		local vector	SpellLoc;
		local rotator	SpellRotation;

		BaseHUD(p.MyHUD).DebugValX = TargetSize;

	// Spawn an appropriate particle system in front of us.

/*		if (abs(vsize(HitLocation - p.location)) > abs(vsize(HitLocation - (vec(TargetSize / 2,0,0) << victim.Rotation) - p.Location)))
		{
			SpellLoc = HitLocation - (vec(TargetSize / 2,0,0) << victim.Rotation);
		}
		else
		{
			SpellLoc = HitLocation + (vec(TargetSize / 2,0,0) << victim.Rotation);
		}
*/


		// AE:
		StartSound();


//		log("Target name/size " $TargetSize $string(victim.name));

//		SpellLoc = HitLocation + (vec(TargetSize / 2,0,0) << victim.Rotation);
//		if (abs(vsize(HitLocation - p.location)) > abs(vsize(HitLocation - (vec(TargetSize / 2,0,0) >> p.Rotation) - p.Location)))
//		{
			SpellLoc = HitLocation - (vec(TargetDepth / 2,0,0) >> p.Rotation);
//		}
//		else
//		{
//			SpellLoc = HitLocation + (vec(TargetSize / 2,0,0) >> p.Rotation);
//		}

//	BaseHUD(p.MyHUD).Debugstring = string(victim.name);
/*	BaseHUD(p.MyHUD).DebugValx = HitLocation.x;
	BaseHUD(p.MyHUD).DebugValy = HitLocation.y;
	BaseHUD(p.MyHUD).DebugValz = HitLocation.z;

	BaseHUD(p.MyHUD).DebugVala2 = TargetSize;
	BaseHUD(p.MyHUD).DebugValx2 = SpellLoc.x;
	BaseHUD(p.MyHUD).DebugValy2 = SpellLoc.y;
	BaseHUD(p.MyHUD).DebugValz2 = SpellLoc.z;
*/
//		Winfx = p.Spawn( class'Reward01',
		Winfx = victim.Spawn( baseWand(p.Weapon).curSpell.default.GestureParticleEffectClass,
			[SpawnLocation] SpellLoc);
/*		Winfx = victim.Spawn( class'Les_SpellShape',
			[SpawnLocation] SpellLoc);*/
//			[SpawnLocation] HitLocation);
//			[SpawnLocation] p.location + (vec(vSize(location - p.location),0,0) >> p.Rotation) );

//		SpellRotation = victim.Rotation;
		SpellRotation = p.Rotation;
		Winfx.SetRotation(SpellRotation);

		Winfx.DrawScale =  TargetSize;
		Winfx.Pattern = SpellGesture;
		Winfx.Period.Base = 0.f;
		Winfx.Period.Rand = 1.f;
		Winfx.ParticlesMax = 0;
//		Winfx.SizeWidth.Base = 8.000000;
//		Winfx.SizeLength.Base = 8.000000;

//		Winfx.SetOwner(victim);
//		Winfx.SetPhysics(PHYS_Trailer);
//		Winfx.bTrailerSameRotation = true;

//		Winfx.Lifetime.Base = 3.0;
	}


// AE:
function StartSound()
{
	// Kick off starting sound.
	PlaySound(sound'HPSounds.magic_sfx.spell_target_nl3', SLOT_Misc);

	// Trigger the loop.
	PlaySound(sound'HPSounds.magic_sfx.spell_targetloop', SLOT_Interact);
}

// AE:
function StopEffect()
{
	if (FXVisible)
	{
		FXVisible = false;
		WinFX.Shutdown();
	}

	// Trigger end sample.
	PlaySound(sound'HPSounds.magic_sfx.spell_off_target3', SLOT_Misc);

	// Stop the effect loop.
	StopSound(sound'HPSounds.magic_sfx.spell_targetloop', SLOT_Interact);
}

function Destroyed()
{

	TargetGlowObjRed.Destroy();
	TargetGlowObjBlue.Destroy();

	// AE:
	StopEffect();

	Super.Destroyed();
}

//	 Textures(0)=Texture'HPParticle.particle_fx.soft_pfx'
//     Textures(0)=Texture'HPParticle.hp_fx.Particles.Sparkle_1'

defaultproperties
{
     ParticlesPerSec=(Base=20)
     SourceWidth=(Base=100)
     SourceHeight=(Base=100)
     SourceDepth=(Base=100)
     AngularSpreadWidth=(Base=2)
     AngularSpreadHeight=(Base=2)
     Speed=(Base=5)
     Lifetime=(Base=2)
     ColorStart=(Base=(R=0,G=0,B=255))
     ColorEnd=(Base=(R=0,B=255))
     SizeWidth=(Base=2,Rand=10)
     SizeLength=(Base=2,Rand=10)
     SizeEndScale=(Base=-0.5)
     SpinRate=(Base=1,Rand=20)
     Attraction=(X=10,Y=10)
     ParticlesAlive=10
     Textures(0)=Texture'HPParticle.hp_fx.Particles.Sparkle_1'
     Rotation=(Pitch=16640)
     bRotateToDesired=True
}
