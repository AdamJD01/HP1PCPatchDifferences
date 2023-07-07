class tut3Peeves expands peeves;



var float hitCount;
var sound peevesVoice;

var PathNode enterPoint;
var PathNode exitPoint;
var PathNode attackPoints[10];
var int curAttackPoint;
var bool bTriggered;
var int currentsound;
var (peeves) name orbitPoint;
var (peeves) float orbitDistance;
var (peeves) float orbitTime;
var (peeves) name exitpathtype;
var (peeves) name exitfirstPath;
var (peeves) name exitstationdestination;
var rotator orbitrot;
var actor orbitact;
var float orbitStartYaw;
var int orbitcount;
VAR float dancetime;
var vector randdir;

var basecam pcam;
var vector camoffset;
var bool hugcamera;

var sound  snd;
var string str;
var float  pitch;
var float zdis;
var int currentsound2;

var PeevesTrail	TrailFX;


function float GetHealth()
{
return hitcount / 4;

}


function PostBeginPlay()
{
local baseWand weap;
local int i;
local PathNode node;

	Super.PostBeginPlay();

	TrailFX = none;

	weap=spawn(class'baseWand');
	weap.BecomeItem();
	AddInventory(weap);
	weap.WeaponSet(self);
	weap.GiveAmmo(self);
	weap.SelectSpell(Class'spellPeevesThrow');

		foreach allActors(class'actor', orbitact)
		{
			if( orbitact.name==orbitPoint)
			{
				break;
			}
		}


	curAttackPoint=0;

}

function timer()
{
	enable('bump');
	bblockplayers=true;
	bblockactors=true;

}
function bump(actor other)
{
	if(other==playerharry)
	{
		playerHarry.takeDamage(10,self,Location, Vect(0,0,1)*9,'exploded');
	}
		settimer(1,false);
		disable('bump');
		bblockplayers=false;
		bblockactors=false;
	

}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
//	playerHarry.clientMessage(self $":I've been shot!");
//	gotostate ('shot');
}


function bool TakeSpellEffect(baseSpell spell)
{
local vector spawnLoc;
local actor newSpawn;

	if(spell.class==class'spellflip')
		{
		hitCount=hitcount-1;
		if(!IsInState('dieing'))
			gotostate ('shot');

			return true;
		}

}

function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	return Rotation;
}

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



auto state waitforTrigger
{
	
function Trigger( actor Other, pawn EventInstigator )
{
//	PlaySound(sound 'HPSounds.peeves_sfx.pee_009', SLOT_Talk, 3.2, false, 2000.0, 1.0);
	cam.gotostate('bossstate');
		playerHarry.BossTarget = self;
		playerHarry.cam.DirectionActor = none;
		playerharry.underattack=true;
		playerharry.attacker=self;

	gotostate('attackCamera');


}
	begin:
	
	
	loop:
		sleep(2.4);
		turntoward(playerHarry);
		
		goto 'loop';

}

state() waitforTriggerLumos
{
	
function Trigger( actor Other, pawn EventInstigator )
{
//	PlaySound(sound 'HPSounds.peeves_sfx.pee_009', SLOT_Talk, 3.2, false, 2000.0, 1.0);
//	cam.gotostate('bossstate');
//		playerHarry.BossTarget = self;
//		playerHarry.cam.DirectionActor = none;
//		playerharry.underattack=true;
//		playerharry.attacker=self;

	gotostate('patrol');


}
	begin:
	
	
	loop:
		sleep(2.4);
		turntoward(playerHarry);
		
		goto 'loop';

}





