//=============================================================================
// HPConsole - console replacer to implement UWindow UI System
//=============================================================================
class  HPConsole extends baseConsole;


#exec TEXTURE IMPORT NAME=MainBack1 FILE=Textures\MainBack1.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MainBack2 FILE=Textures\MainBack2.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MainBack3 FILE=Textures\MainBack3.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MainBack4 FILE=Textures\MainBack4.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MainBack5 FILE=Textures\MainBack5.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MainBack6 FILE=Textures\MainBack6.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=MainBackUp FILE=Textures\MainUp.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MainBackDown FILE=Textures\MainDown.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MainBackOver FILE=Textures\MainOver.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=DemoUp FILE=Textures\DemoUp.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=DemoDown FILE=Textures\DemoDown.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=DemoOver FILE=Textures\DemoOver.bmp GROUP="Icons" MIPS=OFF


#exec TEXTURE IMPORT NAME=LevelUp FILE=Textures\LevelUp.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=LevelDown FILE=Textures\LevelDown.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=LevelOver FILE=Textures\LevelOver.bmp GROUP="Icons" MIPS=OFF

var UWindowDialogClientWindow levSelect;

//var UWindowBitmap letterWin;

var UWindowButton OKButton;
const BUTTONS_X	=185;
const BUTTONS_Y =193;
var bool bLevelSelect;
var bool firstRun;
var int CanvasSizeX,CanvasSizeY;
var float fFadeDirection;

var bool bShootingRange;

var bool bLoadNewLevel;
var bool bFastForwardMode;
//var bool bShowMenu;

var hudStoryBook storyBook;

var FEBook menuBook;

var bool bToggleMoveModePressed;
var bool bShowPos;

//var bool bBossCamera;
var bool bBoostKeyPressed;

//var bool bArrowKeyLeftPressed;
//var bool bArrowKeyRightPressed;
//var bool bArrowKeyUpPressed;
//var bool bArrowKeyDownPressed;


var ParticleFX MouseParticle;

var bool bShiftDown;

var UWindowMessageBoxCW TestConfirm;

var bool	bInHubFlow;		// Whether level is being played like within the normal hub-to-hub flow
							// of the game (as opposed to direct play outside of normal hub flow)
							// Note: this is true even if level was launched from the Level Select
							// menu because that's meant to simulate in-hub flow during testing).

var string ResTimeOutSettings;


function ToggleDebugMode()
{
	if(!class'Version'.default.bDebugEnabled)
		{
		bDebugMode=false;
//		SaveConfig();
		return;
		}

	bDebugMode=!bDebugMode;
//	SaveConfig();
}


function SaveSelectedSlot()
{
	StopFastforward();		//just in case.
	MenuBook.SaveSelectedSlot();
}
function LoadSelectedSlot()
{
	MenuBook.LoadSelectedSlot();
	StopFastforward();		//just in case.
}


function hudstorybook ShowStoryBook(class<hudStoryBook> story)
{
	if(StoryBook!=None && StoryBook.bStoryBookVisible)
		HideStoryBook();

	storyBook = hudStoryBook(Root.CreateWindow(story, 0, 0, 640, 480));
	storyBook.bLeaveOnScreen = True;
	storyBook.bShowStoryBook=true;
	return storyBook;

}

function HideStoryBook()
{
	if(storyBook==None)
		return;
	storyBook.close(false);
	storybook=none;
}

function ShowConsole()
{
	if(!bDebugMode)
		return;
		
	bShowConsole = true;
	if(bCreatedRoot)
		ConsoleWindow.ShowWindow();
}


// Called in order to initiate a level change.
function ChangeLevel(string lev,bool flag)
{
	Log("Changing level to:"$lev $"," $flag);
	viewport.Actor.Level.ServerTravel( lev, flag );
	bLoadNewLevel = true;
}

// Override to change bNoDrawWorld.
function CloseUWindow()
{
	super.CloseUWindow();
	if( bLoadNewLevel )
		bNoDrawWorld = true;
}

