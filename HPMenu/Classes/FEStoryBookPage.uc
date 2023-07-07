class FEStoryBookPage expands baseFEPage;

/*
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_0_0	 FILE=TEXTURES\StoryBook\StoryBook_0_0.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_0_1	 FILE=TEXTURES\StoryBook\StoryBook_0_1.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_0_2	 FILE=TEXTURES\StoryBook\StoryBook_0_2.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_0_3	 FILE=TEXTURES\StoryBook\StoryBook_0_3.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_0_4	 FILE=TEXTURES\StoryBook\StoryBook_0_4.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_0_5	 FILE=TEXTURES\StoryBook\StoryBook_0_5.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_0_6	 FILE=TEXTURES\StoryBook\StoryBook_0_6.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_0_7	 FILE=TEXTURES\StoryBook\StoryBook_0_7.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=HPStoryTexture_1_0	 FILE=TEXTURES\StoryBook\StoryBook_1_0.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_1_1	 FILE=TEXTURES\StoryBook\StoryBook_1_1.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=HPStoryTexture_2_0	 FILE=TEXTURES\StoryBook\StoryBook_2_0.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_2_1	 FILE=TEXTURES\StoryBook\StoryBook_2_1.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_2_2	 FILE=TEXTURES\StoryBook\StoryBook_2_2.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_2_3	 FILE=TEXTURES\StoryBook\StoryBook_2_3.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=HPStoryTexture_3_0	 FILE=TEXTURES\StoryBook\StoryBook_3_0.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_3_1	 FILE=TEXTURES\StoryBook\StoryBook_3_1.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=HPStoryTexture_4_0	 FILE=TEXTURES\StoryBook\StoryBook_4_0.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_4_1	 FILE=TEXTURES\StoryBook\StoryBook_4_1.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_4_2	 FILE=TEXTURES\StoryBook\StoryBook_4_2.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_4_3	 FILE=TEXTURES\StoryBook\StoryBook_4_3.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTexture_4_4	 FILE=TEXTURES\StoryBook\StoryBook_4_4.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
*/

//#EXEC TEXTURE IMPORT NAME=TextureTest1	 FILE=TEXTURES\StoryBook\StoryBook_0_0.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
//#EXEC TEXTURE IMPORT NAME=TextureTest2	 FILE=TEXTURES\StoryBook\3_1_001Test.pcx GROUP="Icons" FLAGS=2 MIPS=OFF


#EXEC TEXTURE IMPORT NAME=HPLevelInfoBackground1	 FILE=TEXTURES\StoryBook\levelload01.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPLevelInfoBackground2	 FILE=TEXTURES\StoryBook\levelload02.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPLevelInfoBackground3	 FILE=TEXTURES\StoryBook\levelload03.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPLevelInfoBackground4	 FILE=TEXTURES\StoryBook\levelload04.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPLevelInfoBackground5	 FILE=TEXTURES\StoryBook\levelload05.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPLevelInfoBackground6	 FILE=TEXTURES\StoryBook\levelload06.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=HPStoryTextureBackground1	 FILE=TEXTURES\StoryBook\bg001.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTextureBackground2	 FILE=TEXTURES\StoryBook\bg002.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTextureBackground3	 FILE=TEXTURES\StoryBook\bg003.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTextureBackground4	 FILE=TEXTURES\StoryBook\bg004.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTextureBackground5	 FILE=TEXTURES\StoryBook\bg005.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=HPStoryTextureBackground6	 FILE=TEXTURES\StoryBook\bg006.pcx GROUP="Icons" FLAGS=2 MIPS=OFF

//#exec OBJ LOAD FILE=..\..\Mmmmusic\JS_StoryBook_v2_mx.umx PACKAGE=Engine


struct cStoryBookPage
{
	var string _GraphicName;
	var string _DialogName;
};

const NUM_STORY_BOOKS = 17;
var int NumStoryPages[17];//num pages in each story

const MAX_PAGES_PER_BOOK = 14;
var cStoryBookPage BookPages0[14];
var cStoryBookPage BookPages1[14];
var cStoryBookPage BookPages2[14];
var cStoryBookPage BookPages3[14];
var cStoryBookPage BookPages4[14];
var cStoryBookPage BookPages5[14];
var cStoryBookPage BookPages6[14];
//var cStoryBookPage BookPages7[11];
//var cStoryBookPage BookPages8[11];
var cStoryBookPage BookPages9[14];
//var cStoryBookPage BookPages10[11];
//var cStoryBookPage BookPages11[11];
//var cStoryBookPage BookPages12[11];
var cStoryBookPage BookPages13[14];
var cStoryBookPage BookPages14[14];
var cStoryBookPage BookPages15[14];
var cStoryBookPage BookPages16[14];

const CREDITS_STORY_BOOK = 16;

var() bool bAllowPageSkipping;

var int iCurrentStory; // 0 based
var int iCurrentPage;  // 0 based

var int _FirstCreditLine; //starts at 0, as each "page" is turned, it goes to the next line on the next page.
var int _CreditLinesPerPage;

var UWindowSmallButton     NextPageButton;

