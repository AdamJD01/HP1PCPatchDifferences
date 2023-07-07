class VenomousTent2 expands baseChar;

var int hitCount;
var sound peevesVoice;

var() bool          bIndividuallyTargetable;
var   VenTent2Head  aHead;

//var() float fAttackPeriod;
//var() int   iDoubleLungeFreq;
var() float fStartDelay;

var bool	bFirstHit;

//***********8

//	array time delays, and animation speed multiplier 6 of em, 0 ends.
struct VTtimingData
{
	var()  float fPeriod;
	var()  float fAnimSpeed;
};

var   int          iTimingDataIdx;
const VT_NUM_TIMING_DATA = 6;
var() VTtimingData timingData[6];

var float fAnimSpeed;

//var() float

var float fWaitTimer;
var int   iLungeCount;

var bool  bGotoIdleState;

var() float fHeadExtendTime;
var() float fAttackRadiusFromMouth;
var() float fAttackDistanceToMouth;
var() float fIdleAttackDistanceToMouth; //sphere touches colcyl if this is zero, pos values then move the sphere outward.
var() float fIdleRadiusFromMouth;

var() float WiltTime;
var() float WiltTimeMax;

var() float StunTime;
var() float StunTimeMax;
var   float StunTimer;

enum enumVTType
{
	VTTYPE_SMALL,
	VTTYPE_LARGE,
};

var() enumVTType eVTType;

var() name       VT_1_2_LinkName;  //"links" a vt1 and multiple vt2 together

var   float      fCloseRangeCheckTimer;

var() int        iVTDamageAmount;

var   int        OriginalYaw;
var() int        DegreeRotateRange;
var() int        RotateRange; // copied from DegreeRotateRange

var   sound      TmpSound;

//*************************************************************************************************************************
function PostBeginPlay()
{
	//local baseWand weap;
	//Super.PostBeginPlay();

	//weap=spawn(class'baseWand');
	//weap.BecomeItem();
	//AddInventory(weap);
	//weap.WeaponSet(self);
	//weap.GiveAmmo(self);
	//weap.SelectSpell(Class'spellEcto');

	//bCollideWorld = true;

	//SetPhysics(PHYS_none);

	//SetCollision( true, true, true );
	
	//SetCollisionSize( CollisionRadius*DrawScale, CollisionRadius*DrawScale );//float NewRadius, float NewHeight );
	//SetCollisionSize( 5, 5 );//float NewRadius, float NewHeight );

	if( idleAnimName != '' )
		loopanim( idleAnimName );
	else
		loopanim('idle');

	//loopanim('attack');

	fWaitTimer = -fStartDelay;

	OriginalYaw = Rotation.Yaw;

	RotateRange = DegreeRotateRange * 65536 / 360;

	//If this vt is Individually Targetable, spawn our target actor, and attach to the correct bone
	if( bIndividuallyTargetable )
	{
		eVulnerableToSpell = SPELL_None;
		bProjTarget = false;

		aHead = spawn(class'VenTent2Head', [SpawnOwner] self);
		aHead.AttachToOwner('Bone_Tent11');
	}

	bFirstHit = true;	// Haven't been hit yet

	//SetTimer( 0.033, true );
}

//*************************************************************************************************************************
event Trigger( Actor Other, Pawn EventInstigator )
{
	bGotoIdleState = true;
}

//*************************************************************************************************************************
event tick(float dtime)
{
	local rotator r;
	local int     YawDiff;

	fCloseRangeCheckTimer += dtime;
	if( fCloseRangeCheckTimer >= 0.07 )
	{
		fCloseRangeCheckTimer = 0;
		CheckForHarryHit( false );  //don't do a full range check, just next to the body
	}

	if( IsInState('stateLunge') || IsInState('stateActive') )
	{
		r = rotator( playerHarry.Location - Location );
		r.pitch = 0;
		r.roll = 0;

		YawDiff = (r.yaw - OriginalYaw) & 0xFFFF;

		if( YawDiff < 32768 )
		{
			if( YawDiff > RotateRange )
				r.yaw = OriginalYaw + RotateRange;
		}
		else
		{
			if( YawDiff < 0xFFFF - RotateRange )
				r.yaw = OriginalYaw - RotateRange;
		}

		DesiredRotation = r;

//playerHarry.Clientmessage("dr="$r$"  yaw="$Rotation.yaw);
	}
}

//*************************************************************************************************************************

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

