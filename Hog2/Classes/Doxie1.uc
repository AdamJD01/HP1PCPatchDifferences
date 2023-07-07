// Doxie1 - Unreal Script code for Doxie creature in Harry Potter Game
//	author: Paul J. Furio

class Doxie1 expands baseChar;

// ** "Global" variables for this class
var ()bool   bLookForHarry;

var vector stoppoint;	// Used for moving Doxy close to Harry, for the Scowl
var vector harryat;
var vector home;
var vector startposition;
var vector tempvelocity;
var rotator tempRot;
var	float OldYaw;
var float OldAirSpeed;

// "Health" variables
var float strength;
var() float startstrength;
var() bool	bAttackOnSight;

var() float nDoxieDamage;
var() bool  bMoveAround;
var() float nAttackDelay;

var basecam pcam;
var float fDestroyFlyTime;

var ParticleFX ParticleFXActor;
var() float   fParticleTrailLife;


//************ Generic Functions ************************************************************
//*******************************************************************************************
function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetPhysics(PHYS_Flying);

	SetCollision( true, true, true );

	ParticleFXActor = spawn(class'doxie_fx',,,Location);
	ParticleFXActor.Lifetime.Base = fParticleTrailLife;

	PlaySound(sound 'HPSounds.critters2_sfx.doxy_wing_loop',, 3.2, true, 2000.0, 1.0);

	home=location;
	startposition = location;
	strength=startStrength;
	OldAirSpeed = AirSpeed;
}


function float GetHealth()
{
	return strength / startstrength;

}

event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	ParticleFXActor.SetLocation( Location );
}


function Trigger( actor Other, pawn EventInstigator )
{
	gotostate('PreMovePrep');
}

// **************** States **********************

auto state startstate
{
begin:
	if(bMoveAround)
		gotostate('patrol');
	else
		gotostate('idlehover');
}


state idlehover
{
	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		ParticleFXActor.SetLocation( Location );
		
		if(bAttackOnSight)
		{
			if(cansee(playerharry))
				gotostate('PreMovePrep');
		}
	}

begin:
	loopanim('hover');
loophere:
	Sleep(1.0);
	goto('loophere');
}


// * PATROL * - The Doxie is wandering in Hover mode.  The 'auto' tag sets this as the default state
state patrol
{

	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		ParticleFXActor.SetLocation( Location );
		
		if(bAttackOnSight)
		{
			if(cansee(playerharry))
				gotostate('PreMovePrep');
		}
	}

	function bool TakeSpellEffect(baseSpell spell)
	{
		if(spell.class==class'spellflip')
		{
			strength = strength - 1;

			playerHarry.clientmessage("Doxie Hit.  Strength:" @ strength);

			endstate();
			gotostate ('KnockBack');
		}
		else
			super.TakeSpellEffect(spell);
	}


	function startup()
	{
		foreach allActors(class'baseHarry', p)
			if( p.bIsPlayer&& p!=Self)
				break;

		if( bFollowPatrolPoints )
		{
			//Only look for first patrol tag if navP isn't set.  This lets you go to another state, and then back here
			// again without starting the path over again.
			if( navP == none )
			{
				if( firstPatrolPointTag != '' )
				{
					foreach allActors(class 'navigationPoint',navP,firstPatrolPointTag)
						break;
				}
				else
				{
					foreach allActors(class 'navigationPoint',navP)
						if( navP.name == firstPatrolPointObjectName )
							break;
				}

				PatrolPointLinkTag = PatrolPoint(navP).PatrolPointLinkTag;
				LastNavP = navP;
			}
		}
		else
		{
			if(stationDestination!='')
			{
				foreach allActors(class 'navigationPoint',navP)
				{
					destP=baseStation(navP);

					if(destP.Name==stationDestination)
						break;
				}
			}

			if(firstPath!='')
			{
				foreach allActors(class 'navigationPoint',navP)
					if(navp.Name==firstPath)
						break;
			}
		}
	}

	function EndState()
	{
		LastLevelTime = 0;
	}

  Begin:
	enable( 'Tick' );