//var UWindowButton          LogoWindow[4];
var texture                LogoTexture[4];

var UWindowWrappedTextArea TextWindow;

var bool bCreated;

var StoryBookDialog   _StoryBookDialog;

var string            _URLToLoad;
var bool              _bGoBackToChapterPage;
var name              _EventWhenDone;

var int               _NumCreditStrings;
var array<string>     _CreditsArray;

var float             _LastLevelTime;

var float             _TimeSecondsSave;
var float             _PageTimer;

var float             _MinTimeOnPage;  //about one second, before the audio starts

//var bool              _bEndStory;

//var baseFEPage	LevSelectPage;

const NUM_LOCALIZED_CREDITS_STRINGS = 19;
var string cdt_StringMatchArray[19];

var localized string cdt_0;
var localized string cdt_1;
var localized string cdt_2;
var localized string cdt_3;
var localized string cdt_4;
var localized string cdt_5;
var localized string cdt_6;
var localized string cdt_7;
var localized string cdt_8;
var localized string cdt_9;
var localized string cdt_10;
var localized string cdt_11;
var localized string cdt_12;
var localized string cdt_13;
var localized string cdt_14;
var localized string cdt_15;
var localized string cdt_16;
var localized string cdt_17;
var localized string cdt_18;

var sound            _dlgSound;
var float            _StartSoundTimer;

var music            _StoryBookMusic;

var bool             _bDoFastPageSkipping;

//***************************************************************************************************************
function Created()
{
	local int     i, i2;
	//local Texture tempTexture;
	local float   x,y;
	//local sound   dlgSound;
	local string  dlgText;
	local float   delay;
	local string  sBase, DialogName;
	local string  s;

	if( !bCreated )
	{
		Super.Created(); 

		SetCreditsLines();

		//		foreach AllActors(class'StoryBookDialog', _StoryBookDialog)
		//			break;

		//if( _StoryBookDialog == none )
		//	_StoryBookDialog = StoryBookDialog( Spawn(class'StoryBookDialog') );
		_StoryBookDialog = root.console.Viewport.Actor.Spawn(class'StoryBookDialog');
	}

	bAllowPageSkipping = HPConsole(root.console).bDebugMode;

	//if( bAllowPageSkipping )
	//	for (i = 0; i < 24; i++)
	//		baseHarry(Root.Console.viewport.actor).WizardCards[i].bHasCard = true;
	//baseHarry(Root.Console.viewport.actor).numBeans = 250;

	//	LevSelectPage = baseFEPage(CreateWindow(class'FELevSelectPage',95,15,440,360));  
	//	LevSelectPage.hideWindow();

	/*
	if( LogoWindow[0] == none )
	{
		LogoWindow[0] = UWindowButton(CreateWindow(class'UWindowButton', 0,     0, 256, 256));//LogoTexture[0].USize, LogoTexture[0].VSize));
		LogoWindow[1] = UWindowButton(CreateWindow(class'UWindowButton', 256,   0, 256, 256));//LogoTexture[1].USize, LogoTexture[1].VSize));
		LogoWindow[2] = UWindowButton(CreateWindow(class'UWindowButton', 0,   256, 256, 256));//LogoTexture[2].USize, LogoTexture[2].VSize));
		LogoWindow[3] = UWindowButton(CreateWindow(class'UWindowButton', 256, 256, 256, 256));//LogoTexture[3].USize, LogoTexture[3].VSize));
	}
	*/

	//tempTexture = GetStoryTexture(); //Texture'HPStoryTexture';
	//log("***************** "$iCurrentStory$" "$iCurrentPage);
	sBase = GetStoryBookBase( DialogName );

	for( i = 0; i < 4; i++ )
	{
		//s = "StoryBookTest.default." $ (iCurrentStory) $ "_" $ (iCurrentPage+1) $ "_00" $ (i+1);
		s = "StoryBookTest.default." $ sBase $ "00" $ (i+1);
		LogoTexture[i] = texture( DynamicLoadObject(s, class'Texture') );

		//Uh, this shouldn't be a button
		//LogoWindow[i].UpTexture =   LogoTexture[i];
		//LogoWindow[i].DownTexture = LogoTexture[i];
		//LogoWindow[i].OverTexture = LogoTexture[i];
	}

	if( bAllowPageSkipping  &&  NextPageButton == none )
	{
		NextPageButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth-120, WinHeight-22, 120, 25));
		NextPageButton.setFont(F_HPMenuLarge);
		NextPageButton.TextColor.r=90;
		NextPageButton.TextColor.g=90;
		NextPageButton.TextColor.b=90;
		NextPageButton.Align=TA_Center;
		NextPageButton.setText("NextPage");
		//y+=30;
	}

	if( TextWindow == none )
	{
		x = 108;//0;//WinWidth/2+10;
		y = WinHeight-99;//70;//20;
		TextWindow = UWindowWrappedTextArea( CreateControl(class'UWindowWrappedTextArea', x, y, 521-x/*WinWidth-x-(WinWidth-521)*/, WinHeight-y-0) );
		//TextWindow.bLog = true;
	}

	TextWindow.Clear();
	TextWindow.NumLinesInLastDraw = 0;  //Reset this.  It'll get set back in the next paint.
	TextWindow.DontDrawIfMoreLines = 4; //The control wont draw if there are more than this many lines

	_TimeSecondsSave = GetLevel().TimeSeconds;
	_PageTimer = 6; //default to this many seconds

	if( bWindowVisible )
	{
		//Music'Engine.Arg_Crabbe_Goyle1_loop'
		//if (baseHarry(Root.Console.viewport.actor).currentMusicEvent != None)
		//	baseHarry(Root.Console.viewport.actor).currentMusicEvent.CancelEvent ();

		baseHarry(Root.Console.viewport.actor).ClientSetMusic( Music'Engine.JS_StoryBook_v2_mx', 0, 255, MTRAN_Instant, false );
//Log("*********** sbm = "$_StoryBookMusic);
//baseHarry(Root.Console.viewport.actor).ClientSetMusic( _StoryBookMusic, 0, 255, MTRAN_Instant, false );

		//PrevPercentMusicVolume = P.PercentMusicVolume;
		//baseHarry(Root.Console.viewport.actor).currentMusicEvent = Root.Console.viewport.actor;


		//Special case for credits
		if( iCurrentStory == CREDITS_STORY_BOOK )
		{
			
		}
		else
		if( _StoryBookDialog != none )
		{
			if( _StoryBookDialog.FindDialog2(DialogName, /*iCurrentStory, iCurrentPage,*/ _dlgSound, delay, dlgText) )
			{
				//Log("********** FEStoryBookPage 2");
				if(_dlgSound!=None)
				{
					_PageTimer = _MinTimeOnPage + delay + 1.0;
					//playerHarry.clientMessage("Playing Sound: Len:" $delay);
					_StartSoundTimer = _MinTimeOnPage - 0.1; //Try and keep this a bit smaller than _MinTimeOnPage
					//root.console.Viewport.Actor.PlaySound(_dlgSound, SLOT_Interact, 3.2, false, 2000.0, 1.0);
					//Log("********** FEStoryBookPage 4");
				}

				TextWindow.AddText( dlgText );
				//TextWindow.AddText("No Text yet, young jimmy.  You must go home sad now...");
			}
		}
	}

	if( _bDoFastPageSkipping )
		_PageTimer = 0.25;

	//UWindowTextAreaControl has it's own int font var, so SetFont doesn't effect it.
	TextWindow.Font = 4;//SetFont( 3 );//F_LargeBold );

	//512 mode?  use smaller font
	if( Root.GUIScale < 0.9 )
		TextWindow.Font = 1;

	//	LogoWindow = UWindowBitmap(CreateWindow(class'UWindowBitmap',
	//		(WinWidth/4)-(tempTexture.USize/2),(WinHeight/2)-(tempTexture.VSize/2),tempTexture.USize,tempTexture.VSize));


	//log("Logo texture:"$tempTexture $" " $tempTexture.USize $" " $tempTexture.VSize);


	/*
			if(theDialog!=None)
			{
				if(theDialog.FindDialog(action.var1,dlgSound,dlgText))
				{
					if(dlgSound!=None)
					{
						delay=GetsoundDuration(dlgSound)+0.5;
						playerHarry.clientMessage("Playing Sound: Len:" $delay);
						PlaySound(dlgSound, SLOT_Interact, 3.2, false, 2000.0, 1.0);
					}
				}
				playerHarry.ReceiveIconMessage(None,dlgText,delay);
			}
	*/

	bCreated = true;
}