state attackCamera
{


function tick(float delta)
{
	local vector vect;

	if(hugcamera==true)
	{
		camoffset.z=-30;
		camoffset.y=0;
		camoffset.x=60;
		camoffset=camoffset>>pcam.rotation;
		camoffset=camoffset+pcam.location;
		vect=camoffset-location;
		if(abs(vsize(vect))>60)
		{
			move(normal(vect)*(delta*1000));
			
		}
		else
		{
			hugcamera=false;
		}
	}

}
function findcam()
{
		foreach allActors(class'basecam', pcam)
		{
			break;
		}


}

	function BeginState()
	{
		disable('tick');
		findcam();
		hugcamera=true;
		loopanim('Float', 0.7);

		FindDialog("EmotivePeeves22", snd, str); 
		PlaySound( snd, SLOT_Talk, , , 10000.0 );
	}

begin:
	

	sleep(1);
	enable('tick');
	pcam.gotostate('cutstate');
	SetPhysics(PHYS_rotating);
//	PlaySound(sound 'HPSounds.peeves_sfx.pee_009', SLOT_Talk, 3.2, false, 2000.0, 1.0);

	
loop:
//	turntoward(pcam);
	sleep(0.5);
	if(abs(vsize(camoffset-location))>80)
	{
		goto'loop';
	}

//	FindDialog("Peeves_002", snd, str); 
//	PlaySound( snd, SLOT_Talk, , , 10000.0 );

	FindDialog("Peeves_001", snd, str); 
	PlaySound( snd, SLOT_Talk, , , 10000.0 );

	turntoward(pcam);
	playanim('grab');

	finishanim();
	loopanim('Float', 0.7);

	Sleep(2.2);

	airspeed=800;
	pcam.gotostate('Bossstate');
//	pcam.gotostate('standardstate');

	gotostate('patrol');
	
	goto 'loop';

}







state attackHarry
{


function tick(float deltatime)
{

	dancetime=dancetime-deltatime;
	if(dancetime<0)
	{
		dancetime=0.5;
		orbitRot.pitch=1000;
		orbitrot.yaw=00000;
		orbitrot.roll=1000;
		
		randdir.z=-50;
		randdir.x=0;
		randdir.y=0;

	}
	
	randdir=randdir>>orbitRot;
//	playerharry.clientmessage("randdir is "$randdir);
	setlocation(location+(randdir*deltatime));


}

	begin:
		switch(	currentSound)
		{
		case 0:
			FindDialog("111Peeves3", snd, str); 
			PlaySound( snd, SLOT_Talk, , , 10000.0 );
			playanim('scheming',1.3);
			currentSound=1;
			break;
		case 1:
			FindDialog("111Peeves2", snd, str); 
			PlaySound( snd, SLOT_Talk, , , 10000.0 );
			PlayAnim('look');
			currentSound=2;
			break;
		case 2:
			FindDialog("111Peeves4", snd, str); 
			PlaySound( snd, SLOT_Talk, , , 10000.0 );
				playanim('scheming',1.3);
			currentSound=3;
			break;
		case 3:
		default:
			FindDialog("111Peeves5", snd, str); 
			PlaySound( snd, SLOT_Talk, , , 10000.0 );
			PlayAnim('look');
			currentSound=0;
			break;

		}

		cam.gotostate('bossstate');
		playerHarry.BossTarget = self;
		playerHarry.cam.DirectionActor = none;

	wait:
		TurnTo(playerHarry.location);
		if(IsAnimating())
		{
			goto 'wait';
		}
		

		dancetime=0;
		settimer(0.1+(frand()*1),false);
		randdir=200*vrand();

	
		
		
		gotostate('throwing');
//		MoveToward(playerHarry);
		goto 'wait';


}

state throwing
{
	begin:
		turnto(playerHarry.location);
		playAnim('throwobject1');
		finishanim();
		target=playerHarry;
		baseWand(weapon).forcespell(playerHarry);
		loopAnim('throwobject2');
		finishanim();
		gotostate('patrol');
}