event Tick(float delta)
{
	if( Viewport.Actor.Level.NextURL == "" )
	{
		bNoDrawWorld = menuBook.bIsOpen;

		if( bLoadNewLevel )
		{
			// Save game as soon as level is loaded. 
			// This is true when NextURL is no longer set.
			// First tick of new level.
			bLoadNewLevel = false;
			Log("Saving level at start");
			SaveSelectedSlot();
		}
	}

	//kludge to insure menu comes up first.
	if(firstRun==false)
		{
		LaunchUWindow();//start menus
		firstRun=true;
		}

	if(bFastForwardMode)
		{
		if(!baseHud(baseHarry(viewport.actor).myHud).bCutSceneMode)
			StopFastForward();
		if(!bSpacePressed)
			StopFastForward();
		}
	else
		{
		if(bSpacePressed && baseHud(baseHarry(viewport.actor).myHud).bCutSceneMode)
			{
			StartFastForward();
			}
		}


//	Root.bAllowConsole=class'Version'.default.bDebugEnabled;
//	Root.bAllowConsole=false;

		//tick any windows
	if(Root != None)
		Root.DoTick(Delta);	
}
function StartFastforward()
{
	if(!bDebugMode)
		return;

	if(baseHarry(viewport.actor)==None)
		return;

	if(baseHud(baseHarry(viewport.actor).myHud)==None)
		return;

	if(!baseHud(baseHarry(viewport.actor).myHud).bCutSceneMode)
		return;
	
	baseHarry(viewport.actor).SloMo(8.0);
	bFastForwardMode=true;
}
function StopFastforward()
{
	baseHarry(viewport.actor).NormalSpeed();
	bFastForwardMode=false;
}


function doLevelSave (int i)
{
	local string savePauser;
	local PlayerPawn playerPawn;
	local GameSaveInfo gameSaveInfo;
	local int n;

	// AWRIGHT_111001_001
	local int SavePointID;


	StopFastforward();		//just in case.

	playerPawn = viewport.Actor;

		// disable and store pauser if active

	savePauser = playerPawn.Level.Pauser;
	playerPawn.Level.Pauser = "";

		// Save the actual game

	playerPawn.Level.ConsoleCommand("SaveGame " $i);

	playerPawn.Level.Pauser = savePauser;

		// Save game info

	gameSaveInfo = new class'GameSaveInfo';
	gameSaveInfo.numBeans  = baseHarry(playerPawn).numBeans;
	gameSaveInfo.numStars  = baseHarry(playerPawn).numStars;
	gameSaveInfo.numPoints = baseHarry(playerPawn).getNumHousePointsHarry ();

	n = InStr(playerPawn.level.LevelEnterText, ".");
	if (n==-1)
		gameSaveInfo.currentLevelString = playerPawn.level.LevelEnterText;
	else
		gameSaveInfo.currentLevelString = Left(playerPawn.level.LevelEnterText, n);
		
	log("LevelSave: Level Name is" $gameSaveInfo.currentLevelString);


	// AWRIGHT_111001_001
	// find near spell book & store instance number 
	// in game save info for later displaying correct 
	// thumbnail in the game slot selection screen

	SavePointID = -1;

	SavePointID = baseHarry(viewport.actor).FindNearestSavePointID();

	Log( "Found Savepoint ID = " $SavePointID );

	// save save point instance 
	// number in save game info

	gameSaveInfo.savePointID = SavePointID;

	// AWRIGHT_111001_001 - end




//	playerPawn.SaveGameSaveInfo(nSelectedSlot$"GameSaveInfo"$i, gameSaveInfo);

	playerPawn.SaveGameSaveInfo("GameSaveInfo"$i, gameSaveInfo);


		// Save screenShot

	// Not working right.	
	// AWRIGHT_091001_002
	// root.console.viewport.Actor.ConsoleCommand("Snap 3");
	// root.console.viewport.Actor.ConsoleCommand("SaveSnap ..\\Save\\SaveGameSnap" $i $".bmp");
	//root.console.viewport.Actor.ConsoleCommand( 
	//	"SaveSnap128 ..\\Save\\SaveGameSnap" $i $".bmp");
}





