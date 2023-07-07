//===============================================================================
//  [bronzechest] 
//===============================================================================

class bronzechest extends hprops;
// Original material [0] is [SKIN00] SkinIndex: 0 Bitmap: brztrunk_128.bmp  Path: C:\Nathan 

var()	int				iNumberOfBeans;
var()	class<Actor>	EjectedObjects[8];		// Up to 8 new objects can appear

var()	vector			ObjectStartPoint[8];
var()	vector			ObjectStartVelocity[8];
var()	bool			bRandomBeans;

var		baseHarry		Player;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	// Find Harry for wizard cards
	foreach allActors(class'baseHarry', Player)
	{
		break;
	}

}

function SetupRandomBeans()
{
	local int	iBean;
	local baseharry p;

	foreach allActors(class'baseHarry', p)
	{
		break;
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
	if(spell.class==class'spellAloho')
		{
			gotostate('turnover');
			return true;
		}
}


	begin:
	//	SetPhysics(PHYS_walking);
	loopanim('start');
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
	local int	iBean;
	local rotator	HarryDirection, DifRotation;

	if (bRandomBeans)
	{
		SetupRandomBeans();
	}

	for (iBean = 0; iBean < iNumberOfBeans; iBean ++)
	{
		vel = ObjectStartVelocity[iBean];
		vel.x +=  (- 16 + rand(96));
		if (vel.x < 0)
		{
			vel.x = 0;
		}

		SpawnDirection = rotation;
		vel = vel >> SpawnDirection;

		dir = ObjectStartPoint[iBean];

		dir = dir >> SpawnDirection;
		dir = dir + location;

		newspawn=spawn(class'Spawn_flash_1',,,dir,rot(0,0,0));
//		newSpawn=Spawn(TransformInto,,, dir);
		newSpawn=Spawn(EjectedObjects[iBean],,, dir);

		if (newspawn.isa('jellybean'))
		{
			// Special case with beans, let them spill out		
			newSpawn.Velocity = vel;
		}
		else if (newspawn.isa('chocolatefrog'))
		{
			// Special case with beans, let them spill out		
			newSpawn.Velocity = vel * 2;
		}
		else if (newspawn.isa('wizzardcardicon'))
		{
			// boost speed
//			newSpawn.Velocity = vel * 2;

			vel = ObjectStartVelocity[iBean];
//			vel.x +=  (16 + rand(32));
			vel.x +=  20;

			SpawnDirection = rotation;
			vel = vel >> SpawnDirection;

			newSpawn.Velocity = vel;

			// Check for position of Harry and modify jump position accordingly

			HarryDirection = rotator(Player.Location - dir);
			DifRotation = HarryDirection - SpawnDirection;

			DifRotation.yaw = DifRotation.yaw & 0xffff;
			if (DifRotation.yaw > 0x7fff)
			{
				DifRotation.yaw -= 0x10000;
			}

			if (abs(DifRotation.yaw) < 0x2000 && vsize(Player.Location - dir) < 50)
			{
				if (DifRotation.yaw > 0)
				{
					newSpawn.Velocity = newSpawn.Velocity << rot(0, 0x3800, 0);
				}
				else
				{
					newSpawn.Velocity = newSpawn.Velocity >> rot(0, 0x3800, 0);
				}

			}
			newSpawn.SetLocation(Location + newSpawn.Velocity);
		}
	}
}

	begin:
	bProjTarget=false;
// AE:
	switch( Rand(4) )
	{
		case 0:	playsound(sound'HPSounds.Hub1_sfx.METAL_CHEST_OPEN_2'); break;
		case 1:	playsound(sound'HPSounds.Hub1_sfx.METAL_CHEST_OPEN_4'); break;
		case 2:	playsound(sound'HPSounds.Hub1_sfx.WOOD_CHEST_OPEN_1'); break;
		case 3:	playsound(sound'HPSounds.Hub1_sfx.WOOD_CHEST_OPEN_2'); break;
	}

	playanim('open');
	finishanim();
	generateobject();
	playsound(sound'HPSounds.Hub1_sfx.chest_landing');


	loop:
	loopanim('end');
	sleep(0.5);
	goto 'loop';


}

//	EjectedObjects(0)=Class'HarryPotter.ChocolateFrog'

defaultproperties
{
     iNumberOfBeans=4
     EjectedObjects(0)=Class'HProps.BlueJellyBean'
     EjectedObjects(1)=Class'HProps.GreenJellyBean'
     EjectedObjects(2)=Class'HProps.SpottedJellyBean'
     EjectedObjects(3)=Class'HProps.GreenPurpleCheckerBean'
     EjectedObjects(4)=Class'HProps.BlueJellyBean'
     EjectedObjects(5)=Class'HProps.BlueJellyBean'
     EjectedObjects(6)=Class'HProps.BlueJellyBean'
     EjectedObjects(7)=Class'HProps.BlueJellyBean'
     ObjectStartPoint(0)=(Z=40)
     ObjectStartPoint(1)=(X=17,Y=-3,Z=40)
     ObjectStartPoint(2)=(X=2,Y=22,Z=40)
     ObjectStartPoint(3)=(X=-4,Y=-18,Z=40)
     ObjectStartPoint(4)=(X=22,Y=19,Z=40)
     ObjectStartPoint(5)=(X=16,Y=-23,Z=40)
     ObjectStartPoint(6)=(X=8,Y=36,Z=40)
     ObjectStartPoint(7)=(X=12,Y=-42,Z=40)
     ObjectStartVelocity(0)=(X=48,Z=120)
     ObjectStartVelocity(1)=(X=64,Z=200)
     ObjectStartVelocity(2)=(X=48,Y=24,Z=120)
     ObjectStartVelocity(3)=(X=48,Y=-24,Z=120)
     ObjectStartVelocity(4)=(X=64,Y=24,Z=200)
     ObjectStartVelocity(5)=(X=64,Y=-24,Z=200)
     ObjectStartVelocity(6)=(X=48,Y=48,Z=150)
     ObjectStartVelocity(7)=(X=48,Y=-48,Z=150)
     bRandomBeans=True
     bStatic=False
     eVulnerableToSpell=SPELL_Alohomora
     CentreOffset=(Z=20)
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HPModels.skbronzechestMesh'
     DrawScale=2
     CollisionHeight=20
     bBlockPlayers=True
     bProjTarget=True
}
