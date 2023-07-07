//=============================================================================
// baseHUD
//=============================================================================
class baseHud extends HUD;

#EXEC TEXTURE IMPORT NAME=HudTextBox1  FILE=TEXTURES\HUDTextBox1.bmp GROUP=Icons
#EXEC TEXTURE IMPORT NAME=HudTextBox2  FILE=TEXTURES\HUDTextBox2.bmp GROUP=Icons

#EXEC TEXTURE IMPORT NAME=leftPanel  FILE=..\HPMENU\TEXTURES\HUD\leftPanel.pcx GROUP=Icons MIPS=off
#EXEC TEXTURE IMPORT NAME=middlePanel  FILE=..\HPMENU\TEXTURES\HUD\middlePanel.pcx GROUP=Icons MIPS=off
#EXEC TEXTURE IMPORT NAME=rightPanel  FILE=..\HPMENU\TEXTURES\HUD\rightPanel.pcx GROUP=Icons MIPS=off



#EXEC TEXTURE IMPORT NAME=HarryBarFull  FILE=..\HPMENU\TEXTURES\HUD\HarryHealth.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HarryBarEmpty  FILE=..\HPMENU\TEXTURES\HUD\HarryHealthEmpty.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=HudTextBox2  FILE=TEXTURES\HUDTextBox2.bmp GROUP=Icons

#EXEC TEXTURE IMPORT NAME=TimerBarFull  FILE=TEXTURES\HUD\Timer.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=TimerBarEmpty  FILE=TEXTURES\HUD\EmptyBar.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

//#exec new TrueTypeFontFactory Name=InkFont FontName="InkPotFitCaps" Height=16 AntiAlias=1 CharactersPerPage=32 
//#exec new TrueTypeFontFactory Name=InkFont FontName="Georgia" Height=16 AntiAlias=1 CharactersPerPage=32 
//#exec new TrueTypeFontFactory Name=InkFont FontName="Georgia" Height=18 AntiAlias=0 CharactersPerPage=32 
//#exec new TrueTypeFontFactory Name=ChiFont FontName="MHei Medium" Height=20 AntiAlias=0 RenderNative=1 Count=65535
#exec new TrueTypeFontFactory Name=HugeInkFont FontName="Times New Roman" Xpad=2 Height=24 AntiAlias=0 CharactersPerPage=32 
#exec new TrueTypeFontFactory Name=BigInkFont FontName="Times New Roman" Height=18 AntiAlias=0 CharactersPerPage=32 
#exec new TrueTypeFontFactory Name=MedInkFont FontName="Times New Roman" Height=14 AntiAlias=0 CharactersPerPage=32 
#exec new TrueTypeFontFactory Name=SmallInkFont FontName="Times New Roman" Height=12 AntiAlias=0 CharactersPerPage=32 
#exec new TrueTypeFontFactory Name=TinyInkFont FontName="Times New Roman" Height=10 AntiAlias=0 CharactersPerPage=32 

#exec new TrueTypeFontFactory Name=AsianFontHuge FontName="Gulim" Height=24 AntiAlias=0 RenderNative=1 
#exec new TrueTypeFontFactory Name=AsianFontBig FontName="Gulim" Height=18 AntiAlias=0 RenderNative=1  
#exec new TrueTypeFontFactory Name=AsianFontMed FontName="Gulim" Height=14 AntiAlias=0 RenderNative=1  
#exec new TrueTypeFontFactory Name=AsianFontSmall FontName="Gulim" Height=12 AntiAlias=0 RenderNative=1 

#exec new TrueTypeFontFactory Name=JapFontHuge FontName="PMingLiU" Height=24 AntiAlias=0 RenderNative=1 
#exec new TrueTypeFontFactory Name=JapFontBig FontName="PMingLiU" Height=18 AntiAlias=0 RenderNative=1  
#exec new TrueTypeFontFactory Name=JapFontMed FontName="PMingLiU" Height=14 AntiAlias=0 RenderNative=1  
#exec new TrueTypeFontFactory Name=JapFontSmall FontName="PMingLiU" Height=12 AntiAlias=0 RenderNative=1 


#exec new TrueTypeFontFactory Name=SystemFontHuge FontName="system" Height=24 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
#exec new TrueTypeFontFactory Name=SystemFontBig FontName="system" Height=18 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
#exec new TrueTypeFontFactory Name=SystemFontMed FontName="system" Height=14 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
#exec new TrueTypeFontFactory Name=SystemFontSmall FontName="system" Height=12 AntiAlias=0 RenderNative=1 CharactersPerPage=64 


