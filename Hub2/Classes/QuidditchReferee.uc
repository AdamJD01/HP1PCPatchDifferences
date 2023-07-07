//=============================================================================
// QuidditchReferee -- Keeper of the rules of the mini-game; main game logic
//=============================================================================
class QuidditchReferee extends GameReferee;

var BroomHarry			Harry;
var QuidPlayer			Seeker;				// Opponent team's seeker
var Snitch				Snitch;
var QuidCommentator		Commentator;		// Source of spoken game commentary

var(GameReferee) int	HoopsToHit;			// How many hoops have to be hit in a row to catch snitch

enum QuidPlayMechanic
{
	PM_Hoops,				// Uses hoop trail to judge how well Harry is tracking snitch
	PM_Proximity,			// Uses snitch proximity to judge how well Harry is tracking snitch; no hoop trail
	PM_ProximityWithHoops	// Uses snitch proximity to judge how well Harry is tracking snitch, but hoop trail is visible
};

enum HouseAffiliation	// Must be in same order as in QuidditchCrowd.uc and QuidCommentator
{
	HA_Gryffindor,
	HA_Ravenclaw,
	HA_Hufflepuff,
	HA_Slytherin,
};

enum TeamAffiliation	// What team a crowd roots for
{
	TA_Gryffindor,
	TA_Opponent,
	TA_Neutral,

	TA_NumAffiliations
};

struct RandomSeed		// To keep game from playing the same way twice
{
	var float SeedA;
	var float SeedB;
	var float SeedC;
	var float SeedD;
};

var(GameReferee) QuidPlayMechanic	PlayMechanic;

var(GameReferee) HouseAffiliation	Opponent;	// Which house is the opponent team affiliated with

var(GameReferee) float	fSnitchTrackingOffset;	// How far behind the snitch is the center of the tracking sphere

var(GameReferee) float	fSnitchMaxGainRadiusAt0;	// How close to snitch Harry needs to be for fastest progress gain
var(GameReferee) float	fSnitchNeutralRadiusAt0;	// How far from snitch Harry needs to be to not gain or lose progress
var(GameReferee) float	fSnitchNeutralRadiusAt100;	// How far from snitch Harry needs to be to not gain or lose progress
var(GameReferee) float	fSnitchMaxLossRadiusAt0;	// How far from snitch Harry needs to be for fastest progress loss

var(GameReferee) float	fSnitchMaxGainRate;		// How fast Harry gains progress when closest to snitch (percent/sec)
var(GameReferee) float	fSnitchMaxLossRate;		// How fast Harry loses progress when farthest from snitch (percent/sec)

var(GameReferee) float	fSnitchMaxCatchTime;	// How long can Harry try to catch the snitch during the catch phase (seconds)
var(GameReferee) int	SnitchMaxCatchTries;	// How many times can Harry try to catch the snitch during the catch phase

var float			fProgressPercent;			// Snitch tracking progress on a scale of 0.0 to 100.0
var int				CatchTriesLeft;				// How many tries left before loosing the snitch

const				NUM_PROGRESS_SOUNDS = 15;
var Sound			ProgressSounds[15];			// All the different tracking progress sounds

var QuidditchCrowd	Crowds[3];					// Chains of spectator crowds, indexed by TeamAffiliation
var float			fTimeToCheer;				// When next to have crowd cheer
var RandomSeed		RandSeed;					// Keep game from playing the same way twice

var bool			bNeedsCommentator;			// Whether this mini-game must have a commentator

var bool			bSnitchVisible;				// Whether Snitch has become visible
var bool			bSeekerJoinedPursuit;		// Whether other seeker has begun chasing snitch yet
var bool			bHarryJoinedPursuit;		// Whether Harry has begun chasing snitch yet
var bool			bHarryReaching;				// Whether Harry is about to grab for the snitch

var int				GryffScore;					// Gryffindor's score at end of match
var int				OpponentScore;				// Opposing team's score at end of match
var bool			bWonLeague;					// Whether Gryffindor won the Quidditch League

var bool			bLeagueMode;				// Whether we're playing from menu rather than hub-flow

// AE:
function PlayBigCheer()
{
	PlaySound( sound'HPSounds.Quidditch_sfx.big_cheerstream', SLOT_Talk, , , 10000.0 );
}

//-------------------------------------------------------------------------------------------
// PreBeginPlay(), PostBeginPlay()
//-------------------------------------------------------------------------------------------