event PostRender( canvas Canvas )
{
	Super.PostRender(Canvas);

	if (Root != None)
		{
		if(MenuBook.bIsOpen)
			RenderUWindow( Canvas );
		else if(storyBook!=none && storyBook.bStoryBookVisible)
			RenderUWindow( Canvas );

		}

	if( bShowPos )
		{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
		Canvas.SetPos( Canvas.SizeX-200, Canvas.SizeY-40 );
		Canvas.DrawText( "Player @ "$ 
			int(Viewport.Actor.Location.X) $","$
			int(Viewport.Actor.Location.Y) $","$
			int(Viewport.Actor.Location.Z) );
		}

/* test code

	if(MouseParticle==None)
		{
		MouseParticle=viewport.Actor.spawn(class'TorchFire01');
		MouseParticle.bShellOnly=true;
		}
	else
		{

// Try screenspace  MouseParticle.SetLocation(vect(20.0,20.0,1.0));

        //set location in world space
		MouseParticle.SetLocation(viewport.Actor.CameraToWorld(vect(0.0,0.0,20)));
		Canvas.DrawActor(MouseParticle,false,true);
		}

*/
}


state UWindow
{

	event bool KeyType( EInputKey Key )
	{
		if (Root != None)
			Root.WindowEvent(WM_KeyType, None, MouseX, MouseY, Key);
		return True;
	}


	event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local byte k;

	//	log("HPConsole keyEvent");
		if(ResTimeOutSettings != "")
		{
			log("HPConsole : setRes");
			viewport.actor.ConsoleCommand("SetRes "$ResTimeOutSettings);
			ResTimeOutSettings = "";

			if (FEOptionsPage(menuBook.curPage) != None)
				FEOptionsPage(menuBook.curPage).LoadAvailableSettings();
		}

		k = Key;

		if( menuBook.KeyEvent( Key, Action, Delta ) )
			{
			return true;
			}
		else // not processed
			{		
			if(Action==IST_Release && Key==IK_LeftMouse)
				{
				if(Root != None) 
					Root.WindowEvent(WM_LMouseUp, None, MouseX, MouseY, k);
				}

			if(action==IST_PRESS && key==IK_F7)	// test
				ToggleDebugMode();

			return Super.KeyEvent(Key, Action, Delta);
			}

	}

Begin:
}


/*
function ShowMenuBook (optional string selectPage)		//replaced by FEBook.OpenBook(optional string page);
{
	// Take a snapshot of the screen, for a possible save game:
	viewport.Actor.ConsoleCommand("Snap 3");
	//Viewport.Actor.Level.screenShot = Viewport.Actor.Level.CreateTextureFromScreenShot (Viewport);

	if (bLocked)
		return;
	bQuickKeyEnable = False;
	LaunchUWindow();

	if (selectPage != "")
		menuBook.ChangePageNamed(selectPage);
}
*/

exec function GiveBeans(int num)
{
	baseHarry(viewport.actor).AddBeans(num);

}


exec function GiveHousePoints(int num)
{
	baseHarry(viewport.actor).AddHousePoints(num);

}

exec function GiveSeeds(int num)
{
	baseHarry(viewport.actor).AddSeeds(num);
}
exec function ShowPos()
{
	bShowPos = !bShowPos;
}

exec function giveAllCards ()
{
	baseHarry(viewport.actor).giveAllCards ();
}

event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	local byte k;


	k = Key;

