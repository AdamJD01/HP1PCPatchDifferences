class baseHarry expands PlayerPawn;

var bool clearMessages;

// The following inputs are in addition to the standard inputs defined in PlayerPawn.uc.
// Broom-flying inputs are given their own input channels here so they can be remapped
// independently of standard walk-and-look inputs.

// Input Axes
var input float
	aBroomYaw, aBroomPitch;			// Intended for mapping to mouse or analog joystick

// Input Buttons
var input byte
	bBroomYawLeft, bBroomYawRight,	// Intended for mapping to keyboard or digital gamepad
	bBroomPitchUp, bBroomPitchDown,
	bBroomBoost, bBroomBrake,
	bBroomAction;

// Input Configuration
var globalconfig bool
	bInvertBroomPitch,				// Reverses direction of broom pitch inputs (both buttons and axes)
	bAllowBroomMouse;				// Enables use of mouse for broom flight control


// Other new variables for Harry...
var bool hidden;
var int stillDistance;
var int movingDistance;
var int hiddenDistance;
var actor bustedBy;
var vector targetOffset;
var bool bMovingBackwards;
var actor focusActor;
var (movement)float turnRate;

var travel float lifePotions;
var float MaxLifePotions;
var int beansoundCount;


var float LessonScore;			// Used for spell lesson so HUD can easily get to value
var float LessonPass;
var int	  iLevelReached;
var int	  iLessonPoints;

var baseProps quickInventory;

var baseNarrator theNarrator;

// @PAB moved these from Harry
// @PAB added new camera target

var target    rectarget;
var CamTarget StandardTarget;
var bool      bExtendedTargetting;
var BaseCam   cam;

var bool      bLockedOnTarget;
var baseChar  BossTarget;

var bool      bCastFastSpells;     //Really just fast flipendo

var bool      bKeepStationary;     //This is a flag you can set to keep harry fixed. (He can still turn)

var bool      bFixedFaceDirection; //If this is true, only let harry face the direction set in vFixedFaceDirection.
var vector    vFixedFaceDirection;

var bool	  bStationary;      //This is more of a bIsStationary flag that you read.
var() bool	  bTargettingError;
var	bool	  bSkipKeyPressed;

var float     fLargestAForward;

//If this is set to an actor, harry carries it, instead of the wand
// Use SetCarryingActor(actor a); to make harry carry something
var actor CarryingActor;

var cHarryAnimChannel   HarryAnimChannel;
var bool                bThrow;
var() bool				bCanCast;

var EAnimType           HarryAnimType;

var Actor CutWalkDest;
var Actor CutTurnDest;
var name CutAnimName;
var baseScript CutNotifyScript;
var string CutCueString;
var name CutSaveState;
var float CutMoveToTimeout;
var rotator CutEndHeading;
var bool bCutArrived;

var vector              vAdditionalAccel;

var bool                bTempKillHarry;

var bool                bAllowHarryToDie;  //Normally true, so after playing die anim, he dies.
                //Set to false (using KillHarry(false)) and he'll lie there and wait until some external agent sets it to true.

var bool bScreenRelativeMovement;
var int   ScreenRelativeMovementYaw; //This is the 2d direction you'd like to be running when in bScreenRelativeMovement mode

var bool bReverseInput;

// yet more variables to do weird stuff
// underAttack bool and pointer are used to indicate that Harry is being attacked.
// intially this is used for spell selection purposes, but could be usefull for other things

var bool underAttack;
var actor attacker;
var vector lookhere;

var bool bClubDeath;
var bool bSlowDeath;

var   bool      bConstrainYaw; //Totally for troll chase, keep harry's yaw pointing down the x axis
var() int       ConstrainYawVariance;

var name	LastState;
var int ShortCutNum;

var   float  _LastKeyPressTime;
var   int    _iCurrentStringChar;
var   string _CurrentString;

var private travel int	  numHousePointsHarry;
var private travel int	  numHousePointsGryffindor;
var private travel int	  numHousePointsSlytherin;
var private travel int	  numHousePointsHufflepuff;
var private travel int	  numHousePointsRavenclaw;
var private int           numLastHousePointsHarry;

var(HousePoints) const int maxPointsPerHouse;
var(HousePoints) const int HarryMultipleForGryffindor;

var int	iFireSeedCount;
var travel int numBeans;
var travel int numStars;

var bool	bInSneak;

var int WaitingCount;

struct WizardList
{
	var int		ID;
	var bool	bHasCard;
};

var travel WizardList	WizardCards[25];

var travel bool bHasCloak;
var travel bool bHasDittany;
var travel bool bHasMucus;
var travel bool bHasFlute;
var travel bool bHasMoly;
var travel bool bHasBark;

// sto: For debugging purposes, below
var globalconfig bool bDisableDialog;

