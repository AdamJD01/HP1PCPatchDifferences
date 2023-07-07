//===============================================================================
//  Base toilet object, used throughout the Troll Boss scene
//===============================================================================

class BaseToiletObject extends HProps;

var vector          PreviousLocation;

var basetroll		Troll;
var baseharry		Player;
var actor			TargetActor;
var bool			bThrown;
var() int			iDamage;

var float			fTimeToBecomeValid;

var() float         RandRangexy;
var() float         RandRangez;

var ChessExplo ExplosionFX;

function ThrowObject(actor TA)
{
	local	vector	TargetVector;

	TargetActor = TA;
	bThrown = true;

	SetPhysics(PHYS_Falling);
	TargetVector = TargetActor.location - location;

	//	log("Location " $location.x $" " $location.y $" " $location.z);
	//	log("TargetActor " $TargetActor.location.x $" " $TargetActor.location.y $" " $TargetActor.location.z);
	TargetVector *= 0.7;

	// Put a small amount of randomness about it
	TargetVector.x = TargetVector.x - 15 + rand(30);
	TargetVector.y = TargetVector.y - 15 + rand(30);

	//	velocity = vec(TargetVector.x, TargetVector.y , 200);
	velocity = vec(TargetVector.x, TargetVector.y , 0);
	//	RotationRate.pitch = rand (8192) - 4096;
	//	RotationRate.yaw = rand (8192) - 4096;
	//	RotationRate.roll = rand (8192) - 4096;
	RotationRate.pitch = rand (0x8000) - 0x4000;
	RotationRate.yaw = rand (0x8000) - 0x4000;
	RotationRate.roll = rand (0x8000) - 0x4000;
}

auto state HoldingState
{
	function beginstate()
	{
		// find the troll
		foreach AllActors(class'basetroll', Troll)
		{
			break;
		}
		foreach AllActors(class'baseHarry', Player)
		{
			break;
		}

//		bCollideWorld	= false;
//		bCollideactors	= false;
//		bBlockactors	= false;
//		bBlockplayers	= false;
//		bThrown = false;
	}

/*	function tick(float deltatime)
	{
		local vector	Offset;

		Offset = vect(0, 0, -100);
		Offset = Offset >> Troll.WeaponRot;

		SetLocation(Troll.WeaponLoc + Offset);
		SetRotation(Troll.WeaponRot);
	}*/
}

//********************************************************************************
state FlyingState
{
	//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	function beginstate()
	{
		fTimeToBecomeValid = 0.5;
	}

	//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	function tick(float deltatime)
	{
		if (!bThrown)
			return;

		if (fTimeToBecomeValid < 0)
		{
			//bCollideWorld	= true;
			//SetCollision(true, true, true);
			fTimeToBecomeValid = 9999;
		}
		else
		{
			fTimeToBecomeValid -= deltatime;
		}

		if (PreviousLocation != Location)
			SetRotation(Rotation + RotationRate * deltatime);
		else // we must be stationary, destroy
			destroy();

		PreviousLocation = location;
	}

	function touch( actor Other )
	{
		playerHarry.ClientMessage("*touch:"$OTher);		

		if( Other != self  &&  BlockPlayer(Other) == none )
			HitWall( vect(0,0,1), Other );
	}

	function bump( actor Other )
	{
		playerHarry.ClientMessage("*bump:"$OTher);		
	}

	//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	function HitWall( vector HitNormal, actor Wall )
	{
playerHarry.ClientMessage("*HitWall:"$Wall);		
		BaseHUD(Player.MyHUD).DebugString = string(Wall.name);

		if (Wall.isa('basechar') || Wall.IsA('baseharry'))
			Wall.takeDamage( iDamage, none, Location, Velocity / 10,'');

		if (!Wall.IsA('bathroomtroll'))
			explode(HitNormal);
		//else
		//	Velocity = MirrorVectorByNormal( Velocity, HitNormal );

		//		Velocity *= 0.25;
		//		Velocity = MirrorVectorByNormal( Velocity, HitNormal );
	}
}

//***********************************************************************************
function bool TakeSpellEffect(baseSpell spell)
{
	explode(normal(-velocity));
}

function explode(vector HitNormal)
{
	local HProps	Fragment;
	local sound     snd;

	ExplosionFX = spawn(class'ChessExplo', [spawnlocation] location);

	Velocity *= 0.5;

	Fragment = spawn(class'TrollThrowFrag1', [spawnlocation] location);
	Fragment.SetPhysics(Phys_falling);
	Fragment.velocity = MirrorVectorByNormal(Velocity, HitNormal);
	Fragment.velocity += vec(RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangez,RandRangez));
	
	Fragment = spawn(class'TrollThrowFrag2', [spawnlocation] location);
	Fragment.SetPhysics(Phys_falling);
	Fragment.velocity = MirrorVectorByNormal(Velocity, HitNormal);
	Fragment.velocity += vec(RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangez,RandRangez));

	Fragment = spawn(class'TrollThrowFrag3', [spawnlocation] location);
	Fragment.SetPhysics(Phys_falling);
	Fragment.velocity = MirrorVectorByNormal(Velocity, HitNormal);
	Fragment.velocity += vec(RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangez,RandRangez));

	Fragment = spawn(class'TrollThrowFrag1', [spawnlocation] location);
	Fragment.SetPhysics(Phys_falling);
	Fragment.velocity = MirrorVectorByNormal(Velocity, HitNormal);
	Fragment.velocity += vec(RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangez,RandRangez));
	
	Fragment = spawn(class'TrollThrowFrag2', [spawnlocation] location);
	Fragment.SetPhysics(Phys_falling);
	Fragment.velocity = MirrorVectorByNormal(Velocity, HitNormal);
	Fragment.velocity += vec(RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangez,RandRangez));

	Fragment = spawn(class'TrollThrowFrag3', [spawnlocation] location);
	Fragment.SetPhysics(Phys_falling);
	Fragment.velocity = MirrorVectorByNormal(Velocity, HitNormal);
	Fragment.velocity += vec(RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangexy,RandRangexy),RandRange(-RandRangez,RandRangez));

	//Actually kinda nice to have these all in one spot
	if( TrollThrowPipe(self) != none )
		snd = sound'HPSounds.hub3_sfx.hit_pipe';
	else
	if( TrollThrowSink(self) != none )
		snd = sound'HPSounds.hub3_sfx.hit_sink';
	else
	if( TrollThrowStone(self) != none )
		snd = sound'HPSounds.hub3_sfx.hit_stone';
	else
	if( TrollThrowToilet(self) != none )
		snd = sound'HPSounds.hub3_sfx.hit_toilet';
	else
	if( TrollThrowWood(self) != none )
		snd = sound'HPSounds.hub3_sfx.hit_wood';

	PlaySound( snd, SLOT_None, [Volume]RandRange(0.8, 1.0), [Radius]100000, [Pitch]RandRange(0.7, 1.2) );

	destroy();
}

defaultproperties
{
     iDamage=8
     RandRangexy=150
     RandRangez=100
     bStatic=False
     eVulnerableToSpell=SPELL_Flipendo
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HProps.TrollThrowPipeMesh'
     CollisionRadius=20
     CollisionHeight=20
     bCollideWorld=True
     bProjTarget=True
     bAlignBottom=False
     bBounce=True
}