//***********************************************************************************************
//These dtime's aren't accurate.  Complete Bollocks.
event tick(float dtime)
{
	local float t;

	dtime = fmin( 0.1, GetLevel().TimeSeconds - _LastLevelTime );

	t = GetLevel().TimeSeconds - _TimeSecondsSave;

	if( t >= _PageTimer )
	{
		GotoNextPage();
	}
	else
	{
		if( _StartSoundTimer > 0 )
		{
			_StartSoundTimer -= dtime;
			if( _StartSoundTimer <= 0 )
				root.console.Viewport.Actor.PlaySound(_dlgSound, SLOT_Interact, 3.2, false, 2000.0, 1.0);
		}
	}
}

//***************************************************************************************************************
function AddCreditsLine(string s)
{
	_CreditsArray[ _NumCreditStrings ] = s;

	//s = TranslateString( s );

	_NumCreditStrings++;
}

//***************************************************************************************************************
function string GetStoryBookBase(out string DialogString)
{
	local string sBase;
	local int    i;

	//Remember that when you mess with these, you'll probably need to mess with the StoryBookDialog object.
	//All these are based on what's in h:\docs\MenuDesign\StoryBookImages.txt

	//This sucks:
	switch( iCurrentStory )
	{
		case 7:
		case 8:
		case 10:
		case 11:
		case 12:
			Log("******* StoryBook " $ iCurrentStory $ " not used");
			break;

		case 0:
			sBase =        BookPages0[iCurrentPage]._GraphicName;
			DialogString = BookPages0[iCurrentPage]._DialogName;
			break;
		case 1:
			sBase =        BookPages1[iCurrentPage]._GraphicName;
			DialogString = BookPages1[iCurrentPage]._DialogName;
			break;
		case 2:
			sBase =        BookPages2[iCurrentPage]._GraphicName;
			DialogString = BookPages2[iCurrentPage]._DialogName;
			break;
		case 3:
			sBase =        BookPages3[iCurrentPage]._GraphicName;
			DialogString = BookPages3[iCurrentPage]._DialogName;
			break;
		case 4:
			sBase =        BookPages4[iCurrentPage]._GraphicName;
			DialogString = BookPages4[iCurrentPage]._DialogName;
			break;
		case 5:
			sBase =        BookPages5[iCurrentPage]._GraphicName;
			DialogString = BookPages5[iCurrentPage]._DialogName;
			break;
		case 6:
			sBase =        BookPages6[iCurrentPage]._GraphicName;
			DialogString = BookPages6[iCurrentPage]._DialogName;
			break;
		case 9:
			sBase =        BookPages9[iCurrentPage]._GraphicName;
			DialogString = BookPages9[iCurrentPage]._DialogName;
			break;
		case 13:
			sBase =        BookPages13[iCurrentPage]._GraphicName;
			DialogString = BookPages13[iCurrentPage]._DialogName;
			break;
		case 14:
			sBase =        BookPages14[iCurrentPage]._GraphicName;
			DialogString = BookPages14[iCurrentPage]._DialogName;
			break;
		case 15:
			sBase =        BookPages15[iCurrentPage]._GraphicName;
			DialogString = BookPages15[iCurrentPage]._DialogName;
			break;
		case 16:
			sBase =        BookPages16[iCurrentPage]._GraphicName;
			DialogString = BookPages16[iCurrentPage]._DialogName;
			break;
	}

/*
		case 0:
		case 14:
			sBase = "CommonRoom";
			break;

		case 1:
			sBase = "HarryGetsBroom";
			break;

		case 2:
			sBase = "HarryStudy";
			break;

		case 3:
		case 4:
		case 6:
		case 7:
			i = iCurrentPage + 1;
			sBase = iCurrentStory $ "_" $ i $ "_";
			break;

		case 5:
			//special case cause the filenames are messed up
			if( i == 0 )
				sBase = "HermioneLibrary";
			else
			{
				if( i == 5 )
					i = 6;
			
				sBase = iCurrentStory $ "_" $ i $ "_";
			}
			
			break;

		case 8:
		case 11:
		case 12:
			Log("******* StoryBook " $ iCurrentStory $ " not used");
			break;

		case 9:
			sBase = "QuidditchVictory";
			break;

		case 10:
			sBase = "RunDownHall";
			break;

		case 13:
			i = iCurrentPage + 3;
			sBase = "5_" $ i $ "_";
			break;

		case 15:
			sBase = "5_2_";
			break;
	}
*/
	return sBase;
}