function PreBeginPlay()
{
	// Initialize
	Super.PreBeginPlay();

	// Find commentator (or create one)
	foreach AllActors( class'QuidCommentator', Commentator )
		break;
	if ( bNeedsCommentator && Commentator == None )
		Commentator = Spawn( class'QuidCommentator' );

	// AE:
	PlayBigCheer();

	// Tell commentator who the opposing team is
	if ( Commentator != None )
	{
		switch ( Opponent )
		{
			case HA_Ravenclaw:	Commentator.SetOpponent( HA_Ravenclaw );	break;
			case HA_Hufflepuff:	Commentator.SetOpponent( HA_Hufflepuff );	break;
			case HA_Slytherin:	Commentator.SetOpponent( HA_Slytherin );	break;
			default:
				Log( "QuidReferee: Warning: Opponent property not set" );
		}
	}
}

function PostBeginPlay()
{
	local QuidPlayer		OtherPlayer;
	local QuidditchCrowd	Crowd;
	local TeamAffiliation	eTeam;

	// Initialize
	Super.PostBeginPlay();

	// Find actors that are subjects to this game
	foreach AllActors( class'BroomHarry', Harry )
		break;
	foreach AllActors( class'Snitch', Snitch )
		break;

	// Find opponent seeker
	foreach AllActors( class'QuidPlayer', OtherPlayer )
	{
		if ( OtherPlayer.InitialState == 'Seeker' )
		{
			Seeker = OtherPlayer;
			break;
		}
	}

	// Find all the crowds and link them up into separate chains for each team
	foreach AllActors( class'QuidditchCrowd', Crowd )
	{
		Log( "Found crowd "$Crowd.name$", "$Crowd.Affiliation );

		if ( Crowd.Affiliation == HA_Gryffindor )
			eTeam = TA_Gryffindor;
		else if ( Crowd.Affiliation == Opponent )
			eTeam = TA_Opponent;
		else
			eTeam = TA_Neutral;

		Crowd.NextCrowd = Crowds[ eTeam ];	// Singly-link chain
		Crowds[ eTeam ] = Crowd;
	}

	// Setup HUD
	Harry.HUDType = class'HPMenu.QuidHud';

	// Load the tracking progress sounds
	ProgressSounds[ 0] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop01';
	ProgressSounds[ 1] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop02';
	ProgressSounds[ 2] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop03';
	ProgressSounds[ 3] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop04';
	ProgressSounds[ 4] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop05';
	ProgressSounds[ 5] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop06';
	ProgressSounds[ 6] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop07';
	ProgressSounds[ 7] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop08';
	ProgressSounds[ 8] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop09';
	ProgressSounds[ 9] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop10';
	ProgressSounds[10] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop11';
	ProgressSounds[11] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop12';
	ProgressSounds[12] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop13';
	ProgressSounds[13] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop14';
	ProgressSounds[14] = Sound'HPSounds.Quidditch_sfx.Q_Through_Hoop15';

	// Other initialization
	bSnitchVisible = false;
	bSeekerJoinedPursuit = false;
	bHarryJoinedPursuit = false;
	bHarryReaching = false;

	// Start the mini-game with intro CutScene
	InitialState = 'GameIntro';
}

function OnPlayerPossessed()
{
	// Called when player gets possessed by (attached to) the viewport (Player).
	// This is the first moment when the Player member of PlayerPawn is valid,
	// and thus a reference to the Console.

	// Find out from console whether the mini-game is being played in league mode
	// (directly from the menu, rather than in the course of hub flow).
	Super.OnPlayerPossessed();

	// Determine play mode
	switch ( PlayMode )
	{
		case PM_Auto:		bLeagueMode = !HPConsole( Console ).bInHubFlow;	break;
		case PM_InHubFlow:	bLeagueMode = false;							break;
		case PM_MenuDirect:	bLeagueMode = true;								break;
	}
}

//-------------------------------------------------------------------------------------------
// Score methods
//-------------------------------------------------------------------------------------------

function ComputeScore( bool bGryffWon )
{
	// Computes the score for this match and determines if Gryffindor won the
	// Quidditch League with this match.
	local FEQuidMatchPage	MatchPage;

	// Compute match score
	GryffScore    = rand(14)*10;
	OpponentScore = rand(14)*10;

	if ( bGryffWon )
		GryffScore += 150;
	else
		OpponentScore += 150;

	// Determine if Gryffindor won the Quidditch League
	MatchPage = FEQuidMatchPage( HPConsole( Console ).menuBook.QuidMatchPage );
	bWonLeague = MatchPage.DoesTeam0WinLeagueWithThisScore( GryffScore, OpponentScore );
}


