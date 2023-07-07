class tut1Peeves expands peeves;



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



	function destroyed()
	{
		TrailFX.Shutdown();
		
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
		playerHarry.takeDamage(5,self,Location, Vect(0,0,1)*9,'exploded');
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

	gotostate('patrol');


}
	begin:
	

	loop:
		loopanim('look');
		sleep(1.4);
		turntoward(playerHarry);

		
		goto 'loop';

}




state waitforTrigger2
{
	
function Trigger( actor Other, pawn EventInstigator )
{
//	PlaySound(sound 'HPSounds.peeves_sfx.pee_009', SLOT_Talk, 3.2, false, 2000.0, 1.0);

	
	gotostate('attackcamera');


}
	begin:
	
	SetPhysics(PHYS_Rotating);
	loop:
		loopanim('look');
		sleep(0.4);
		turntoward(playerHarry);
		moveto(location);
		playerharry.clientmessage("in waiting peeves 2");
		
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

begin:
	
	findcam();
	Opacity=1;
	hugcamera=true;
	pcam.gotostate('cutstate');
	SetPhysics(PHYS_rotating);
//	PlaySound(sound 'HPSounds.peeves_sfx.pee_009', SLOT_Talk, 3.2, false, 2000.0, 1.0);

	
loop:
	turntoward(pcam);
	sleep(0.5);
	if(abs(vsize(camoffset-location))>80)
	{
		goto'loop';
	}
	FindDialog("111Peeves1", snd, str); 
	PlaySound( snd, SLOT_Talk, , , 1000.0 );


	turntoward(pcam);
	playanim('grab');
	finishanim();
	sleep(0.75);
	airspeed=200;
	pcam.gotostate('standardstate');
	sleep(0.5);
	TriggerEvent('cutscenepee',self,self);
	gotostate('taunt');
	
	goto 'loop';





}



state taunt
{


	
function Trigger( actor Other, pawn EventInstigator )
{


	gotostate('obspatrol');


}

function setup()
	{
		foreach allActors(class 'navigationPoint',navP)
		{
			destP=baseStation(navP);

			if(destP !=None && destP.Name=='basestation2')
			{
				break;
			}
		}

	}
	begin:
		setup();
		Opacity=1;
		SetPhysics(PHYS_flying);
		playerharry.clientmessage("moving to "$navp);
		movetoward(navp);
		SetPhysics(PHYS_rotating);
	loop:
		
		turntoward(playerharry);
		loopanim('scheming');
		sleep(5.5);
		playanim('seeharry');
		switch(	currentSound)
		{
		case 0:

			FindDialog("111Peeves3", snd, str); 
			PlaySound( snd, SLOT_Talk, , , 1000.0 );
		
		//	PlaySound(sound 'HPSounds.peeves_sfx.pee_004', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			currentSound=1;
			break;
		case 1:
			FindDialog("111Peeves2", snd, str); 
			PlaySound( snd, SLOT_Talk, , , 1000.0 );

		//	PlaySound(sound 'HPSounds.peeves_sfx.pee_008', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			currentSound=2;
			break;
		case 2:
			FindDialog("111Peeves4", snd, str); 
			PlaySound( snd, SLOT_Talk, , , 1000.0 );

		//	PlaySound(sound 'HPSounds.peeves_sfx.pee_010', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			currentSound=3;
			break;
		case 3:
			FindDialog("111Peeves5", snd, str); 
			PlaySound( snd, SLOT_Talk, , , 1000.0 );

		//	PlaySound(sound 'HPSounds.peeves_sfx.pee_003', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			currentSound=0;
			break;

		}
		finishanim();

		goto 'loop';




	
}
state attackHarry
{


function tick(float deltatime)
{

	dancetime=dancetime+deltatime;
	if(dancetime>0.3)
	{
		randdir=200*vrand();
		dancetime=0;

	}
	if(randdir.z<0)
	{
		randdir.z=0;
	}
	setlocation(location+(randdir*deltatime));


}

	begin:
		Opacity=1;
		switch(	currentSound)
		{
		case 0:

		//	PlaySound(sound 'HPSounds.peeves_sfx.pee_004', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			currentSound=1;
			break;
		case 1:
		//	PlaySound(sound 'HPSounds.peeves_sfx.pee_008', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			currentSound=2;
			break;
		case 2:
		//	PlaySound(sound 'HPSounds.peeves_sfx.pee_010', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			currentSound=3;
			break;
		case 3:
		//	PlaySound(sound 'HPSounds.peeves_sfx.pee_003', SLOT_Talk, 3.2, true, 2000.0, 1.0);
			currentSound=0;
			break;

		}

		cam.gotostate('bossstate');
		loopAnim('attackfloat');
//		AirSpeed=+00200.000000;

	wait:
		TurnTo(playerHarry.location);
		playanim('scheming',1.3);

		dancetime=0;
		settimer(0.1+(frand()*2),false);
		randdir=200*vrand();

		finishanim();
		
		
		gotostate('throwing');
//		MoveToward(playerHarry);
		goto 'wait';


}


