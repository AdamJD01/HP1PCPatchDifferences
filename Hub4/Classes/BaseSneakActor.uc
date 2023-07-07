// BaseSneakActor - encapsulates common code for SneakFilch and SneakNorris.
//	This is a "virtual class" - it's not meant to be used per se in the game
// Author - Tyler Durden

class BaseSneakActor extends baseChar;

// These are so we can keep track of the running speed and animations, since these characters vary between
//	walking and running pretty often...
var int OldGroundspeed;			// The Original Walk Speed
var () int RunningSpeed;			// The Speed at which this character Runs
var float OldYaw;				// A variable that we can use to do a StopMoving with, by buffering their Old Yaw...

var SneakBaseStation LastBaseStation;		// The Basestation that we're currently running to
var vector			 CurrentRunToLocation;	// The location of the newest SneakNode or BaseStation that we're rushing to
var SneakToStationNavPoint NearestPathNode;


var () float fOnStoneDistance;	// How far away can we hear Harry if he's walking on Stone?
var () float fOnWoodDistance;	// How far away can we hear Harry if he's walking on Wood?
var () float fOnCarpetDistance;	// How far away can we hear Harry if he's walking on Carpet?

var () bool	bSneakActive;		// Are we in Sneak Mode?  Set this to false to make this character Dormant.

//*********************************************************************************************
// function PostBeginPlay - Set up all the pre game stuff
function PostBeginPlay()
{
	OldGroundspeed = groundspeed;
}


// HandleCutscene Stuff with these two Overloads
function CutCapture()
{
	groundspeed = OldGroundspeed;	// Make sure he's walking
	CutSaveState=GetStateName();
}

function CutRelease()
{
	gotostate(CutSaveState);
}


function RunToPredeterminedPointStartHack()
{
	// do nothing
}

// ************************************************************************************************
// function RunToFixedLocation - Runs The Sneak Guy to the "watch point" specified for whichever BaseStation
//	triggered him.  Sets a bunch of variables and sends the Sneak Actor into an alternative mode of the
//	patrol function.
function RunToPredeterminedPoint(SneakBaseStation SBS)
{
	local SneakToStationNavPoint TempPathNode;
	local float TempPathDistance;
	local float NearestPathDistance;
	local name BaseStationName;
	
	// Initialize the Data
	LastBaseStation = SBS;
	BaseStationName = SBS.Name;

	// We need to find the nearest Path Point, so we set the PathDistance horribly out of range
	NearestPathDistance = 99999999;
	NearestPathNode = None;

	playerHarry.clientMessage("BaseSneakActor Went To RunToPredeterminedPoint for station "@BaseStationName);

	// Now we search for the nearest tracable SneakToStationNavPoint
	foreach AllActors( class 'SneakToStationNavPoint', TempPathNode )
	{
		if(FastTrace(TempPathNode.location))	// Can we get there?
		{
			TempPathDistance = VSize (self.location - TempPathNode.location);	// Range Check
			if(TempPathDistance < NearestPathDistance)	
			{
				if(TempPathNode.HasPathForBaseStation(BaseStationName))	// If it doesn't have a path to
				{															// the basestation, it's useless
					NearestPathDistance = TempPathDistance;	// Adjust Low Bound of Distance
					NearestPathNode = TempPathNode;		// Set this one as the first
				}	
			}
		}
	}

	if(NearestPathNode == None)	// If we didn't get a node, then we gracefully return to the Patrol state.
	{
		playerHarry.clientMessage("Failed to find Nearest SneakToStationNavPoint");
		loopanim('walk');
		gotostate('patrol');
		return;
	}
	else // We need this because all functions execute all the way throught before exiting...
	{
		RunToPredeterminedPointStartHack();
		playerHarry.clientMessage("Sneak Actor is Running To First "@ NearestPathNode.Name);
		CurrentRunToLocation = NearestPathNode.location;
		bFollowPatrolPoints=false;
		groundspeed = RunningSpeed;
		loopanim('run');
		gotostate('RuningToStation');
		return;
	}
}