//	SetPhysics(PHYS_Walking);
	startup();
	//playerHarry.clientMessage(self $" starting patrol");

	if( !bFollowPatrolPoints  &&  firstPath == '' )
		goto 'idleloop';

	patrolPlayWalkAnim();

  moveLoop:
	
	if( !bFollowPatrolPoints )
		next = findPath(navP,stationDestination);

	/*	if(next==none)
			goto 'idleloop';	*/

	if( bFollowPatrolPoints && bUseFraySplines && !bGoBackToLastNavPoint && PatrolPoint(navP).bHasSplineInfo )
	{
		while( !MoveTo_FraySpline() )
			sleep(0.005);
	}
	else //normal
	{
		do
		{
			//If bGoBackToLastNavPoint is set, set navp to LastNavP
			if( bFollowPatrolPoints && bGoBackToLastNavPoint )
			{
				navP = LastNavP;
				bGoBackToLastNavPoint = false;
			}

			moveTo(navP.location);
			sleep(0.005);
		}until( vsize(location-navP.location) < fNavPointColRadius );
	}

	impartinformation();

	if( bFollowPatrolPoints )
		_PawnAtPatrolPoint( PatrolPoint(navP) );
	else
	if( destp==navP )
		PawnAtStation();

	if( bFollowPatrolPoints )
	{
		tempNavP = navP;

		if( PatrolPoint(navP).NextPatrolPoint == none )
			navP = FindClosestPatrolPoint( LastNavP, navP );  //Find closest, excluding Last one you were at, and the one you're currently at.
		else
			navP = PatrolPoint(navP).NextPatrolPoint;

		LastNavP = tempNavP;

		_PostPawnAtPatrolPoint( PatrolPoint(LastNavP), PatrolPoint(navP) );
	}
	else
	{
		navP=navigationPoint(next);
	}

	if(navP==none)
	{
	  idleLoop:
		while( true )
		{
			loopAnim(idleAnimName);
			impartinformation();
			sleep(speechTime);
			speechTime=0;
			sleep(0.5);

			//If loop path, just start the whole patrol process over again by setting navp to firstPath.
			if( bLoopPath )
			{
				if( bFollowPatrolPoints )
				{
					if( firstPatrolPointTag != '' )
					{
						foreach allActors(class 'navigationPoint',navP,firstPatrolPointTag)
							break;
					}
					else
					{
						foreach allActors(class 'navigationPoint',navP)
							if( navP.name == firstPatrolPointObjectName )
								break;
					}
				}
				else
				{
					foreach allActors(class 'navigationPoint',navP)
						if(navp.Name==firstPath)
							break;
				}

				break; //break the while loop
			}

			//goto 'idleloop';
		}
	}

	
	next=none;
	
	goto 'moveLoop';
}


state PreMovePrep
{
	function bool TakeSpellEffect(baseSpell spell)
	{
		if(spell.class==class'spellflip')
		{
			strength = strength - 1;

			playerHarry.clientmessage("Doxie Hit.  Strength:" @ strength);

			endstate();
			gotostate ('KnockBack');
		}
		else
			super.TakeSpellEffect(spell);
	}

begin:
	if(nAttackDelay > 0)
	{
		turntoward(playerHarry);
		loopanim('hover');
		Sleep(nAttackDelay);
	}

	playanim('hover_to_fly');
	finishanim();
	gotostate('MoveToScowl');
}

state MoveToScowl
{
	function bool TakeSpellEffect(baseSpell spell)
	{
		if(spell.class==class'spellflip')
		{
			strength = strength - 1;

			playerHarry.clientmessage("Doxie Hit.  Strength:" @ strength);

			endstate();
			gotostate ('KnockBack');
		}
		else
			super.TakeSpellEffect(spell);
	}

	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		ParticleFXActor.SetLocation( Location );
		
		if(vsize(location - playerHarry.location) < 128)
		{
			gotostate('SwoopAttacking');
		}
		else
			gotostate('MoveToScowl');
	}

	function bump(actor other)
	{
		if(other==playerHarry)
		{
			playerharry.TakeDamage(nDoxieDamage, self,Location, Location * 0,'exploded');
			gotostate('Backoff');
		}
	}

Begin:
	playerHarry.clientmessage("Entered State Move To Scowl");
	basewand(playerHarry.weapon).bUseNoSpell = false;

	LoopAnim('fly');
	
	moveto(playerHarry.Location);

	gotostate('SwoopAttacking');
}


// * SWOOPATTACKING * - The Doxie is attacking and doing damage to Harry
state SwoopAttacking
{
	// Cause Damage on Bump
	function bump(actor other)
	{
		if(other==playerHarry)
		{
			disable('bump');
			playerharry.TakeDamage(nDoxieDamage, self,Location, Location * 0,'exploded');
			gotostate('Backoff');
		}
	}

	function bool TakeSpellEffect(baseSpell spell)
	{
		if(spell.class==class'spellflip')
		{
			strength = strength - 1;

			playerHarry.clientmessage("Doxie Hit.  Strength:" @ strength);

			endstate();
			gotostate ('KnockBack');
		}
		else
			super.TakeSpellEffect(spell);
	}

	// State Starts Here
	begin:
		harryat=playerHarry.location;

		// Step through the animation states to get to the attack anim
		finishanim();
		playanim('hover_to_fly');
		finishanim();

		loopanim('fly');

		// Close the Gap to Harry
		enable('bump');
		moveto(harryat);
		PlaySound(sound 'HPSounds.critters2_sfx.doxy_attack3', SLOT_Talk, 3.2, true, 2000.0, 1.0);
		
		gotostate('Backoff');
}

