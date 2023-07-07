//=============================================================================
// GridMover.
//=============================================================================
class GridMover extends Mover;

// Allows this mover to go anywhere on a grid, depending on the direction it is hit.

var() float MoveIncrement;

var   bool  bDoingInterpolation;

function Tick(float dtime)
{
	super.Tick(dtime);

	//Log("************* self:"$self$" ph:"$Physics$" bInterpolating:"$bInterpolating);

	//Check for Mover bug, if in the middle of moving, but for some reason bInterpolating got
	// turned off, stop moving.
	if( bDoingInterpolation && !bInterpolating )
		GotoState('BumpMove', 'DoneMoving');
}


// Move when bumped.
state() BumpMove
{
	function Bump( actor Other )
	{
		local vector offset;

		//Log("**************** a:"$self$" GridMover 8 Other:"$Other$" Other.I:"$Other.Instigator);
		if( !IsRelevant(Other) )
			return;

		//Log("**************** a:"$self$" GridMover 9");
		SavedTrigger = Other;
		Instigator = Pawn( Other );

		// Dynamically set interpolation point.
		KeyPos[1] = Location-BasePos;

		offset = Other.Location - Location;
		if( Abs(offset.X) > Abs(offset.Y) )
		{
			if( offset.X > 0 )
				KeyPos[1].X -= MoveIncrement;
			else
				KeyPos[1].X += MoveIncrement;
		}
		else
		{
			if( offset.Y > 0 )
				KeyPos[1].Y -= MoveIncrement;
			else
				KeyPos[1].Y += MoveIncrement;
		}
		GotoState( 'BumpMove', 'Move' );
	}

  Move:
	Disable( 'Bump' );

	bDoingInterpolation = true;

	//Log("**************** a:"$self$" GridMover 1");
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}

	//Log("**************** a:"$self$" GridMover 2");
	DoOpen();

	//Log("**************** a:"$self$" GridMover 3");
	FinishInterpolation();

  DoneMoving:
	//Log("**************** a:"$self$" GridMover 4");
  	bDoingInterpolation = false;

	FinishedOpening();

	//Log("**************** a:"$self$" GridMover 5");
	KeyNum = 0; PrevKeyNum = 0;
	Sleep( StayOpenTime );

	//Log("**************** a:"$self$" GridMover 6");
	if( bTriggerOnceOnly )
		GotoState('');

	//Log("**************** a:"$self$" GridMover 7");
	Enable( 'Bump' );
}

defaultproperties
{
     MoveIncrement=64
     InitialState=BumpMove
     CollisionRadius=55
     CollisionHeight=48
     bCollideWorld=True
}
