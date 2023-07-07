//=============================================================================
// Flip_hit.
//=============================================================================
class Flip_hit expands ParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=500)
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=800)
     Lifetime=(Rand=1)
     ColorStart=(Base=(G=255,B=255),Rand=(R=133,G=133,B=133))
     ColorEnd=(Base=(G=4,B=11))
     SizeWidth=(Base=12,Rand=18)
     SizeLength=(Base=12,Rand=18)
     SizeEndScale=(Base=5)
     SpinRate=(Base=-3,Rand=6)
     bSystemRelative=True
     Damping=7
     ParticlesMax=50
     Textures(0)=Texture'HPParticle.hp_fx.Spells.Particle_02'
     LastUpdateLocation=(X=132,Y=-272,Z=-44.50056)
     LastEmitLocation=(X=132,Y=-272,Z=-44.50056)
     LastUpdateRotation=(Pitch=16464)
     Age=1591.323
     ParticlesEmitted=50
     bDynamicLight=True
     Tag=Dummyparticle
     Location=(X=132,Y=-272,Z=-44.50056)
     OldLocation=(Z=32)
     bSelected=True
}