//***************************************************************************************************************
function Paint(Canvas canvas,float x,float y)
{
	local int width;
	local int i;
	local int tx,ty;
	local color saveColor;

	//We set TextWindow.NumLinesInLastDraw to zero when we put up a new page.
	// If it's not zero anymore (cause it's been drawn once), see if it's bigger than two,
	// and if so, tell the control to use a different font size.
	if( TextWindow.NumLinesInLastDraw > 4 )
		TextWindow.Font = 1;

	//ScaleAndDraw(canvas, 0,     0, LogoTexture[0]);
	//ScaleAndDraw(canvas, 0,   256, LogoTexture[1]);
	//ScaleAndDraw(canvas, 256,   0, LogoTexture[2]);
	//ScaleAndDraw(canvas, 256, 256, LogoTexture[3]);
	//for( y = 0; y < 480; y += 32 )
	//	for( x = 0; x < 640; x += 32 )

	DrawStretchedTexture( canvas,   0,   0, 256, 256, texture'HPStoryTextureBackground1' );
	DrawStretchedTexture( canvas, 256,   0, 256, 256, texture'HPStoryTextureBackground2' );
	DrawStretchedTexture( canvas, 512,   0, 256, 256, texture'HPStoryTextureBackground3' );
	DrawStretchedTexture( canvas,   0, 256, 256, 256, texture'HPStoryTextureBackground4' );
	DrawStretchedTexture( canvas, 256, 256, 256, 256, texture'HPStoryTextureBackground5' );
	DrawStretchedTexture( canvas, 512, 256, 256, 256, texture'HPStoryTextureBackground6' );

	tx = 92;//(WinWidth - 512) / 2;
	ty = 42;//20;

	//canvas.SetPos(tx+  0, ty+  0);
	//canvas.DrawTile(LogoTexture[0], 256, 256, 0, 0, 256, 256);

	DrawStretchedTexture( canvas, tx+  0, ty+  0, 256, 256, LogoTexture[0] );
	DrawStretchedTexture( canvas, tx+256, ty+  0, 256, 256, LogoTexture[1] );
	DrawStretchedTexture( canvas, tx+  0, ty+256, 256, 256, LogoTexture[2] );
	DrawStretchedTexture( canvas, tx+256, ty+256, 256, 256, LogoTexture[3] );

	//Special case for credits
	if( iCurrentStory == CREDITS_STORY_BOOK )
		PaintCredits( canvas );

	//Controls dont get drawn in super.Paint, they get drawn after at some point.
	super.Paint(canvas, x, y);
}