state orbit
{

	function tick (float deltatime)
	{
		local vector loc;
		local vector newvec;
		local rotator newrot;
		local float ydiff;
		local vector oldlocation;
		
		ydiff=vsize(orbitact.location-playerharry.location);
	
		if(ydiff>orbitDistance)
		{
			loc.x=ydiff;
		}
		else
		{
			loc.x=orbitDistance;
		}
		loc.y=0;
		loc.z=0;
		loc=loc>>orbitrot;

		loc=loc+orbitact.location;

		newvec=loc-location;
		newrot=rotator(newvec);
		ydiff=newrot.yaw-rotation.yaw;
		ydiff=ydiff*deltatime;
	

		if(ydiff>2600)
			ydiff=2600;
		if(ydiff<-2600)
			ydiff=-2600;
		newrot.yaw=rotation.yaw+ydiff;

		setrotation(newrot);
		oldlocation=location;
		move(normal(newvec)*(500*deltatime));

	
		if(vsize(oldlocation-location)<1)
		{
//			playerharry.clientmessage("whacked");

			SetPhysics(PHYS_flying);
			gotostate('patrol');
		}
			
		if(vsize(newvec)<10)
		{
			orbitrot.yaw=orbitrot.yaw+10000;	
		}
	}



	begin:
		orbitStartYaw=rotation.yaw;
		cam.gotostate('standardstate');
		playerharry.bosstarget=self;
		SetPhysics(PHYS_none);
		loopanim('scheming');
		sleep(orbittime);
	spotLoop:
		if(abs((orbitrot.yaw&65536)-(orbitStartYaw&65536))>1000)
		{
			sleep(0.1);
			goto 'spotloop';
		}

		SetPhysics(PHYS_flying);
		cam.gotostate('bossstate');
		playerHarry.BossTarget = self;
		playerHarry.cam.DirectionActor = none;
		gotostate('patrol');



}



// patrol state moves the characters around a path described by hpath and basestations

state patrol
{

/*	function tick(float deltatime)
	{
		super.tick(deltatime);
		if (Opacity > 0.3)
		{
			Opacity -= 0.35 * deltatime;
			if (Opacity < 0.3)
			{
				Opacity = 0.3;
			}
		}
	}*/

function bool TakeSpellEffect(baseSpell spell)
{
				//no damage if in patrol
}

	function startup()
	{
		foreach allActors(class'baseHarry', p)
		{
			if( p.bIsPlayer&& p!=Self)
			{
				break;
			}
		}

		foreach allActors(class 'navigationPoint',navP)
		{
			destP=baseStation(navP);

			if(destP.Name==stationDestination)
			{
				break;
			}
		}

		foreach allActors(class 'navigationPoint',navP)
		{
			if(navp.Name==firstPath)
			{
				break;
			}
		}

		TrailFX = spawn(class'PeevesTrail', [spawnlocation] location);
		TrailFX.SetPhysics(PHYS_Trailer);
		TrailFX.setowner(self);
		TrailFX.AttachToOwner();
	}

	function EndState()
	{
		TrailFX.Shutdown();
		super.EndState();
	}

  Begin:
  

	enable( 'Tick' );
	startup();
	SetPhysics(PHYS_flying);
	Style=STY_Translucent;
	Opacity = 0.3;

		switch(	currentSound2)
		{
		case 0:
			FindEmote("EmotivePeeves19", snd);   
			PlaySound( snd, SLOT_Talk, , , 10000.0 );
			currentSound2=1;
			break;
		case 1:
			FindEmote("EmotivePeeves20", snd);   
			PlaySound( snd, SLOT_Talk, , , 10000.0 );
			
			currentSound2=2;
			break;
		case 2:
			FindEmote("EmotivePeeves21", snd);   
			PlaySound( snd, SLOT_Talk, , , 10000.0 );
			currentSound2=3;
			break;
		case 3:
		default:
				FindEmote("EmotivePeeves22", snd);    
			PlaySound( snd, SLOT_Talk, , , 10000.0 );			
			currentSound2=0;
			break;

		}
	

	PlaySound( snd, SLOT_Talk, , , 10000.0 );


	if(firstPath=='')
	{
			goto 'idleloop';

	}
	if (FRand() < 0.5)
		loopAnim('scheming');
	else
		loopAnim('attackfloat', 0.7);

  moveLoop:
	
	next=findPath(navP,stationDestination);
//	p.clientmessage("next in patrol is "$next);
//	p.clientmessage("station destionation is "$stationDestination);
/*	if(next==none)
	{
		goto 'idleloop';
	}
*/
	do
	{
		moveTo(navP.location);
		
		impartinformation();
		sleep(0.005);
	}until(vsize(location-(navP.location)) < 200);

	if(destp==navP)
	{
		PawnAtStation();
	}

	navP=navigationPoint(next);
	if(navP==none)
	{
	  idleLoop:
		while( true )
		{
			loopAnim(idleAnimName, 0.7);
			impartinformation();
			sleep(speechTime);
			speechTime=0;
			sleep(0.5);

			//If loop path, just start the whole patrol process over again by setting navp to firstPath.
			if( bLoopPath )
			{
				foreach allActors(class 'navigationPoint',navP)
					if(navp.Name==firstPath)
						break;
				break; //break the while loop
			}

			//goto 'idleloop';
		}
	}

	
	next=none;
	
	goto 'moveLoop';
}


