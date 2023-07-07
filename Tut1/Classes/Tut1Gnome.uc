	class tut1gnome extends basechar;







var vector harryat;
var float sleepmin;
var float sleepmax;
var vector home;
var vector randdir;
var float dancetime;
var float strength;
var float startstrength;
var rotator tempRot;

var vector	PathTrace[160];
var float	TimeFollowing;
var int		TimeIndex;
var	vector	OldPosition;

var vector hidespot;
var vector focusspot;
var actor  hactor;
var actor  focusActor;
var (gnome) name safespot;
var (gnome) name lookSpot;
var (gnome) float serpentineScale;
var (gnome) int		iDamageCaused;
var (gnome) float	fAttackDelayTime;

var float	TimeToTaunt;
var float	TimeInPickupBeans;
var float	fTimeSinceLastPoint;
var bool	bTaunted, bCanTaunt;

function float GetHealth()
{
return strength / startstrength;

}

function bool GnomeCanSee(actor Target)
{
	local bool bCanSeeTarget;
	local actor PossibleVictim;
	local vector HitLocation;
	local vector HitNormal;
	local actor  HitActor;

	bCanSeeTarget = true;
			
	PossibleVictim = none;
	foreach TraceActors(class 'actor', HitActor, HitLocation, HitNormal, Target.Location, Location)
	{
//		log(string(HitActor.name) $" " $vsize(HitLocation - TraceStart));

		if (HitActor.bBlockActors || HitActor.isa('levelinfo'))
		{
			// Found target, 
			PossibleVictim = HitActor;
			break;
		}
	}

	if (PossibleVictim != none && PossibleVictim.Location != Target.Location)
	{
		bCanSeeTarget = false;
	}

/*				BaseHUD(p.MyHUD).DebugValX = offset.x;
				BaseHUD(p.MyHUD).DebugValY = offset.y;
				BaseHUD(p.MyHUD).DebugValZ = offset.z;*/

//	BaseHUD(playerharry.MyHUD).DebugString = string(PossibleVictim.name);

	return bCanSeeTarget;
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
}

function bool TakeSpellEffect(baseSpell spell)
{
	if(spell.class==class'spellflip')
		{
		endstate();
		gotostate ('knockback');
			return true;
		}
	else
		super.TakeSpellEffect(spell);

}

function DropBeans(vector Direction, int iNumber)
{
	local vector SpawnPoint, Vel;
	local class<Actor> transformInto;
	local rotator	SpawnDirection;
	local actor		DroppedBean;
	local float			fDist;
	local int		iBean;

	if (iNumber > 3)
	{
		iNumber = 3;	// clamp the number
	}

	if (iNumber > playerHarry.numBeans)
	{
		iNumber = playerHarry.numBeans;
	}

	if (iNumber > 0)
	{
		playerHarry.AddBeans (-iNumber);
		SpawnDirection.pitch = 0;
		SpawnDirection.yaw = 8000;
		SpawnDirection.roll = 0;

		if(baseHud(playerHarry.myHud).BeanItem!=None)
		{
			baseHud(playerHarry.myHud).BeanItem.Show();
		}

		// Drop the beans
		while (iNumber > 0)
		{
			SpawnPoint = normal(Direction) * 30;
			SpawnPoint.z = 0;
			fDist = float(rand(10)) / 10.0;

			if (iNumber == 3)
			{
				SpawnPoint = SpawnPoint + vect(0, 0, 75);
				Vel = SpawnPoint * (fDist + 1) + vect(0, 0, 70);
				SpawnPoint = SpawnPoint + location;
			}
			else if (iNumber == 1)
			{
				SpawnPoint = (SpawnPoint + vect(0, 0, 65)) >> SpawnDirection;
				Vel = SpawnPoint * (fDist + 1) + vect(0, 0, 70);
				SpawnPoint = SpawnPoint + playerHarry.location;
			}
			else if (iNumber == 2)
			{
				SpawnPoint = (SpawnPoint  + vect(0, 0, 65)) << SpawnDirection;
				Vel = SpawnPoint * (fDist + 1) + vect(0, 0, 70);
				SpawnPoint = SpawnPoint + playerHarry.location;
			}

			switch(rand(5))
			{
				case 0:
					transforminto = Class'HProps.BlueJellyBean';
					break;

				case 1:
					transforminto = Class'HProps.GreenJellyBean';
					break;

				case 2:
					transforminto = Class'HProps.SpottedJellyBean';
					break;

				case 3:
					transforminto = Class'HProps.GreenPurpleCheckerBean';
					break;

				case 4:
					transforminto = Class'HProps.RedBlackStripeBean';
					break;

			}

			DroppedBean = Spawn(transformInto,,, SpawnPoint);

			DroppedBean.Velocity = Vel;
			iNumber --;
		}
	}
}