//***************************************************************************************************************
function PaintCredits( Canvas canvas )
{
	local float w, h;
	local int   StartY, EndY;
	local int   i;
	local int   iNumLinesThisPage;

	StartY = 50 * Root.GUIScale;
	EndY = 400 * Root.GUIScale;


	TextSize(canvas,"Final Results", w, h);
	_CreditLinesPerPage = (EndY - StartY) / (h + 0 );

	iNumLinesThisPage = _CreditLinesPerPage;
	if( iNumLinesThisPage < _NumCreditStrings - _FirstCreditLine )
		iNumLinesThisPage = _NumCreditStrings - _FirstCreditLine;

	for( i = 0; i < iNumLinesThisPage; i++ )
	{
//		Root.SetPos(canvas, (320-(w/2))*Root.GuiScale, StartY + i*h );
//		Canvas.DrawText("Final Results");  //not done
	}

}

//***************************************************************************************************************
function ShowWindow()
{
	super.ShowWindow ();

	//Log("************ FEStoryBookPage::ShowWindow");
	Created();
}

//***************************************************************************************************************
// if EventWhenDone is set, go back to the game, and send this trigger event off.
//  otherwise will just run URL, unless bGoBackToChapterPage is set.
function SetStory(int story, string URLToLoad, bool bGoBackToChapterPage, name EventWhenDone)
{
	SetStoryAndPage(story, 0);

	_URLToLoad = URLToLoad;
	_bGoBackToChapterPage = bGoBackToChapterPage;
	_EventWhenDone = EventWhenDone;
}

//***************************************************************************************************************
function GotoNextPage()
{
	//Alright, special hack, if you're in the final story book, and you're on page 2 (dialog StoryBook31),
	// but you dont have 24 cards, or less than 250 beans, skip the next 3 pages.
	if(   iCurrentStory == 6
	   && BookPages6[iCurrentPage]._DialogName == "StoryBook31"
	  )
	{
		//Log("******** harry - numBeans:"$baseHarry(Root.Console.viewport.actor).numBeans$" numCards:"$baseHarry(Root.Console.viewport.actor).getNumCards());
		if(   baseHarry(Root.Console.viewport.actor).numBeans < 250
	       || baseHarry(Root.Console.viewport.actor).getNumCards() < 24
	      )
		{
			SetStoryAndPage( iCurrentStory, iCurrentPage + 4 );
		}
		else
		{
			//All right, you have the last card, so add the card, and go to the next page.
			baseHarry(Root.Console.viewport.actor).addcard(100);
			SetStoryAndPage( iCurrentStory, iCurrentPage + 1 );
		}
	}
	else
	{
		SetStoryAndPage( iCurrentStory, iCurrentPage + 1 );
	}


}

//***************************************************************************************************************
function SetStoryAndPage(int story, int page)
{
	//local bool bRedraw;

	//bRedraw = (story != iCurrentStory  ||  page != iCurrentPage);

	//See if we're done with the story
	if( page >= NumStoryPages[iCurrentStory] )
	{
		root.console.Viewport.Actor.StopSound( , SLOT_Interact );
		baseHarry(Root.Console.viewport.actor).ClientSetMusic( none, 255, 255, MTRAN_Instant, false );

		//All right, for now, it's time for a hack.  If we just finished the credits, go back to the main menu, and turn off bGamePlaying.
		if( iCurrentStory == 16 )
		{
			FEBook(book).ChangePageNamed("MAIN");
			FEBook(book).bGamePlaying = false;
			FEBook(book).bCameFromStoryBook = false;
		}
		else //See if we're supposed to go back to the chapters page when we're done
		if( _bGoBackToChapterPage )
		{
			FEBook(book).ChangePageNamed("CHAPTER");
		}
		else
		{
			//Go back to main page
			FEBook(book).ChangePageNamed("MAIN");

			//Now, if _EventWhenDone is set, dont run the url, just fire off the trigger
			if( _EventWhenDone != '' )
			{
				FEBook(book).bCameFromStoryBook = false;
				FEBook(book).CloseBook();
				root.console.Viewport.Actor.TriggerEvent( _EventWhenDone, none, none );
			}
			else
			{
				//Run our map
				FEBook(book).RunURL( _URLToLoad, true );
			}
		}
	}
	else
	{
		//Not done, go to the requested page
		iCurrentStory = Clamp( story, 0, NUM_STORY_BOOKS - 1 );
		iCurrentPage  = Clamp(  page, 0, NumStoryPages[iCurrentStory] - 1 );

		Created();
	}
}

