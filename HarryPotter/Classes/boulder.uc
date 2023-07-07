class boulder extends basechar;







// Original material [0] is [LOG_SKIN00] SkinIndex: 0 Bitmap: flipylog_128.bmp  Path: C:\Nathan 

#exec MESH  MODELIMPORT MESH=skboulderMesh MODELFILE=..\hpmodels\models\skboulder.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=skboulderMesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=skboulderAnims ANIMFILE=..\hpmodels\models\skboulder.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=skboulderMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=skboulderMesh ANIM=skboulderAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=skboulderAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=skboulderTex0  FILE=..\hpmodels\TEXTURES\grayrock_128.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=skboulderMesh NUM=0 TEXTURE=skboulderTex0

// Original material [0] is [BOULDER_SKIN00] SkinIndex: 0 Bitmap: grayrock_128.bmp  Path: C:\Nathan 


var BoulderTrail	trail;

event Falling()
{
	StopSound(sound'HPSounds.Hub2_sfx.big_boulder_roll');
}

state atStation
{

	begin:


	SetPhysics(PHYS_Rotating);

	
	desiredRotation=(destP.rotation);
	loopanim('stop');
	PlaySound(sound'HPSounds.Hub2_sfx.big_boulder_thump');
	trail.Shutdown();

	sleep(destP.aiData[stationNumber].pauseTime);
	stationDestination=destP.aiData[stationNumber].stationDestination;
	pathType=destP.aiData[stationNumber].pathType;
	firstPath=destP.aiData[stationNumber].firstPath;
	stationNumber=destP.aiData[stationNumber].nextStationGroup;
	if(destP.aiData[stationNumber].behavior==BH_Idle1)
	{
		gotostate('waitforspell');
	}

	if(destP.aiData[stationNumber].behavior==BH_die)
	{
		destroy();
	}


	if(destP.aiData[stationNumber].behavior==BH_Idle2)
	{
		bprojtarget=false;
		gotostate('justwaitforever');
	}
	else
	{

		gotostate('patrol');
	}


}



state justwaitforever
{

	begin:
		
		sleep(5);
		
		goto 'begin';


}

auto state waitforspell
{



function bool TakeSpellEffect(baseSpell spell)
{
local vector spawnLoc;
local actor newSpawn;
	if(spell.class==class'spellflip')
		{
			PlaySound(sound'HPSounds.Hub2_sfx.big_boulder_roll');
			trail = spawn(class'BoulderTrail', [spawnlocation] location);
			trail.SetPhysics(PHYS_Trailer);
			trail.setowner(self);
			trail.AttachToOwner();
			gotostate('patrol');

			return true;
		}
}


	begin:
		SetPhysics(PHYS_walking);
	loop:
		sleep(1);
		goto 'loop';


}

defaultproperties
{
     bFlipTarget=True
     WalkAnimName=Roll
     IdleAnimName=Stop
     GroundSpeed=200
     eVulnerableToSpell=SPELL_Flipendo
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HPModels.skboulderMesh'
     bProjTarget=True
}