//-------------------------------------------------------------------------------------------
// States
//
// GameIntro	- Playing intro cut-scene
// GameIntro2	- Playing part 2 of intro cut-scene (quid players flying)
// GameIntro3	- Playing part 3 of intro cut-scene (Harry flying too)
// GamePlay		- Interactive; flying Harry to get close to the snitch
// GameCatch	- Interactive; timing Harry to actually catch the snitch
// GameWon		- Harry caught snitch
// GameLosing	- Harry lost all stamina and is dying
// GameLost		- Harry died; game lost
//-------------------------------------------------------------------------------------------

state GameIntro
{
	function BeginState()
	{
		PlayerHarry.ClientMessage( "Entered GameIntro State" );
		Log( "Entered GameIntro State" );
		TriggerEvent( 'Intro', self, None );	// Triggered as soon as possible
	}

	function OnCutSceneEvent( Name CutSceneTag )
	{
		// Intro CutScene wants all quid players to start flying
		local QuidPlayer	OtherPlayer;

		foreach AllActors( class'QuidPlayer', OtherPlayer )
			OtherPlayer.Trigger( self, None );

		GotoState( 'GameIntro2' );
	}

Begin:
	// If in league mode, skip to part 3
	if ( bLeagueMode )
		GotoState( 'GameIntro3' );

Loop:
	Sleep( 0.1 );

	goto 'Loop';
}

state GameIntro2
{
	function BeginState()
	{
		PlayerHarry.ClientMessage( "Entered GameIntro2 State" );
		Log( "Entered GameIntro2 State" );
	}

	function OnCutSceneEvent( Name CutSceneTag )
	{
		// Intro CutScene wants Harry to start flying
		Harry.FlyOnPath( 'IPGHarry_Intro' );
		GotoState( 'GameIntro3' );
	}
}

state GameIntro3
{
	function BeginState()
	{
		local QuidPlayer	OtherPlayer;

		PlayerHarry.ClientMessage( "Entered GameIntro3 State" );
		Log( "Entered GameIntro3 State" );

		// If in league mode, there is only one part to intro cutscene;
		// start everything at once
		if ( bLeagueMode )
		{
			// Start seekers and Harry on intro paths
			foreach AllActors( class'QuidPlayer', OtherPlayer )
				OtherPlayer.Trigger( self, None );

			Harry.FlyOnPath( 'IPGHarry_Intro' );
		}
	}

	function OnCutSceneEvent( Name CutSceneTag )
	{
		// Intro CutScene ended; start playing quidditch
		Harry.AirSpeed = 10;
		Harry.Deceleration = Harry.AirSpeedNormal - Harry.AirSpeed;
		Harry.SetLookForTarget( Snitch );

		// Make seeker look for snitch
		if ( Seeker != None )
			Seeker.SetLookForTarget( Snitch );

		fTimeToCheer = Level.TimeSeconds;

		switch ( PlayMechanic )
		{
			case PM_Hoops:
				Snitch.HoopTrail.SetHoopsToHit( HoopsToHit );
				break;

			case PM_Proximity:
			case PM_ProximityWithHoops:
				fProgressPercent = 0.0;
				break;
		}

		GotoState( 'GamePlay' );
	}

	function EndState()
	{
		Harry.StopFlyingOnPath();
		PlayerHarry.ClientMessage( "Exited GameIntro3 State" );
		Log( "Exited GameIntro3 State" );
	}
}