function AddStars(int n)
{
	numStars+=n;
	if(baseHud(myHud).StarItem!=None)
		baseHud(myHud).StarItem.Show();

}
function AddBeans(int n)
{
	numBeans+=n;
	if(baseHud(myHud).BeanItem!=None)
		baseHud(myHud).BeanItem.Show();

}
function AddSeeds(int n)
{
	iFireSeedCount+=n;
	if(baseHud(myHud).SeedItem!=None)
		baseHud(myHud).SeedItem.Show();

}

//********************************************************************************************

// function to call when Gryffindor win

function Add60HousePointsToGryffindor ()
{
	numHousePointsHarry += 60;
	numHousePointsGryffindor += 60;
	numLastHousePointsHarry = 60;

	// just in case of error somewhere
	if (numHousePointsSlytherin >= numHousePointsGryffindor)
		numHousePointsSlytherin = numHousePointsGryffindor -1;
}

function AddHousePoints (int num)
{
	local int temp;
	local float ftemp;

	numLastHousePointsHarry = num;

	numHousePointsHarry += num;

	if(baseHud(myHud).PointItem!=None)
		baseHud(myHud).PointItem.Show();

	// Set Gryffindor
	numHousePointsGryffindor = numHousePointsHarry;

	// Set Slytherin
		// Note Slytherin must always be ahead of Gryffindor,
		// but less than 60 points ...

	if (numHousePointsGryffindor<58)
		temp = numHousePointsGryffindor + Rand(numHousePointsGryffindor) + 1;
	else
		temp = numHousePointsGryffindor + Rand(58) + 1;
	if (numHousePointsSlytherin < temp)
		numHousePointsSlytherin = temp;

	// Set Hufflepuff
	ftemp = float(numHousePointsGryffindor) * (0.5 + Frand()*0.2);
	if (numHousePointsHufflepuff < ftemp)
		numHousePointsHufflepuff = ftemp;

	// Set Ravenclaw
	ftemp = float(numHousePointsGryffindor) * (0.7 + Frand()*0.2);
	if (numHousePointsRavenclaw < ftemp)
		numHousePointsRavenclaw = ftemp;

	log ("###### House Points");
	log ("added"@numLastHousePointsHarry);
	log ("Harry total"@numHousePointsHarry);
	log ("Gryffindor"@numHousePointsGryffindor);
	log ("Slytherin"@numHousePointsSlytherin);
	log ("Hufflepuff"@numHousePointsHufflepuff);
	log ("Ravenclaw"@numHousePointsRavenclaw);
}

function int getNumHousePointsHarry ()
{
	return numHousePointsHarry;
}

function int getLastHousePointsHarry ()
{
	return numLastHousePointsHarry;
}

function int getNumHousePointsGryffindor ()
{
	return numHousePointsGryffindor;
}

function int getNumHousePointsSlytherin ()
{
	return numHousePointsSlytherin;
}

function int getNumHousePointsHufflePuff ()
{
	return numHousePointsHufflepuff;
}

function int getNumHousePointsRavenclaw ()
{
	return numHousePointsRavenclaw;
}


//********************************************************************************************


function addcard(int iID)
{
	local int iCard;

	for (iCard = 0; iCard < ArrayCount(WizardCards); iCard ++)
	{
		log("Checking card " $WizardCards[iCard].ID $" for " $iID);
		if (WizardCards[iCard].ID == iID)
		{
			WizardCards[iCard].bHasCard = true;
			log("added card " $WizardCards[iCard].ID);
			break;
		}
	}
}

function int getNumCards ()
{
	local int iCard, num;

	for (iCard = 0; iCard < ArrayCount(WizardCards); iCard ++)
	{
		if (WizardCards[iCard].bHasCard)
			num++;
	}
			
	return num;
}

// debugging function
function giveAllCards ()
{
	local int iCard;
	for (iCard = 0; iCard < ArrayCount(WizardCards)-1; iCard ++)
	{
			WizardCards[iCard].bHasCard = true;
	}
}

//********************************************************************************************
function TurnDebugModeOn()
{
}

//********************************************************************************************

function SaveStateName()
{
	clientmessage("Harry state " $GetStateName() $" " $LastState);
	
	if (GetStateName() != 'PickingUpWizardCard')
	{
		LastState = GetStateName();
	}
}

//********************************************************************************************

function RestoreStateName()
{
	gotostate(LastState);
}

//********************************************************************************************
function SetCarryingActor(actor a)
{
	CarryingActor = a;

	if( CarryingActor != none )
	{
		weapon.bHidden = true;
		HarryAnimChannel.GotoStateHoldUpArm();
		HarryAnimType = AT_Combine;

		//If anyone else ever needs to be picked up, this call should be made more generic
		if( spellFireCracker(a) != none )
			spellFireCracker(a).ActorPickedUp();
	}
	else
	{
		weapon.bHidden = false;
		//HarryAnimChannel.GotoStateIdle();
		//HarryAnimType = AT_Replace;
	}

	bThrow = false;
}

