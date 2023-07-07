//=============================================================================
// baseProps
//=============================================================================
class baseProps expands Decoration;


var vector saveLocation;	//original position. used by bobbing code
var (display) float fBobAmount;
var bool bDebounce;

var (display) bool bDoBob;	//bob up and down a little bit. (for hogs letter)
var () bool bProxMessage;	//Proximity message.
var () string sProxMessage;
var () Texture ProxMessageIcon;
var () float fProxRange;
var rotator rotv;
var float dist;
var actor camSpawn;
var float curlevTime;

var (SpellEffects) bool bCanLevitate;
var (SpellEffects) float levHeight;
var (spellEffects) float levTime;
var bool bIsLevitating;
var float levDestZ;
var bool bStopLevitating;

var (SpellEffects) bool bCanTransform;
var (SpellEffects) class<Actor> transformInto;
var (spelleffects) bool bMakesBean;
var (spelleffects) class<actor>beantoMake;
var bool hasTransformed;

var (SpellEffects) bool bFlintTarget;
var (SpellEffects) bool bAvifTarget;
var (SpellEffects) bool bVerdTarget;
var (SpellEffects) bool bAlohoTarget;

var (Trigger) bool bTransformOnTrigger;
var (Trigger) class<Actor> triggerTransformInto;
var (SpellEffects) bool bSpellCausesTrigger;

var (SpellEffects) class<ParticleFX> attachedParticleClass;
var (SpellEffects) vector attachedParticleOffset;
var ParticleFX attachedParticleFX;
var ParticleFX wingParticleFX;

var  float olddist;
var  float oldyaw;
var float bouncetime;
var float prevYawdir;
var int realmove;
var float wingwobble;
var float wobblePlus;
var float levParSize;
var (display)class <decal> ShadowClass;
var bool stoppedLev;




var (Puzzle) bool bPartOfPuzzle;
var (Puzzle) name puzzleName;

var () Texture hudIcon;		//use when item is in quickInventory.

var basePuzzle puzzle;
var basecam cam;

var baseHarry playerHarry;
var vector orgloc;		//location where the prop was located
var actor touchingAct;

var float LiftTimer;		//how long it's been levitating
var bool lockSpell;			// lock the spell casting on until leviatated.

var float wingYaw;

var() bool  bSuperJump;
var() float JumpMultiplier;
var bool nowing;

function touch(actor other)
{
	touchingAct=other;

}


event Trigger( Actor Other, Pawn EventInstigator )
{
local actor newSpawn;
local vector spawnLoc;

	if(bTransformOnTrigger && triggerTransformInto!=None)
		{
		spawnLoc=location;
		spawnLoc.z=location.z+30;
		newSpawn=Spawn(triggerTransformInto,,, spawnLoc);

		Destroy();
		}
		noWing=true;	
		playerharry.clientmessage("Triggered");

}
function killAttachedParticleFX(float time)
{
	if(attachedParticleFX!=None)
		{
		attachedParticleFX.ParticlesPerSec.base=0;
		attachedParticleFX.LifeTime.base=0;

		if(time==0.0)
			attachedParticleFX.destroy();
		else
			attachedParticleFX.lifeSpan=time;
		}
	
}
function changeAttachedParticleFX(class<ParticleFX> newFX)
{
	if(attachedParticleFX!=None)
		attachedParticleFX.destroy();
	attachedParticleFX=spawn(newFX,self,,location+attachedParticleOffset);
	attachedParticleFX.setRotation(newFX.default.rotation);
	attachedParticleFX.setPhysics(PHYS_Trailer);
}
event PreBeginPlay()
{
local basePuzzle puz;

	foreach allActors(class'baseHarry', playerHarry)
		{
		if( playerHarry.bIsPlayer)
			break;
		}

	if(bDoBob)		//start bobbing if on by default
		{
		startBobbing();
		}
	if(bPartOfPuzzle)
		{
		foreach allActors(class'basePuzzle', puz)
			{
			if( puz.name==puzzleName)
				{
				log("Bound "$self $"To "$puzzleName);
				puzzle=puz;
				break;
				}
			}
		if(puzzle==None)
			{
			log("Cant find puzzle named "$puzzleName $"In "$self);
			}
		}
	Enable('Touch');

	if(attachedParticleClass!=None)
		{
		attachedParticleFX=spawn(attachedParticleClass,self,,location+attachedParticleOffset);
		attachedParticleFX.setRotation(attachedParticleClass.default.rotation);
		attachedParticleFX.setPhysics(PHYS_Trailer);
		}
	orgloc=location;



}

