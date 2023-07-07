class rolllog extends basechar;






#exec MESH  MODELIMPORT MESH=sklogMesh MODELFILE=..\hpmodels\models\sklog.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=sklogMesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=sklogAnims ANIMFILE=..\hpmodels\models\sklog.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=sklogMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=sklogMesh ANIM=sklogAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=sklogAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=sklogTex0  FILE=..\hpmodels\TEXTURES\flipylog_128.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=sklogMesh NUM=0 TEXTURE=sklogTex0

// Original material [0] is [LOG_SKIN00] SkinIndex: 0 Bitmap: flipylog_128.bmp  Path: C:\Nathan 







state atStation
{

	begin:

	playerharry.clientmessage("at station");
	SetPhysics(PHYS_Rotating);

	
	desiredRotation=(destP.rotation);
	loopanim('stop');
	
	PlaySound(sound'HPSounds.Hub2_sfx.big_boulder_thump');

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


	if(destP.aiData[stationNumber].behavior==BH_Idle2||destP.aiData[stationNumber].behavior==BH_Idle3)
	{
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
		playerharry.clientmessage("just waiting");
		loopanim('stop');
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

			gotostate('patrol');
		}
}


	begin:
		SetPhysics(PHYS_walking);
		loopanim('stop');
	loop:
		sleep(1);
		goto 'loop';


}

defaultproperties
{
     ShadowClass=None
     bFlipTarget=True
     WalkAnimName=Roll
     IdleAnimName=Stop
     GroundSpeed=200
     eVulnerableToSpell=SPELL_Flipendo
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HPModels.sklogMesh'
     CollisionRadius=0
     CollisionHeight=0
     CollideType=CT_Shape
     bProjTarget=True
}
