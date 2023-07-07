//===============================================================================
//  [skspikybush] 
//===============================================================================

class spikybush extends baseChar;


auto state ReadyAndWaiting
{
	function ShootSpikes ()
	{
		local int i;
		local int NumSpikes;
		local rotator rotate_spike;
		local vector spike_locn, harrys_head;

		local baseharry harry;



		// find harry so we can aim the spikes at his head
		foreach AllActors(class'baseharry', harry)
			break;
		harrys_head = harry.location;

		harrys_head.z += harry.collisionHeight/2;

		NumSpikes = 8;


//	    Mesh=Mesh'HPModels.skspikybushnothornsMesh';
//		SkelAnim=Animation'HPModels.skspikybushnothornsAnims';

		rotate_spike = rotator(harrys_head - location);
		log("Spike aim" @ rotate_spike);


		rotate_spike.roll = 0;
		rotate_spike.pitch += (65536*3) / 4;

		// @AE: Trigger audio events of shooting spikes.
		switch( Rand(4) )
		{

			case 0: PlaySound(sound'HPSounds.Hub2_sfx.spiky_bush_shootlots1'); break;

			case 1: PlaySound(sound'HPSounds.Hub2_sfx.spiky_bush_shootlots2'); break;

			case 2: PlaySound(sound'HPSounds.Hub2_sfx.spiky_bush_shootlots3'); break;

			case 3: PlaySound(sound'HPSounds.Hub2_sfx.spiky_bush_shootlots4'); break;
		}

		for (i=0; i<NumSpikes; ++i)
		{
			rotate_spike.yaw = (65536 / NumSpikes) * i;

			spike_locn = location;
			spike_locn.z += drawScale*3;

			spawn(class'SpikeyPlantSpike',self,,spike_locn, rotate_spike);
		}
		/* GAS
		eVulnerableToSpell = SPELL_None;


		replaceBush = spawn(class'SpikyBushNoThorns',,,location,rotation);

		if (replaceBush == None)
		{
			log("Replace bush failed to spawn");
		}
		else
		{
			replaceBush.SetCollisionSize(collisionRadius, collisionHeight);
			replaceBush.drawScale = drawScale;
		}

		destroy ();
		*/
	}

	function KillMaimDestroy()	// GAS
	{
		local SpikyBushNoThorns replaceBush;

		eVulnerableToSpell = SPELL_None;

		replaceBush = spawn(class'SpikyBushNoThorns',,,location,rotation);

		if (replaceBush == None)
		{
			log("Replace bush failed to spawn");
		}
		else
		{
			replaceBush.SetCollisionSize(collisionRadius, collisionHeight);
			replaceBush.drawScale = drawScale;
		}

		destroy ();
	}

	function bool TakeSpellEffect(baseSpell spell)
	{
		ShootSpikes ();
		KillMaimDestroy(); // GAS
		return true;
	}

	function Bump (actor other)
	{
		if (other.IsA('BaseHarry'))
		{
			other.acceleration = vect(0,0,0);
			other.velocity = vect(0,0,0);
			ShootSpikes ();
			KillMaimDestroy();	// GAS
		}
	}
begin:	// GAS
loop:
//	loopAnim ('idle', 1.0 - 0.5*FRand ());

	Sleep(Rand(2));

	//PlaySound ( sound'HPSounds.Hub2_sfx.spiky_bush_wilt', SLOT_None);

	playAnim ('idle');
	finishanim();

	if (baseHud(playerharry.myHud).bCutSceneMode == false)
	{
		if(abs(vsize(location-playerharry.location))<200)
		{
			ShootSpikes();
		}
	}

	goto 'loop';
}

state Wilted
{
	event AnimEnd()
	{
		// When wilted, players can walk over
	   bBlockPlayers = false;

		// Don't know if the following line is completely necessary.
		// trying to fix problem where withered plants block spells being done on normal plants
		SetCollisionSize(0, 0);
	}

begin:
    bprojtarget=false;

	playAnim('wither');

	Sleep(1); // hold on for the first second of animation before playing sound effect

	PlaySound ( sound'HPSounds.Hub2_sfx.spiky_bush_wilt', SLOT_None);
}

defaultproperties
{
     eVulnerableToSpell=SPELL_Incendio
     SizeModifier=0.9
     CentreOffset=(Z=25)
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HPModels.skspikybushMesh'
     DrawScale=2.4
     CollisionRadius=48
     CollisionHeight=48
     bProjTarget=True
}
