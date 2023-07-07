//=============================================================================
// CamTarget.
//=============================================================================
class CamTarget expands Pawn;

var baseharry p;
var vector targetOffset;
var vector moveTarget;
var float previousYaw;

var rotator BossCamBox;

var bool	bInPlayerAiming;
var vector	OldOffset;
var vector	OldRecTargetLocation;

auto state seeking
{
	function startup()
	{
		foreach allActors(class'baseHarry', p)
		{
			if( p.bIsPlayer&& p!=Self )
			{
				break;
			}
		}
		TargetOffset = vect(100, 0 ,50);
		OldRecTargetLocation = vect(0, 0, 0);

		bInPlayerAiming = false;
	}

	function touch (actor other)
	{
	}


	function HitWall (vector HitNormal, actor Wall)
	{
	}

	function tick(float Deltatime)
	{
		setTarget(Deltatime);
	}

	event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
	}

	function setTarget(float deltatime)
	{

		local vector tloc;
		local vector offset;

/*		if (p.IsInState('PlayerAiming'))
		{
			if (!bInPlayerAiming)
			{
				OldOffset = TargetOffset;
				bInPlayerAiming = true;
				tloc = vector(p.cam.rotation) * (512 + vsize(p.Location - p.cam.location)) + p.cam.location;
				tloc.z = tloc.z - 50;
				log("before " $location.x $" " $location.y $" " $location.z);
				SetLocation(tloc);
			}
			// Find point between Target and Harry
			tloc = Normal(p.rectarget.Location - p.Location) * 512 + p.Location;
			OldRecTargetLocation = p.rectarget.Location;
//			tloc = p.rectarget.Location;
		}
		else
		{*/
			if (bInPlayerAiming)
			{
/*				TargetOffset = Normal(OldRecTargetLocation - p.cam.Location) * 100;
				TargetOffset.x = OldOffset.x;
				TargetOffset.y = OldOffset.y;
				TargetOffset.z += 50;	// Offset in the battle cam aim offset
*/
				bInPlayerAiming = false;
			}

			if (p.bStationary)
			{
/*                if(p.SmoothMouseY>64 && targetOffset.z < 150)
				{
					targetOffset.z=targetOffset.z+2;
				}

                if(p.SmoothMouseY<-64 && targetOffset.z > 0)
				{
					targetOffset.z=targetOffset.z-2;
				}*/

				if((p.SmoothMouseY < -256) && targetOffset.z > 0)
				{
					targetOffset.z = targetOffset.z - 4;

					if (targetOffset.z < 0)
					{
						targetOffset.z = 0;
					}
				}

				if((p.SmoothMouseY > 256) && targetOffset.z < 150)
				{
					targetOffset.z = targetOffset.z + 4;
//					targetOffset.z = targetOffset.z + p.SmoothMouseY / 128;

					if (targetOffset.z > 150)
					{
						targetOffset.z = 150;
					}
				}
			}
            else
            {
                if(targetOffset.z < 50)
				{
					targetOffset.z=targetOffset.z+2;
				}
                else if(targetOffset.z > 50)
				{
					targetOffset.z=targetOffset.z-2;
				}
            }

			offset=targetOffset>>p.viewrotation;
//			offset=(targetOffset + (p.velocity * deltatime)) >> p.viewrotation;
			
			tloc=p.location;
			tloc=tloc+offset;

			if(tloc.z<p.location.z)
			{
				targetOffset.z=targetOffset.z+2;
			}
		
			if(tloc.z>(p.location.z+150))
			{
				targetOffset.z=targetOffset.z-2;
			}
//		}
		
/*	BaseHUD(p.MyHUD).DebugValx = tloc.x;
	BaseHUD(p.MyHUD).DebugValy = tloc.y;
	BaseHUD(p.MyHUD).DebugValz = tloc.z;

	BaseHUD(p.MyHUD).DebugValx2 = OldRecTargetLocation.x;
	BaseHUD(p.MyHUD).DebugValy2 = OldRecTargetLocation.y;
	BaseHUD(p.MyHUD).DebugValz2 = OldRecTargetLocation.z;
*/

		offset=tloc-location;

		if (p.IsInState('PlayerAiming'))
		{
//			log("Now " $location.x $" " $location.y $" " $location.z);
//			log("Rectarget " $p.rectarget.location.x $" " $p.rectarget.location.y $" " $p.rectarget.location.z);

			if (vsize(offset) > 30)
			{
				offset = (vsize(offset) - 30) * normal(offset);
				SetLocation(offset + location);
//				movesmooth(offset);
			}
		}
		else
		{
			SetLocation(offset + location);
//			movesmooth(offset);
		}

		BaseHUD(p.MyHUD).DebugValx2 = targetOffset.x;
		BaseHUD(p.MyHUD).DebugValy2 = targetOffset.y;
		BaseHUD(p.MyHUD).DebugValz2 = targetOffset.z;
	}

	begin:
		startup();

		
	seekloop:
		sleep(0.001);
	goto 'seekloop';


}

