class VenomousTent1 expands baseChar;

enum enumVTType
{
	VTTYPE_SMALL,
	VTTYPE_LARGE,
};

var() enumVTType eVTType;

var() float      fAffectVT2sInThisRange;

var() name       VT_1_2_LinkName;   //"links" a vt1 and multiple vt2 together

var() float      WiltTime;
var() float      WiltTimeMax;

var() float      StunTime;
var() float      StunTimeMax;
var   float      StunTimer;

//*************************************************************************************************************************
function PostBeginPlay()
{
	//SetPhysics( PHYS_None );

}

//*************************************************************************************************************************
function HandleIncendioSpell()
{
	local VenomousTent2 a;

	//Find vt2's that are close, and pass the spell hit along
	foreach AllActors(class'VenomousTent2', a)
	{
		if( VT_1_2_LinkName == '' )
		{
			if( VSize( a.Location - Location ) < fAffectVT2sInThisRange )
				a.HandleIncendioSpell();
		}
		else
		{
			if( a.VT_1_2_LinkName == VT_1_2_LinkName )
				a.HandleIncendioSpell();
		}
	}

	
	if( eVTType == VTTYPE_SMALL )
	{
		StunTimer = FMin( StunTimer + WiltTime, WiltTimeMax );

		//Play wilt and die anim/state
		if( !IsInState('stateWiltAndComeBack') )
			GotoState('stateWiltAndComeBack');
	}
	else //large
	{
		//state stunned.  anim and what not...
		if( IsInState('stateStunned') )
			StunTimer = FMin( StunTimer + StunTime, StunTimeMax );
		else
		if( !IsInState('stateStunRetract') )
			GotoState('stateStunRetract');
	}
}

//*************************************************************************************************************************
auto state patrol
{
	function bump(actor other)
	{
		//	PlaySound(sound 'filch', SLOT_Interact, 3.2, false, 2000.0, 1.0);
		//	playerHarry.clientMessage(self $":" $other $" touched me!");
		//playerHarry.clientMessage(self $":touch");
		//gotostate('attackHarry');
		if(   other == playerHarry
		   && !IsInState('stateWiltAndComeBack')
		   && !IsInState('stateStunRetract')
		   && !IsInState('stateStunned')
		   && !IsInState('stateStunGoBackOut')
		  )
		{
			playerHarry.clientMessage(self $":touch");

			if( !playerHarry.IsInState('hit') )
			{
				playerHarry.TakeDamage( 5, none, Location, Vect(0,0,0), '');
				
				//Totally temp, move harry back abit
				//playerHarry.SetLocation( Location + (OldLocation-Location)/4 );
				//playerHarry.SetLocation( playerHarry.Location - playerHarry.Velocity/5 );
				playerHarry.Velocity = Vect(0,0,0);
				playerHarry.Acceleration = Vect(0,0,0);
			}
		}
	}

  Begin:
	AirSpeed=500;

	if( idleAnimName != '' )
		loopanim( idleAnimName );
	else
		loopanim('idle');

	//loopAnim('idlefast');

  actionloop:

	sleep(1);
	goto 'actionloop';
}

//*************************************************************************************************************************
state stateWiltAndComeBack
{
  Begin:
	PlayAnim('idle', , 1.0);
	FinishAnim();

	SetCollision( false, false, false );

  Loop:
	LoopAnim('idle');
	Sleep(0.5);
	StunTimer -= 0.5;

	if( StunTimer > 0 )
		Goto 'Loop';

	PlayAnim('idle');
	FinishAnim();

	SetCollision( true, false, true );

	GotoState('patrol');
}

//stun
//stunned
//wakeup

//*************************************************************************************************************************
state stateStunRetract
{
  Begin:
	PlayAnim('idle', , 1.0);
	FinishAnim();
	StunTimer = StunTime;
	GotoState('stateStunned');
}

state stateStunned
{
  Begin:
	LoopAnim('idle');
	Sleep(0.5);
	StunTimer -= 0.5;

	if( StunTimer > 0 )
		goto 'Begin';

	GotoState('stateStunGoBackOut');
}

state stateStunGoBackOut
{
  Begin:
	PlayAnim('idle');
	FinishAnim();
	GotoState('patrol');
}

defaultproperties
{
     fAffectVT2sInThisRange=60
     WiltTime=3
     WiltTimeMax=6
     StunTime=3
     StunTimeMax=8
     GroundSpeed=770
     AirSpeed=700
     AccelRate=4000
     MenuName="VenomousTentacular1"
     eVulnerableToSpell=SPELL_Incendio
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HarryPotter.skvenomous1Mesh'
     CollisionRadius=70
     CollisionHeight=42
     bProjTarget=True
     Mass=130
}