event destroyed()
{
	if(attachedParticleFX!=None)
		{
		attachedParticleFX.Shutdown();
		}
	super.destroyed();
}

function startBobbing()
{
	saveLocation=Location;
	saveLocation.Z+=fBobAmount+3.5;	//move it up a bit so it doesnt fall out of the world when it bobs.
	bDoBob=TRUE;
}

event Tick(float delta)
{
local vector vect; 
local vector dir;
local vector vect2;
local bool distchang;
local vector oldloc;
local rotator trot;

	if(bDoBob)
		{
		vect.x=0;
		vect.y=0;
		vect.Z=fBobAmount*sin(8.0 * Level.TimeSeconds);
		SetLocation(saveLocation+vect);
		}
	if(bProxMessage)
		{
		if ( (abs(Location.Z - playerHarry.Location.Z) < CollisionHeight + playerHarry.CollisionHeight)
			&& (VSize(Location - playerHarry.Location) < fProxRange))
			{
			playerHarry.ReceiveIconMessage(ProxMessageIcon,sProxMessage,3.0);
//	log("proxMessage triggered "$sProxMessage);
			}
		else
			bDebounce=false;

		}

	if(bIsLevitating)
	{
		
			if(curlevtime>0&&!bStopLevitating&&location.z<levDestZ)
			{
				vect.x=0;
				vect.y=0;
				vect.z=0.4;
				vect=normal(vect);
				vect2=location;
				Move(vect*2);
				if(vsize(vect2-location)<0.3)	//change for getting stuck in doorways 9/24 gk
					levDestZ=location.z;
				vect2=cam.location;
				vect2.z=vect2.z+3.0;	
				cam.setlocation(vect2);	
				liftTimer=liftTimer+delta;
				if(lifttimer>8)
				{
					bStopLevitating=true;
					playerharry.clientmessage("lift timeout");
				}
			}

			else
			{
				lockSpell=false;
				vect.x=0;
				vect.y=0;
				vect.z=0;

				distchang=false;
				
					
				if(bouncetime>0)
				{
					dist=dist+olddist;
					rotv.yaw=rotv.yaw+prevyawdir;
					bouncetime=bouncetime-delta;
					
				}
				else
				{
			
					if(playerHarry.smoothMouseY>10||playerharry.aformove>0)
					{
						olddist=-4;
						dist=dist+4;
						
						distchang=true;
					}
					if(playerHarry.smoothMouseY<-10||playerharry.aformove<0)
					{
						olddist=+4;
						dist=dist-4;
						
						distchang=true;
					}
				
					wingyaw=100;
							
					if(playerHarry.smoothMouseX>10||playerharry.asidemove>0)
					{
						oldyaw=rotv.yaw;
						rotv.yaw=rotv.yaw-wingyaw;
						prevyawdir=20;
						
						distchang=true;
						
					}
					if(playerHarry.smoothMousex<-10||playerharry.asidemove<0)
					{
						oldyaw=rotv.yaw;
						rotv.yaw=rotv.yaw+wingyaw;
						prevyawdir=-20;
							
						distchang=true;
					
					}
				}
				basewand(playerharry.weapon).lastcastedspell.flyParticleEffect.SizeWidth.base=levParSize*(curlevtime/levtime);
				basewand(playerharry.weapon).lastcastedspell.flyParticleEffect.Sizelength.base=levParSize*(curlevtime/levtime);
				if(dist<60)
				{
					dist=60;
				}
				if(dist>400)
				{
					dist=400;
				}

				dir.x=dist;
				dir.y=0;
				dir.z=0;
				dir=dir>>rotv;
				dir.x=cam.location.x+dir.x;
				dir.y=cam.location.y-dir.y;
				dir.z=location.z;
				vect=(dir-location);
				curlevtime=curlevtime-delta;

//cmp 10-17 spamming the log				dir=wingParticleFX.location;
				dir.x=location.x;
				dir.y=location.y;
//cmp 10-17 spamming the log				wingParticlefx.setlocation(dir);


				if(bStopLevitating==true)
				{

					if(!stoppedLev)
					{
						stoppedLev=true;
						StopSound(sound'HPSounds.magic_sfx.levitate_loop' , SLOT_Interact );
						PlaySound(sound'HPSounds.magic_sfx.levitate_end');



					}
					eVulnerableToSpell=SPELL_None;
					playerHarry.freeHarry();
					cam.gotostate('standardstate');

					vect.x=0;
					vect.y=0;
					vect.Z=-0.40;
					
					trot=rotation;
					if(trot.pitch<0)
					{
						trot.pitch=trot.pitch+1000;
						
						if(trot.pitch>0)
						{
							trot.pitch=0;
							
						}
					}
					if(trot.pitch>0)
					{
						trot.pitch=trot.pitch-1000;
						if(trot.pitch<0)
						{
							trot.pitch=0;
						}
					}
					trot.roll=trot.pitch;
					
					setrotation(trot);
					if(touchingAct!=none)
					{	
						if(touchingAct.isa('trigger'))
						{
							vect=touchingAct.location-location;
							playerharry.clientMessage("touching "$touchingAct);
							//touchingAct=none;
						}
					}
					oldloc=location;
					Move(normal(vect)*4);
					
					vect2=cam.location;
					vect2.z=vect2.z-3.2;
					
					if((location.z<=orgloc.z)||(oldloc.z-location.z<2))
					{
						
						
						bIsLevitating=false;
						bStopLevitating=false;
					
						
						SetPhysics(PHYS_Falling);
//						wingParticlefx.destroy();
						
						if(!noWing)
							eVulnerableToSpell=SPELL_WingardiumLeviosa;
					
						if(shadow!=none)
						{
							shadow.destroy();
						}
					
					}

					return;

				}
				if(curlevtime<0)
				{
					bstoplevitating=true;

					
					


				}
							
				else
				{
					trot=rotation;
					trot.pitch=(wingwobble*sin(8.0 * Level.TimeSeconds))*100;
					trot.roll=(wingwobble*sin(8.0 * Level.TimeSeconds))*100;
					
					setrotation(trot);
					wingwobble=wingwobble+(wobbleplus*delta);


					if(bouncetime>0)
					{
							move(vect*delta);
							
							return;
					}


					if(true)
					{

						//bCollideActors=true;
						//bCollideWorld=true;
						
						

					
						if(trace(vect2,oldloc,location+((vect*delta)*50))==none)
						{
							
							move(vect*delta);
							
							if((vsize(vect)*delta)>20)
							{
								playerharry.clientmessage("stuck "$vsize(vect));
								vect=location;
								vect.z=0;
								vect2=cam.location;
								vect2.z=0;

								dir=normal(vect-vect2);
								rotv=rotator(dir);
								rotv.yaw=-rotv.yaw;
							
								dist=vsize(cam.location-location);

							}
							
							realmove=0;

						
						
					
					
						}
						
						else
						{
					
							if(realmove!=0)
							{
								if(realmove==1)
								{
									prevyawdir=-prevyawdir;
								}
								if(realmove==2)
								{
									olddist=-olddist;
									prevyawdir=-prevyawdir;
								}
								if(realmove==3)
								{
									prevyawdir=-prevyawdir;
								}
								if(realmove==4)
								{
									
									vect=location;
									vect.z=0;
									vect2=cam.location;
									vect2.z=0;

									dir=normal(vect-vect2);
									rotv=rotator(dir);
									rotv.yaw=-rotv.yaw;
								
									dist=vsize(cam.location-location);
									bouncetime=0;

								}
								if(realmove>4)
								{
								

									bStopLevitating=true;
									realmove=0;

								}
							}
						
							bouncetime=0.4;
							realmove=realmove+1;
							
					
						}
						
					}
				}
			}
		}

}