//********************************************************************************************
function ThrowCarryingActor()
{
	local vector  v, v2;
	local rotator r;

	//Make sure everythings ok
	if( bThrow && projectile(CarryingActor) != none )
	{
		bThrow = false;

		//May need a variable that sais what state to go to
		if( spellFireCracker(CarryingActor) != none )
		{
			CarryingActor.GotoState('Flying');
			spellFireCracker(CarryingActor).bExplodeOnContact = true;
			spellFireCracker(CarryingActor).target = none; //different target than actor::target
		}

		CarryingActor.SetPhysics( PHYS_FALLING );
		r = Rotation;
		r.pitch = 30 * 65536/360;
		v = vector(r);
		v *= 500;
		CarryingActor.Velocity = v;

		//This is a hack, to try and figure out what's going on with the hovering wizard cracker.
		if( spellFireCracker(CarryingActor) != none )
		{
			spellFireCracker(CarryingActor).iKeepResettingVel = 2;
			spellFireCracker(CarryingActor).vInitialVelSave = v;
		}

		//Set the Instigator to 'self'
		CarryingActor.Instigator = self;
		CarryingActor.SetCollision(true, true, false);

		SetCarryingActor( none );
	}
}

//********************************************************************************************
function ReceiveIconMessage(Texture icon,string message,float duration)
{
	baseHUD(myHud).ReceiveIconMessage(icon,message,duration);
}

function GotoShortcut(int num)
{
local navShortcut sc;
local int count;
local vector newLoc;

	if( num < 0 )
		num = ShortCutNum++;
	count=0;
	foreach AllActors(class'navShortcut', sc)
		{
		if(count==num)
			{
				//calc new pos
			newLoc=sc.location;
				//set correct height
			newLoc.z=newLoc.z+CollisionHeight;
				//find the camera
			SetLocation(newLoc);
			cam.SetLocation(newLoc + vect(0, 0, 150));
			}
		count++;
		}
	if( ShortCutNum >= count )
		ShortCutNum = 0;
}


//********************************************************************************************
//AWRIGHT_111001_001
function int FindNearestSavePointID()
{
	local actor SavePointInstance;
	local int ReturnID;
	local string Str;
	local int SearchStrLen;

	ReturnID = -1;

	SearchStrLen = Len( "savepoint" );

	foreach RadiusActors( class'actor', SavePointInstance, 50, Location )
	{
		Log( "Found Actor In Radius = " $SavePointInstance.Name );

		if ( SavePointInstance.IsA('savepoint') )
		{
			Log( "Found Savepoint = " $SavePointInstance.Name );

			Str = Mid( SavePointInstance.Name, SearchStrLen );
			
			Log( "Found ID Str = " $Str );

			ReturnID = int( Str );
			break;
		}
	}

	return ReturnID;
}
//AWRIGHT_111001_001 - end



//********************************************************************************************

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
{
	local bool  bHarryKilled;

	if( lifePotions > 0 )
	{
		clientmessage("baseHarry: argghhh I'm HIT!!!!  " @ Damage);

		lifePotions = fmax( 0, lifePotions-Damage );

		if( lifePotions <= 0.0 )
			bHarryKilled = true;

		if( BossTarget != none )
			BossTarget.HarryWasHurt( bHarryKilled );

		if( bHarryKilled )
			KillHarry(true);
	}
	else
	{
		clientmessage("baseHarry: argghhh I'm HIT!!!! (no damage) " @ Damage);
	}
}

//********************************************************************************************
function actor ExtendTarget()
{
	local int	defaultyaw, defaultpitch;
	local float	BestDist, TempDist;
	local actor BestTarget;
	local actor HitActor;
	local rotator checkAngle, bestAngle;
	local vector objectDir;
	
	checkangle = rotator(rectarget.location - location);
	defaultYaw = Rotation.yaw & 0xffff;
	defaultpitch = rectarget.TargetPitch & 0xffff;

	BestTarget = none;

	if (defaultyaw > 0x7fff)
	{
		defaultyaw = defaultyaw - 0x10000;
	}
	if (defaultpitch > 0x7fff)
	{
		defaultpitch = defaultpitch - 0x10000;
	}

	BaseHUD(MyHUD).DebugValx = defaultyaw;
	BaseHUD(MyHUD).DebugValy = defaultpitch;

	foreach VisibleActors( class 'ACTOR', hitactor)
	{
		if( HitActor.bprojtarget && PlayerPawn(HitActor) != Self && !HitActor.IsA('BaseCam'))
		{
			objectdir = normal(hitactor.location - location);
			checkAngle = rotator(objectdir);
			checkAngle.yaw = checkAngle.yaw & 0xffff;
			checkAngle.pitch = checkAngle.pitch & 0xffff;
			if (checkAngle.yaw > 0x7fff)
			{
				checkAngle.yaw = checkAngle.yaw - 0x10000;
			}
			if (checkAngle.pitch > 0x7fff)
			{
				checkAngle.pitch = checkAngle.pitch - 0x10000;
			}

			if(abs(checkAngle.yaw - defaultYaw) < 4000 && abs(checkAngle.pitch - defaultPitch) < 4000)
			{
				if( bestTarget == none)
				{
					BestDist = vsize(hitactor.location - location);
					bestTarget = hitactor;
					bestAngle = checkAngle;
				}
				else
				{	
					TempDist = vsize(hitactor.location - location);
					if (TempDist < BestDist)
					{
						BestDist = TempDist;
						bestTarget = hitActor;
						bestAngle = checkAngle;
					}
				}
			}
		}
	}

	if (BestDist > 512)
	{
		BestTarget = none;
	}
	BaseHUD(MyHUD).DebugValx2 = bestAngle.yaw;
	BaseHUD(MyHUD).DebugValy2 = bestAngle.pitch;

	return BestTarget;
}