state PickupBeans
{
	function animend()
	{
		if (AnimSequence == 'tauntass')
		{
			loopanim('runnormal');
		}
	}

	function tick(float deltatime)
	{
		local vector	offset;
		local JellyBean	Bean, ClosestBean;
		local float		fDist, fClosestDist;

		// check to see if there is a bean nearby

		TimeToTaunt -= deltatime;

		if (TimeToTaunt > 0)
		{
			DesiredRotation = rotator(location - playerHarry.location);
			return;
		}

/*		if (TimeToTaunt < 0)
		{
			TimeToTaunt = 9999;

//			if (rand(2) == 1)
//			{
				DesiredRotation = rotator(location - playerHarry.location);
				playanim('tauntass');
				return;
//			}
		}*/

		if (animsequence == 'tauntass')
		{
			return;
		}

		TimeInPickupBeans -= deltatime;

		if (TimeInPickupBeans < 0)
		{
			if (TimeIndex < 0)
			{
				gotostate('hide');
			}
			else
			{
				gotostate('findhide');
			}
		}

		ClosestBean = none;
		foreach AllActors( class'JellyBean', Bean )
		{
			fDist = vsize(Bean.location - location);

			if (fDist < 150)
			{
				if (ClosestBean == none || fDist < fClosestDist)
				{
					ClosestBean = Bean;
					fClosestDist = fDist;
				}
			}
		}

		if (ClosestBean == none)
		{
			if (bCanTaunt)
			{
				DesiredRotation = rotator(location - playerHarry.location);
				
				// AE: taunt
				switch( Rand(4) )
				{
					case 0:	PlaySound( sound'HPSounds.gnome_sfx.taunt1', SLOT_Talk ); break;
					case 1:	PlaySound( sound'HPSounds.gnome_sfx.taunt2', SLOT_Talk ); break;
					case 2:	PlaySound( sound'HPSounds.gnome_sfx.taunt3', SLOT_Talk ); break;
					case 3:	PlaySound( sound'HPSounds.gnome_sfx.taunt4', SLOT_Talk ); break;
				}
				
				playanim('tauntass');
				bCanTaunt = false;
				return;
			}

			if (TimeIndex < 0)
			{
				gotostate('hide');
			}
			else
			{
				gotostate('findhide');
			}
		}
		else
		{
			bCanTaunt = true;
			offset = ClosestBean.location - location;

			if (vsize(offset) > (deltatime * groundspeed))
			{
				offset = normal(offset) * deltatime * groundspeed;
			}


			desiredrotation = rotator(offset);
			movesmooth(offset);
		}
	}

	begin:
	
		// AE: laugh
		switch( Rand(4) )
		{
			case 0:	PlaySound( sound'HPSounds.gnome_sfx.laugh1', SLOT_Talk ); break;
			case 1:	PlaySound( sound'HPSounds.gnome_sfx.laugh2', SLOT_Talk ); break;
			case 2:	PlaySound( sound'HPSounds.gnome_sfx.laugh3', SLOT_Talk ); break;
			case 3:	PlaySound( sound'HPSounds.gnome_sfx.laugh5', SLOT_Talk ); break;
		}


		TimeToTaunt = 1;
		TimeInPickupBeans = 3;
		bCanTaunt = false;
		loopanim('runnormal');
		enable('bump');
//		TimeIndex -= 1;
}

auto state waitforTrigger
{
	
function Trigger( actor Other, pawn EventInstigator )
{
	gotostate('hide');
		//playerharry.underattack=true;
		//playerharry.attacker=self;

	
}
	begin:
	sleepmin=0.5;
	sleepmax=1.0;
	home=location;
	strength=startStrength;
	foreach allActors(class 'actor',hactor)
		{

			if(hactor.Name==safespot)
			{
				hidespot=hactor.location;	
				break;
			}
		}

	focusspot=home;
	foreach allActors(class 'actor',focusActor)
		{

			if(focusactor.Name==lookspot)
			{
				focusspot=focusactor.location;	
				break;
			}
		}
	
	

	
	loopanim('breath');
	

	loop:
		sleep(0.4);
		turntoward(playerHarry);
		
		goto 'loop';

}



