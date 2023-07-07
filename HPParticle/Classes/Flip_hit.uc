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
     bSteadyState=True
     Speed=(Base=800)
     Lifetime=(Rand=1)
     ColorStart=(Base=(G=255,B=255),Rand=(R=133,G=133,B=133))
     ColorEnd=(Base=(G=4,B=11))
     SizeWidth=(Base=15,Rand=5)
     SizeLength=(Base=15,Rand=5)
     SizeEndScale=(Base=5)
     SpinRate=(Base=-3,Rand=6)
     bSystemRelative=True
     Damping=7
     ParticlesMax=50
     Textures(0)=Texture'HPParticle.hp_fx.Spells.Particle_02'
}