function RunToNextPoint()
{
	local name NextNodeName;
	local SneakToStationNavPoint TempPathNode;

	// Sanity check to make sure we're almost there
//	if(vsize(location-CurrentRunToLocation) > 16 )	// This is stupid to hardcode, but we're being pedantic here
//	{
//		playerHarry.clientMessage("BSN Failed Location Proximity Test");
//		gotostate('RuningToStation');
//			return;	
//	}

	// Check if the place we're at can get us to the Basestation
	if(NearestPathNode.CanGetDirectlyToBaseStationFromHere(LastBaseStation.Name))
	{
		playerHarry.clientMessage("Sneak Actor is Running Directly To "@ LastBaseStation.Name);
		CurrentRunToLocation = LastBaseStation.location;
		bFollowPatrolPoints=false;
		groundspeed = RunningSpeed;
		gotostate('RuningToStation');
		return;
	}
	else	// Otherwise, find the next node...
	{
		NextNodeName = NearestPathNode.ReturnNextPathNodeNameForStation(LastBaseStation.Name);

		TempPathNode = None;

		foreach AllActors( class 'SneakToStationNavPoint', TempPathNode )
		{
			if(TempPathNode.Name == NextNodeName)
			{
				NearestPathNode = TempPathNode;
				break;
			}
		}
		
		if(NearestPathNode != None)
		{
			if(NearestPathNode.HasPathForBaseStation(LastBaseStation.Name))
			{
				playerHarry.clientMessage("Sneak Actor is Running To "@ NearestPathNode.Name);
				CurrentRunToLocation = NearestPathNode.location;
				bFollowPatrolPoints=false;
				groundspeed = RunningSpeed;
				gotostate('RuningToStation');
				return;
			}
			else
			{
				playerHarry.clientMessage("Fell Through to Patrol");

				// Didn't find a path to Run...
				bFollowPatrolPoints=true;
				groundspeed = OldGroundSpeed;
				loopanim('walk');
				gotostate('patrol');
				return;
			}
		}
		else
		{
			playerHarry.clientMessage("Fell Through to Patrol");

			// Didn't find a path to Run...
			bFollowPatrolPoints=true;
			groundspeed = OldGroundSpeed;
			loopanim('walk');
			gotostate('patrol');
			return;
		}
	}
}


function PostPawnAtPatrolPoint(PatrolPoint CurrentP, PatrolPoint NextP)
{
	Super.PostPawnAtPatrolPoint(CurrentP, NextP);

	if( CurrentP.PatrolAnim == 'breathe' )
	{
		DesiredRotation = CurrentP.rotation;
		gotostate('Idle');
	}
}

//***********************************************************************************************
// function RevealHarry - Take away Harry's cloak, which fades him to visible
function RevealHarry()
{
	local InvisibleHarry	InvisHarry;

	foreach allActors(class'InvisibleHarry', InvisHarry)
	{
		if( InvisHarry.bIsPlayer&& InvisHarry!=Self)
		{
			playerharry.clientmessage("Revealed Harry");
			InvisHarry.bHasCloak = false;
			break;
		}
	}
}

function DormantCheckTick()
{
	if(bSneakActive == false)
		gotostate('Dormant');
}