//***************************************************************************************************************
function Notify(UWindowDialogControl C, byte E)
{

	if(e==DE_Click)
	{
		switch(c)								
		{
			case NextPageButton:
				if( bAllowPageSkipping )
					KeyEvent( 0x20, 1, 0 ); //Send through a space bar press
				break;

			//case LoadGameButton:
			//	FEBook(book).ChangePageNamed("load");
			//	break;
			//case OptionsButton:
			//	break;
			//case CreditsButton:
			//	break;
			//case ExitButton:
			//	Root.DoQuitGame();
			//	break;
		}
	}
}

//***********************************************************************************************
function bool KeyEvent( byte/*EInputKey*/ Key, byte/*EInputAction*/ Action, FLOAT Delta )
{
	//All right, smeg all of this...
	//if(Action==1/*IST_Press*/ && Key==0x1b/*IK_Escape*/)
	//{
	//	//All right, go back to the menu, and let the menu know that it came from the StoryBook
	//	if( GetLevel().TimeSeconds - _TimeSecondsSave > _MinTimeOnPage )
	//	{
	//		//Welcome to hacksville, population me!
	//		FEBook(book).bCameFromStoryBook = true;
	//		root.console.Viewport.Actor.StopSound( , SLOT_Interact );
	//		FEBook(book).ChangePageNamed("REPORT");
	//	}
	//
	//	return true;
	//}
	//else
	//if(Action==1/*IST_Press*/ && Key==0x20/*IK_Space*/)
	//{
	//	if(   GetLevel().TimeSeconds - _TimeSecondsSave > _MinTimeOnPage
	//	   && iCurrentPage != 0 //dont allow skip past the first page.
	//	  )
	//	{
	//		//If we allow page skipping, go to the next page, otherwise use space to skip the whole story book.
	//		if( bAllowPageSkipping )
	//			GotoNextPage();
	//		else
	//			SetStoryAndPage( iCurrentStory, NumStoryPages[ iCurrentStory ] );
	//	}
	//	return true;
	//}

	if(Action==1/*IST_Press*/ && Key==0x1b/*IK_Escape*/)
	{
		//All right, go back to the menu, and let the menu know that it came from the StoryBook
//		if(   bAllowPageSkipping
//		   && GetLevel().TimeSeconds - _TimeSecondsSave > _MinTimeOnPage
//		   && iCurrentPage != 0 //dont allow skip past the first page.
//		  )
//		{
//			SetStoryAndPage( iCurrentStory, NumStoryPages[ iCurrentStory ] );
//		}
	
		return true;
	}
	else
	if(Action==1/*IST_Press*/ && Key==0x20/*IK_Space*/)
	{
		if(   bAllowPageSkipping
		   && GetLevel().TimeSeconds - _TimeSecondsSave > _MinTimeOnPage
		   && iCurrentPage != 0 //dont allow skip past the first page.
		  )
		{
			GotoNextPage();
		}

		return true;
	}
	else
	if(Action==1/*IST_Press*/ && Key==0x46/*IK_F*/)
	{
		if( bAllowPageSkipping )
		{
			_bDoFastPageSkipping = true;
			_PageTimer = 0.25;
		}

		return true;
	}

	return false;
}