// patrol state moves the characters around a path described by hpath and basestations

state patrol
{
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

			if(destP!=None && destP.Name==stationDestination)
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
	airspeed=130;
	Opacity=0.3;
	SetPhysics(PHYS_flying);

		switch(	currentSound2)
		{
		case 0:
			FindEmote("EmotivePeeves19", snd);   
			PlaySound( snd, SLOT_Talk, , , 1000.0 );
			currentSound2=1;
			break;
		case 1:
			FindEmote("EmotivePeeves20", snd);   
			PlaySound( snd, SLOT_Talk, , , 1000.0 );
			
			currentSound2=2;
			break;
		case 2:
			FindEmote("EmotivePeeves21", snd);   
			PlaySound( snd, SLOT_Talk, , , 1000.0 );
			currentSound2=3;
			break;
		case 3:
		default:
				FindEmote("EmotivePeeves22", snd);    
			PlaySound( snd, SLOT_Talk, , , 1000.0 );			
			currentSound2=0;
			break;

		}
	

	PlaySound( snd, SLOT_Talk, , , 1000.0 );



	if(firstPath=='')
	{
			goto 'idleloop';

	}
	loopAnim('float');

  moveLoop:
	
	next=findPath(navP,stationDestination);
	playerharry.clientmessage("next in patrol is "$next);
	playerharry.clientmessage("station destionation is "$stationDestination);

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
	}until(vsize(location-(navP.location)) < fNavPointColRadius);

//cmp 10-17 added destp!=None &&	to fix log spam.
	if(destp!=None)
		{ 
		if(destp==navP)
			{
			PawnAtStation();
			}
		}

	navP=navigationPoint(next);
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




// patrol state moves the characters around a path described by hpath and basestations

state obspatrol
{
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

			if(destp!=None && destP.Name==stationDestination)
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
	airspeed=120;
	SetPhysics(PHYS_flying);
	

	PlaySound( snd, SLOT_Talk, , , 1000.0 );



	if(firstPath=='')
	{
			goto 'idleloop';

	}
	loopAnim('float');

  moveLoop:


		switch(	currentSound2)
		{
		case 0:
			FindEmote("EmotivePeeves19", snd);   
			PlaySound( snd, SLOT_Talk, , , 1000.0 );
			currentSound2=1;
			break;
		case 1:
			FindEmote("EmotivePeeves20", snd);   
			PlaySound( snd, SLOT_Talk, , , 1000.0 );
			
			currentSound2=2;
			break;
		case 2:
			FindEmote("EmotivePeeves21", snd);   
			PlaySound( snd, SLOT_Talk, , , 1000.0 );
			currentSound2=3;
			break;
		case 3:
		default:
				FindEmote("EmotivePeeves22", snd);    
			PlaySound( snd, SLOT_Talk, , , 1000.0 );			
			currentSound2=0;
			break;

		}

	if(vsize(location-(playerharry.location))>150)
	{ 
		Opacity=0.6;
	}
	else
	{
		Opacity=1;
	}

	next=findPath(navP,stationDestination);
	playerharry.clientmessage("next in patrol is "$next);
	playerharry.clientmessage("station destionation is "$stationDestination);

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
	}until(vsize(location-(navP.location)) < fNavPointColRadius);

//cmp 10-17 added destp!=None &&	to fix log spam.
	if(destp!=None)
	{
		if(destp==navP)
		{
			PawnAtStation();
		}
	}

	navP=navigationPoint(next);
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

	begin:


	//SetPhysics(PHYS_Rotating);

	
	desiredRotation=(destP.rotation);


	sleep(destP.aiData[stationNumber].pauseTime);
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
			gotostate('attackHarry');
		}
	}
	if(destP.aiData[stationNumber].behavior==bh_idle1)
	{
		

		gotostate('waitfortrigger2');
	}

	gotostate('patrol');
}




state shot
{
begin:
	FindEmote("EmotivePeeves15", snd);   
	PlaySound( snd, SLOT_Talk, , , 1000.0 );


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
	bCollideWorld=false;
	SetPhysics(PHYS_flying);
	airspeed=200;
	causetrigger();
	FindDialog("111Peeves7", snd, str); 
	PlaySound( snd, SLOT_Talk, , , 1000.0 );

//	PlaySound(sound 'HPSounds.peeves_sfx.pee_011', SLOT_Talk, 3.2, false, 2000.0, 1.0);
	stationDestination=exitstationdestination;
	pathType=exitpathtype;
	firstPath=exitfirstpath;
	findpstart();
	playerharry.clientmessage("move toward "$navp);
	turntoward(navp);
	sleep(1);
	gotostate('patrol');






}

defaultproperties
{
     HitCount=4
     bFlipTarget=True
     IdleAnimName=None
     AirSpeed=200
     Physics=PHYS_Flying
     bCollideWorld=False
     bProjTarget=True
     RotationRate=(Pitch=10000,Yaw=10000,Roll=10000)
}
