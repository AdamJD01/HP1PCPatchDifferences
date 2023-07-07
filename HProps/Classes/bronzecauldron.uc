//===============================================================================
//  [bronzecauldron] 
//===============================================================================

class bronzecauldron extends hprops;

#exec MESH  MODELIMPORT MESH=skbronzecauldronMesh MODELFILE=..\hpmodels\models\skbronzecauldron.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=skbronzecauldronMesh X=0 Y=0 Z=30 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=skbronzecauldronAnims ANIMFILE=..\hpmodels\models\skbronzecauldron.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=skbronzecauldronMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=skbronzecauldronMesh ANIM=skbronzecauldronAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=skbronzecauldronAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=skbronzecauldronTex0  FILE=..\hpmodels\TEXTURES\flipcouldronrnze_64.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=skbronzecauldronMesh NUM=0 TEXTURE=skbronzecauldronTex0

// Original material [0] is [SKIN00] SkinIndex: 0 Bitmap: flipcouldronrnze_64.bmp  Path: C:\Nathan 

var()	int				iNumberOfBeans;
var()	class<Actor>	EjectedObjects[3];		// Up to 8 new objects can appear

var()	vector			ObjectStartPoint[3];
var()	vector			ObjectStartVelocity[3];
var() bool bRandomBean;

function SetupRandomBeans()
{
	local int	iBean;
	local baseharry p;

	foreach allActors(class'baseHarry', p)
	{
		break;
	}

	if (iNumberOfBeans > 3)
	{
		iNumberOfBeans = 3;
	}

	for (iBean = 0; iBean < iNumberOfBeans; iBean ++)
	{
		if (rand(100) < (30 - (p.GetHealth() * 30)) && iBean == 0)
		{
			EjectedObjects[iBean] = Class'HarryPotter.ChocolateFrog';
		}
		else
		{
			switch(rand(5))
			{
				case 0:
					EjectedObjects[iBean] = Class'HProps.BlueJellyBean';
					break;

				case 1:
					EjectedObjects[iBean] = Class'HProps.GreenJellyBean';
					break;

				case 2:
					EjectedObjects[iBean] = Class'HProps.SpottedJellyBean';
					break;

				case 3:
					EjectedObjects[iBean] = Class'HProps.GreenPurpleCheckerBean';
					break;

				case 4:
					EjectedObjects[iBean] = Class'HProps.RedBlackStripeBean';
					break;

			}
		}
	}
}



auto state waitforspell
{



function bool TakeSpellEffect(baseSpell spell)
{
local vector spawnLoc;
local actor newSpawn;
	if(spell.class==class'spellflip')
		{
			gotostate('turnover');
		}
}


	begin:
	//	SetPhysics(PHYS_walking);
	loop:
		sleep(1);
		goto 'loop';


}


state turnover
{

function generateobject()
{
	local vector dir, vel;
	local actor newspawn;
	local rotator	SpawnDirection;
	local int iBean;

	if (bRandomBean)
	{
		SetupRandomBeans();
	}
	else
	{
		if (TransformInto != none)
		{
			EjectedObjects[0] = TransformInto;
		}
	}

	for (iBean = 0; iBean < iNumberOfBeans; iBean ++)
	{
		vel = ObjectStartVelocity[iBean];
		vel.x +=  (rand(64));

		SpawnDirection = rotation;
		SpawnDirection.yaw += 5000;

		vel = vel >> SpawnDirection;

		dir = ObjectStartPoint[iBean];

		dir = dir >> SpawnDirection;
		dir = dir + location;

		newspawn=spawn(class'Spawn_flash_2',,,dir,rot(0,0,0));
		newSpawn=Spawn(EjectedObjects[iBean],,, dir);

		if (newspawn.isa('jellybean'))
		{
			// Special case with beans, let them spill out		
			newSpawn.Velocity = vel;
		}
		else if (newspawn.isa('chocolatefrog') || newspawn.isa('wizzardcardicon'))
		{
			// Special case with frogs, let them jump
			vel.z *= 2;
			newSpawn.Velocity = vel * 2;
		}
	}
}




	begin:
	bProjTarget=false;
	playsound(sound'HPSounds.Hub1_sfx.cauldron_flip',,5.00);
	playanim('tipover',[RootBone] 'move');
	finishanim();
	generateobject();

	loop:
	loopanim('tipped',[RootBone] 'move');
	sleep(0.5);
	goto 'loop';


}

//	transforminto=Class'HarryPotter.ChocolateFrog'

defaultproperties
{
     iNumberOfBeans=3
     EjectedObjects(0)=Class'HProps.BlueJellyBean'
     EjectedObjects(1)=Class'HProps.GreenJellyBean'
     EjectedObjects(2)=Class'HProps.SpottedJellyBean'
     ObjectStartPoint(0)=(X=64,Z=-20)
     ObjectStartPoint(1)=(X=64,Y=-20,Z=20)
     ObjectStartPoint(2)=(X=64,Y=20,Z=20)
     ObjectStartVelocity(0)=(X=64,Z=40)
     ObjectStartVelocity(1)=(X=64,Y=40,Z=40)
     ObjectStartVelocity(2)=(X=64,Y=-40,Z=40)
     bRandomBean=True
     bStatic=False
     eVulnerableToSpell=SPELL_Flipendo
     CentreOffset=(Z=20)
     bDirectional=True
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HPModels.skbronzecauldronMesh'
     CollisionHeight=60
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
