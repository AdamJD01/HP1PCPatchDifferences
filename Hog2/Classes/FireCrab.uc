class FireCrab expands baseChar;


var int hitCount;
var sound peevesVoice;
var	rotator vMoveDirRot;
var vector vMoveDir;

var bool   bLookForHarry;
var vector vOriginalLoc;
var float WanderDistance;
var float TetherCheckTimer;
var bool bOutsideOfTether;
var float TimeUntilNextFire;

const MAX_ROT_VEL = 500.0;
var   float fRotVel;

var() bool  bMoveAround;

var() float fAttackRange;

enum enumCrabSize
{
	CRAB_SMALL,
	CRAB_MEDIUM,
	CRAB_LARGE,
};

var() enumCrabSize eCrabSize;
var() float CrabGroundSpeed[3];

var() float DelayBetweenAttacks[3];

var   int   iNumSpellHitsToFlipStart;
var   int   iNumSpellHitsToFlip;

var() float fTimeSpentOnBack;

var   int   NumShots;

var() float fWakeupDistance;

var   vector vnExtraSlideVelocity;
var   float  fExtraSlideSpeed;

//*************************************************************************************************************************
function PostBeginPlay()
{
	local baseWand weap;
	Super.PostBeginPlay();

	weap=spawn(class'baseWand');
	weap.BecomeItem();
	AddInventory(weap);
	weap.WeaponSet(self);
	weap.GiveAmmo(self);
	weap.SelectSpell(Class'spellFire');
	//weap.FireOffset = vect(0,0,0);

	SetPhysics(PHYS_Walking);

	SetCollision( true, true, true );
	//SetCollisionSize( CollisionRadius*0.75*DrawScale, 20 );//float NewRadius, float NewHeight );

	vMoveDir.x = 1;
	vMoveDir.y = 0;
	vMoveDir.z = 0;
	vMoveDirRot.yaw = 65536.0*FRand();
	vMoveDirRot.pitch = 0;
	vMoveDirRot.roll = 0;
	vMoveDir = vMoveDir>>vMoveDirRot;

	SetRotation( vMoveDirRot );

	vOriginalLoc = location;
	bOutsideOfTether = false;

	TimeUntilNextFire = FRand() * 1.0;

	fRotVel = 0;

	GroundSpeed = CrabGroundSpeed[ eCrabSize ];

	switch( eCrabSize )
	{
		case CRAB_SMALL:     iNumSpellHitsToFlipStart = 1;      break;
		case CRAB_MEDIUM:    iNumSpellHitsToFlipStart = 2;      break;
		case CRAB_LARGE:     iNumSpellHitsToFlipStart = 3;      break;
	}

	iNumSpellHitsToFlip = iNumSpellHitsToFlipStart;
}

//*************************************************************************************************************************
event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	if( DamageType == 'ZonePain' )
		Destroy();

	//playerHarry.clientMessage(self $" DamateType:"$DamageType);
	//	gotostate ('shot');
}

//*************************************************************************************************************************
function bool TakeSpellEffect(baseSpell spell)
{	
	local vector v;

	//PlaySound(sound 'HPSounds.peeves_sfx.pee_004', SLOT_Interact, 3.2, false, 2000.0, 1.0);
	
	if( spell.class != class'spellFlip' )
		return true;

	// AE:
	switch( Rand(2) )
	{
		case 0: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Hit_01', SLOT_none); break;
		case 1: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Hit_02', SLOT_none); break;
	}


	if( IsInState('DoFlip') )
	{
//		if( rand(2) == 0 )
//			PlaySound(sound'HPSounds.Critters_sfx.firecrab_ouch1', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );
//		else
//			PlaySound(sound'HPSounds.Critters_sfx.firecrab_ouch2', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );

		//v = spell.velocity;  For some reason the spell velocity is off half the time
		v = Location - playerHarry.Location;
		v.z = 0;
		v = normal( v );
		vnExtraSlideVelocity += v;
		vnExtraSlideVelocity = normal( vnExtraSlideVelocity );

		fExtraSlideSpeed += 400;

		GotoState('DoFlip');
	}
	else
	{
		if( --iNumSpellHitsToFlip <= 0 )
		{
//			PlaySound(sound'HPSounds.Critters_sfx.firecrab_flipover', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );

			iNumSpellHitsToFlip = iNumSpellHitsToFlipStart;
			GotoState('DoFlip');
		}
		else
		{
			// Play some sort of a temp hit anim
//			if( rand(2) == 0 )
//				PlaySound(sound'HPSounds.Critters_sfx.firecrab_ouch1', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );
//			else
//				PlaySound(sound'HPSounds.Critters_sfx.firecrab_ouch2', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );

			GotoState('stateHitBySpell');
		}
	}

	//Stay a flip target
	bFlipTarget = true;

	return true;
}