//********************************************************************************************
function bool HarryIsDead()
{
	return lifePotions <= 0;
}

//********************************************************************************************
function KillHarry(bool bImmediateDeath)
{
	clientmessage("argghhh I'm Dead!!!!");

	//If you're fighting a boss, stop the boss encounter
	if( baseBoss(BossTarget) != none )
		StopBossEncounter();

	//If you're fighting a boss, and he has a "I win" trigger, send that, and dont kill harry.
	if(   baseBoss(BossTarget) != none
	   && baseBoss(BossTarget).TrigEventWhenVictor != ''
	  )
	{
		baseBoss(BossTarget).SendVictoriousTrigger();
	}
	else
	{
		bAllowHarryToDie = bImmediateDeath;
		gotostate('stateDead');
	}

}

//********************************************************************************************
// a is the actor that clubs him
function KillHarryWithClub(bool bImmediateDeath, actor a)
{
	local int     yaw;
	local rotator r;

	bClubDeath = true;
	KillHarry( bImmediateDeath );

	//yaw = rotator(a.Location - Location).yaw;
	//yaw += 65536/4;

	yaw = a.Rotation.yaw;
	yaw += 65536/4;

	r = rotation;
	r.yaw = yaw;
	SetRotation( r );

	DesiredRotation = r;
}

//********************************************************************************************
//Returns distance to plane.  neg if looking away from plane

//********************************************************************************************
state stateDead
{
	ignores Tick, AltFire, Fire;

	//Use this, cause it gets called when you call GotoState();
	function BeginState()
	{
		local float fAnimRate;

		fAnimRate = 1.0;

		if( bClubDeath )
			fAnimRate = 1; //2; //3;

		if( bSlowDeath )
			fAnimRate = 0.65;

		//enable('tick');
		Velocity.x = 0;
		Velocity.y = 0;
		Acceleration = vect(0,0,0);

		playAnim('faint', fAnimRate);

		//Harry's anim has already been started, so now set the frame his faint is on.
		//if( bClubDeath )
		//	AnimFrame = 42.0/93.0;//0.247;
	}

  begin:

	//End of the project hack.  This would normally go to a special HarryDeadCam, but instead for the last two months it's
	// gone to CutState.  So, if you're fighting Voldemort, clear out the CutState vars.
	if( !( BossTarget != none  &&  BossTarget.IsA('BossQuirrel') ) )
	{
		cam.PositionActor = none;
		cam.DirectionActor = none;
	}

	cam.GotoState('CutState');

	finishAnim();

	//	moveto(self.location);
  loop:
	if( bSlowDeath )
		sleep( 2.0 );
	else
		sleep( 0.5 );

	if( bAllowHarryToDie )
	{
		//I'm sure something else needs to happen here...

		//Level.Game.RestartGame();

		baseConsole(player.console).LoadSelectedSlot();
	
/*		if( SaveGameExists() )
		{
			ConsoleCommand("open save9.usa");
		}
		else
		{
			Level.Game.RestartGame();
		}
*/
		//ClientTravel( "?load=9", TRAVEL_Absolute, false);

	}

	goto 'loop';

}

//********************************************************************************************

function float GetHealth()
{
	return LifePotions / MaxLifePotions;
}

function AddHealth(int iHealth)
{
	LifePotions += iHealth;
	if (LifePotions > MaxLifePotions)
	{
		LifePotions = MaxLifePotions;
	}
}

function forceHarryLook(actor other)
{
	focusActor=other;
	gotostate('lookatActor');
}


function forceHarrywing(actor other)
{
	focusActor=other;
	setphysics(phys_rotating);
	gotostate('wingspell');
}


