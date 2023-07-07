//===============================================================================
//  [rememberallbroom] 
//===============================================================================

class rememberallbroom extends hprops;
#exec MESH  MODELIMPORT MESH=rememberallbroomMesh MODELFILE=models\rememberallbroom.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=rememberallbroomMesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=rememberallbroomAnims ANIMFILE=models\rememberallbroom.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=rememberallbroomMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=rememberallbroomMesh ANIM=rememberallbroomAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=rememberallbroomAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=rememberallbroomTex0  FILE=TEXTURES\QUID_SKIN01.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=rememberallbroomMesh NUM=0 TEXTURE=rememberallbroomTex0

// Original material [0] is [SKIN00] SkinIndex: 0 Bitmap: QUID_SKIN01.bmp  Path: C:\Nathan

defaultproperties
{
     bStatic=False
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HProps.rememberallbroomMesh'
}