/*	if( menuBook.KeyEvent( Key, Action, Delta ) )
	{
		return true;
	}
*/


	switch(Action)
	{
	case IST_Release:
		switch(k)
			{
			case EInputKey.IK_LEFTMOUSE:
				bspaceReleased = true;
			//	return True;
				break;

			case EInputKey.IK_SPACE:
				//This is also used for
				bSpacePressed = false;
				bBoostKeyPressed = false;

				baseHarry(viewport.actor).bSkipKeyPressed = false;
				break;

			case EInputKey.IK_NumPad4:
				bLeftKeyDown = false;
				break;

			case EInputKey.IK_NumPad6:
				bRightKeyDown = false;
				break;

			case EInputKey.IK_NumPad8:
				bForwardKeyDown = false;
				break;

			case EInputKey.IK_NumPad2:
				bbackKeyDown = false;
				break;

			case EInputKey.IK_NumPad1:
				bRotateLeftKeyDown = false;
				break;

			case EInputKey.IK_NumPad3:
				bRotateRightKeyDown = false;
				break;

			case EInputKey.IK_NumPad0:
				bRotateUpKeyDown = false;
				break;

			case EInputKey.IK_NumPadPeriod:
				bRotateDownKeyDown = false;
				break;

			case EInputKey.IK_NumPad7:
				bUpKeyDown = false;
				break;

			case EInputKey.IK_NumPad9:
				bDownKeyDown = false;

			case EInputKey.IK_Shift:
				bShiftDown = False;
				break;

			}
		break;

	case IST_Press:

		if(	baseHarry(viewport.actor) != none )
			baseHarry(viewport.actor).KeyDownEvent( int(Key) );

		switch(k)
			{
			//case EInputKey.IK_Left:
			//case EInputKey.IK_Up:
			//case EInputKey.IK_Right:
			//case EInputKey.IK_Down:


			case EInputKey.IK_Shift:
				bShiftDown = True;
				break;

			case EInputKey.IK_TAB:
				if(bDebugMode)
					Type();
				break;

			case EInputKey.IK_NumPad4:
				bLeftKeyDown = true;
				break;

			case EInputKey.IK_NumPad6:
				bRightKeyDown = true;
				break;

			case EInputKey.IK_NumPad8:
				bForwardKeyDown = true;
				break;

			case EInputKey.IK_NumPad2:
				bbackKeyDown = true;
				break;

			case EInputKey.IK_NumPad1:
				bRotateLeftKeyDown = true;
				break;

			case EInputKey.IK_NumPad3:
				bRotateRightKeyDown = true;
				break;

			case EInputKey.IK_NumPad0:
				bRotateUpKeyDown = true;
				break;

			case EInputKey.IK_NumPadPeriod:
				bRotateDownKeyDown = true;
				break;

			case EInputKey.IK_NumPad7:
				bUpKeyDown = true;
				break;

			case EInputKey.IK_NumPad9:
				bDownKeyDown = true;
				break;

		// Save screenShot

			case EInputKey.IK_Insert:
				if(bDebugMode)
					viewport.Actor.sshot();
//				viewport.Actor.ConsoleCommand("Shot");
				break;


			case EInputKey.IK_Backspace:
				//HarryRef.ClientMessage("tab!");
				//man, cant even do a foreach here.
				bToggleMoveModePressed = true;
				break;

			case EInputKey.IK_RIGHTMOUSE:
				/*
				if(storyBook!=none)
				{
						HideStoryBook();
						return True;
				}

				if (!bTyping )
					{
					bQuickKeyEnable = True;
					LaunchUWindow();

					}
				return true;
				*/
				break;
//			case EInputKey.IK_RIGHTMOUSE:
//				if (bLocked)
//					return true;
//				bQuickKeyEnable = False;
//				LaunchUWindow();

//				break;
			case EInputKey.IK_Escape:
				// AMM
				// MenuBook.OpenBook("REPORT");
				MenuBook.EscFromConsole();
				return true;

			case ConsoleKey:
				if (bLocked)
					return true;

				Root.bAllowConsole=class'Version'.default.bDebugEnabled;
				if(!bDebugMode)
					return true;

				bQuickKeyEnable = True;
				LaunchUWindow();
				if(!bShowConsole)
					ShowConsole();
				return true;
			case EinputKey.IK_LEFTMOUSE:
				bspaceReleased=false;
			//	return(true);
				break;

			case EInputKey.IK_SPACE:
				bSpacePressed = true;
				bBoostKeyPressed = true;
				baseHarry(viewport.actor).bSkipKeyPressed = true;
				break;

			case EInputKey.IK_F2:	// test
				if(bDebugMode)
					baseHarry(viewport.actor).GotoShortcut(0);
				break;
			case EInputKey.IK_F3:	// test
				if(bDebugMode)
					baseHarry(viewport.actor).GotoShortcut(1);
				break;
			case EInputKey.IK_F4:	// test
				if(bDebugMode)
					baseHarry(viewport.actor).GotoShortcut(2);
				break;
			case EInputKey.IK_F5:	// test
				if(bDebugMode)
					baseHarry(viewport.actor).GotoShortcut(-1);
				break;
			case EInputKey.IK_F6:	// test
				break;

			case EInputKey.IK_F7:	// test
				ToggleDebugMode();
				break;
			case EInputKey.IK_F8:	// test
				if(bDebugMode)
					baseHarry(viewport.actor).cam.NextCamera();
				break;
			case EInputKey.IK_F9:	// test
				// Switch strafing mode
				baseHarry(viewport.actor).cam.bUseStrafing = !baseHarry(viewport.actor).cam.bUseStrafing;
				if (baseHarry(viewport.actor).cam.IsInState('BossState'))
				{
					// reset state
					if (baseHarry(viewport.actor).cam.bUseStrafing)
					{
						baseHarry(viewport.actor).MovementMode(true);
					}
					else
					{
						baseHarry(viewport.actor).MovementMode(false);
					}
				}
				break;

			case eInputKey.IK_F10:
			//	doLevelSave(99);
				break;

			case eInputKey.IK_F11:
				if(bDebugMode)
					{
					baseHud(Viewport.Actor.myHUD).BeanItem.Show();
					baseHud(Viewport.Actor.myHUD).SeedItem.Show();
					baseHud(Viewport.Actor.myHUD).StarItem.Show();
					baseHud(Viewport.Actor.myHUD).PointItem.Show();
					}
				break;

			case EInputKey.IK_F12:	
				break;
			}
		break;
	}
		
	

	return False; 
	//!! because of ConsoleKey
	//!! return Super.KeyEvent(Key, Action, Delta);
}