//#exec new TrueTypeFontFactory Name=ThaiFontHuge FontName="CordiaUPC" Height=24 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
//#exec new TrueTypeFontFactory Name=ThaiFontBig FontName="CordiaUPC" Height=18 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
//#exec new TrueTypeFontFactory Name=ThaiFontMed FontName="CordiaUPC" Height=14 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
//#exec new TrueTypeFontFactory Name=ThaiFontSmall FontName="CordiaUPC" Height=12 AntiAlias=0 RenderNative=1 CharactersPerPage=64 

#exec new TrueTypeFontFactory Name=ThaiFontHuge FontName="Tahoma" Height=24 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
#exec new TrueTypeFontFactory Name=ThaiFontBig FontName="Tahoma" Height=20 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
#exec new TrueTypeFontFactory Name=ThaiFontMed FontName="Tahoma" Height=18 AntiAlias=0 RenderNative=1 CharactersPerPage=64 
#exec new TrueTypeFontFactory Name=ThaiFontSmall FontName="Tahoma" Height=14 AntiAlias=0 RenderNative=1 CharactersPerPage=64 


var bool bCutSceneMode;
var float fCutSceneBoarderOffset;
var baseScript curCutScene;

var bool bDrawDialogText;

enum _HUDGameType
{
	HUDG_QUIDDITCH,
	HUDG_FLYINGKEYS,
};

struct IconMessage
{
	var bool valid;
	var Texture icon;
	var string message;
	var float duration;	//time that message will disappear
};

var _HUDGameType HUDGameType;

var IconMessage curIconMessage;

var basePopup curPopup;

var bool bCountingDown;
var float fCountdownTime;
var float fStartCountdown;

var float fLastTickTime;

var float fSeedHideTime;
var float fStarHideTime;
var float fBeanHideTime;
var float fPointsHideTime;
var float fHealthHideTime;

var int SeedOffset;
var int StarOffset;
var int BeanOffset;
var int PointsOffset;
var int HealthOffset;

// @PAB debug info

var string	DebugString;
var int		DebugValA;
var int		DebugValX;
var int		DebugValY;
var int		DebugValZ;

var string	DebugString2;
var int		DebugValA2;
var int		DebugValX2;
var int		DebugValY2;
var int		DebugValZ2;

var bool	bScoreCountup;
var float	fScoreCountTime;
var float	fMaxScoreCountTime;

var baseHudItem BeanItem;
var baseHudItem PointItem;
var baseHudItem StarItem;
var baseHudItem SeedItem;
//var baseHudItem HealthItem;

var bool bPlayQHUDGame;
var baseQHUDGame	QHUDGame;

event Tick(float fDeltaTime)
{
	super.tick(fDeltaTime);

	if(curIconMessage.valid)
		{
		curIconMessage.duration-=fDeltaTime;
		if(curIconMessage.duration<0)
			curIconMessage.valid=false;
		}
}
function SetScoreCountTime(float t)
{
	fScoreCountTime = t;
	fMaxScoreCountTime = t;
}

function PlayHUDGame(bool bEnable )
{
	bPlayQHUDGame = bEnable;
}

function SetHUDGameType(_HUDGameType GameType )
{
	HUDGameType = GameType;
}

function DrawHealth(Canvas canvas)
{
	local int ox,oy,i;
	local float	Health;
	local texture HealthBar;

	if(baseHarry(owner)==None)
		return;
	
	ox=0;
	oy=0;

	Canvas.SetPos(ox,oy);
	Canvas.DrawIcon(Texture'HarryBarfull',1);

	Health = baseHarry(Owner).GetHealth();
	Health = fclamp( Health, 0, 1.0);

	HealthBar = Texture'HarryBarEmpty';

//	Canvas.SetPos(ox, oy + (HealthBar.VSize * (1 - Health) );
	Canvas.SetPos(ox, oy);
	Canvas.DrawTile(HealthBar, HealthBar.USize, (HealthBar.VSize - 50) * (1 - Health) + 25, 0, 0, HealthBar.USize, (HealthBar.VSize - 50) * (1 - Health) + 25);
//	Canvas.DrawTile(HealthBar, HealthBar.USize, HealthBar.VSize * Health, 0, HealthBar.VSize * (1 - Health), HealthBar.USize, HealthBar.VSize * Health);
}


function StartCountdown(float time)
{
	bCountingDown=true;
	fCountdownTime=time;
	fStartCountdown = time;
	fLastTickTime = 0;
}
function StopCountdown()
{
	bCountingDown=false;
}

