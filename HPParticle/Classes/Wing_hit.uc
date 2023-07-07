//=============================================================================
// Wing_hit.
//=============================================================================
class Wing_hit expands ParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=300)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=200)
     Lifetime=(Rand=2)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(R=0))
     SizeWidth=(Base=4,Rand=6)
     SizeLength=(Base=4,Rand=6)
     SizeEndScale=(Base=5)
     SpinRate=(Base=-3,Rand=6)
     Chaos=1
     Attraction=(X=-1,Y=-1)
     Damping=3
     GravityModifier=-0.1
     ParticlesMax=60
     Textures(0)=Texture'HPParticle.hp_fx.Particles.White_Feather'
     LastUpdateLocation=(X=-2.164597,Y=-1.367966,Z=36.10041)
     LastEmitLocation=(X=-2.164597,Y=-1.367966,Z=36.10041)
     Age=16.26438
     ParticlesEmitted=100
     bDynamicLight=True
     Tag=Wing_hit
     Location=(X=-2.164597,Y=-1.367966,Z=36.10041)
     Rotation=(Pitch=0)
     OldLocation=(X=-2.164597,Y=-1.367966,Z=36.10041)
}