state waitforAttack
{


function tick(float deltatime)
{

	dancetime=dancetime+deltatime;
	if(dancetime>1)
	{
		randdir=4*vrand();
		dancetime=0;

	}
	move((randdir*deltatime));
	//setlocation(location+(randdir*deltatime));


}
function Trigger( actor Other, pawn EventInstigator )

{
	gotostate('attackharry');
}


	begin:
	
	bprojtarget=true;
	dancetime=0;
	turnTo(home);
	loopanim('sidestep');
	sleep(0.5);

	settimer(0.1+(frand()*sleepmax),false);
	loopanim('sidestep');
	randdir=40*vrand();
//	PlaySound(sound 'HPSounds.critters2_sfx.gno_stunned1', SLOT_Talk, 3.2, true, 2000.0, 1.0);

	loop:
	
	turnTo(focusspot);	
//	if(vsize(playerharry.location-location)<250)
	if(GnomeCanSee(playerharry))
	{
		switch( Rand(4) )
		{
			case 0:	PlaySound( sound'HPSounds.gnome_sfx.spoth1', SLOT_Misc ); break;
			case 1:	PlaySound( sound'HPSounds.gnome_sfx.spoth2', SLOT_Misc ); break;
			case 2:	PlaySound( sound'HPSounds.gnome_sfx.spoth3', SLOT_Misc ); break;
			case 3:	PlaySound( sound'HPSounds.gnome_sfx.spoth4', SLOT_Misc ); break;
		}

		sleep(fAttackDelayTime);
		if(GnomeCanSee(playerharry))
		{
			if (rand(3) == 0)
			{
				switch( Rand(3) )
				{
					case 0:	PlaySound( sound'HPSounds.gnome_sfx.jump1', SLOT_Talk ); break;
					case 1:	PlaySound( sound'HPSounds.gnome_sfx.jump2', SLOT_Talk ); break;
					case 2:	PlaySound( sound'HPSounds.gnome_sfx.jump3', SLOT_Talk ); break;
				}

				playanim('tauntjump');
				finishanim();
			}

			switch( Rand(4) )
			{
				case 0:	PlaySound( sound'HPSounds.gnome_sfx.pant2', SLOT_Misc ); break;
				case 1:	PlaySound( sound'HPSounds.gnome_sfx.pant4', SLOT_Misc ); break;
				case 2:	PlaySound( sound'HPSounds.gnome_sfx.pant5', SLOT_Misc ); break;
				case 3:	PlaySound( sound'HPSounds.gnome_sfx.pant6', SLOT_Misc ); break;
			}

			gotostate('attackharry');
		}
	}
	sleep(0.8);

	goto 'loop';


}

state FindHide
{
	function animend()
	{
		if (AnimSequence == 'tauntass')
		{
			loopanim('runnormal');
		}
	}

	function tick(float deltatime)
	{
		local vector	offset;
 
/*		TimeToTaunt -= deltatime;
		if (TimeToTaunt < 0)
		{
			TimeToTaunt = 9999;

			if (rand(2) == 1)
			{
				playanim('tauntass');
				return;
			}
		}
*/
		if (animsequence == 'tauntass')
		{
			return;
		}

		fTimeSinceLastPoint += deltatime;

		if (fTimeSinceLastPoint > 1)
		{
			gotostate('attackharry', 'TimeoutAttack');
		}
		offset = PathTrace[TimeIndex] - location;

		if (vsize(offset) < (deltatime * groundspeed))
		{
			fTimeSinceLastPoint = 0;
			TimeIndex --;
			if (TimeIndex < 0)
			{
				gotostate('hide');
			}
			else
			{
				offset = PathTrace[TimeIndex] - location;
			}
		}

		if (vsize(offset) > (deltatime * groundspeed))
		{
			offset = normal(offset) * deltatime * groundspeed;
		}
		desiredrotation = rotator(offset);
//		DBack = offset;
		movesmooth(offset);
	}

	begin:
		
		//turnto(harryat);
		
		loopanim('runnormal');
		enable('bump');
		fTimeSinceLastPoint = 0;
		TimeIndex --;
		if (TimeIndex < 0)
		{
			gotostate('hide');
		}
/*	loop:
		sleep(0.001);
		turnto(Location + DBack * 100);
		goto('loop');*/
}