function float GetCountdown()
{
	if(bCountingDown)
		return(fCountdownTime);
	else
		return(0.0);
}
/*
function DrawCountdown(Canvas canvas)
{
local font saveFont;
local int t;

	local int		Ox, Oy;
	local int		RealVSize;
	local texture	TimerFull;
	local float		TimeRemaining;

	if(baseHarry(owner)==None)
		return;

	if(bCountingDown)
	{
		// Now draw the timer
	
		TimerFull = Texture'TimerBarFull';

		Ox = Canvas.SizeX - 8 - TimerFull.USize;
		Oy = Canvas.SizeY - 8 - TimerFull.VSize;

		Canvas.SetPos(Ox,Oy);
		Canvas.DrawIcon(Texture'TimerBarEmpty',1);

		TimeRemaining = fCountdownTime / fStartCountdown;

		Canvas.SetPos(ox, oy + (TimerFull.VSize - 11 - 9) * (1 - TimeRemaining) + 11);
		Canvas.DrawTile(TimerFull, TimerFull.USize, (TimerFull.VSize - 20) * TimeRemaining + 9, 0, (TimerFull.VSize - 11 - 9 ) * (1 - TimeRemaining) + 11, TimerFull.USize, (TimerFull.VSize - 20) * TimeRemaining + 9);

		if (abs(fLastTickTime - fCountdownTime) > 1.0)
		{
			// Play timer tick
			if (fCountdownTime > 30.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_1', SLOT_None, 0.5);
				DebugString = "Timer 1";
			}
			else if (fCountdownTime > 20.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_2', SLOT_None, 0.5);
				DebugString = "Timer 2";
			}
			else if (fCountdownTime > 15.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_3', SLOT_None, 0.5);
				DebugString = "Timer 3";
			}
			else if (fCountdownTime > 10.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_4', SLOT_None, 0.5);
				DebugString = "Timer 4";
			}
			else if (fCountdownTime > 5.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_5', SLOT_None, 0.5);
				DebugString = "Timer 5";
			}
			else
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_6', SLOT_None, 0.5);
				DebugString = "Timer 6";
			}
			fLastTickTime = fCountdownTime;
		}
	}
}
*/

function DrawCountdown(Canvas canvas)
{
	local font saveFont;
	local int t;

	local int		Ox, Oy;
	local int		RealVSize;
	local texture	TimerFull;
	local float		TimeRemaining;

	if(baseHarry(owner)==None)
		return;

	if(bCountingDown)
	{
		// Now draw the timer
	
		TimerFull = Texture'TimerBarFull';

		Ox = Canvas.SizeX - TimerFull.USize - 8;
		Oy = Canvas.SizeY - 160;

		Canvas.SetPos(Ox, Oy);
		Canvas.DrawIcon(Texture'TimerBarEmpty',1);

		TimeRemaining = fCountdownTime / fStartCountdown;

		Canvas.SetPos(ox, oy);
		Canvas.DrawTile(TimerFull, (TimerFull.USize - 97 ) * TimeRemaining + 97, TimerFull.VSize, 0, 0, (TimerFull.USize - 97) * TimeRemaining + 97, TimerFull.VSize);

		if (abs(fLastTickTime - fCountdownTime) > 1.0)
		{
			// Play timer tick
			if (fCountdownTime > 30.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_1', SLOT_None, 0.5);
				DebugString = "Timer 1";
			}
			else if (fCountdownTime > 20.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_2', SLOT_None, 0.5);
				DebugString = "Timer 2";
			}
			else if (fCountdownTime > 15.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_3', SLOT_None, 0.5);
				DebugString = "Timer 3";
			}
			else if (fCountdownTime > 10.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_4', SLOT_None, 0.5);
				DebugString = "Timer 4";
			}
			else if (fCountdownTime > 5.0)
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_5', SLOT_None, 0.5);
				DebugString = "Timer 5";
			}
			else
			{
				owner.PlaySound(Sound'HPSounds.menu_sfx.timer_6', SLOT_None, 0.5);
				DebugString = "Timer 6";
			}
			fLastTickTime = fCountdownTime;
		}
	}
}