state GamePlay
{
	function BeginState()
	{
		local Bludger	Bludger;
		local int		PercentDone;

		// Start seeking the snitch
		PlayerHarry.ClientMessage( "Entered GamePlay State" );
		Log( "Entered GamePlay State" );

		// Make bludgers look for Harry
		foreach AllActors( class'Bludger', Bludger )
			Bludger.SeekTarget( Harry );

		switch ( PlayMechanic )
		{
			case PM_Hoops:
				QuidHud( Harry.MyHud ).SetHoopCounts( Snitch.HoopTrail.HoopsToHit - Snitch.HoopTrail.HoopsToGo,
													  Snitch.HoopTrail.HoopsToHit );
				break;

			case PM_Proximity:
			case PM_ProximityWithHoops:
				PercentDone = fProgressPercent;
				QuidHud( Harry.MyHud ).SetHoopCounts( PercentDone, 100 );
				break;
		}
		QuidHud( Harry.MyHud ).SetHoopBarType(BT_Quidditch);
		QuidHud( Harry.MyHud ).EnableHoopBarDraw( true );
	}

	function Tick( float DeltaTime )
	{
		local Vector			SnitchDir;
		local Vector			ProximityTestPoint;
		local float				fProximity;

		local float				fTrackingOffset;
		local float				fCompression;
		local float				fMaxGainRadius;
		local float				fNeutralRadius;
		local float				fMaxLossRadius;

		local float				fProgressRate;
		local int				PercentDone;
		local int				LastPercentDone;
		local int				ProgressTier;
		local int				NewStage;

		local TeamAffiliation	eTeam;

		local Vector			HarryHeading;
		local Vector			SnitchFromHarry;
		local bool				bSnitchInFront;

		if ( PlayMechanic == PM_Proximity || PlayMechanic == PM_ProximityWithHoops )
		{
			// Compute radius compression that is based on progress
			// (radii pull in closer to snitch as progress nears completion)
			fTrackingOffset = (1.0 - (fProgressPercent / 100.0)) * fSnitchTrackingOffset;
			fCompression = 1.0 - (fProgressPercent / 100.0) * ((fSnitchNeutralRadiusAt0 - fSnitchNeutralRadiusAt100) / fSnitchNeutralRadiusAt0);
			fMaxGainRadius = fCompression * fSnitchMaxGainRadiusAt0;
			fNeutralRadius = fCompression * fSnitchNeutralRadiusAt0;
			fMaxLossRadius = fCompression * fSnitchMaxLossRadiusAt0;

			// Compute Harry's proximity to snitch
			SnitchDir = Vector( Harry.Rotation );
			ProximityTestPoint = -fTrackingOffset * SnitchDir + Snitch.Location;
			fProximity = VSize( Harry.Location - ProximityTestPoint );

			// Adjust tracking progress based on proximity: closer than
			// Neutral radius gains progress, farther loses progress.
			if ( Snitch.bHidden )
				fProgressRate = -fSnitchMaxLossRate;
			else if ( fProximity >= fMaxLossRadius )
				fProgressRate = -fSnitchMaxLossRate;
			else if ( fProximity <= fMaxGainRadius )
				fProgressRate =  fSnitchMaxGainRate;
			else if ( fProximity > fNeutralRadius )
				fProgressRate = -fSnitchMaxLossRate * (fProximity - fNeutralRadius)
													/ (fMaxLossRadius - fNeutralRadius);
			else
				fProgressRate =  fSnitchMaxGainRate * (fProximity - fNeutralRadius)
													/ (fMaxGainRadius - fNeutralRadius);

			fProgressPercent += fProgressRate * DeltaTime;
			if ( fProgressPercent < 0.0 )
				fProgressPercent = 0.0;
			else if ( fProgressPercent > 100.0 )
				fProgressPercent = 100.0;

			// Update the progress element of the HUD
			LastPercentDone = QuidHud( Harry.MyHud ).CurrentNumberHoops;
			PercentDone = fProgressPercent;
			QuidHud( Harry.MyHud ).SetHoopCounts( PercentDone, 100 );

			// If percent done has increased enough, play a progress sound
			ProgressTier = PercentDone / (100.0/NUM_PROGRESS_SOUNDS);
			if ( ProgressTier > (LastPercentDone / (100.0/NUM_PROGRESS_SOUNDS)) )
			{
				Snitch.PlaySound( ProgressSounds[ ProgressTier-1 ], SLOT_Interact );
			}

			// If snitch has a hoop trail, update it's stage
			if ( PlayMechanic == PM_ProximityWithHoops )
			{
				NewStage = (5.0 * fProgressPercent/105.0) + 1;
				if ( Snitch.HoopTrail.CurrentStage != NewStage )
				{
					Snitch.HoopTrail.CurrentStage = NewStage;
				}

				// Suppress hoop trail if too close
				if ( fProximity < 480 )
				{
					if ( Snitch.HoopTrail.IsInState( 'TrailOn' ) )
						Snitch.HoopTrail.GotoState( 'TrailOff' );
				}
				else
				{
					if ( Snitch.HoopTrail.IsInState( 'TrailOff' ) )
						Snitch.HoopTrail.GotoState( 'TrailOn' );
				}
			}

			// If Harry has tracked the snitch long enough...
			if ( fProgressPercent >= 100.0 )
			{
				// Caught the Snitch!  Put snitch in harry's hand
/*
				if ( PlayMechanic == PM_ProximityWithHoops )
					Snitch.HoopTrail.GotoState( 'TrailOff' );
				Snitch.StopFlyingOnPath();
				Harry.CatchTarget( Snitch, 'IPHarry_Win' );
*/

//				Harry.SetLookForTarget( None );
//				Harry.SecondaryAnim = 'Hold';	// This will become the loop animation after the 'Catch' finishes
//				Harry.PlayAnim( 'Catch' );

//				Snitch.StopFlyingOnPath();
//				Snitch.SetLocation( Harry.WeaponLoc );
//				Snitch.SetOwner( Harry );
//				Snitch.SetPhysics( PHYS_Trailer );

				// Tell seeker to stop looking for the Snitch
/*
				if ( Seeker != None )
					Seeker.SetLookForTarget( None );
*/
				GotoState( 'GameCatch' );
			}

			// Comment on Harry's pursuit of the snitch
			if ( !bHarryJoinedPursuit )
			{
				if ( !Snitch.bHidden && fProximity < fSnitchNeutralRadiusAt0 )	// If found snitch
				{
					if ( Commentator == None || Commentator.SayComment( QC_HereComesSeeker, TA_Gryffindor ) )
						bHarryJoinedPursuit = true;
				}
			}
			else
			{
				if ( Snitch.bHidden || fProximity > fSnitchMaxLossRadiusAt0	)	// If lost snitch
				{
					if ( bHarryReaching )
					{
						if ( Commentator == None || Commentator.SayComment( QC_MissedSnitch, , true ) )
						{
							bHarryReaching = false;
							bHarryJoinedPursuit = false;
						}
					}
					else
					{
						if ( Commentator == None || Commentator.SayComment( QC_DontGiveUp ) )
							bHarryJoinedPursuit = false;
					}
				}
				else if ( fProximity < fSnitchNeutralRadiusAt0 )	// If closing in
				{
					fProximity = VSize( Harry.Location - Snitch.Location );	// Ignore tracking offset

					HarryHeading = Vector( Harry.Rotation );
					SnitchFromHarry = Snitch.Location - Harry.Location;
					bSnitchInFront = (SnitchFromHarry dot HarryHeading) > 0.0;

					if ( !bHarryReaching )
					{
						if ( fProximity < 75.0 || fProgressPercent > 95.0 )		// If close enough to reach
						{
							if ( Commentator != None )
								Commentator.SayComment( QC_ReachingForSnitch, , true );
							bHarryReaching = true;
						}
					}
					else if ( !bSnitchInFront && (fProximity > 90.0 && fProgressPercent < 92.0) )	// If missed
					{
						Harry.PlayAnim( 'Miss' );
						if ( Commentator == None || Commentator.SayComment( QC_MissedSnitch, , true ) )
							bHarryReaching = false;
					}

					if ( Commentator != None && fProgressPercent < 95.0 )
					{
						switch ( Rand(2) )
						{
							case 0: Commentator.SayComment( QC_ClosingOnSnitch );	break;
							case 1: Commentator.SayComment( QC_ClosingOnSnitch2 );	break;
						}
					}
				}
			}
		}

		// Play the Hurrah sound every now-and-then with some comments
		if ( Level.TimeSeconds > fTimeToCheer )
		{
			if ( Rand(2) == 0 )
				eTeam = TA_Gryffindor;
			else
				eTeam = TA_Opponent;
			Log( "Playing "$eTeam$" crowd hurrah at "$Level.TimeSeconds );
			if ( Crowds[ eTeam ] != None )
				Crowds[ eTeam ].Cheer();
			fTimeToCheer = Level.TimeSeconds + 8.0 + 3.0*FRand();

			fProximity = VSize( Harry.Location - Snitch.Location );		// Ignore tracking offset
			if ( Commentator != None && ( fProximity > fSnitchNeutralRadiusAt0 ) )	// If not focusing on Harry
			{
				switch ( Rand(4) )
				{
					case 0:
						switch ( eTeam )
						{
							case TA_Gryffindor:	Commentator.SayComment( QC_HasQuaffle, TA_Gryffindor );	break;
							case TA_Opponent:	Commentator.SayComment( QC_HasQuaffle, TA_Opponent );	break;
						}
						break;

					case 1:
						if ( Commentator.CommentHasBeenSaidBefore( QC_HasQuaffle ) )
						{
							switch ( eTeam )
							{
								case TA_Gryffindor:	Commentator.SayComment( QC_Scores, TA_Gryffindor );	break;
								case TA_Opponent:	Commentator.SayComment( QC_Scores, TA_Opponent );	break;
							}
						}
						break;

					case 2:
						Commentator.SayComment( QC_KeeperDives );
						break;

					case 3:
						Commentator.SayComment( QC_Block );
						break;
				}
			}
		}

		// See if snitch has become visible yet; comment on it
		if ( Snitch.bHidden )
			bSnitchVisible = false;
		else
		{
			if ( !bSnitchVisible && (Commentator == None || Commentator.SayComment( QC_TheresTheSnitch )) )
				bSnitchVisible = true;
		}

		// See if other seeker has joined the pursuit of the snitch; comment on it
		if ( Snitch.bHidden || Seeker == None )
			bSeekerJoinedPursuit = false;
		else
		{
			fProximity = VSize( Seeker.Location - Snitch.Location );
			if ( !bSeekerJoinedPursuit )
			{
				if ( fProximity < 500 )
				{
					if ( Commentator == None || Commentator.SayComment( QC_HereComesSeeker, TA_Opponent ) )
						bSeekerJoinedPursuit = true;
				}
			}
			else
			{
				if ( fProximity > 1200 )
					bSeekerJoinedPursuit = false;
			}
		}

		// Test: Play random comment (ones not used anywhere yet)
/*
		switch ( Rand(23) )
		{
			case 11:	Commentator.SayComment( QC_BludgerPursuit );		break;
			case 12:	Commentator.SayComment( QC_BludgerPursuit_Multi );	break;
			case 13:	Commentator.SayComment( QC_BludgerMiss );			break;
			case 14:	Commentator.SayComment( QC_BludgerHit );			break;

			case 15:	Commentator.SayComment( QC_HitNearDeath );			break;
			case 16:	Commentator.SayComment( QC_HitDying );				break;

			case 19:	Commentator.SayComment( QC_ReturnToFlight );		break;

			case 22:	Commentator.SayComment( QC_Foul );					break;
		}
*/

	}

	function OnTouchEvent( Pawn Subject, Actor Object )
	{
		// Something touched something, and the event affects the flow of the
		// mini-game.  Update game state accordingly.
		local BroomHoop Hoop;

		// If Harry touched something...
		if ( Subject == Harry )
		{
			switch ( PlayMechanic )
			{
				case PM_Hoops:
					Hoop = BroomHoop( Object );
					if ( Hoop != None )
					{
						// Harry touched a hoop in snitches hoop trail; let trail react to it
						Snitch.HoopTrail.OnHoopTouch( Hoop );
					}
					else if ( Object == Snitch )
					{
						// Harry grazed the snitch; show him missing a catch (if he didn't really catch it)
						if ( !Snitch.bHidden && Snitch.HoopTrail.HoopsToGo > 0 )
						{
							Harry.PlayAnim( 'Miss' );
						}
					}
					else
					{
						// Harry touched something else
						PlayerHarry.ClientMessage( "Touched "$Object.Tag );
					}
					break;

				case PM_Proximity:
				case PM_ProximityWithHoops:
					if ( Object == Snitch )
					{
						// Harry grazed the snitch; show him missing a catch (if he didn't really catch it)
						if ( !Snitch.bHidden && fProgressPercent < 90.0 )
						{
//							Harry.PlayAnim( 'Miss' );
						}
					}
					else
					{
						// Harry touched something else
						PlayerHarry.ClientMessage( "Touched "$Object.Tag );
					}
					break;
			}
		}
		else
		{
			// Unexpected touch event
			Super.OnTouchEvent( Subject, Object );
		}
	}

	function OnTriggerEvent( Actor Other, Pawn EventInstigator )
	{
		// Something triggered a 'GameReferee' event.

		// If Other is the HoopTrail, then it's telling the referee that the
		// game progress has changed
		if ( PlayMechanic == PM_Hoops && Other == Snitch.HoopTrail )
		{
			// Update the progress element of the HUD
			QuidHud( Harry.MyHud ).SetHoopCounts( Snitch.HoopTrail.HoopsToHit - Snitch.HoopTrail.HoopsToGo,
												  Snitch.HoopTrail.HoopsToHit );

//			if ( Snitch.HoopTrail.HoopsToGo <= 4 )	// *** Test for winning ***
			if ( Snitch.HoopTrail.HoopsToGo <= 0 )
			{
				// Hit all the hoops!  Caught the Snitch!
				// Turn off hoop trail and put snitch in harry's hand
				Harry.bAuxBoost = false;
				Harry.SetLookForTarget( None );
				Harry.SecondaryAnim = 'Hold';	// This will become the loop animation after the 'Catch' finishes
				Harry.PlayAnim( 'Catch' );

				Snitch.StopFlyingOnPath();
				Snitch.HoopTrail.GotoState( 'TrailOff' );
				Snitch.SetLocation( Harry.WeaponLoc );
				Snitch.SetOwner( Harry );
				Snitch.SetPhysics( PHYS_Trailer );

				GotoState( 'GameWon' );
			}

			// If Hoop Trail progress suggests a change in speed, tell Harry
			Harry.bAuxBoost = Snitch.HoopTrail.bSpeedBoostSuggested;
		}
		else
		{
			// Unexpected trigger event
			Super.Trigger( Other, EventInstigator );
		}
	}

	function OnPlayerDying()
	{
		// Called when player starts dying.

		PlayerHarry.ClientMessage( "Player dying..." );
		GotoState( 'GameLosing' );
	}

	function OnPlayersDeath()
	{
		// Called when player dies.

		PlayerHarry.ClientMessage( "Player died; restarting game" );
		GotoState( 'GameLost' );
	}

	function EndState()
	{
		PlayerHarry.ClientMessage( "Exited GamePlay State" );
		Log( "Exited GamePlay State" );
		QuidHud( Harry.MyHud ).EnableHoopBarDraw( false );
	}
}