//*************************************************************************************************************************
function HandleIncendioSpell()
{
	if (bFirstHit)
	{
		bFirstHit = false;
		SendTrigger();		// Trigger an event when it is hit for the first time
	}

	if( eVTType == VTTYPE_SMALL )
	{
		switch( Rand(2) )
		{
			case 0:   TmpSound = sound'HPSounds.Critters_sfx.vt_small_ouch1';      break;
			case 1:   TmpSound = sound'HPSounds.Critters_sfx.vt_small_ouch2';      break;
		}

		PlaySound( TmpSound, SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );

		StunTimer = FMin( StunTimer + WiltTime, WiltTimeMax );

		if( !IsInState('stateWiltAndComeBack') )
		{
			PlaySound( sound'HPSounds.Critters_sfx.vt_small_wilt', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );
			GotoState('stateWiltAndComeBack');
		}
	}
	else //type large
	{
		switch( Rand(3) )
		{
			case 0:   TmpSound = sound'HPSounds.Critters_sfx.vt_big_ouch1';      break;
			case 1:   TmpSound = sound'HPSounds.Critters_sfx.vt_big_ouch2';      break;
			case 2:   TmpSound = sound'HPSounds.Critters_sfx.vt_big_ouch3';      break;
		}

		PlaySound( TmpSound, SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );

		if( IsInState('stateStunned') )
		{
			StunTimer = FMin( StunTimer + StunTime, StunTimeMax );
		}
		else
		if( !IsInState('stateStunRetract') )
		{
			//PlaySound( sound'HPSounds.Critters_sfx.vt_big_wilt', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );
			PlaySound( sound'HPSounds.Critters_sfx.vt_small_wilt', SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );
			GotoState('stateStunRetract');
		}
	}
}

//*************************************************************************************************************************
event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	//	playerHarry.clientMessage(self $":I've been shot!");
	//	gotostate ('shot');
}

//*************************************************************************************************************************
state stateIdle
{
  Begin:
	loopAnim('idle');
	//loopAnim('idlefast');

  actionloop:

	sleep(1);
	goto 'actionloop';

}

//*************************************************************************************************************************
auto state stateActive
{
	function touch(actor other)
	{
		playerHarry.clientMessage(self $":touch");
	}

	function HitWall(vector HitNormal, actor Wall)
	{
	}

	function Tick(float DeltaTime)
	{
		local vector newloc;
		local actor  a;

		global.tick( DeltaTime );

		fWaitTimer += DeltaTime;

		if( bGotoIdleState )
		{
			bGotoIdleState = false;
			//GotoState('stateIdle');
			HandleIncendioSpell();
		}
		else
		{
			//if( fWaitTimer > fAttackPeriod )
			if( fWaitTimer > timingData[iTimingDataIdx].fPeriod )
			{
				fWaitTimer -= timingData[iTimingDataIdx].fPeriod;

				//Not sure if there's a max time slice that the engine allows
				if( fWaitTimer >= timingData[iTimingDataIdx].fPeriod )
					fWaitTimer = 0;

				GotoState('stateLunge');
			}
		}
	}

  Begin:
	AirSpeed=500;

	if( idleAnimName != '' )
		loopanim( idleAnimName );
	else
		loopanim('idle');

  actionloop:

	sleep(1);
	goto 'actionloop';
}

//*************************************************************************************************************************
state stateLunge
{
	//Keep the timing accurate while the anim is running
	function Tick(float DeltaTime)
	{
		global.tick( DeltaTime );
		fWaitTimer += DeltaTime;
	}

  Begin:
	fAnimSpeed = timingData[iTimingDataIdx].fAnimSpeed;
	if( fAnimSpeed == 0 )
		fAnimSpeed = 1;

	loopAnim( 'attack', fAnimSpeed );

	if( eVTType == VTTYPE_SMALL )
	{
		switch( Rand(5) )
		{
			case 0:   TmpSound = sound'HPSounds.Critters_sfx.vt_small_attack1';      break;
			case 1:   TmpSound = sound'HPSounds.Critters_sfx.vt_small_attack2';      break;
			case 2:   TmpSound = sound'HPSounds.Critters_sfx.vt_small_attack3';      break;
			case 3:   TmpSound = sound'HPSounds.Critters_sfx.vt_small_attack4';      break;
			case 4:   TmpSound = sound'HPSounds.Critters_sfx.vt_small_attack5';      break;
		}
	}
	else //large
	{
		switch( Rand(3) )
		{
			case 0:   TmpSound = sound'HPSounds.Critters_sfx.vt_big_attack1';      break;
			case 1:   TmpSound = sound'HPSounds.Critters_sfx.vt_big_attack2';      break;
			case 2:   TmpSound = sound'HPSounds.Critters_sfx.vt_big_attack3';      break;
		}
	}

	PlaySound( TmpSound, SLOT_none, RandRange(0.8, 1.0), [Pitch]RandRange(0.8, 1.1) );

  actionloop:

	//Sleep until the head is out
	
	sleep( fHeadExtendTime / fAnimSpeed );
	
	//See if you get harry
	CheckForHarryHit( true );  //true, full lunge check

	finishAnim();

	iTimingDataIdx++;
	if( iTimingDataIdx >= VT_NUM_TIMING_DATA )
		iTimingDataIdx = 0;

	if(   timingData[iTimingDataIdx].fAnimSpeed == 0
	   && iTimingDataIdx > 0
	  )
	{
		iTimingDataIdx = 0;
	}

	//do our double lunge check
	//iLungeCount++;
	//if( iLungeCount >= iDoubleLungeFreq )
	//{
	//	iLungeCount = 0;
	//
	//	loopAnim('attack');
	//	sleep( VT_HEAD_EXTEND_TIME );
	//
	//	CheckForHarryHit();
	//
	//	finishAnim();
	//}

	GotoState( 'stateActive' );	
	
	goto 'actionloop';

}