state atStation
{

/*	function tick(float deltatime)
	{
		super.tick(deltatime);
		if (Opacity < 1.0)
		{
			Opacity += 0.35 * deltatime;
		}
	}
*/
	begin:

	bCollideWorld=true;
	SetPhysics(PHYS_Rotating);
	Style=STY_Normal;
	Opacity = 1.0;
	
	desiredRotation=(destP.rotation);


	//sleep(destP.aiData[stationNumber].pauseTime);
	stationDestination=destP.aiData[stationNumber].stationDestination;
	pathType=destP.aiData[stationNumber].pathType;
	firstPath=destP.aiData[stationNumber].firstPath;
	stationNumber=destP.aiData[stationNumber].nextStationGroup;



	if(destP.aiData[stationNumber].behavior==bh_die)
	{
		destroy();
	}
	if(destP.aiData[stationNumber].behavior==bh_idle2)
	{
		if(false)
		{
			gotostate('orbit');
			orbitCount=0;
		}
		else
		{
			orbitCount=orbitCount+1;
			turntoward(playerHarry);
			gotostate('attackHarry');
		}
	}
	else
	{
		
		turntoward(playerHarry);
		gotostate('attackHarry');
	}


}




state shot
{
begin:

	switch(Rand(4))
	{
	case 0:
		FindEmote("EmotivePeeves31", snd); 
		PlaySound( snd, SLOT_Talk, , , 10000.0 );
		playerHarry.clientMessage("Peeves tried to PlaySound Emotive31");
		break;
	case 1:
		FindEmote("EmotivePeeves32", snd); 
		PlaySound( snd, SLOT_Talk, , , 10000.0 );
		playerHarry.clientMessage("Peeves tried to PlaySound Emotive32");
		break;
	case 2:
		FindEmote("EmotivePeeves33", snd); 
		PlaySound( snd, SLOT_Talk, , , 10000.0 );
		playerHarry.clientMessage("Peeves tried to PlaySound Emotive33");
		break;
	case 3:
		FindEmote("EmotivePeeves34", snd); 
		PlaySound( snd, SLOT_Talk, , , 10000.0 );
		playerHarry.clientMessage("Peeves tried to PlaySound Emotive34");
		break;
	}

//	PlaySound(sound 'HPSounds.peeves_sfx.pee_009', SLOT_Talk, 3.2, false, 2000.0, 1.0);
	loopAnim('hit');
	finishanim();
	if(hitCount<=0)
		gotostate('dieing');
	gotoState('patrol');

}
state dieing
{


function causetrigger()
{

	local actor a;



	foreach AllActors( class 'Actor', A, Event )
	{
		A.Trigger( self, self.Instigator );
	}


}

function findpstart()
{
		foreach allActors(class 'navigationPoint',navP)
		{
			if(navp.Name==firstPath)
			{
				break;
			}
		}

}
begin:
	cam.gotostate('standardstate');
	playerharry.underattack=false;
	playerharry.BossTarget=none;
	bCollideWorld=false;
	SetPhysics(PHYS_flying);
	airspeed=200;
	sleep(0.5);
	causetrigger();
	FindDialog("111Peeves7", snd, str); 
	PlaySound( snd, SLOT_Talk, , , 10000.0 );

//	PlaySound(sound 'HPSounds.peeves_sfx.pee_011', SLOT_Talk, 3.2, false, 2000.0, 1.0);
	stationDestination=exitstationdestination;
	pathType=exitpathtype;
	firstPath=exitfirstpath;
	findpstart();
	turntoward(navp);
	sleep(1);
	gotostate('patrol');






}

defaultproperties
{
     HitCount=4
     bFlipTarget=True
     IdleAnimName=None
     AirSpeed=800
     Physics=PHYS_Flying
     CollideType=CT_Shape
     bCollideWorld=False
     bProjTarget=True
     RotationRate=(Pitch=100000,Yaw=100000,Roll=100000)
}