function freeHarry()
{
	gotostate('playerWalking');
}

function MovementMode(bool bLockTarget)
{
	if (bLockTarget)
	{
		bStrafe = 1;
		bLook = 1;
		bLockedOnTarget = true;
	}
	else
	{
		bStrafe = 0;
		bLook = 0;
		bLockedOnTarget = false;
	}
}

state lookatActor
{
exec function AltFire( optional float F )
	{
	}

exec function Fire( optional float F )
	{
	}

	begin:

	enable('tick');
	loopanim('breath');

	loop:
//	turnto(focusActor.location);
//	clientmessage("2focusactor is "$focusactor);

	sleep(0.1);
	goto 'loop';

}

function CutRelease()
{
	viewRotation=rotation;
	desiredRotation=rotation;
	gotostate('playerWalking');
}

function CutDoIdle()
{
	gotostate('CutIdleing');
}

state CutIdleing
{

	function PlayerTick(float fDeltaTime)
		{
		}
	exec function AltFire( optional float F )
		{
		}

	exec function Fire( optional float F )
		{
		}
	function AnimEnd()
		{
		}

	begin:

	setphysics(phys_rotating);
	enable('tick');

	MoveSmooth(vect(0,0,-100));	//make sure on ground.
	loopanim('breath');


//	moveto(self.location);
	loop:

	sleep(0.1);
	goto 'loop';

}



function CutMoveTo(actor dest,baseScript script,string cue)
{
	CutWalkDest=dest;
	CutNotifyScript=script;
	CutCueString=cue;

		//this is an error.
	if(dest==None)
		{
			//send this back to avoid a hang in the script.
		CutNotifyScript.CutCue(CutCueString);

		CutCueString="";
		CutNotifyScript=None;
		return;
		}
	SetupMoveTo(dest);
	gotostate('CutMovingTo');
}
function SetupMoveTo(actor actorDest)
{
local vector curLoc;
local vector dest;

	CutWalkDest=actorDest;

	curLoc=location;
	dest=CutWalkDest.location;
	dest.z=curLoc.z;

	CutMoveToTimeout=vsize(dest-curLoc)/GroundSpeed;
	CutMoveToTimeout+=1.0;	//slop

//PlayerHarry.ClientMessage(self $" SetupMoveTo:Dist:" $vsize(dest-curLoc) $" Estimated Time:"$CutMoveToTimeout);
	bCutArrived=false;
}