function handleMenuEvent()
{

}

function drawLegal(Canvas canvas)
{
}

function newDrawBack( canvas Canvas )
{
}
function drawBack( canvas Canvas )
{
}

function SetupLanguage()
{
local string f1,f2,f3,f4;
local int f1s,f2s,f3s,f4s;


	LanguageCode=GetLanguage();

	log("LanguageCode="$LanguageCode);


	switch(caps(LanguageCode))
		{
		case "SIM":
		case "CHI":
		case "TRA":
		case "KOR":
		case "THA":
		case "JAP":
			bUseAsianFont=true;
			f1=Localize("all","Font1Name", "SAPFont");
			f1s=int(Localize("all","Font1Size", "SAPFont"));
			f2=Localize("all","Font2Name", "SAPFont");
			f2s=int(Localize("all","Font2Size", "SAPFont"));
			f3=Localize("all","Font3Name", "SAPFont");
			f3s=int(Localize("all","Font3Size", "SAPFont"));
			f4=Localize("all","Font4Name", "SAPFont");
			f4s=int(Localize("all","Font4Size", "SAPFont"));

			log("Font1:" $f1 $":" $f1s);
			log("Font2:" $f2 $":" $f2s);
			log("Font3:" $f3 $":" $f3s);
			log("Font4:" $f4 $":" $f4s);

			LocalBigFont=CreateNativeFont(f1,f1s);
			LocalMedFont=CreateNativeFont(f2,f2s);
			LocalSmallFont=CreateNativeFont(f3,f3s);
			LocalTinyFont=CreateNativeFont(f4,f4s);
			LocalIconMessageFont=LocalBigFont;

			root.Fonts[0]=LocalSmallFont;
			root.Fonts[1]=LocalSmallFont;
			root.Fonts[2]=LocalMedFont;
			root.Fonts[3]=LocalMedFont;
			root.Fonts[4]=LocalMedFont;

			break;

/*		case "THA":
			bUseThaiFont=true;
			LocalBigFont=Font'ThaiFontBig';
			LocalMedFont=Font'ThaiFontMed';
			LocalSmallFont=Font'ThaiFontSmall';
			LocalTinyFont=Font'ThaiFontSmall';
			LocalIconMessageFont=LocalBigFont;

			root.Fonts[0]=Font'ThaiFontSmall';
			root.Fonts[1]=Font'ThaiFontSmall';
			root.Fonts[2]=Font'ThaiFontMed';
			root.Fonts[3]=Font'ThaiFontMed';
			root.Fonts[4]=Font'ThaiFontMed';
			break;
		case "JAP":
			bUseAsianFont=true;
			LocalBigFont=CreateNativeFont(JapFont1Name, JapFont1Size);
			LocalMedFont=CreateNativeFont(JapFont2Name, JapFont2Size);
			LocalSmallFont=CreateNativeFont(JapFont3Name, JapFont3Size);
			LocalTinyFont=CreateNativeFont(JapFont4Name, JapFont4Size);
			LocalIconMessageFont=LocalBigFont;

			root.Fonts[0]=LocalSmallFont;
			root.Fonts[1]=LocalSmallFont;
			root.Fonts[2]=LocalMedFont;
			root.Fonts[3]=LocalMedFont;
			root.Fonts[4]=LocalMedFont;
			break;
*/

		case "POL":		//
			LocalBigFont=Font(DynamicLoadObject("HPFonts.PolFontLarge", class'Font'));
			LocalMedFont=Font(DynamicLoadObject("HPFonts.PolFontMed", class'Font'));
			LocalSmallFont=Font(DynamicLoadObject("HPFonts.PolFontSmall", class'Font'));
			LocalTinyFont=Font(DynamicLoadObject("HPFonts.PolFontTiny", class'Font'));

			root.Fonts[0]=LocalTinyFont;
			root.Fonts[1]=LocalSmallFont;
			root.Fonts[2]=LocalSmallFont;
			root.Fonts[3]=LocalSmallFont;
			root.Fonts[4]=LocalSmallFont;

			LocalIconMessageFont=LocalMedFont;
			break;
		case "ENG":		//
		case "INT":		//
			LocalBigFont=Font'HugeInkFont';
			LocalMedFont=Font'BigInkFont';
			LocalSmallFont=Font'MedInkFont';
			LocalTinyFont=Font'SmallInkFont';
			LocalIconMessageFont=LocalSmallFont;
			break;
		case "GER":
		default:
			LocalBigFont=Font'BigInkFont';
			LocalMedFont=Font'MedInkFont';
			LocalSmallFont=Font'SmallInkFont';
			LocalTinyFont=Font'TinyInkFont';
			LocalIconMessageFont=Font'SmallInkFont';
			break;
		}

/*
bUseSystemFonts=false;
	if(bUseAsianFont)
		{
if(false)//		if(bUseSystemFonts)
			{
			LocalBigFont=Font'SystemFontBig';
			LocalMedFont=Font'SystemFontMed';
			LocalSmallFont=Font'SystemFontSmall';
			LocalTinyFont=Font'SystemFontSmall';
			LocalIconMessageFont=LocalBigFont;

			root.Fonts[0]=Font'SystemFontSmall';
			root.Fonts[1]=Font'SystemFontSmall';
			root.Fonts[2]=Font'SystemFontMed';
			root.Fonts[3]=Font'SystemFontMed';
			root.Fonts[4]=Font'SystemFontMed';
			}
		else
			{
			}
		}
	if(bUseThaiFont)
		{
		}
*/

	SaveConfig();

}
function RenderUWindow( canvas Canvas )
{
local LevelInfo lev;

	local UWindowWindow NewFocusWindow;

	local Texture curTexture;

	Canvas.bNoSmooth = True;
	Canvas.Z = 1;
	Canvas.Style = 1;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;

//	Canvas.clear();

	if(Viewport.bWindowsMouseAvailable && Root != None)
	{
		MouseX = Viewport.WindowsMouseX/Root.GUIScale;
		MouseY = Viewport.WindowsMouseY/Root.GUIScale;
	}


	if(!bCreatedRoot) 
		{
		CreateRootWindow(Canvas);
		root.SetScale(root.RealWidth/640);
//		root.GUIScale=root.RealWidth/640;

		SetupLanguage();

		menuBook=FEBook(Root.CreateWindow(class'FEBook', 0*((Root.WinWidth/2)-320), 0*((Root.WinHeight/2)-240), 640, 480, root));
		MenuBook.OpenBook("Splash");

		// find out if this was a custom level
		lev=Root.GetLevel();
		log("Init level = " $lev.GetLocalUrl());
		if( InStr(caps(lev.GetLocalUrl()),"STARTUP")<0 )
			{	//yup so bypass the menus
			MenuBook.bGamePlaying=true;
			MenuBook.bShowSplash=false;
			MenuBook.CloseBook();
			}


		}

	Root.bWindowVisible = True;
	Root.bUWindowActive = bUWindowActive;
	Root.bQuickKeyEnable = bQuickKeyEnable;

	if(Canvas.ClipX != OldClipX || Canvas.ClipY != OldClipY)
	{
		OldClipX = Canvas.ClipX;
		OldClipY = Canvas.ClipY;
		
		Root.WinTop = 0;
		Root.WinLeft = 0;
		Root.WinWidth = Canvas.ClipX / Root.GUIScale;
		Root.WinHeight = Canvas.ClipY / Root.GUIScale;

		Root.RealWidth = Canvas.ClipX;
		Root.RealHeight = Canvas.ClipY;

		Root.ClippingRegion.X = 0;
		Root.ClippingRegion.Y = 0;
		Root.ClippingRegion.W = Root.WinWidth;
		Root.ClippingRegion.H = Root.WinHeight;

		Root.Resized();
	}

	if(MouseX > Root.WinWidth) MouseX = Root.WinWidth;
	if(MouseY > Root.WinHeight) MouseY = Root.WinHeight;
	if(MouseX < 0) MouseX = 0;
	if(MouseY < 0) MouseY = 0;


	// Check for keyboard focus
	NewFocusWindow = Root.CheckKeyFocusWindow();

	if(NewFocusWindow != Root.KeyFocusWindow)
	{
		Root.KeyFocusWindow.KeyFocusExit();		
		Root.KeyFocusWindow = NewFocusWindow;
		Root.KeyFocusWindow.KeyFocusEnter();
	}


	Root.MoveMouse(MouseX, MouseY);
	Root.WindowEvent(WM_Paint, Canvas, MouseX, MouseY, 0);
	if(bUWindowActive || bQuickKeyEnable) 
		{
		Root.DrawMouse(Canvas);

		}
}