function DrawCutSceneBoarder(Canvas canvas)
{

	if(bCutSceneMode || curIconMessage.valid)
		{
		if(fCutSceneBoarderOffset<canvas.SizeY/8)
			fCutSceneBoarderOffset+=((canvas.SizeY/8)-fCutSceneBoarderOffset)/5;
		}
	else
		{
		if(fCutSceneBoarderOffset>0)
			fCutSceneBoarderOffset-=fCutSceneBoarderOffset/5;
		}


	Canvas.SetPos(0,0);
	canvas.DrawTile(Texture'leftPanel',canvas.SizeX,fCutSceneBoarderOffset, 0,0, 1, 1);

	Canvas.SetPos(0,canvas.SizeY-fCutSceneBoarderOffset);
	canvas.DrawTile(Texture'leftPanel',canvas.SizeX,fCutSceneBoarderOffset, 0,0, 1, 1);
}
function DrawIconMessageBox(Canvas canvas)
{
}

function DrawIconMessages(Canvas canvas)
{
local int xpos, ypos;
local float w, h;
local int lines,AvailLines;
local Font saveFont;

	local string TextLine, SearchStr;
	local int	iOrgPos, iNewPos;

	if(curIconMessage.valid!=true)
		return;

	if(curIconMessage.message!="")
		DrawIconMessageBox(canvas);

	if(!bDrawDialogText)
		return;

//	Canvas.Font=Font'ChiFont';
//	Canvas.Font=Font'InkFont';
//	Canvas.Font=Font'KorFont';

	saveFont=Canvas.Font;	
	Canvas.Font=baseConsole(playerpawn(owner).player.console).LocalIconMessageFont;

	xpos=0;
	if(curIconMessage.icon!=None)
		{
		Canvas.Style = 2;
		Canvas.SetPos(xpos, (canvas.SizeY-fCutSceneBoarderOffset+5));
	 	Canvas.DrawIcon(curIconMessage.icon, 1.0);
		xpos+=curIconMessage.icon.USize+10;
		}
	if(curIconMessage.message!="")
	{
		Canvas.Style = 2;

		Canvas.DrawColor.r=127;
		Canvas.DrawColor.g=127;
		Canvas.DrawColor.b=255;

		canvas.TextSize(curIconMessage.message, w, h);

		//Massive KLUDGE. cmp 10-18 The +90 below is a fudge factor to overcome the spaces added to a string when it gets word wrapped. 
		//specificly to fix German storybook_new_20
		lines=((w+90)/Canvas.SizeX)+1;
		AvailLines=((canvas.SizeY)/8)/h;

//baseHarry(owner).clientMessage(self $" " $lines $" " $AvailLines $"Width:" $w $"Height:" $h);
		if(lines>AvailLines)
		{
			Canvas.Font=baseConsole(playerpawn(owner).player.console).LocalMedFont;
			canvas.TextSize(curIconMessage.message, w, h);
			lines=((w+90)/Canvas.SizeX)+1;
			AvailLines=((canvas.SizeY)/8)/h;
			if(lines>AvailLines)
				{
				Canvas.Font=baseConsole(playerpawn(owner).player.console).LocalSmallFont;
				canvas.TextSize(curIconMessage.message, w, h);
				lines=((w+90)/Canvas.SizeX)+1;
				AvailLines=((canvas.SizeY)/8)/h;

				if(lines>AvailLines)
					{
					Canvas.Font=baseConsole(playerpawn(owner).player.console).LocalTinyFont;
					canvas.TextSize(curIconMessage.message, w, h);
					lines=((w+90)/Canvas.SizeX)+1;
					AvailLines=((canvas.SizeY)/8)/h;
					}
				}
		}

//		log("original " $curIconMessage.message);
		if (caps(GetLanguage()) == "THA")
		{
			TextLine = "";

			iOrgPos = 0;

			ypos = (canvas.SizeY - fCutSceneBoarderOffset) + 1;
			Canvas.SetPos(xpos, ypos);

			SearchStr = curIconMessage.message;

			while (iOrgPos <= Len(curIconMessage.message))
			{
				iNewPos = InStr(SearchStr, "_");

				log("_ found at " $iNewPos);
				if (iNewPos != -1)
				{
					TextLine = TextLine $Left(SearchStr, iNewPos);
				}
				else
				{
					TextLine = TextLine $SearchStr;
				}

				canvas.TextSize(TextLine, w, h);
//				log("new line is " $TextLine);

				if ( w > canvas.SizeX - 16 - xpos)
				{
					// We've gone past the line, go back and print out the string
					TextLine = Left(TextLine, iOrgPos - 1);
					Canvas.DrawText(TextLine, False);	
					ypos += h;
					Canvas.SetPos(xpos, ypos);
					TextLine = "";
				}
				else
				{
					if (iNewPos != -1)
					{
						iOrgPos += iNewPos;
						SearchStr = Right(SearchStr, Len(SearchStr) - iNewPos - 1);
					}
					else
					{
						break;
					}
				}

//				log("New search str " $SearchStr);
			}
			canvas.TextSize(TextLine, w, h);

			if ( w < canvas.SizeX - 16 - xpos)
			{
				xpos = (canvas.SizeX - w - xpos) / 2;
			}
			Canvas.SetPos(xpos, ypos);
			Canvas.DrawText(TextLine, False);	

/*			lines = 1;
			while (lines > 0)
			{
				iOrgPos = 0;
				iNewPos = 0;

				while (Mid(curIconMessage.message, iOrgPos, 1) != " " 
					&& Mid(curIconMessage.message, iOrgPos, 1) != "\n"
					&& Mid(curIconMessage.message, iOrgPos, 1) != "\0")				
				{
//					if (Mid(curIconMessage.message, iOrgPos, 1) != "_")
//					{
						TextLine = TextLine $Mid(curIconMessage.message, iOrgPos, 1);
//					}
					iOrgPos ++;
				}

				TextLine = TextLine $Mid(curIconMessage.message, iOrgPos, 1);

				Canvas.DrawText(TextLine, False);	
				lines --;
				ypos += h;
				Canvas.SetPos(xpos, ypos);
			}*/
		}
		else
		{

			if ( w < canvas.SizeX - 16 - xpos)
			{
				xpos = (canvas.SizeX - w - xpos) / 2;
			}


			Canvas.SetPos(xpos, (canvas.SizeY-fCutSceneBoarderOffset)+1);
			Canvas.DrawText(curIconMessage.message, False);	

		}
	}
	Canvas.DrawColor.r=255;
	Canvas.DrawColor.g=255;
	Canvas.DrawColor.b=255;
	Canvas.Font=saveFont;
}


