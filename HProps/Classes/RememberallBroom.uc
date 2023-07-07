//===============================================================================
//  [RememberallBroom] 
//===============================================================================

class RememberallBroom extends HProps;
#exec MESH  MODELIMPORT MESH=RememberallBroomMesh MODELFILE=models\RememberallBroom.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=RememberallBroomMesh X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=RememberallBroomAnims ANIMFILE=models\RememberallBroom.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#exec MESHMAP   SCALE MESHMAP=RememberallBroomMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=RememberallBroomMesh ANIM=RememberallBroomAnims

// Digest and compress the animation data. Must come after the sequence declarations.
// 'VERBOSE' gives more debugging info in UCC.log 
#exec ANIM DIGEST  ANIM=RememberallBroomAnims VERBOSE

#EXEC TEXTURE IMPORT NAME=RememberallBroomTex0  FILE=TEXTURES\QUID_SKIN01.bmp  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=RememberallBroomMesh NUM=0 TEXTURE=RememberallBroomTex0

// Original material [0] is [SKIN04] SkinIndex: 4 Bitmap: QUID_SKIN01.bmp  Path: D:\Harry Potter\Art\Characters\Harry Rememberall

defaultproperties
{
     bStatic=False
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'HProps.RememberallBroomMesh'
}