//*************************************************************************************************************************
function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	local Rotator  r;

	r = Rotation;
	r.pitch = 12 * 65536/360;

	return r;
}

//*************************************************************************************************************************
function rotator AdjustToss(float projSpeed, vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	local vector loc;

	if(self!=playerHarry)
	{
		loc=playerHarry.location;
		loc.z-=30;
		return Rotator(loc - Location);
	}
	else
		return Rotation;
}

//*************************************************************************************************************************
function Tick(float DeltaTime)
{
	local vector newloc;
	local actor  a;

	//See if we should shoot at Harry
	TimeUntilNextFire -= DeltaTime;
	if( TimeUntilNextFire < 0 )
	{
		if( VSize(playerHarry.Location - Location) < fAttackRange  &&  PlayerCanSeeMe() )
		{
			//TimeUntilNextFire = 4.0 + FRand()*3.0;
			TimeUntilNextFire = DelayBetweenAttacks[ eCrabSize ] + 1.0;
			
			if( bLookForHarry )
				GotoState('attackHarry');
		}
		else
		{
			TimeUntilNextFire = 2.0;
		}
	}
}

//*************************************************************************************************************************
state PatrolForHarry
{
	//* * * * * * * * * * * * * * * * * * * * * * *
	function touch(actor other)
	{
		//	PlaySound(sound 'filch', SLOT_Interact, 3.2, false, 2000.0, 1.0);
		//	playerHarry.clientMessage(self $":" $other $" touched me!");
		//playerHarry.clientMessage(self $":touch");
		//gotostate('attackHarry');
		//playerHarry.clientMessage(self $":touch");

		//if( baseHarry(other) != None )
		//	GotoState('DoFlip');

		if( other.bBlockActors )
			HitWall( normal(Location - other.Location), other );
	}

	//* * * * * * * * * * * * * * * * * * * * * * *
	function bump(actor other)
	{
		touch( other );
	}

	//* * * * * * * * * * * * * * * * * * * * * * *
	function HitWall(vector HitNormal, actor Wall)
	{
		SetLocation( OldLocation );//+ (HitNormal * 50));
		//Find a new vMoveDir

		vMoveDir.x = 1;
		vMoveDir.y = 0;
		vMoveDir.z = 0;
		vMoveDirRot = rotator(HitNormal);
		vMoveDirRot.yaw += 65536.0*(8.0/20.0)/2.0*((FRand()*2.0)-1.0);
		vMoveDirRot.pitch = 0;
		vMoveDirRot.roll = 0;
		vMoveDir = vMoveDir>>vMoveDirRot;

		fRotVel = 0;

		//PlaySound(sound 'HPSounds.peeves_sfx.pee_004', SLOT_Interact, 3.2, false, 2000.0, 1.0);
		//playerHarry.clientMessage(self $":HitWall");
		gotostate('TurnToNewDir');
		//vMoveDir = -vMoveDir;
	}

	//* * * * * * * * * * * * * * * * * * * * * * *
	function Tick(float DeltaTime)
	{
		local vector newloc;
		local actor  a;

		fRotVel += DeltaTime * 1000.0 * (FRand()*1.98 - 1.0); //FRand tends towards 1 rather than 0
		fRotVel = FClamp( fRotVel, -MAX_ROT_VEL, MAX_ROT_VEL );
		vMoveDirRot.yaw += fRotVel;
		//playerHarry.clientMessage(fRotVel);
		vMoveDir = vector( vMoveDirRot );
		SetRotation( vMoveDirRot );

		if( bMoveAround )
			MoveSmooth( vMoveDir * 60 * DeltaTime);

		//Acceleration = vMoveDir * 500;
		//Velocity = vMoveDir * 1000; //*speed;
		//AirSpeed=500;
		//AutonomousPhysics( DeltaTime );

		//Now, check and see if we've gone past our tether distance
		TetherCheckTimer += DeltaTime;
		if( TetherCheckTimer > 0.5 )
		{
			// AE:
			switch( Rand(12) )
			{
				case 0: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Idle_02', SLOT_none); break;
				case 1: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Idle_03', SLOT_none); break;
				case 2: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Idle_04', SLOT_none); break;
				case 3: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Idle_05', SLOT_none); break;
				case 4: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Idle_06', SLOT_none); break;
				default:
			}

			TetherCheckTimer = 0;
			if( VSize( location - vOriginalLoc ) > WanderDistance )
			{
				if( !bOutsideOfTether )
				{
					bOutsideOfTether = true;

					//For now, just turn and face back to the tether
					vMoveDir = Normal( vOriginalLoc - Location );
					vMoveDir.z = 0;
					vMoveDirRot = rotator( vMoveDir );
					gotostate('TurnToNewDir');
					fRotVel = 0;
				}
			}
			else
			{
				bOutsideOfTether = false;
			}
		}

		//See if we should shoot at Harry

		//Probably move this so it is handled in Global.Tick()

		TimeUntilNextFire -= DeltaTime;
		if( TimeUntilNextFire < 0 )
		{
			if( PlayerCanSeeMe() )
			{
				TimeUntilNextFire = 4.0 + FRand()*3.0;
				
				if( bLookForHarry )
					GotoState('attackHarry');
			}
			else
			{
				TimeUntilNextFire = 2.0 + FRand()*2.0;
			}
		}
	}

  Begin:
	AirSpeed=500;
	loopAnim('Walk');

  actionloop:

	//Velocity = vMoveDir * 1000; //*speed;

	sleep(1);
	goto 'actionloop';
}

