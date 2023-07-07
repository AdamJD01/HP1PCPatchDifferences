//===============================================================================
//  [FlipendoVaseBronze] 
//===============================================================================

class FlipendoVaseBronze extends HProps;
#exec MESH  MODELIMPORT MESH=FlipendoVaseBronzeMesh MODELFILE=models\FlipendoVaseBronze.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=FlipendoVaseBronzeMesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=FlipendoVaseBronzeAnims ANIMFILE=models\FlipendoVaseBronze.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=FlipendoVaseBronzeMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=FlipendoVaseBronzeMesh ANIM=FlipendoVaseBronzeAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=FlipendoVaseBronzeAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=FlipendoVaseBronzeTex0  FILE=TEXTURES\fvasebrz_64.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=FlipendoVaseBronzeMesh NUM=0 TEXTURE=FlipendoVaseBronzeTex0

// Original material [0] is [Material #9] SkinIndex: 0 Bitmap: fvasebrz_64.bmp  Path: D:\Harry Potter\Art\Objects\Flipendo Vases 

var class<Actor> brokentype;


auto state waitforspell
{

function Trigger( actor Other, pawn EventInstigator )
{

	gotostate('break');
}

function bool TakeSpellEffect(baseSpell spell)
{
local vector spawnLoc;
local actor newSpawn;
	if(spell.class==class'spellflip')
		{
			gotostate('break');
		}
}


	begin:
	//	SetPhysics(PHYS_walking);
	loop:
		sleep(1);
		goto 'loop';


}


state break
{

function generateobject()
{
	local vector dir;
	local vector vel;
	local actor newspawn;
	local rotator newrot;
		
	dir.x=20;
	dir.y=0;
	dir.z=0;
	dir=dir>>rotation;
	vel = dir * 4;
	dir=dir+location;

	playsound(sound'HPSounds.Hub1_sfx.vase_breaking');
	newspawn=spawn(class'avifors_hit',,,location,rot(0,0,0));
	newSpawn=Spawn(transformInto,,,dir);

	if (newspawn.isa('jellybean'))
	{
		// Special case with beans, let them spill out		
		newSpawn.Velocity = vel;
	}

	newrot=rotation;
	newrot.yaw=newrot.yaw+32000;
	newspawn=spawn(brokentype,,,location,newrot);
	dir.x=100;
	dir.y=0;
	dir.z=0;
	dir=dir>>rotation;
	dir=dir+location;

	newspawn=spawn(class'FlipendoVaseBronzeShard',,,dir,rotation);
	newspawn=spawn(class'FlipendoVaseBronzeShard',,,dir,rotation);
	newspawn=spawn(class'FlipendoVaseBronzeShard',,,dir,rotation);
	newspawn=spawn(class'FlipendoVaseBronzeShard',,,dir,rotation);
	newspawn=spawn(class'FlipendoVaseBronzeShard',,,dir,rotation);
	newspawn=spawn(class'FlipendoVaseBronzeShard',,,dir,rotation);



	
	
}




	begin:
	generateobject();
	destroy();
	loop:
	sleep(1.5);
	
	goto 'loop';


}

defaultproperties
{
     brokentype=Class'HProps.FlipendoVaseBronzeBroken'
     bStatic=False
     eVulnerableToSpell=SPELL_Flipendo
     SizeModifier=1.5
     CentreOffset=(Z=25)
     bDirectional=True
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HProps.FlipendoVaseBronzeMesh'
     bCollideWorld=True
     bBlockPlayers=True
     bProjTarget=True
}