function bool TakeSpellEffect(baseSpell spell)
{
local vector spawnLoc;
local actor newSpawn;
local bool isHit;
local actor a;


//	playerPawn(spell.Instigator).clientMessage("XXXXXXX:Spell " $spell);

	if(spell.class==class'spellAloho' && bAlohoTarget)
		{
		isHit=(true);	//what else? open door?
		}

	else if(spell.class==class'spellAvif' && bAvifTarget)
		{
		spawnLoc=location;
		spawnLoc.z=location.z+30;
		newSpawn=Spawn(transformInto,,, spawnLoc);

		Destroy();
		isHit=(true);	
		}

	else if(spell.class==class'spellFlint' && bAvifTarget)
		{
		spawnLoc=location;
		spawnLoc.z=location.z+30;
		newSpawn=Spawn(transformInto,,, spawnLoc);

		Destroy();
		isHit=(true);	
		}

	 else if(spell.class==class'spellVerd' && bVerdTarget)
		{
			//take damage probably.
			isHit=(true);	
		}

	else if(spell.class==class'spellLev')
		{
		if(bCanLevitate)
			{
			startLevitate();
			isHit=(true);	//spell took effect.
			}
		else
			isHit=(false);
		}
	else if(spell.class==class'spellTrans')
		{
		if(bCanTransform)
			{
			spawnLoc=location;
			spawnLoc.z=location.z+30;
			newSpawn=Spawn(transformInto,,, spawnLoc);

			bCanTransform=false;

			if(puzzle!=None)
				puzzle.myTrigger(self);
			Destroy();
			isHit=(true);	//spell took effect.
			}
		else
			isHit=(false);
		}
/*
	playerPawn(spell.Instigator).clientMessage("reached trigger isHit is "$isHit);
	if(isHit && bSpellCausesTrigger&&bcanTransform)
		{
		if( Event != '' )
		playerPawn(spell.Instigator).clientMessage("event isis "$isHit);
			foreach AllActors( class 'Actor', A, Event )
			{
			
			//	A.Trigger( self, playerHarry );
				break;
			}

		}
	*/

	if(isHit&&bMakesBean)
	{
			spawnLoc=location;
			spawnLoc.z=location.z-40;
			newSpawn=Spawn(beantoMake,,, spawnLoc);
	}


	return(isHit);

}








