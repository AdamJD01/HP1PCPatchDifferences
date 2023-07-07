// SneakNorris Class - used to detect "invisible Harry" walking around level...
// author - Paul J. Furio	


class sneaknorris extends BaseSneakActor;

var		float  fJumpZ;
var		float  JumpAnimSpeed;
var()	float  fJumpHorizSpeed;
var()	float  fJumpVertSpeed;
var()	float  fJumpAnimMultiplier;
var		float  fShortestDestDistance;

var()		float	fCatGravity;

var()	bool	bCalcTrajectory;
var		bool	bForceCalc;

var Vector JumpMoveVector;

var		vector		JumpOriginLocation;
var		PatrolPoint JumpOrigin;
var		PatrolPoint JumpDest;
var		bool	bJumpAligned;

// Mrs Norris Jumps, and as a result, we have to write some special code to handle her jumping...
function PerformJump()
{
	local float     s;
	local float		ftempX;
	local float		ftempY;
	local float		ftempZ;
	local float		fDeltaTime;
	local float		fDeltaZ;
	local float		fDeltaX;
	local float		TimeInAirScalar;
	local float		fTweakFactor;



	playerharry.clientmessage("Ms. Norris entered Perform Jump");

	ftempX = 0.0;
	ftempY = 0.0;
	ftempZ = 0.0;

	fTweakFactor = 0.5;

	if((bCalcTrajectory)||(bForceCalc))
	{
		fDeltaX = abs(JumpOriginLocation.x - JumpDest.location.x);
		fDeltaZ = JumpDest.location.z - JumpOriginLocation.z;

		ftempX = 240;	// Hack
		fDeltaTime = fDeltaX/ftempX;
		
		if(fDeltaZ > 0)
		{
			// Solve for the initial Vertical Jump Speed
			ftempZ = (fDeltaZ + (( 0.5 * fCatGravity) * (fDeltaTime*fDeltaTime))) / fDeltaTime;
		}

		if(ftempZ < 0)
			ftempZ = 0;

	//	if(!FastTrace(JumpDest.location))
	//	{
	//		playerharry.clientmessage("Ms. Norris Tweaked Up Jump Factor");
	//		fTweakFactor = 3;
	//	}

		ftempZ += fTweakFactor;	// Tweak so the cat always jumps slightly upwards

		playerharry.clientmessage("Calculated Z as "@ ftempZ);
	}
	else //Look for values set in the actual PatrolPoint object
	{
		if( JumpOrigin.fJumpHorizSpeed > 0 )
			ftempX = JumpOrigin.fJumpHorizSpeed;
		else
			ftempX = fJumpHorizSpeed;

		if( JumpOrigin.fJumpVertSpeed > 0 )
			ftempZ = JumpOrigin.fJumpVertSpeed;
		else
			ftempZ = fJumpVertSpeed;
	}

	JumpMoveVector.x = ftempX;
	JumpMoveVector.y = ftempY;
	JumpMoveVector.z = ftempZ;
//	JumpMoveVector = vect(0,0,0);

	// Normalizes to the Orientation of the Cat
	JumpMoveVector = JumpMoveVector >> Rotation;

	playerharry.clientmessage("Ms. Norris' X Velocity is " @ ftempX);
	playerharry.clientmessage("Ms. Norris' Z Velocity is " @ ftempZ);

	TimeInAirScalar = ftempZ / default.fJumpVertSpeed;

	if(JumpOrigin != None)
	{
		if( JumpOrigin.fJumpAnimMultiplier > 0 )
			s = JumpOrigin.fJumpAnimMultiplier;
		else
			s = fJumpAnimMultiplier;
	}

	JumpAnimSpeed = 0.25/TimeInAirScalar * s;

//	Acceleration = vec(0, 0, 0); //- fJumpGravityBoost;

	fJumpZ = Location.z;

	bJumpAligned = true;

	SetPhysics( PHYS_None );

	playerharry.clientmessage("Ms. Norris finished Perform Jump");

	fShortestDestDistance == vsize(location - JumpDest.location);	// Store this for overshoot calcs

	// PlaySound( Sound'HPSounds.magic_sfx.s_wand_wave', [Radius]2000 );//, [Pitch]RandRange(0.6, 0.65));

	//Tick will now check for when we land...
}


//** PostPawnAtPatrolPoint - Stolen from Fraiser
function PostPawnAtPatrolPoint(PatrolPoint CurrentP, PatrolPoint NextP)
{
	Super.PostPawnAtPatrolPoint(CurrentP, NextP);

	if( CurrentP.PatrolAnim == 'jump' )
	{
		JumpOrigin = CurrentP;
		JumpOriginLocation = JumpOrigin.Location;
		JumpDest = NextP;
		bJumpAligned = false;
		playerharry.clientmessage("Ms. Norris is at Jump Point");
		GotoState('stateJump');
	}
	else
	{
		if(Rand(20) == 1)	// Do a Lookaround
		{
			gotostate('LookAround');
		}
	}

}