state attackHarry
{
function HitWall (vector HitNormal, actor Wall)
{

/*	endstate();
	serpentinescale=serpentinescale-0.1;
	gotostate('rehome');*/
}		


function bump(actor other)
{

	if(other==playerHarry)
	{
		switch( Rand(6) )
		{
			case 0:	PlaySound( sound'HPSounds.gnome_sfx.hit1', SLOT_Misc ); break;
			case 1:	PlaySound( sound'HPSounds.gnome_sfx.hit2', SLOT_Misc ); break;
			case 3:	PlaySound( sound'HPSounds.gnome_sfx.hit4', SLOT_Misc ); break;
			case 4:	PlaySound( sound'HPSounds.gnome_sfx.hit5', SLOT_Misc ); break;
			case 5:	PlaySound( sound'HPSounds.gnome_sfx.hit6', SLOT_Misc ); break;
		}

		playerHarry.takeDamage(iDamageCaused, self,Location, Vect(0,0,1)*9,'exploded');
		DropBeans(normal(location - playerHarry.location), 3);
		disable('bump');

		gotostate('PickupBeans');
	}

}

	function tick(float deltatime)
	{
		local vector	offset;

		TimeFollowing = TimeFollowing + deltatime;

		if (vsize(OldPosition - location) < 1)		
		{
			// give up and go home
			gotostate('Findhide');
		}

		if (TimeFollowing - (float(TimeIndex) / 8) > 0.125)
		{
			if (TimeIndex < 160)
			{
				PathTrace[TimeIndex] = Location;
				TimeIndex ++;
			}
			else
			{
				// Gnome gives up, goes back to base
				gotostate('Findhide');
			}
		}

		if (GnomeCanSee(playerHarry))
		{
			switch( Rand(4) )
			{
				case 0:	PlaySound( sound'HPSounds.gnome_sfx.spoth1', SLOT_Talk ); break;
				case 1:	PlaySound( sound'HPSounds.gnome_sfx.spoth2', SLOT_Talk ); break;
				case 2:	PlaySound( sound'HPSounds.gnome_sfx.spoth3', SLOT_Talk ); break;
				case 3:	PlaySound( sound'HPSounds.gnome_sfx.spoth4', SLOT_Talk ); break;
			}

			offset = playerHarry.location - location;
			HarryAt = playerHarry.location;
		}
		else
		{
			offset = HarryAt - location;
		}

		if (vsize(offset) > (deltatime * groundspeed))
		{
			offset = normal(offset) * deltatime * groundspeed;
		}

		movesmooth(offset);
	}

	begin:
		
		TimeIndex = 0;

	TimeoutAttack:
		//turnto(harryat);
		turntoward(playerHarry);
		loopanim('runattack');
		enable('bump');
		finishanim();
		loopanim('runattackbite');
		TimeFollowing = 0;

	loop:
//		PlaySound(sound 'HPSounds.critters2_sfx.gno_attack2', SLOT_Talk, 3.2, true, 2000.0, 1.0);
//		harryat=playerHarry.location;
//		moveto(harryat);
//		movesmooth(playerHarry.location - location);

		turntoward(playerHarry);

		sleep(0.01);
//		if(abs(vsize(location-playerharry.location))<100)

		if (!GnomeCanSee(playerHarry) && vsize(Location - HarryAt) < 1)
		{
			gotostate('Findhide');
		}
		goto 'loop';
}




state hide
{

function HitWall (vector HitNormal, actor Wall)
{

/*	endstate();
	gotostate('rehome');*/
}		

	begin:
	
	TimeIndex = 0;
	TimeFollowing = 0;

	home = playerHarry.location;
	loopanim('runnormal');

		playerharry.clientmessage("hide");
		moveto(hidespot);
		sleep(0.1);
	loop:
		if(abs(vsize(location-hidespot))<100)
		{
			loopanim('look');
			turnTo(home);
			sleep(1);
			gotostate('waitforattack');
		}
		sleep(0.1);
		goto 'loop';

}



state rehome
{




function HitWall (vector HitNormal, actor Wall)
{
}		

	begin:
	

	loopanim('runnormal');
	loop:
		playerharry.clientmessage("rehome");
			moveto(home);

	
		if(abs(vsize(location-home))<100)
		{
			gotostate('hide');
		}
		goto 'loop';

}




state runback
{





	begin:
	loopanim('runnormal');
	loop:
		playerharry.clientmessage("runback");
		randdir=home-location;
		tempRot=rotator(randdir);
		if(frand()<0.5)
		{
			temprot.yaw=temprot.yaw+(10000*serpentineScale);
		}
		else
		{
			temprot.yaw=temprot.yaw-(10000*serpentineScale);
		}

		
		if(vsize(randdir)>150)
		{
			randdir=randdir/4;
			randdir=randdir<<temprot;
			
			randdir=location-randdir;
			moveto(randdir);
		}
		else
		{
			moveto(home);
		}
	
	
		if(abs(vsize(location-home))<100)
		{
			gotostate('waitforattack');
		}
		goto 'loop';

}