// *************************************************************************
// FindHarryTick - Pretty Much all the Tick Functions execute this code...
//	Subclasses must implement the following states:
//		RunLocation
//		Caught
// *************************************************************************
function FindHarryTick(float DeltaTime)
{
	local InvisibleHarry	InvisHarry;
	local Texture		HitTexture;

	// Figure out what Harry is doing...
	if(cansee(playerHarry))
	{
		// If Harry didn't pick up the Cloak...
		if(playerHarry.Opacity >= 0.8)
		{
			playerHarry.clientMessage("BaseSneakActor went to state RunLocation");
			gotostate('RunLocation');
		}
	}
	
	if (playerHarry.IsInState('playeraiming'))	// Must be casting a spell
	{
		if(cansee(playerHarry))
		{
			// Change to instant caught

			playerHarry.clientMessage("Trace To Harry");
			gotostate('Caught');
		}
	}
	
	// Is Harry moving, and thus making noise?  How do we test this?
	
	foreach allActors(class'InvisibleHarry', InvisHarry)
	{
		if( InvisHarry.bIsPlayer&& InvisHarry!=Self)
		{
			// We can only hear him if he's moving
			if(InvisHarry.IsMoving)
			{
				// If so, how what surface is he on, and how far away is he?

				HitTexture = InvisHarry.HitTexture;

				if(HitTexture.FootstepSound == FOOTSTEP_Wood)
				{
					if(vsize(location-playerHarry.location) < fOnWoodDistance)
					{
						playerharry.clientmessage("BaseSneakActor says 'I hear you on Wood, Potter!'");				
						gotostate('RunLocation');
					}
				}
				else if(HitTexture.FootstepSound == FOOTSTEP_Rug)
				{
					if(vsize(location-playerHarry.location) < fOnCarpetDistance)
					{
						playerharry.clientmessage("BaseSneakActor says 'I hear you on Rug, Potter!'");	
						gotostate('RunLocation');
					}
				}
				else if(HitTexture.FootstepSound == FOOTSTEP_Stone)
				{
					if(vsize(location-playerHarry.location) < fOnStoneDistance)
					{
						playerharry.clientmessage("BaseSneakActor says 'I hear you on Stone, Potter!'");	
						gotostate('RunLocation');
					}
				}
			}
		}
	}
}

event Trigger( Actor Other, Pawn EventInstigator )
{
	bSneakActive = !bSneakActive;
	
	playerharry.clientmessage("Toggled Dormant for " @ self.Name);
}

//**************************************************************************************************
// STATES ******************************************************************************************
//**************************************************************************************************

// It starts out in this state and not Patrol so we can activate this guy with a trigger and let
//	other instances of it sit there like rocks when Harry's not in the room
auto state Dormant
{
	function Tick(float DeltaTime)
	{
		if(bSneakActive)
			gotostate('patrol');

		Super.Tick(DeltaTime);
	}

begin:
	loopanim('breathe');
	groundspeed = OldGroundSpeed;

loop:
	Sleep(1);
	goto 'loop';
}


// **********************************************************************************************
// state RunningToStation - 
state RuningToStation
{
//	function HitWall (vector HitNormal, actor Wall)
//	{
//		groundspeed = OldGroundspeed;
//		
//		gotostate('LookAround');
//	}

	function bump(actor other)
	{	
		if(other==playerHarry)
		{
			disable('bump');
			// Give some kind of Patronizing "Caught" Remark.
			gotostate('Caught');
		}
	}

	// Tick for Patrol has to check all this stuff on Harry...
	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		DormantCheckTick();

		FindHarryTick(DeltaTime);

	}

	function EndState()
	{
		Acceleration = Vect(0,0,0);
		Velocity = Vect(0,0,0);
	}

begin:
	loopanim('run');
	groundspeed = RunningSpeed;
	playerharry.clientmessage("Sneak Actor is Moving to New Station");
	moveto(CurrentRunToLocation);		// Latent Function, returns when at Location
	playerharry.clientmessage("Sneak Actor Has Reached New Station");

	if(CurrentRunToLocation == LastBaseStation.location)
	{
		// we're at the destintation!!!  Do the Destination Stuff
		bFollowPatrolPoints=true;
		groundspeed = OldGroundSpeed;
		
		// Set the Patrol Point to the New Path...
		firstPath = '';
		firstPatrolPointObjectName = '';
		firstPatrolPointTag = LastBaseStation.NextPatrolPoint;

		foreach allActors(class 'navigationPoint',navP)
		{
			if(navP.Name==firstPatrolPointTag)
			{
				bGoBackToLastNavPoint = false;
				break;
			}
		}

		gotostate('LookAround');
	}
	else
	{
		RunToNextPoint();
		goto('begin');
	}
}