// * KNOCKBACK * - The Doxie has been hit and has taken damage
state KnockBack
{

begin:
	playerHarry.clientmessage("Doxie entered state Knockback");

	tempvelocity = -1 * Velocity;
	tempvelocity.Z += 160.0;		// Kick it up in the air...
	playanim('hover_to_spin');
	Velocity = tempvelocity;
	finishanim();

	loopanim('spin');

	// If he's down for the count, play the defeated sound
	if(strength<=0)
	{
		PlaySound(sound 'HPSounds.critters2_sfx.doxy_defeated', SLOT_Talk, 3.2, true, 2000.0, 1.0);
	}
	else	// Otherwise, he's just hurt and he'll make another sound...
	{
		switch(rand(3))
		{
		case 1:
			PlaySound(sound 'HPSounds.critters2_sfx.doxy_ouch1', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			break;
		case 2:
			PlaySound(sound 'HPSounds.critters2_sfx.doxy_ouch2', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			break;
		default:
			PlaySound(sound 'HPSounds.critters2_sfx.doxy_ouch3', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			break;
		}
	}

	// Shorter Knockback for No_Grapple type Doxies
	switch(rand(3))
	{
	case 1:
		PlaySound(sound 'HPSounds.critters2_sfx.doxy_stunned1', SLOT_Talk, 3.2, true, 2000.0, 1.0);
		break;
	case 2:
		PlaySound(sound 'HPSounds.critters2_sfx.doxy_stunned2', SLOT_Talk, 3.2, true, 2000.0, 1.0);
		break;
	default:
		PlaySound(sound 'HPSounds.critters2_sfx.doxy_stunned3', SLOT_Talk, 3.2, true, 2000.0, 1.0);
		break;
	}

	sleep(1.0);
	finishanim();
	home = location;

	loopanim('hover');

	if(strength<=0)
	{
		endstate();
		gotostate('KillDoxie');
	}
	else
		gotostate('Backoff');
}


state Backoff
{
begin:
	playerHarry.clientmessage("Doxie entered state Backoff");

	disable('bump');
	loopanim('hover');
	moveto(home);
	gotostate('MoveToScowl');
}

state KillDoxie
{
	event tick(float delta)
		{
		local vector dest;
		fDestroyFlyTime-=delta;

		Move((playerharry.CameraToWorld(vect(0.1,0.1,32))-location)/(fDestroyFlyTime/delta));
//		Move((playerharry.CameraToWorld(vect(0.75,0.75,150))-location)/5);
		}

	begin:
		playerHarry.clientmessage("Doxie entered state KillDoxie");
		basewand(playerHarry.weapon).bUseNoSpell = true;

		foreach allActors(class'basecam', pcam)
		{
			break;
		}
		loopanim('fly');

		Turntoward(pcam);

		disable('touch');
		bprojtarget=false;
		eVulnerableToSpell=SPELL_none;
		bCollideWorld=false;

		PlaySound(sound 'HPSounds.critters2_sfx.doxy_run_away', SLOT_Talk, 3.2, true, 2000.0, 1.0);
		
		fDestroyFlyTime=0.25;
		while(fDestroyFlyTime>0)
			{
			sleep(0.1);
			}
		
		// Kill the particles First
		ParticleFXActor.Destroy();
		destroy();
}



// Default Props for the Doxie
//*************************************************************************************************************************

defaultproperties
{
     bLookForHarry=True
     startstrength=1
     nDoxieDamage=5
     bMoveAround=True
     fParticleTrailLife=2
     bFlipTarget=True
     IdleAnimName=hover
     bGestureOnTargeting=False
     GroundSpeed=200
     AirSpeed=200
     AccelRate=4000
     AirControl=2
     BaseEyeHeight=30
     EyeHeight=30
     MenuName="Doxie1"
     eVulnerableToSpell=SPELL_Flipendo
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HPModels.skdoxyMesh'
     DrawScale=2
     AmbientGlow=200
     bProjTarget=True
     Mass=20
}