//*******************************************************************************
state stateJump
{
	//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	event Tick(float dtime)
	{
		if(fShortestDestDistance < vsize(location - JumpDest.location))
			fShortestDestDistance = vsize(location - JumpDest.location);

		if(bJumpAligned)	// We're facing the right direction, so we can start moving
		{
			if(vsize(location - JumpDest.location) > 32 )	// Not at the Dest Yet
			{
				// Do a MoveSmooth to get the character to their position
				MoveSmooth(JumpMoveVector * dtime);


				//Now Adjust the JumpMoveVector for the next tick..
				JumpMoveVector.z = (JumpMoveVector.z - (fCatGravity * dtime ));
			}
			else if((vsize(location - JumpDest.location) - fShortestDestDistance) > 64)
			{
				// Overshot our target, do a transition
				playerharry.clientmessage("Ms. Norris going from Jump to Patrol");

				SetPhysics( PHYS_Walking );

				bJumpAligned = false;
				navP = JumpDest;
				GotoState('patrol');
			}
			else // At the destination, do the transition to Patrol
			{
				playerharry.clientmessage("Ms. Norris going from Jump to Patrol");

				SetPhysics( PHYS_Walking );

				bJumpAligned = false;
				navP = JumpDest;
				GotoState('patrol');
			}
		}
	}

	function HitWall (vector HitNormal, actor Wall)
	{
		playerharry.clientmessage("Ms. Norris hit a wall, autotransition to Patrol");

		SetPhysics( PHYS_Walking );

		bJumpAligned = false;
		navP = JumpDest;
		GotoState('patrol');
	}

	function bump(actor other)
	{	
		if(other==playerHarry)
		{
			SetPhysics( PHYS_Walking );
			disable('bump');
			// Give some kind of Patronizing "Caught" Remark.
			gotostate('Caught');
		}
	}

	//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	function EndState()
	{
		bForceCalc=false;
		PlayAnim('jump2stand', JumpAnimSpeed, 0.1);
	}

begin:
	TurnToward(JumpDest);
	playanim('stand2jump');
	Sleep(0.5);
	PerformJump();
	finishanim();
	loopanim('jump');
	playerharry.clientmessage("Ms. Norris is looping anim Jump");
LoopPoint:
	Sleep(0.1);
	goto('LoopPoint');
}


// *** LookAround - If BaseSneakActor doesn't bump into Harry during RunLocation or Patrol, he'll stand around
//		"looking" to see what's up.  Bump is still active here...
state LookAround
{
	function bump(actor other)
	{	
		if(other==playerHarry)
		{
			disable('bump');
			// Give some kind of Patronizing "Caught" Remark.
			gotostate('Caught');
		}
	}

	function Tick(float DeltaTime)
	{
		// Figure out what Harry is doing...
		Super.Tick(DeltaTime);
		DormantCheckTick();	
		FindHarryTick(DeltaTime);
	}

begin:

	groundspeed = OldGroundspeed;

	if(CurrentRunToLocation == LastBaseStation.location)
	{
		DesiredRotation = LastBaseStation.rotation;

	}

	switch(Rand(6))
	{
	case 0:
		PlaySound(sound 'HPSounds.critters2_sfx.msnorris_hiss', SLOT_Talk, 3.2, true, 2000.0, 1.0);
		break;
	case 1:
		PlaySound(sound 'HPSounds.critters2_sfx.msnorris_screech', SLOT_Talk, 3.2, true, 2000.0, 1.0);
		break;
	}

	loopanim('look');
	playerharry.clientmessage("Ms. Norris looks around");
	Sleep(3.0);
	finishanim();

	if(bFollowPatrolPoints)
	{
		if(abs(NavP.Location.Z - location.Z) > 64)
		{
			JumpOrigin = None;
			JumpOriginLocation = Location;
			JumpDest = PatrolPoint(NavP);
			bForceCalc=true;
			gotostate('stateJump');
		}
		else
		{
			gotostate('patrol');
		}
	}
	else
		RunToPredeterminedPoint(LastBaseStation);
}



state Caught
{
Begin:
	
	groundspeed = OldGroundspeed;

	// Stop Moving
	OldYaw = rotationrate.yaw;
	rotationrate.yaw = 0.0;
	moveto(location);
	rotationrate.yaw = OldYaw;

	// Take control of Harry from the player...
	playerharry.gotostate('harryfrozen');
	playerharry.turntoward(self);

	// Make Harry visible
	RevealHarry();

	turntoward(playerHarry);

	playanim('hiss');
	PlaySound(sound 'HPSounds.critters2_sfx.msnorris_hiss', SLOT_Talk, 3.2, true, 2000.0, 1.0);

	// Play some "I caught You sound here..."
	playerharry.clientmessage("Mrs. Norris says 'I got you, Potter!'");
	finishanim();

	playanim('stand2sit');
	finishanim();

	loopanim('sit');

killloop:
	Sleep(1.0);

	playerHarry.KillHarry(true);
	goto('killloop');
	// Give some kind of Patronizing "Caught" Remark.
	// Kill Player, force reload...
}	

defaultproperties
{
     fJumpHorizSpeed=400
     fJumpVertSpeed=700
     fJumpAnimMultiplier=3
     fCatGravity=750
     bCalcTrajectory=True
     fOnWoodDistance=384
     fOnCarpetDistance=128
     GroundSpeed=60
     Mesh=SkeletalMesh'HarryPotter.skmrsnorrisMesh'
     CollisionRadius=30
     CollisionHeight=30
     bProjTarget=True
}