//*************************************************************************************************************
//	state Patrol - Patrol will follow Nav Points laid down, unless the Sneak Character is
//	triggered by the RunToPredeterminedPoint function (called by a SneakBaseStation).  In this case, we
//	switch to a new state to handle that pathfinding...
//		We have some overloaded functions to take care of Bumping into Harry here and detecting him on a Tick...
//
state patrol
{
//	function HitWall (vector HitNormal, actor Wall)
//	{
//		groundspeed = OldGroundspeed;
//		
//		gotostate('LookAround');
//	}

	function bump(actor other)
	{	
		if(other==playerHarry)
		{
			disable('bump');
			// Give some kind of Patronizing "Caught" Remark.
			gotostate('Caught');
		}
	}

	// Tick for Patrol has to check all this stuff on Harry...
	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		DormantCheckTick();

		FindHarryTick(DeltaTime);

	}

	function EndState()
	{
		Super.EndState();
		Acceleration = Vect(0,0,0);
		Velocity = Vect(0,0,0);
	}

	// Run rest of state in BaseClass
}

// *** RunLocation - This state is for when BaseSneakActor Detects Harry.
//		He'll run over to the position where he heard Harry, and move to
//		the Look Around state if he doesn't immediately bump into Mr. Potter
state RunLocation
{
	function Tick(float DeltaTime)	// Overloaded so we can run the Find Harry and Dormant Funtions
	{
		Super.Tick(DeltaTime);
		
		DormantCheckTick();

		FindHarryTick(DeltaTime);
	}


	// If he hits a wall before he gets to Harry's Location, check if Harry is on a Bookshelf within site...
	//	This will have to be tweaked for gameplay?
	function HitWall (vector HitNormal, actor Wall)
	{
		groundspeed = OldGroundspeed;

		// We really want to check for some other stuff here, like if he actually caught him...
		gotostate('LookAround');
		
	}

	function bump(actor other)
	{	
		if(other==playerHarry)
		{
			disable('bump');

			// Give some kind of Patronizing "Caught" Remark.
			groundspeed = OldGroundspeed;
			gotostate('Caught');
		}
	}

Begin:
	// Make the Run Speed Really Fast
	groundspeed = RunningSpeed;

	loopanim('run');

	moveto(playerHarry.location);

	groundspeed = OldGroundspeed;

	gotostate('LookAround');
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

	function BeginState()
	{
		Acceleration = Vect(0,0,0);
		Velocity = Vect(0,0,0);
	}

begin:

	groundspeed = OldGroundspeed;

	if(CurrentRunToLocation == LastBaseStation.location)
	{
		SetRotation(LastBaseStation.rotation);
	}

	loopanim('look');
	playerharry.clientmessage("BaseSneakActor says 'Who's there?  Peeves, is that you?'");
	Sleep(3.0);
	finishanim();

	if(bFollowPatrolPoints)
		gotostate('patrol');
	else
		RunToPredeterminedPoint(LastBaseStation);
}

state Idle
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
	
	loopanim('breathe');
LoopHere:
	Sleep(1.0);
	goto('LoopHere');
}

//***************************************************************************************
// state Caught - Base Class Instance.  Derived classes will override this with their
//	own custom animations and speech.
state Caught
{
begin:
loop:
	playerharry.clientmessage("Stuck in BaseSneakActor Caught");
	Sleep(1);
	goto('loop');

}	

// *********************************************************************8
// defaultproperties - the default settings for this Character

defaultproperties
{
     RunningSpeed=150
     fOnStoneDistance=192
     fOnWoodDistance=192
     fOnCarpetDistance=64
     bSneakActive=True
     bStopAtLedges=True
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HarryPotter.skfilchMesh'
}