event DrawLevelInfo( canvas C, string URL )
{
	local float sizeX, sizeY;
	local string index;
	local string text;
	local int dot, cards, secrets;

	sizeX = 256.0*FrameX/640.0;
	sizeY = 256.0*FrameY/480.0;

	C.CurX = 0;  C.CurY = 0;		C.DrawRect(Texture'HPLevelInfoBackground1', sizeX, sizeY);
	C.CurX = sizeX;					C.DrawRect(Texture'HPLevelInfoBackground2', sizeX, sizeY);
	C.CurX = 2*sizeX;				C.DrawRect(Texture'HPLevelInfoBackground3', sizeX, sizeY);
	C.CurX = 0;  C.CurY = sizeY;	C.DrawRect(Texture'HPLevelInfoBackground4', sizeX, sizeY);
	C.CurX = sizeX;					C.DrawRect(Texture'HPLevelInfoBackground5', sizeX, sizeY);
	C.CurX = 2*sizeX;				C.DrawRect(Texture'HPLevelInfoBackground6', sizeX, sizeY);

	// Convert file name to level title and objective.
	dot = InStr( URL, "." );
	if( dot >= 0 )
		URL = Left( URL, dot );
	log("NextURL = "$ URL);

	C.bCenter = true;

	// Clip to edges of parchment.
	C.OrgX = FrameX * 0.15;		
	C.ClipX = FrameX * 0.7;

	C.DrawColor.R = 0;  C.DrawColor.G = 0;  C.DrawColor.B = 0;

	// Convert level name to index.
	index = Localize( "text", "n_"$ URL, "Dobby" );
	
	// Level name.
	text = Localize( "text", "level_name_"$ index, "HPMenu" );
	if( Left(text,1) != "<" )
	{
		C.CurX = FrameX * 0.35;
		C.CurY = FrameY * 0.25;
		C.Font = LocalBigFont;
		C.DrawText( text );
	}

	// Objective.
	text = Localize( "text", "objective_"$ index, "HPMenu" );
	if( Left(text,1) != "<" )
	{
		C.CurX = FrameX * 0.35;
		C.CurY = FrameY * 0.5;
		C.Font = LocalMedFont;
		C.DrawText( text ); 
	}

	// Only show secret counts if in regular game flow.
	if( bInHubFlow )
	{
		text = Localize( "text", "secret_"$ URL, "Dobby" );
		cards = int(Left(text, 1));
		secrets = int(Mid(text, 2, 1));

		C.Font = LocalSmallFont;
		C.CurY = FrameY * 0.7;
		if( cards > 0 )
		{
			C.CurX = FrameX * 0.35;
			text = Localize( "all", "find_wizard_text_0"$ cards, "Pickup" );
			if( Left(text,1) != "<" )
				C.DrawText( text );
			C.CurY = FrameY * 0.75;
		}
		if( secrets > 0 )
		{
			C.CurX = FrameX * 0.35;
			text = Localize( "all", "find_secret_text_0"$ secrets, "Pickup" );
			if( Left(text,1) != "<" )
				C.DrawText( text );
		}
	}
}

defaultproperties
{
     bShootingRange=True
     FadeOutTime=0.5
     FadeInTime=1
     PausedMessage="PRESS ESC TO EXIT"
     PrecachingMessage="ENTERING"
}