function startLevitate()
{
	local vector vect;
	local vector vect2;
	local vector dir;
	local vector spawnLoc;

	if(bIsLevitating)
		return;	//already levitating.

	lifttimer=0;
	noWing=false;
	lockSpell=true;
	stoppedLev=false;
	playerharry.bSkipKeyPressed =false;
	levDestZ=orgloc.z+levHeight;
	wingwobble=0;
	wobbleplus=15/levtime;

	foreach allActors(class'BaseCam', cam)
		break;

	SetPhysics(PHYS_Projectile);
	RotationRate.Yaw = 7500*FRand();
//	RotationRate.Pitch = 7500*FRand();
	bFixedRotationDir=True;

//	bCanLevitate=false;
	bIsLevitating=true;
	cam.gotostate('cutstate');
	cam.positionactor=none;
	cam.directionactor=self;
	vect=location;
	vect.z=0;
	vect2=cam.location;
	vect2.z=0;

	dir=normal(vect-vect2);
	rotv=rotator(dir);
	rotv.yaw=-rotv.yaw;
//	playerharry.clientmessage("rotv is "$rotv);	
	dist=vsize(cam.location-location);
	curlevtime=levtime;
	playerharry.forceHarrywing(self);

	eVulnerableToSpell=SPELL_WingSustain;

	levParsize=basewand(playerharry.weapon).lastcastedspell.flyParticleEffect.SizeWidth.base;

//	wingParticleFX=spawn(Class'HPParticle.Levitate_react',,,location);
	wingyaw=50;

	PlaySound(sound'HPSounds.magic_sfx.levitate_loop',SLOT_Interact);
	playerharry.clientmessage("starting sound");

	if( ShadowClass != none )
		Shadow = Spawn(ShadowClass,self);



}

defaultproperties
{
     fBobAmount=1.5
     fProxRange=70
     levHeight=100
     levTime=10
     JumpMultiplier=1.85
     CollisionRadius=30
     CollisionHeight=30
     bCollideActors=True
}