//***************************************************************************************************************
function SetCreditsLines()
{
	//AddCreditsLine( "sdfsd" );
	//AddCreditsLine( "sdfsd 2" );

	AddCreditsLine( "Executive Producers" );
	AddCreditsLine( "Dan Elenbaas" );
	AddCreditsLine( "David Mann" );
	AddCreditsLine( "" );
	AddCreditsLine( "Producer" );
	AddCreditsLine( "Elizabeth Smith" );
	AddCreditsLine( "" );
	AddCreditsLine( "Creative Director" );
	AddCreditsLine( "Phil Trumbo" );
	AddCreditsLine( "" );
	AddCreditsLine( "Director of Design" );
	AddCreditsLine( "Kris Summers" );
	AddCreditsLine( "" );
	AddCreditsLine( "Director of QA" );
	AddCreditsLine( "Jack Brummet" );
	AddCreditsLine( "" );
	AddCreditsLine( "Lead Programmer" );
	AddCreditsLine( "Glen Kirk" );
	AddCreditsLine( "" );
	AddCreditsLine( "Lead Artist" );
	AddCreditsLine( "Christopher Vuchetich" );
	AddCreditsLine( "" );
	AddCreditsLine( "Composer" );
	AddCreditsLine( "Jeremy Soule" );
	AddCreditsLine( "" );
	AddCreditsLine( "Programming" );
	AddCreditsLine( "Chris Phillips" );
	AddCreditsLine( "David Lawson" );
	AddCreditsLine( "Fraser Thompson" );
	AddCreditsLine( "Paul Furio" );
	AddCreditsLine( "Peter Kolarov" );
	AddCreditsLine( "" );
	AddCreditsLine( "Art" );
	AddCreditsLine( "Sharon Plotkin" );
	AddCreditsLine( "Kerwin Burton" );
	AddCreditsLine( "Tiffany Vongerichten" );
	AddCreditsLine( "Bill Sears" );
	AddCreditsLine( "Eric Gingrich" );
	AddCreditsLine( "Lorian Kiesel" );
	AddCreditsLine( "" );
	AddCreditsLine( "Animation" );
	AddCreditsLine( "Nathan Hocken" );
	AddCreditsLine( "Laura Smith" );
	AddCreditsLine( "" );
	AddCreditsLine( "Design and Level Design" );
	AddCreditsLine( "Benjamin Golus" );
	AddCreditsLine( "Chad Verrall" );
	AddCreditsLine( "Jordan Thomas" );
	AddCreditsLine( "" );
	AddCreditsLine( "Sound Design" );
	AddCreditsLine( "Mark Yeend" );
	AddCreditsLine( "" );
	AddCreditsLine( "Production Manager" );
	AddCreditsLine( "Frank Peterson" );
	AddCreditsLine( "" );
	AddCreditsLine( "Art Coordinator" );
	AddCreditsLine( "Aspen Price" );
	AddCreditsLine( "" );
	AddCreditsLine( "Additional Art" );
	AddCreditsLine( "David Stevenson" );
	AddCreditsLine( "Forrest Keyes" );
	AddCreditsLine( "Jason Zayas" );
	AddCreditsLine( "Jeff Willis" );
	AddCreditsLine( "Bill Meyer" );
	AddCreditsLine( "Keith Himebaugh" );
	AddCreditsLine( "Les Betterley" );
	AddCreditsLine( "Lynne Startup" );
	AddCreditsLine( "Mike Ingrassia" );
	AddCreditsLine( "Mike Prittie" );
	AddCreditsLine( "Todd Lovering" );
	AddCreditsLine( "Tony Ravo" );
	AddCreditsLine( "" );
	AddCreditsLine( "QA Test Lead" );
	AddCreditsLine( "Cheryl Penick" );
	AddCreditsLine( "" );
	AddCreditsLine( "Testing" );
	AddCreditsLine( "Jason Bay" );
	AddCreditsLine( "" );
	AddCreditsLine( "Special Thanks" );
	AddCreditsLine( "Steve Ettinger" );
	AddCreditsLine( "Daryle Conners" );
	AddCreditsLine( "JC Connors" );
	AddCreditsLine( "Laurie Bauman" );
	AddCreditsLine( "Mike Dean" );
	AddCreditsLine( "Stephanie Hertager" );
	AddCreditsLine( "Susan DeMerit" );
	AddCreditsLine( "Aaron Rice" );
	AddCreditsLine( "Kevin Burdick" );
	AddCreditsLine( "Curtis Asplund" );

}

//***************************************************************************************************************

