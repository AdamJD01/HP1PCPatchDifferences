//=============================================================================
// Harry  -- hero character 
//	This subclass is specialised to operate only in the Fluffy level.
//=============================================================================
class HarryL502 extends Harry;

var() name FluteBone;


var fluffy Fluffy;
var hprops Flute;

function PostBeginPlay()
{
 	Super.PostBeginPlay();

	// Find Fluffy.
	foreach allActors(class'fluffy', Fluffy)
	{
		break;
	}
}

//**************************************************************************************
function DoJump( optional float F )
{
	if( VSize2d( Fluffy.Location - Location ) > 1500 )
		Super.DoJump( F );
}

//**************************************************************************************
function CutRelease()
{
	Super.CutRelease();
ClientMessage("Make Flute 1");

	// See if time to play flute yet.
	if( VSize(Fluffy.Location - Location) < 1000  &&  Flute == none )
	{
		// Swap flute in for wand.
		Flute = spawn(class'Flute', [SpawnOwner] self);
		//Flute.AttachToOwner('RightHand');//FluteBone);
     ClientMessage("Make Flute:"$Flute$" bp:"$BonePos('RightHand')	);

		Weapon.bHidden = true;
		if( baseWand(Weapon) != none )
			baseWand(Weapon).WandEffect.bHidden = true;
	}
}

// Override Cast to play flute here.
exec function AltFire( optional float F )
{
	if(baseHud(myhud).bcutscenemode)
	{
		return;
	}
	if( Weapon.bHidden )
		gotoState('FlutePlay');
	else
		super.AltFire(F);
}

state FlutePlay
{
	ignores ProcessMove;

	function BeginState()
	{
		Velocity *= vec(0,0,1);  //Leave z be, so he keeps falling (if he's falling)
		Acceleration = vec(0,0,0);
		loopAnim('flutePlay');
		Fluffy.Trigger(Flute, self);
	}

	function EndState()
	{
		Fluffy.Trigger(none, self);
	}

	// Exit state when button let up.
	function PlayerTick( float T )
	{
		Super.PlayerTick(T);
		if( bAltFire==0 )
		{
			loopAnim('breath');
			gotoState('PlayerWalking');
		}
	}
}

defaultproperties
{
     FluteBone=RightHand
}