//*************************************************************************************************************************
state() stateAsleep
{
  Begin:
	LoopAnim('breath');
	sleep(1.0);

	if( VSize( playerHarry.Location - Location ) < fWakeupDistance )
		GotoState('attackHarry');

	Goto 'Begin';
}

//*************************************************************************************************************************
state stateHitBySpell
{
	function Tick(float DeltaTime)
	{
	}

  Begin:
	Velocity = vect(0,0,0);
	acceleration = vect(0,0,0);

	PlayAnim('attack');
	finishanim();
	PlayAnim('throwobject2');
	finishanim();
	PlayAnim('attack');
	finishanim();
	PlayAnim('throwobject2');
	finishanim();

	TimeUntilNextFire = DelayBetweenAttacks[ eCrabSize ] + 1.0;

	if( bFollowPatrolPoints )
		GotoState('patrol');
	else
		gotostate('PatrolForHarry');

}

//*************************************************************************************************************************
state DoFlip
{
	function Tick(float DeltaTime)
	{
		MoveSmooth( vnExtraSlideVelocity * fExtraSlideSpeed * DeltaTime );

		fExtraSlideSpeed -= 250 * DeltaTime;

		if( fExtraSlideSpeed < 0 )
			fExtraSlideSpeed = 0;
	}

  begin:

	Velocity = vect(0,0,0);//vExtraSlideVelocity;
	Acceleration = vect(0,0,0);
	//vExtraSlideVelocity = vect(0,0,0);

	loopAnim('flipover');
	FinishAnim();

	// AE:
	switch( Rand(2) )
	{
		case 0:	PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Dazed_01', SLOT_none);	break;
		case 1:	PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Dazed_02', SLOT_none);	break;
	}
	
	loopAnim('idleonback');
	sleep( fTimeSpentOnBack );

	loopAnim('flipback');
	FinishAnim();

	loopAnim('breath');

	TimeUntilNextFire = DelayBetweenAttacks[ eCrabSize ] + 1.0;

	if( bFollowPatrolPoints )
		GotoState('patrol');
	else
		gotostate('PatrolForHarry');

}

//*************************************************************************************************************************
//state PatrolBackToPen
//{
//  begin:
//	GotoState('patrol');
//
//  wait:
//	Sleep(1);
//	goto 'wait';
//}