defaultproperties
{
     NumStoryPages(0)=2
     NumStoryPages(1)=1
     NumStoryPages(2)=1
     NumStoryPages(3)=14
     NumStoryPages(4)=8
     NumStoryPages(5)=6
     NumStoryPages(6)=13
     NumStoryPages(9)=1
     NumStoryPages(13)=8
     NumStoryPages(14)=1
     NumStoryPages(15)=1
     NumStoryPages(16)=1
     BookPages0(0)=(_GraphicName="CommonRoom",_DialogName="storybook_new_7")
     BookPages0(1)=(_GraphicName="CommonRoom",_DialogName="storybook_new_8")
     BookPages1(0)=(_GraphicName="HarryGetsBroom",_DialogName="storybook_new_4")
     BookPages2(0)=(_GraphicName="HarryStudy",_DialogName="storybook_new_3")
     BookPages3(0)=(_GraphicName="3_1_",_DialogName="StoryBook1")
     BookPages3(1)=(_GraphicName="3_2_",_DialogName="StoryBook2")
     BookPages3(2)=(_GraphicName="3_3_",_DialogName="StoryBook3")
     BookPages3(3)=(_GraphicName="3_3_",_DialogName="StoryBook52")
     BookPages3(4)=(_GraphicName="3_4_",_DialogName="StoryBook4")
     BookPages3(5)=(_GraphicName="3_5_",_DialogName="StoryBook5")
     BookPages3(6)=(_GraphicName="3_5_",_DialogName="storybook_new_20")
     BookPages3(7)=(_GraphicName="3_6_",_DialogName="storybook50")
     BookPages3(8)=(_GraphicName="6_6_",_DialogName="storybook_new_21")
     BookPages3(9)=(_GraphicName="3_7_",_DialogName="StoryBook7")
     BookPages3(10)=(_GraphicName="3_7_",_DialogName="StoryBook53")
     BookPages3(11)=(_GraphicName="3_7_",_DialogName="StoryBook54")
     BookPages3(12)=(_GraphicName="3_7_",_DialogName="StoryBook55")
     BookPages3(13)=(_GraphicName="3_7_",_DialogName="StoryBook49")
     BookPages4(0)=(_GraphicName="4_1_",_DialogName="StoryBook9")
     BookPages4(1)=(_GraphicName="4_1_",_DialogName="StoryBook10")
     BookPages4(2)=(_GraphicName="4_2_",_DialogName="StoryBook11")
     BookPages4(3)=(_GraphicName="4_2_",_DialogName="StoryBook12")
     BookPages4(4)=(_GraphicName="4_1_",_DialogName="StoryBook13")
     BookPages4(5)=(_GraphicName="4_1_",_DialogName="StoryBook14")
     BookPages4(6)=(_GraphicName="4_2_",_DialogName="StoryBook15")
     BookPages4(7)=(_GraphicName="4_2_",_DialogName="StoryBook16")
     BookPages5(0)=(_GraphicName="QuidditchVictory",_DialogName="storybook_new_6")
     BookPages5(1)=(_GraphicName="HermioneLibrary",_DialogName="storybook_new_9")
     BookPages5(2)=(_GraphicName="HarryGetsCloak",_DialogName="storybook_new_4")
     BookPages5(3)=(_GraphicName="5_1_",_DialogName="StoryBook17")
     BookPages5(4)=(_GraphicName="5_1_",_DialogName="StoryBook18")
     BookPages5(5)=(_GraphicName="HarryStudy",_DialogName="storybook_new_1")
     BookPages6(0)=(_GraphicName="6_1_",_DialogName="StoryBook29")
     BookPages6(1)=(_GraphicName="6_1_",_DialogName="StoryBook30")
     BookPages6(2)=(_GraphicName="6_1_",_DialogName="StoryBook31")
     BookPages6(3)=(_GraphicName="6_2_",_DialogName="StoryBook44")
     BookPages6(4)=(_GraphicName="6_3_",_DialogName="StoryBook45")
     BookPages6(5)=(_GraphicName="6_4_",_DialogName="StoryBook46")
     BookPages6(6)=(_GraphicName="6_5_",_DialogName="StoryBook34")
     BookPages6(7)=(_GraphicName="6_5_",_DialogName="StoryBook35")
     BookPages6(8)=(_GraphicName="6_6_",_DialogName="StoryBook37")
     BookPages6(9)=(_GraphicName="8_0_",_DialogName="StoryBook38")
     BookPages6(10)=(_GraphicName="6_6_",_DialogName="StoryBook39")
     BookPages6(11)=(_GraphicName="6_7_",_DialogName="StoryBook40")
     BookPages6(12)=(_GraphicName="6_8_",_DialogName="StoryBook41")
     BookPages9(0)=(_GraphicName="QuidditchVictory",_DialogName="storybook_new_5")
     BookPages13(0)=(_GraphicName="5_3_",_DialogName="StoryBook21")
     BookPages13(1)=(_GraphicName="5_4_",_DialogName="StoryBook23")
     BookPages13(2)=(_GraphicName="5_5_",_DialogName="storybook_new_10")
     BookPages13(3)=(_GraphicName="5_5_",_DialogName="storybook_new_11")
     BookPages13(4)=(_GraphicName="5_6_",_DialogName="StoryBook24")
     BookPages13(5)=(_GraphicName="5_6_",_DialogName="StoryBook25")
     BookPages13(6)=(_GraphicName="5_6_",_DialogName="StoryBook26")
     BookPages13(7)=(_GraphicName="5_6_",_DialogName="StoryBook28")
     BookPages14(0)=(_GraphicName="CommonRoom",_DialogName="storybook_new_2")
     BookPages15(0)=(_GraphicName="5_2_",_DialogName="StoryBook20")
     BookPages16(0)=(_GraphicName="TempCredits0_")
     _MinTimeOnPage=2
     cdt_StringMatchArray(0)="Executive Producers"
     cdt_StringMatchArray(1)="Producer"
     cdt_StringMatchArray(2)="Creative Director"
     cdt_StringMatchArray(3)="Director of Design"
     cdt_StringMatchArray(4)="Director of QA"
     cdt_StringMatchArray(5)="Lead Programmer"
     cdt_StringMatchArray(6)="Lead Artist"
     cdt_StringMatchArray(7)="Composer"
     cdt_StringMatchArray(8)="Programming"
     cdt_StringMatchArray(9)="Art"
     cdt_StringMatchArray(10)="Animation"
     cdt_StringMatchArray(11)="Design and Level Design"
     cdt_StringMatchArray(12)="Sound Design"
     cdt_StringMatchArray(13)="Production Manager"
     cdt_StringMatchArray(14)="Art Coordinator"
     cdt_StringMatchArray(15)="Additional Art"
     cdt_StringMatchArray(16)="QA Test Lead"
     cdt_StringMatchArray(17)="Testing"
     cdt_StringMatchArray(18)="Special Thanks"
     cdt_0="Executive Producers"
     cdt_1="Producer"
     cdt_2="Creative Director"
     cdt_3="Director of Design"
     cdt_4="Director of QA"
     cdt_5="Lead Programmer"
     cdt_6="Lead Artist"
     cdt_7="Composer"
     cdt_8="Programming"
     cdt_9="Art"
     cdt_10="Animation"
     cdt_11="Design and Level Design"
     cdt_12="Sound Design"
     cdt_13="Production Manager"
     cdt_14="Art Coordinator"
     cdt_15="Additional Art"
     cdt_16="QA Test Lead"
     cdt_17="Testing"
     cdt_18="Special Thanks"
}