state CutMovingTo
{
	Event PlayerTick(float fDeltaTime)
		{
		local vector heading;
		local vector delta;
		local vector curLoc;
		local vector dest;
		
		if(bCutArrived)
			return;
			//calc new heading

		curLoc=location;
		dest=CutWalkDest.location;
		dest.z=curLoc.z;

		heading=normal(dest-curLoc);

			//set char rotation
		desiredRotation=rotator(heading);
		desiredRotation.pitch=0;

			//calc position change
		delta=(heading*GroundSpeed)*fDeltaTime;
		delta.z+=0.1; //slight up angle to assist climbing stairs.

//PlayerHarry.ClientMessage(self $" Dist:" $vsize(dest-curLoc) $" Delta:" $vsize(delta) $" Time:"$CutMoveToTimeout);


//fTimeInAir=0.0; 
//fFallingZ=curLoc.z;

			//apply movement delta
		if(vsize(delta) < vsize(dest-curLoc) )
			{
			MoveSmooth(vect(0,0,15));	//move up enough to clear stairs.
			MoveSmooth(delta);	//full move
			MoveSmooth(vect(0,0,-15));	//back down.
			}
		else 
			{	//partial move to dest.
//PlayerHarry.ClientMessage(self $" Arrived. Time left:" $CutMoveToTimeout );
			MoveSmooth(vect(0,0,15));	//move up enough to clear stairs.
			MoveSmooth(dest-curLoc);
			MoveSmooth(vect(0,0,-15));	//back down.
			bCutArrived=true;
			}
			
			
			//check for timeout
		CutMoveToTimeout-=fDeltaTime;
		if(CutMoveToTimeout<0 && !bCutArrived)
			{
//PlayerHarry.ClientMessage(self $" Gaveup. Remaining dist" $vsize(dest-curLoc) );
			SetLocation(CutWalkDest.location);
				//make sure char is on the floor.
			MoveSmooth(vect(0,0,-100));
			bCutArrived=true;
			}


		}

	function AnimEnd()
		{
		}
	exec function AltFire( optional float F )
		{
		}
	exec function Fire( optional float F )
		{
		}
Begin:

	enable( 'Tick' );
	SetPhysics(PHYS_Walking);

	loopAnim('run');
moveLoop:
	
	while(!bCutArrived)
		{
		Sleep(0.1);
		}	
	if(CutNotifyScript!=None)
		{
		CutNotifyScript.CutCue(CutCueString);
		CutCueString="";
		CutNotifyScript=None;
		}
	loopAnim('breath');
	gotostate('CutIdleing');

//**************************************************************************************************
//**************************************************************************************************
//**************************************************************************************************
//**************************************************************************************************
//**************************************************************************************************

//	Log(self $"*** MoveTo.StartPos:   " $location); 
//	Log(self $"*** MoveTo.Target:     " $CutWalkDest.location); 

		//Calculate the final heading. (To overcome faceing bug)
	CutEndHeading=rotator(normal(CutWalkDest.location-location));
	moveTo(CutWalkDest.location);

	CutMoveToTimeout=9999;
retry:


//	Log(self $" Finished MoveTo:"$location $" Desired Loc:" $CutWalkDest.location $" Dist:" $vsize(location-CutWalkDest.location)); 
	if(vsize(location-CutWalkDest.location) > 50)
		{
		Log(self $"*** " $self $" Failed to reach Dest in CutMovingTo. Current Loc:"$location $" Dest Loc:" $CutWalkDest.location $" Dist:" $vsize(location-CutWalkDest.location)); 
		ClientMessage("*** " $self $" Failed to reach Dest in CutMovingTo. Current Loc:"$location $" Dest Loc:" $CutWalkDest.location $" Dist:" $vsize(location-CutWalkDest.location)); 
		Acceleration = Vect(0,0,0);
		Velocity = Vect(0,0,0);
		if(CutMoveToTimeout>100)
			CutMoveToTimeout=2.0;
		
		if(CutMoveToTimeout>0.0)
			goto 'retry';
		Log(self $"*** " $self $" Gave up trying to reach Dest in CutMovingTo. Current Loc:"$location $" Dest Loc:" $CutWalkDest.location $" Dist:" $vsize(location-CutWalkDest.location)); 
		ClientMessage("*** " $self $" Gave up trying to reach Dest in CutMovingTo. Current Loc:"$location $" Dest Loc:" $CutWalkDest.location $" Dist:" $vsize(location-CutWalkDest.location)); 
		SetLocation(CutWalkDest.location);
		}


	if(CutNotifyScript!=None)
		{
//		clientMessage(self $" Notifying:" $CutNotifyScript $" Cue:" $CutCueString);

		CutNotifyScript.CutCue(CutCueString);

		CutCueString="";
		CutNotifyScript=None;
		}
	loopAnim('breath');

		//force correct heading.
	RotationRate.yaw=0;
	desiredRotation=CutEndHeading;
	setRotation(CutEndHeading);

	gotostate('CutIdleing');
}

function CutTurnTo(actor dest,baseScript script,string cue)
{
	CutTurnDest=dest;
	CutNotifyScript=script;
	CutCueString=cue;
		//this is an error.
	if(dest==None)
		{
			//send this back to avoid a hang in the script.
		CutNotifyScript.CutCue(CutCueString);

		CutCueString="";
		CutNotifyScript=None;
		return;
		}

	gotostate('CutTurningTo');
}
state CutTurningTo
{

Begin:

	enable( 'Tick' );

//	clientMessage(self $" starting turnTo->" $CutTurnDest $" " $CutNotifyScript);
	SetPhysics(PHYS_ROTATING);

moveLoop:
	
	turnto(CutTurnDest.location);

	if(CutNotifyScript!=None)
		{
//		clientMessage(self $" Notifying:" $CutNotifyScript $" Cue:" $CutCueString);
		CutNotifyScript.CutCue(CutCueString);

		CutCueString="";
		CutNotifyScript=None;
		}

	gotostate('CutIdle');
}

function CutAnimate(name animName,baseScript script,string cue)
{
	CutAnimName=animName;
	CutSaveState=GetStateName();

	gotostate('CutAnimating');
}

state CutAnimating
{

Begin:

	enable( 'Tick' );

//	playerHarry.clientMessage(self $" starting walkTo->" $CutWalkDest $" " $walkAnimName);
	playAnim(CutAnimName);
	finishAnim();

	gotostate(CutSaveState);
}



state wingspell
{
function tick (float deltaTime)
{


}
exec function AltFire( optional float F )
	{
		baseprops(focusActor).bStopLevitating=true;
	}

exec function Fire( optional float F )
	{
		baseprops(focusActor).bStopLevitating=true;
	}

function endstate()

	{
		baseprops(focusActor).bStopLevitating=true;
	}




	begin:

	enable('tick');
	loopanim('breath');
	setphysics(phys_rotating);
	sleep(0.1);

	loop:
	lookhere=focusActor.location;
	lookhere.z=location.z;
	turnto(lookhere);
	viewrotation=rotation;

//	turnto(focusActor.location);
	if(bSkipKeyPressed)
	{
			baseprops(focusActor).bStopLevitating=true;
			
	}
	playanim('wave');
	basewand(weapon).castspell(rectarget.victim);
	sleep(0.3);
	goto 'loop';

}