function DrawDebug(Canvas canvas)
{
	Canvas.SetPos(8, Canvas.SizeY-240);
	Canvas.DrawText("Text " $DebugString, False);
	Canvas.SetPos(8, Canvas.SizeY-224);
	Canvas.DrawText("ValA " $DebugValA, False);
	Canvas.SetPos(8, Canvas.SizeY-208);
	Canvas.DrawText("ValX " $DebugValX, False);
	Canvas.SetPos(8, Canvas.SizeY-192);
	Canvas.DrawText("ValY " $DebugValY, False);
	Canvas.SetPos(8, Canvas.SizeY-176);
	Canvas.DrawText("ValZ " $DebugValZ, False);

	Canvas.SetPos(8, Canvas.SizeY-144);
	Canvas.DrawText("Text " $DebugString2, False);
	Canvas.SetPos(8, Canvas.SizeY-128);
	Canvas.DrawText("ValA " $DebugValA2, False);
	Canvas.SetPos(8, Canvas.SizeY-112);
	Canvas.DrawText("ValX " $DebugValX2, False);
	Canvas.SetPos(8, Canvas.SizeY-96);
	Canvas.DrawText("ValY " $DebugValY2, False);
	Canvas.SetPos(8, Canvas.SizeY-80);
	Canvas.DrawText("ValZ " $DebugValZ2, False);

}

function ShowPopup(class<basePopup> popup)
{
	curPopup=Spawn(popup);
}

function DestroyPopup()
{
	if (curPopup != None)
	{
		curPopup.destroy();
		curPopup = None;
	}
}

function DrawPopup(Canvas canvas)
{
	if(curPopup==None)
		return;
	curPopup.Draw(canvas);

	if(curPopup.bDeleteMe)
		curPopup=None;

}


function ReceiveIconMessage(Texture icon,string message,float duration)
{
	curIconMessage.icon=icon;
	curIconMessage.message=message;
	curIconMessage.duration=duration;
	curIconMessage.valid=true;
}


simulated function HUDSetup(canvas canvas)
{
	// Setup the way we want to draw all HUD elements
	Canvas.Reset();
	Canvas.SpaceX=0;
	Canvas.bNoSmooth = True;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;	

	Canvas.Font=baseConsole(playerpawn(owner).player.console).LocalMedFont;
/*
	if(baseConsole(playerpawn(owner).player.console).bUseAsianFont)
		Canvas.Font=Font'AsianFontMed';
	if(baseConsole(playerpawn(owner).player.console).bUseThaiFont)
		Canvas.Font=Font'ThaiFontMed';
	else
		Canvas.Font=Font'MedInkFont';
*/
}
exec function ToggleDialog()
{
	bDrawDialogText=!bDrawDialogText;
}

defaultproperties
{
     bDrawDialogText=True
}