state BossFollow
{
	function startup()
	{
		foreach allActors(class'baseHarry', p)
		{
			if( p.bIsPlayer&& p!=Self )
			{
				break;
			}
		}
	}

	function touch (actor other)
	{
	}


	function HitWall (vector HitNormal, actor Wall)
	{
	}

	function tick(float Deltatime)
	{
		setTarget(Deltatime);
	}

	event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
	}

	function setTarget(float deltatime)
	{

		local vector tloc;
		local vector offset;
		local rotator ViewDif;

		// Find current rotation of Harry to target

		ViewDif = Rotator(p.BossTarget.Location - p.location) - p.Rotation;

		ViewDif.Yaw = ViewDif.Yaw & 0xffff;

		if (ViewDif.Yaw > 0x8000)
		{
			ViewDif.Yaw -= 0x8000;
		}

//		BaseHUD(p.MyHUD).DebugValX = ViewDif.pitch;
//		BaseHUD(p.MyHUD).DebugValY = ViewDif.yaw;

		if (BossCamBox.yaw == 0)
		{
			offset = p.BossTarget.Location - location;

			if (vsize(offset) > 200)
			{
				offset = (vsize(offset) - 200) * normal(offset);
				movesmooth(offset);

/*				BaseHUD(p.MyHUD).DebugValX = offset.x;
				BaseHUD(p.MyHUD).DebugValY = offset.y;
				BaseHUD(p.MyHUD).DebugValZ = offset.z;*/
			}
		}
		else if (abs(ViewDif.Yaw) > BossCamBox.yaw )
		{
			if (ViewDif.Yaw > 0 && ViewDif.Yaw < 0x8000)
			{
				ViewDif.yaw = BossCamBox.yaw;
			}
			else
			{
				ViewDif.yaw = -BossCamBox.yaw;
			}
			ViewDif.pitch = 0;
			ViewDif.roll = 0;
			ViewDif = Rotator(p.BossTarget.Location - p.location) - ViewDif;
			tloc = vector(ViewDif) * VSize(p.BossTarget.Location - p.location) + p.Location;

/*		BaseHUD(p.MyHUD).DebugValX = tloc.x;
		BaseHUD(p.MyHUD).DebugValY = tloc.y;
		BaseHUD(p.MyHUD).DebugValZ = tloc.z;
*/
			offset=tloc-location;

			if (vsize(offset) > 200)
			{
				offset = (vsize(offset) - 200) * normal(offset);
				SetLocation(offset + location);
//				movesmooth(offset);

/*				BaseHUD(p.MyHUD).DebugValX = offset.x;
				BaseHUD(p.MyHUD).DebugValY = offset.y;
				BaseHUD(p.MyHUD).DebugValZ = offset.z;*/
			}
		}
	}

	begin:
		startup();

		
	seekloop:
		sleep(0.001);
	goto 'seekloop';


}

state Free
{
	function startup()
	{
		foreach allActors(class'baseHarry', p)
		{
			if( p.bIsPlayer&& p!=Self )
			{
				break;
			}
		}
	}

	function touch (actor other)
	{
	}


	function HitWall (vector HitNormal, actor Wall)
	{
	}

	function tick(float Deltatime)
	{
	}


	begin:
		startup();

		
	seekloop:
		sleep(0.001);
	goto 'seekloop';


}

defaultproperties
{
     Texture=None
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
}
