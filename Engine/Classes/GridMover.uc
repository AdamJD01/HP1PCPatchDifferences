//=============================================================================
// GridMover.
//=============================================================================
class GridMover extends Mover;

// Allows this mover to go anywhere on a grid, depending on the direction it is hit.

var() float MoveIncrement;

// Move when bumped.
state() BumpMove
{
	function Bump( actor Other )
	{
		local vector offset;

		if( !IsRelevant(Other) )
			return;
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
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	KeyNum = 0; PrevKeyNum = 0;
	Sleep( StayOpenTime );
	if( bTriggerOnceOnly )
		GotoState('');
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