state GameCatch
{
	function BeginState()
	{
		local Bludger	Bludger;

		PlayerHarry.ClientMessage( "Entered GameCatch State" );
		Log( "Entered GameCatch State" );

		CatchTriesLeft = SnitchMaxCatchTries;
		SetTimer( 10.0, false );		// Watchdog timer in case Harry never reaches ground

		// Make Harry trail the snitch
		Harry.GotoState( 'Pursue' );

		// Make bludgers stop seeking Harry
		foreach AllActors( class'Bludger', Bludger )
			Bludger.SeekTarget( None );

		// Switch to catch-the-snitch hud element
		QuidHud( Harry.MyHud ).PlayHUDGame(true);
		QuidHud( Harry.MyHud ).SetHUDGameType(HUDG_QUIDDITCH);

		Harry.cam.gotostate('LockAroundHarry');
		Harry.cam.CameraDistance = 200.000;
		Harry.cam.TargetRot = rot(5000, 5000, 0);
	}

	function Tick( float DeltaTime )
	{
		local TeamAffiliation	eTeam;

		// Comment on Harry's pursuit of the snitch
		if ( Commentator != None )
		{
			switch ( Rand(2) )
			{
				case 0: Commentator.SayComment( QC_ClosingOnSnitch );	break;
				case 1: Commentator.SayComment( QC_ClosingOnSnitch2 );	break;
			}
		}

		// Play the Hurrah sound every now-and-then
		if ( Level.TimeSeconds > fTimeToCheer )
		{
			if ( Rand(2) == 0 )
				eTeam = TA_Gryffindor;
			else
				eTeam = TA_Opponent;
			Log( "Playing "$eTeam$" crowd hurrah at "$Level.TimeSeconds );
			if ( Crowds[ eTeam ] != None )
				Crowds[ eTeam ].Cheer();
			fTimeToCheer = Level.TimeSeconds + 8.0 + 3.0*FRand();
		}
	}

	function OnActionKeyPressed()
	{
		// Called when the player's "Action" key/button is pressed.
		Super.OnActionKeyPressed();

		// Determine if snitch is caught; if so, goto Won state; otherwise
		// either wait for a few more tries, or return to regular game play
		if ( QuidHud( Harry.MyHud ).HUDGameGrab() /*Snitch caught*/ )
		{
			// Caught the Snitch!  Put snitch in harry's hand
			if ( PlayMechanic == PM_ProximityWithHoops )
				Snitch.HoopTrail.GotoState( 'TrailOff' );
			Snitch.StopFlyingOnPath();
			Harry.CatchTarget( Snitch, 'IPHarry_Win' );
			Snitch.Halo.bHidden = true;

			QuidHud(Harry.myHUD).DestroyPopup();

			// Tell seeker to stop looking for the Snitch
			if ( Seeker != None )
				Seeker.SetLookForTarget( None );

			GotoState( 'GameWon' );
		}
		else
		{
			--CatchTriesLeft;
			if ( CatchTriesLeft <= 0 )
			{
				// Turn off hud progress element
				QuidHud( Harry.MyHud ).PlayHUDGame(false);
				QuidHud(Harry.myHUD).DestroyPopup();
				Harry.cam.gotostate('QuidditchState');

				Harry.GotoState( 'PlayerWalking' );
				GotoState( 'GamePlay' );
			}
		}
	}

	function Timer()
	{
		// Never actioned on the snitch; go back to regular gameplay

		// Turn off hud progress element
		QuidHud( Harry.MyHud ).PlayHUDGame(false);
		QuidHud(Harry.myHUD).DestroyPopup();
		Harry.cam.gotostate('QuidditchState');

		Harry.GotoState( 'PlayerWalking' );
		GotoState( 'GamePlay' );
	}

	function EndState()
	{
		PlayerHarry.ClientMessage( "Exited GameCatch State" );
		Log( "Exited GameCatch State" );

		SetTimer( 0.0, false );
		Harry.StopFlyingOnPath();
		fProgressPercent = 75.0;
	}
}