//*************************************************************************************************************************
// BaseChar::patrol calls this when you get to your station destination
function PawnAtStation()
{
	bLookForHarry = false;
	vOriginalLoc = Location;
	WanderDistance = 50;
	bOutsideOfTether = false;

	GotoState('PatrolForHarry'); //He wont be shooting at him though

	//Send trigger to the fire crab counter
	//foreach allActors(class'baseHarry', p, firecrabcounter)
	//{
		playerHarry.clientMessage("FireCrabCounter trigger");
		//Trigger();
		TriggerEvent( 'firecrabcounter', self, self );
	//	break;
	//}

}

//*************************************************************************************************************************
state TurnToNewDir
{
	function Tick(float DeltaTime)
	{
	}

  begin:
	loopAnim('breath');

  wait:
	sleep( 0.5 );
		
	TurnTo( location + vMoveDir );
	gotostate('PatrolForHarry');
	goto 'wait';

}

//	PlaySound(sound 'own_good', SLOT_Interact, 3.2, false, 2000.0, 1.0);
//	PlaySound(sound 'please', SLOT_Interact, 3.2, false, 2000.0, 1.0);
//	PlaySound(sound 'own_good', SLOT_Interact, 3.2, false, 2000.0, 1.0);
//	PlaySound(sound 'student', SLOT_Interact, 3.2, false, 2000.0, 1.0);

//*************************************************************************************************************************
state attackHarry
{
	function Tick(float DeltaTime)
	{
	}

  begin:

	// AE:
	PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_SeeHarry', SLOT_none);

	loopAnim('breath');
	velocity = vect(0,0,0);
	acceleration = vect(0,0,0);

  wait:
	TurnTo(Location + Location-playerHarry.Location);
	Sleep( 0.05 );
	gotostate('throwing');
	goto 'wait';

}

//*************************************************************************************************************************
state throwing
{
	function Tick(float DeltaTime)
	{
	}

	begin:
		if( Rand(4) == 0 )
			NumShots = 3 + Rand(2);
		else
			NumShots = 1;

		while( NumShots > 0 )
		{
			TurnTo( Location + (Location - playerHarry.Location) );

			loopAnim('attack');
			finishanim();
			//PlaySound(sound'HPSounds.Critters_sfx.firecrab_attack', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );

			AE:
			switch( Rand(3) )
			{
				case 0: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Blast_07', SLOT_none); break;
				case 1: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Blast_08', SLOT_none); break;
				case 2: PlaySound( sound'HPSounds.firecrab_sfx.Fire_Crab_Blast_09', SLOT_none); break;
			}

			target=playerHarry;
			//You dont see the crab rotate 180, but it makes the projectile come out his ass...
			SetRotation( Rotation + rot(0,32768,0) );
			baseWand(weapon).CastSpell( none /*playerHarry*/ );
			SetRotation( Rotation + rot(0,32768,0) );
			//baseWand(weapon).LastCastedSpell.target = none;  //no autotargetting
			loopAnim('throwobject2');
			finishanim();

			NumShots--;
		}

		TurnTo( Location + vMoveDir );

		//gotostate('attackHarry');

		vMoveDirRot = Rotation;
		vMoveDir = vector( vMoveDirRot );

		if( bFollowPatrolPoints )
		{
			//Turn back towards the PatrolPoint you're currently moving to
			TurnTo( navP.Location );

			GotoState('patrol');
		}
		else
		{
			gotostate('PatrolForHarry');
		}
}

//*************************************************************************************************************************

defaultproperties
{
     HitCount=4
     bLookForHarry=True
     WanderDistance=50
     bMoveAround=True
     fAttackRange=400
     eCrabSize=CRAB_MEDIUM
     CrabGroundSpeed(0)=60
     CrabGroundSpeed(1)=80
     CrabGroundSpeed(2)=100
     DelayBetweenAttacks(0)=2
     DelayBetweenAttacks(1)=1.5
     DelayBetweenAttacks(2)=1
     iNumSpellHitsToFlip=2
     fTimeSpentOnBack=5
     fWakeupDistance=200
     bFlipTarget=True
     WalkAnimName=Breath
     IdleAnimName=None
     GroundSpeed=60
     AirSpeed=60
     AccelRate=4000
     BaseEyeHeight=20
     EyeHeight=20
     MenuName="FireCrab"
     eVulnerableToSpell=SPELL_Flipendo
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HarryPotter.skfirecrabMesh'
     DrawScale=2
     bProjTarget=True
     Mass=130
}