//*************************************************************************************************************************
state stateWiltAndComeBack
{
  Begin:
playerHarry.ClientMessage("stateWiltAndComeBack");
	PlayAnim('stun', , 1.0);
	FinishAnim();

	SetCollision( false, false, false );

  Loop:
	LoopAnim('stunned');
	Sleep(0.5);
	StunTimer -= 0.5;

	if( StunTimer > 0 )
		Goto 'Loop';

	PlayAnim('wakeup');
	FinishAnim();

	SetCollision( true, false, true );

	GotoState('stateActive');
}

//*************************************************************************************************************************
state stateStunRetract
{
  Begin:
	PlayAnim('stun', , 1.0);
	FinishAnim();
	StunTimer = StunTime;
	GotoState('stateStunned');
}

state stateStunned
{
  Begin:
	LoopAnim('stunned');
	Sleep(0.5);
	StunTimer -= 0.5;

	if( StunTimer > 0 )
		goto 'Begin';

	GotoState('stateStunGoBackOut');
}

state stateStunGoBackOut
{
  Begin:
	PlayAnim('wakeup');
	FinishAnim();
	GotoState('stateActive');
}

//*************************************************************************************************************************
// ~133 is start distance for vt attack distance

function CheckForHarryHit( bool bFullLungeCheck )
{
	local vector v, v2;
	local actor a;

	v = vector(Rotation);

	if( bFullLungeCheck )
	{
		v2 = v * fAttackDistanceToMouth * DrawScale;
		v2 += vect(0,0,25)*DrawScale; //Oops, bring the z up a bit

		if(   VSize( Location+v2       - playerHarry.Location ) < fAttackRadiusFromMouth*DrawScale
		   || VSize( Location+(v2*0.6) - playerHarry.Location ) < fAttackRadiusFromMouth*DrawScale
		  )
		{
			//PlaySound(sound 'HPSounds.peeves_sfx.pee_004', SLOT_Interact, 3.2, false, 2000.0, 1.0);

			if( !playerHarry.IsInState('hit') )
				playerHarry.TakeDamage( iVTDamageAmount, none, Location, Vect(0,0,0), '');
		}
	}
	else //Just check next to the body
	{
		if( !IsInState( 'stateWiltAndComeBack' ) )
		{
			v2 = v * (CollisionRadius + fIdleRadiusFromMouth*DrawScale + fIdleAttackDistanceToMouth*DrawScale);
			v2 += vec(0,0,20)*DrawScale; //Oops, bring the z up a bit (not neccessary)

			if(	VSize/*2d*/( Location+v2 - playerHarry.Location ) < fIdleRadiusFromMouth*DrawScale )
			{
				//PlaySound(sound 'HPSounds.peeves_sfx.pee_004', SLOT_Interact, 3.2, false, 2000.0, 1.0);

				if( !playerHarry.IsInState('hit') )
					playerHarry.TakeDamage( iVTDamageAmount, none, Location, Vect(0,0,0), '');
			}
		}
	}


}

//*************************************************************************************************************************

defaultproperties
{
     HitCount=4
     fStartDelay=1
     fHeadExtendTime=1.1
     fAttackRadiusFromMouth=20
     fAttackDistanceToMouth=110
     fIdleAttackDistanceToMouth=15
     fIdleRadiusFromMouth=30
     WiltTime=3
     WiltTimeMax=6
     StunTime=3
     StunTimeMax=8
     iVTDamageAmount=5
     DegreeRotateRange=20
     GroundSpeed=770
     AirSpeed=700
     AccelRate=4000
     MenuName="VenomousTentacular2"
     Physics=PHYS_Rotating
     eVulnerableToSpell=SPELL_Incendio
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HarryPotter.skvenomous2Mesh'
     CollisionRadius=5
     CollisionHeight=5
     bCollideWorld=False
     bBlockActors=False
     Mass=130
     RotationRate=(Yaw=15000)
}