state GameWon
{
Begin:
	ComputeScore( true );
	
	// AE:
	PlayBigCheer();

	// Trigger fanfare
	TriggerEvent( 'FanfareMusicEnd', self, None );

	// Play the final commentator comments
	if ( Commentator != None )
	{
		Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
		Commentator.SayComment( QC_Positive, , true );
		Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
		Commentator.SayComment( QC_CaughtSnitch, , true );

		Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
		if ( bLeagueMode )
		{
			if ( bWonLeague )
			{
				Commentator.SayComment( QC_WinsCup, TA_Gryffindor, true );		// Won league
				Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
				Commentator.SayComment( QC_Positive, , true );
			}
			else
				Commentator.SayComment( QC_WinsMatch, TA_Gryffindor, true );	// Won match
		}
		else
		{
			if ( Opponent == HA_Slytherin )
				Commentator.SayComment( QC_WinsSlyth, TA_Gryffindor, true );	// Level Quid 1
			else
				Commentator.SayComment( QC_WinsAgain, TA_Gryffindor, true );	// Level Quid 2
		}

		Sleep( Commentator.TimeLeftUntilSafeToSayAComment() );
		Commentator.SayComment( QC_SigningOff );
		Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
	}
	else
	{
		Sleep( 12.0 );
	}

	if ( bLeagueMode )
	{
		// Tell the quidditch match page that the match is finished
		FEQuidMatchPage( HPConsole( Console ).menuBook.QuidMatchPage ).
			FinishGame( GryffScore, OpponentScore );
	}
	else
	{
		// Unlock Quidditch League on special quidditch menu; earned it by passing level
		FEQuidMatchPage( HPConsole( Console ).menuBook.QuidMatchPage ).
			UnlockQuidditch( "League" );

		// Wait until harry has reached his victory path
		while ( !Harry.IsInState( 'FlyingOnPath' ) )
			Sleep( 0.2 );

		// Trigger end cutscene; cut scene will load the next level
		TriggerEvent( 'End', self, None );
	}
}