function KeyDownEvent( int Key )
{
	if(   Level.TimeSeconds - _LastKeyPressTime > 1.0
	   || _iCurrentStringChar > 20
	  )
	{
		_iCurrentStringChar = 0;
		_CurrentString = "";
	}

	_LastKeyPressTime = Level.TimeSeconds;

	//if( Key == Asc(Caps(Mid(_sCheatString, _iCurrentStringChar, 1))))

	_CurrentString = _CurrentString $ Chr(Key);
	_iCurrentStringChar++;

	if( _CurrentString ~= "HarryTriggerCheat" )
	{
		TriggerEvent('HarryCheat', self, self);
	}
	//else
	//if( _CurrentString ~= "HarryKoresh" )
	//{
	//	if( IsInState('PlayerWalking') )
	//		HarryK(true);
	//}
	//else
	//if( _CurrentString ~= "HarrySuperKoresh" )
	//{
	//	DoJump(0);
	//	velocity = (vector(Rotation) + vect(0,0,1)) * 650;
	//	HarryK(false);
	//	HarryK(false);
	//	HarryK(false);
	//	HarryK(false);
	//	HarryK(false);
	//	HarryK(true);
	//}
	//else
	//if( _CurrentString ~= "HarryKorWalk" )
	//{
	//	if( IsInState('PlayerWalking') )
	//		HarryK(false);
	//}
	else
	if( _CurrentString ~= "HarryDebugModeOn" )
	{
		TurnDebugModeOn();
	}
	else
	if( _CurrentString ~= "HarryGetsFullHealth" )
	{
		lifePotions = MaxLifePotions;
	}
	else
	if( _CurrentString ~= "HarrySuperJump" )
	{
		DoJump(0);
		velocity = (vector(Rotation) + vect(0,0,1)) * 800;
	}
	else
	if( _CurrentString ~= "HarryNormalJump" )
	{
		DoJump(0);
		velocity = (vector(Rotation) + vect(0,0,1)) * 500;
	}
}

function HarryK(bool k)
{
	local sound snd;

	SpawnAndAttach('Harry Pelvis');
	SpawnAndAttach('Harry Spine');
	SpawnAndAttach('Harry L Thigh');
	SpawnAndAttach('Harry L Calf');
	SpawnAndAttach('Harry L Foot');
	SpawnAndAttach('Harry L Toe0');
	SpawnAndAttach('Harry R Thigh');
	SpawnAndAttach('Harry R Calf');
	SpawnAndAttach('Harry R Toe0');
	SpawnAndAttach('Harry Spine1');
	SpawnAndAttach('Harry Spine2');
	SpawnAndAttach('Harry Neck');
	SpawnAndAttach('Harry Head');
	SpawnAndAttach('glasses');
	SpawnAndAttach('Harry L Clavicle');
	SpawnAndAttach('Harry L UpperArm');
	SpawnAndAttach('Harry L Forearm');
	SpawnAndAttach('Harry L Hand');
	SpawnAndAttach('Harry R Clavicle');
	SpawnAndAttach('Harry R UpperArm');
	SpawnAndAttach('Harry R Forearm');
	SpawnAndAttach('Harry R Hand');

	PlaySound(sound'HPSounds.har_emotes.potion_bad1', SLOT_none);
	PlaySound(sound'HPSounds.quidditch_sfx.slow_whoosh_2', SLOT_none);
	//PlaySound(sound'HPSounds.Ambient.s_fire_big_loop', SLOT_none);
	PlaySound(sound'HPSounds.Hub5_sfx.voldemart_fire', SLOT_none);
	PlaySound(sound'HPSounds.Hub2_sfx.fireplace_loop', SLOT_none);

	if( k )
	{
		//theNarrator.FindEmote("EmotiveQuirrel13", snd);
		//PlaySound(snd, SLOT_none);
		theNarrator.FindEmote("EmotiveQuirrel14", snd);
		PlaySound(snd, SLOT_none);
		theNarrator.FindEmote("EmotiveQuirrel15", snd);
		PlaySound(snd, SLOT_none);

		bSlowDeath = true;
		KillHarry(true);
	}
}

function SpawnAndAttach(name bone)
{
	local actor e;

	e = spawn(class'TorchFire03', [SpawnOwner] self);
	e.AttachToOwner(bone);
	//Log("********* bone:"$bone$"  AnimBone:"$e.AnimBone);
}

function bool PlayNamedCutscene(name CutName)
{
local CutScene cut;
	foreach AllActors( class 'CutScene', cut, CutName )
		{
		cut.StartPlaying();
		return(true);
		}
	return(false);
}