state knockback
{


function bool TakeSpellEffect(baseSpell spell)
{

}


function HitWall (vector HitNormal, actor Wall)
{

	endstate();
	playerharry.clientmessage("hitwall knockback");
	gotostate('runback');
	
}
function timer()
{
	endstate();
	gotostate('runback');
}
begin:
	disable('timer');

	temprot=rotationrate;
	rotationrate.yaw=0;
	
	moveto(location);

	strength=strength-1;

//	PlaySound(sound 'HPSounds.critters2_sfx.gno_ouch1', SLOT_Talk, 3.2, true, 2000.0, 1.0);
	
	// AE: fall
	switch( Rand(5) )
	{
		case 0:	PlaySound( sound'HPSounds.gnome_sfx.fall1', SLOT_Talk ); break;
		case 1:	PlaySound( sound'HPSounds.gnome_sfx.fall2', SLOT_Talk ); break;
		case 2:	PlaySound( sound'HPSounds.gnome_sfx.fall3', SLOT_Talk ); break;
		case 3:	PlaySound( sound'HPSounds.gnome_sfx.fall4', SLOT_Talk ); break;
		case 4:	PlaySound( sound'HPSounds.gnome_sfx.fall5', SLOT_Talk ); break;
	}

//	playanim('knockback',[RootBone] 'move');
	playanim('knockback');
	finishanim();
//	loopanim('downbreath',[RootBone] 'move');
	loopanim('downbreath');

	

	

	if(strength<=0)
	{
		
		endstate();
		playerharry.underattack=false;
		gotostate('stunned');
	}
		sleep(1);
//	playanim('getup',[RootBone] 'move');
	playanim('getup');
	finishanim();
//	PlaySound(sound 'HPSounds.critters2_sfx.gno_ouch3', SLOT_Talk, 3.2, false, 2000.0, 1.0);
	loopanim('runscared');
	rotationrate=temprot;
	moveto(location-(500*(playerHarry.location-location)));
	sleep (1);
	
	
	gotostate('runback');

}



state stunned
{


function bool TakeSpellEffect(baseSpell spell)
{

}

function causetrigger()
{

	local actor a;


	if(event!='')
	{
		foreach AllActors( class 'Actor', A, Event )
		{
			A.Trigger( self, self.Instigator );
		}
	}
}

// AE: dazed.
function PlayDazedSound()
{
	switch( Rand(6) )
	{
		case 0:	PlaySound( sound'HPSounds.gnome_sfx.dazed1', SLOT_Talk ); break;
		case 1:	PlaySound( sound'HPSounds.gnome_sfx.dazed2', SLOT_Talk ); break;
		case 2:	PlaySound( sound'HPSounds.gnome_sfx.dazed3', SLOT_Talk ); break;
		default:
	}
}

	begin:
		bprojtarget=false;
		SetCollision(false, false, false);

		eVulnerableToSpell=SPELL_none;
		causetrigger();
		PlayDazedSound();
//		PlaySound(sound 'HPSounds.critters2_sfx.gno_defeated', SLOT_Talk, 3.2, true, 2000.0, 1.0);
//		playanim('downdizzy',[RootBone] 'move');
		playanim('downdizzy');
//      spawn(class'sleepfx',,,Location);
		finishanim();
			
	loop:
		if(abs(vsize(location-playerharry.location))<200)
		{
			PlayDazedSound();
		//	PlaySound(sound 'HPSounds.critters2_sfx.gno_defeated', SLOT_Talk, 3.2, true, 2000.0, 1.0);
		//	playanim('downdizzy',[RootBone] 'move');
			playanim('downdizzy');
			finishanim();
		}
		
	//	loopanim('downbreath',[RootBone] 'move');



		loopanim('downbreath');
		sleep (2);
		goto 'loop';

}

defaultproperties
{
     startstrength=1
     serpentineScale=1
     iDamageCaused=2
     bFlipTarget=True
     bGestureOnTargeting=False
     GroundSpeed=150
     PeripheralVision=1
     Physics=PHYS_Walking
     eVulnerableToSpell=SPELL_Flipendo
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HPModels.skgnomeMesh'
     DrawScale=1.25
     CollisionRadius=20
     CollisionHeight=20
     bProjTarget=True
}
