//===============================================================================
//  [Knight] 
//===============================================================================

class Knight extends baseProps;
var int NumSpellHits;

//**************************************************************
//function PostBeginPlay()
//{
//Log("*******************eVulnerableToSpell = "$eVulnerableToSpell);
//	eVulnerableToSpell = SPELL_Flipendo;
//}

//*******************************************************************************
event Trigger( Actor Other, Pawn EventInstigator )
{
	if( !IsInState('stateWobble') )
		GotoState('stateWobble');
}

//**************************************************************
auto state idle
{
	// AE:
	function PlayHeadMoveSound()
	{
		// Check distance from harry to armour
		if( abs(vsize(location-playerharry.location)) < 250 )
		{
			// In range, so trigger a squeak.
			switch( Rand(2) )
			{
				case 0:	PlaySound( sound'HPSounds.hub1_sfx.armor_head_move1' ); break;
				case 1:	PlaySound( sound'HPSounds.hub1_sfx.armor_head_move2' ); break;
			}
		}
	}

	function bool TakeSpellEffect(baseSpell spell)
	{
		local FireCracker  a;
		local byte         b;
		local int          i;
Log("************ knight takespelleffect");
		super.TakeSpellEffect(spell);

		//NumSpellHits++;
		//
		//if( NumSpellHits >= 3 )
		//{
		//	Playsound( sound 'HPSounds.hub1_sfx.MAL_candy_explodes');
		//	PlaySound( sound'HPSounds.menu_sfx.s_menu_click', SLOT_Interact, 1.0, false, 1000.0, 1.0);
		//
		//	for( i = 0; i < 10; i++ )
		//	{
		//		a = spawn( class'FireCracker' ); //cWizCrackerConfetti' );
		//
		//		b = 127 + Rand(128);
		//		a.ColorStart.Base.r = b;
		//		a.ColorStart.Base.g = b;
		//		a.ColorStart.Base.b = b;
		//		a.ColorEnd.Base.r = b;
		//		a.ColorEnd.Base.g = b;
		//		a.ColorEnd.Base.b = b;
		//
		//		a.Gravity.z = -(30 + Rand(4)*30);
		//	}
		//
		//	Destroy();	
		//}
		//else
		//{
			GotoState('stateWobble');
		//}
	}

  begin:
  loop:
	
	PlayHeadMoveSound();
	LoopAnim('IDLE2LOOKRIGHT', 1.0, 0.0);
	finishanim();
	LoopAnim('LOOKRIGHT', 1.0, 0.0);
	sleep(frand()*2);
	finishanim();
	PlayHeadMoveSound();
	LoopAnim('LOOKRIGHT2IDLE', 1.0, 0.0);
	finishanim();
	LoopAnim('IDLE', 1.0, 0.0);
	sleep(frand()*3);
	finishanim();

	PlayHeadMoveSound();
	LoopAnim('IDLE2LOOKLEFT', 1.0, 0.0);
	finishanim();
	LoopAnim('LOOKLEFT', 1.0, 0.0);
	sleep(frand()*2);
	finishanim();
	PlayHeadMoveSound();
	LoopAnim('LOOKLEFT2IDLE', 1.0, 0.0);
	finishanim();
	LoopAnim('IDLE', 1.0, 0.0);
	sleep(frand()*3);
	finishanim();

	goto 'loop';
}

//**************************************************************
state stateWobble
{
  Begin:

	// AE:
	switch( Rand(4) )
	{
		case 0:	PlaySound( sound'HPSounds.hub1_sfx.Armour_Clinks_01' ); break;
		case 1:	PlaySound( sound'HPSounds.hub1_sfx.Armour_Clinks_02' ); break;
		case 2:	PlaySound( sound'HPSounds.hub1_sfx.Armour_Clinks_03' ); break;
		case 3:	PlaySound( sound'HPSounds.hub1_sfx.Armour_Clinks_04' ); break;
	}

	PlayAnim('wobble');
	FinishAnim();
	GotoState('idle');
}

defaultproperties
{
     bStatic=False
     eVulnerableToSpell=SPELL_Flipendo
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HProps.skknightMesh'
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
