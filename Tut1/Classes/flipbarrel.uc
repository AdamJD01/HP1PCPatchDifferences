class flipbarrel extends basechar;




#exec MESH  MODELIMPORT MESH=skbarrelMesh MODELFILE=..\hpmodels\models\skbarrel.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=skbarrelMesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=skbarrelAnims ANIMFILE=..\hpmodels\models\skbarrel.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=skbarrelMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=skbarrelMesh ANIM=skbarrelAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=skbarrelAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=skbarrelTex0  FILE=..\hpmodels\TEXTURES\barrelrl_128.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=skbarrelMesh NUM=0 TEXTURE=skbarrelTex0

// Original material [0] is [BARREL_SKIN00] SkinIndex: 0 Bitmap: barrelrl_128.bmp  Path: C:\Nathan 




event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{

}




state atStation
{

	begin:


	SetPhysics(PHYS_Rotating);

	
	desiredRotation=(destP.rotation);
	loopanim('stop');
	
	playsound(sound'HPSounds.Hub1_sfx.chest_landing',SLOT_Misc);
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
		bProjTarget=false;
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
			playsound(sound'HPSounds.Hub1_sfx.barrel_roll_loop',SLOT_Misc);
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
     Mesh=SkeletalMesh'HPModels.skbarrelMesh'
     bProjTarget=True
}
