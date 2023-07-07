//=============================================================================
// FireSeed plant base class
//=============================================================================
class FireSeedPlant extends basechar;

var		float	TimeToNextEruption;
var()	float	EruptionRange;		// Range will be between 0 and 2 * EruptionRange + 2 in bell shape
var()	int		iNumberHitsToWilt;
var()	int		iBumpDamage;

var		bool	bFirstHit;

var		FSPlantFire		Fire;

//------------------------------------------------------
// Functions
//------------------------------------------------------


function PostBeginPlay()
{
	Super.PostBeginPlay();
	bFirstHit = true;
	Fire = spawn(class'FSPlantFire', [spawnlocation] location);
	Fire.SetPhysics(PHYS_Trailer);
	Fire.setowner(self);
	Fire.AttachToOwner();
}

//------------------------------------------------------

function bool TakeSpellEffect(baseSpell spell)
{
	if(spell.class==class'spellFlip')			// Use flipendo for the moment
	{

		if (bFirstHit)
		{
			bFirstHit = false;
			SendTrigger();
		}

		// Delay the next eruption 
		TimeToNextEruption = rand(EruptionRange) + rand(EruptionRange) + 2 + EruptionRange;

		GotoState('ExplodingState');
	}
}

//------------------------------------------------------

function bump(actor other)
{
	if(other.IsA('baseHarry'))
	{
		if( !other.IsInState('hit') )
		{
			other.TakeDamage( iBumpDamage, none, Location, Vect(0,0,0), '');
				
			other.Velocity = Vect(0,0,0);
			other.Acceleration = Vect(0,0,0);
		}
	}
}

//------------------------------------------------------

function SendTrigger()
{
	local actor A;

	// Trigger the end scene
	if( Event != '' )
	{
		foreach AllActors( class 'Actor', A, Event )
		{
			A.Trigger( self, self );
		}
	}
}

//------------------------------------------------------
// States
//------------------------------------------------------

auto state NormalState
{
	// Check for plant being hit
	// If so, then go to the Exploding state

	function BeginState()
	{
		TimeToNextEruption = rand(EruptionRange) + rand(EruptionRange) + 2;
//		loopanim('idle');
	}

//------------------------------------------------------

	function AnimEnd()
	{
//		loopanim('idle');
	}

//------------------------------------------------------

	function tick(float deltatime)
	{
		local FireSeedSmoke		Smoke;

		TimeToNextEruption -= deltatime;

		// Blow off some steam every so often
		if (TimeToNextEruption < 0)
		{
//			playanim('gasventstart');
			Smoke = spawn(class'FireSeedSmoke', [spawnlocation] location + vect(0, 0, 80));
			TimeToNextEruption = rand(EruptionRange) + rand(EruptionRange) + 2;
//			playanim('gasventend');
		}
	}
}

//------------------------------------------------------

state ExplodingState
{

//------------------------------------------------------

/*	function AnimEnd()
	{
		if (AnimSequence == 'explodestart')
		{
			// Send out the fire seeds
			GenerateSeeds();

			playanim('explodeend');
		}
		else if (AnimSequence == 'explodeend')
		{
			// Check to see whether the plant has expelled all its seeds
			// and whether it should go back to normal or not

			iNumberHitsToWilt --;

			if (iNumberHitsToWilt > 0)
			{
				// recover
				GotoState('NormalState');
			}
			else
			{
				// its dead
				playanim('wither');
				Fire.Shutdown();
				bProjTarget = false;
			}
		}
		else
		{
			// must be dead
			playanim('dead');
		}
	}
*/
//------------------------------------------------------

	function BeginState()
	{

		playanim('explodestart');
		// Start the plant heating up
		GenerateHitSmoke();

		// PAB new stuff for new plant

		GenerateSeeds();

		iNumberHitsToWilt --;

		if (iNumberHitsToWilt > 0)
		{
			// recover
			GotoState('NormalState');
		}
		else
		{
			// its dead
			Fire.Shutdown();
			bProjTarget = false;
		}
	}

	function GenerateHitSmoke()
	{
		local FireSeedSmoke		Smoke;

		Smoke = spawn(class'FireSeedSmoke', [spawnlocation] location + vect(0, 0, 80));
		Smoke.ParticlesMax *= 3;		// Double the smoke for added effect
		Smoke = spawn(class'FireSeedSmoke', [spawnlocation] location + vect(0, 0, 80));
		Smoke.ParticlesMax *= 3;		// Double the smoke for added effect
	}

	function GenerateSeeds()
	{
		local FireSeeds		Seeds;

//		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(0, 0, 60));
		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(20, 20, 60));
		Seeds.Direction = vect(20, 20, 60);
		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(-20, -20, 60));
		Seeds.Direction = vect(-20, -20, 60);
//		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(20, 0, 60));
//		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(0, 20, 60));
//		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(-20, 0, 60));
		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(-20, 20, 60));
		Seeds.Direction = vect(-20, 20, 60);
//		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(0, -20, 60));
//		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(20, -20, 60));
//		Seeds = spawn(class'FireSeeds', [spawnlocation] location + vect(0, 0, 80));
	}
}

//     Mesh=SkeletalMesh'HPModels.skfireseedplantMesh'
//     Mesh=SkeletalMesh'HProps.fireseedNewMesh'

defaultproperties
{
     EruptionRange=10
     iNumberHitsToWilt=3
     iBumpDamage=5
     eVulnerableToSpell=SPELL_Flipendo
     CentreOffset=(Z=15)
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HPModels.FireseedBushNewMesh'
     CollisionRadius=40
     CollisionHeight=32
     bBlockActors=False
     bProjTarget=True
}