//****************************************************************************
// you can pass none for boss.  If in_vFixedFaceDirection is non zero, then harry will face that direction.
function StartBossEncounter( baseBoss   boss
                            ,bool       in_bHarryShouldLockOntoBoss
                            ,bool       in_bReverseInput
                            ,bool       in_bKeepHarryFixed
                            ,bool       in_bCanCast
                            ,vector     in_vFixedFaceDirection
                            ,ESpellType ForceSpellType
                            ,bool       in_bExtendedTargetting
                           )
{
	BossTarget = boss;
	bLockedOnTarget = in_bHarryShouldLockOntoBoss;

	if(   in_vFixedFaceDirection.x != 0
	   || in_vFixedFaceDirection.y != 0
	   || in_vFixedFaceDirection.z != 0
	  )
	{
		bFixedFaceDirection = true;
		vFixedFaceDirection = normal(in_vFixedFaceDirection);
	}

	if( in_bHarryShouldLockOntoBoss )// ||  bFixedFaceDirection )
		bStrafe = 1;
	else
		bStrafe = 0;

	if( in_bReverseInput )
	{
		bReverseInput = true;

		//We'll make the assumption here that this is the troll chase.
		bConstrainYaw = true;
	}

	if( in_bKeepHarryFixed )
		bKeepStationary = true;

	bCanCast = in_bCanCast;
	bTargettingError = false;

	if( ForceSpellType != SPELL_None )
	{
		basewand(weapon).ChooseSpell( ForceSpellType );//SelectSpell( Class'spellflip' );
		basewand(weapon).bAutoSelectSpell = false;

		//All right, special hack case.  Sorry bout that.
		if( ForceSpellType == SPELL_Flipendo )
		{
			basewand(weapon).SelectSpell(class'spellFastFlip');
			bCastFastSpells = true;
		}
	}

	bExtendedTargetting = in_bExtendedTargetting;

	//cam.SaveState();
	// then RestoreState() in StopBossEncounter

	if( bStrafe == 0 )//in_bHarryShouldLockOntoBoss )
	{
		//Tell the base cam not to use Strafing, cause if that's set, the camera calls
		// baseHarry.MovementMode(true), which turns on 		bStrafe = 1;		bLook = 1;	and  	bLockedOnTarget = true;
		// which we dont want.
		cam.bUseStrafing = false;
	}

	if( boss != none )
	{
		cam.GotoState( boss.GetCamState() ); //'BossState');
		//Energy bars?

		cam.CameraOffset = boss.GetCameraOffset();
	}
}

//****************************************************************************
function StopBossEncounter()
{
	cam.GotoState('StandardState');

	BossTarget = none;
	bLockedOnTarget = false;
	bFixedFaceDirection = false;
	bStrafe = 0;
	bKeepStationary = false;
	bReverseInput = false;
	bConstrainYaw = false;
ClientMessage("baseHarry.StopBossEncounter()");
	basewand(weapon).ChooseSpell( SPELL_None );//SelectSpell( Class'spellflip' );
	basewand(weapon).bAutoSelectSpell = true;
	bCanCast = true;
	bCastFastSpells = false;
	bTargettingError = true;
	bExtendedTargetting = false;
}

//****************************************************************************

// <EAUK> Function which updates the "inverted broom" state, then saves
// the configuration. This is used by FEOptionsPage, instead of
// updating the variable directly, to ensure that the value is saved.
function InvertBroomPitch( bool Value )
{
	bInvertBroomPitch = Value;
	SaveConfig();
}
//****************************************************************************

defaultproperties
{
     turnRate=1000
     lifePotions=50
     MaxLifePotions=50
     bTargettingError=True
     bCanCast=True
     bAllowHarryToDie=True
     ConstrainYawVariance=5500
     maxPointsPerHouse=400
     HarryMultipleForGryffindor=3
     WizardCards(0)=(Id=101)
     WizardCards(1)=(Id=1)
     WizardCards(2)=(Id=28)
     WizardCards(3)=(Id=10)
     WizardCards(4)=(Id=24)
     WizardCards(5)=(Id=18)
     WizardCards(6)=(Id=8)
     WizardCards(7)=(Id=2)
     WizardCards(8)=(Id=19)
     WizardCards(9)=(Id=47)
     WizardCards(10)=(Id=35)
     WizardCards(11)=(Id=41)
     WizardCards(12)=(Id=17)
     WizardCards(13)=(Id=69)
     WizardCards(14)=(Id=48)
     WizardCards(15)=(Id=37)
     WizardCards(16)=(Id=62)
     WizardCards(17)=(Id=57)
     WizardCards(18)=(Id=49)
     WizardCards(19)=(Id=96)
     WizardCards(20)=(Id=72)
     WizardCards(21)=(Id=82)
     WizardCards(22)=(Id=83)
     WizardCards(23)=(Id=11)
     WizardCards(24)=(Id=100)
}