state GameLosing
{
	function BeginState()
	{
		local Bludger	Bludger;

		PlayerHarry.ClientMessage( "Entered GameLosing State" );
		Log( "Entered GameLosing State" );

		// Make bludgers stop seeking Harry
		foreach AllActors( class'Bludger', Bludger )
			Bludger.SeekTarget( None );
	}

	function OnPlayersDeath()
	{
		// Called when player dies.

		PlayerHarry.ClientMessage( "Player died; restarting game" );
		GotoState( 'GameLost' );
	}

Begin:
	if ( Commentator != None )
	{
		Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
		Commentator.SayComment( QC_Dying, , true );
	}

Loop:
	Sleep( 0.1 );

	goto 'Loop';
}

state GameLost
{
Begin:
	ComputeScore( false );

	// Play the final commentator comments
	if ( Commentator != None )
	{
		Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
		Commentator.SayComment( QC_Dead, , true );

		if ( bLeagueMode )
		{
			Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
			Commentator.SayComment( QC_WinsMatch, TA_Opponent, true );		// Opponent won match

			if ( bWonLeague )
			{
				Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
				Commentator.SayComment( QC_WinsCup, TA_Gryffindor, true );	// Gryff won league anyway
			}

			Sleep( Commentator.TimeLeftUntilSafeToSayAComment() );
			Commentator.SayComment( QC_SigningOff );
		}
		Sleep( Commentator.TimeLeftUntilSafeToSayAComment( true ) );
	}
	else
	{
		Sleep( 0.2 );
	}

	if ( bLeagueMode )
	{
		// Tell the quidditch match page that the match is finished
		FEQuidMatchPage( HPConsole( Console ).menuBook.QuidMatchPage ).
			FinishGame( GryffScore, OpponentScore );
	}
	else
	{
		Level.Game.RestartGame();
	}
}

defaultproperties
{
     HoopsToHit=3
     PlayMechanic=PM_ProximityWithHoops
     fSnitchTrackingOffset=150
     fSnitchMaxGainRadiusAt0=100
     fSnitchNeutralRadiusAt0=500
     fSnitchNeutralRadiusAt100=150
     fSnitchMaxLossRadiusAt0=1200
     fSnitchMaxGainRate=20
     fSnitchMaxLossRate=10
     fSnitchMaxCatchTime=20
     SnitchMaxCatchTries=3
     RandSeed=(SeedA=1.14224e+33,SeedB=1.49916e+10,SeedC=4.569593e+33,SeedD=1.718108e+19)
     bNeedsCommentator=True
}
