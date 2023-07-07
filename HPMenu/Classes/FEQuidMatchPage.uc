class FEQuidMatchPage expands baseFEPage;

#EXEC TEXTURE IMPORT NAME=FEQuidBackTexture1	 FILE=TEXTURES\FE\QuidBack1.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEQuidBackTexture2	 FILE=TEXTURES\FE\QuidBack2.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEQuidBackTexture3	 FILE=TEXTURES\FE\QuidBack3.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEQuidBackTexture4	 FILE=TEXTURES\FE\QuidBack4.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEQuidBackTexture5	 FILE=TEXTURES\FE\QuidBack5.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEQuidBackTexture6	 FILE=TEXTURES\FE\QuidBack6.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=FELeftArrowUpIcon		FILE=TEXTURES\Arrows\leftarrowup.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FELeftArrowOverIcon	FILE=TEXTURES\Arrows\leftarrowover.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FERightArrowUpIcon	FILE=TEXTURES\Arrows\rightarrowup.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FERightArrowOverIcon	FILE=TEXTURES\Arrows\rightarrowover.bmp GROUP="Icons" FLAGS=2 MIPS=OFF


#EXEC TEXTURE IMPORT NAME=FEGrifLogoMed	 FILE=TEXTURES\FE\griffendorMed.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEHuffLogoMed	 FILE=TEXTURES\FE\hufflepuffMed.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FESlytLogoMed	 FILE=TEXTURES\FE\slytherinMed.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FERaveLogoMed	 FILE=TEXTURES\FE\ravenclawMed.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=FEGrifLogoSmall	 FILE=TEXTURES\FE\griffendorSmall.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEHuffLogoSmall	 FILE=TEXTURES\FE\hufflepuffSmall.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FESlytLogoSmall	 FILE=TEXTURES\FE\slytherinSmall.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FERaveLogoSmall	 FILE=TEXTURES\FE\ravenclawSmall.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=FEGrifLogoTiny	 FILE=TEXTURES\FE\griffendorTiny.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEHuffLogoTiny	 FILE=TEXTURES\FE\hufflepuffTiny.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FESlytLogoTiny	 FILE=TEXTURES\FE\slytherinTiny.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FERaveLogoTiny	 FILE=TEXTURES\FE\ravenclawTiny.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=FEVSTexture	 FILE=TEXTURES\FE\vs.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FESmallVSTexture	 FILE=TEXTURES\FE\vsSmall.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=BroomstickPracticeTexture	 FILE=TEXTURES\FE\broompracticebutton.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=QuidLeagueTexture	 FILE=TEXTURES\FE\quidditchleaugebutton.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=BroomstickPracticeLockedTexture	 FILE=TEXTURES\FE\broompracticebuttonGrey.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=QuidLeagueLockedTexture	 FILE=TEXTURES\FE\quidditchleaugebuttonGrey.bmp GROUP="Icons" FLAGS=2 MIPS=OFF


var UWindowButton ForwardButton;
var UWindowButton BackButton;
var UWindowButton StartPracticeButton;
var UWindowButton StartMatchButton;

var UWindowButton PageTitle;


var UWindowWrappedTextArea StartTextWindow;


var string curScreen;

var globalconfig int unlocked;
var bool bFakeGames;	//for debugging.

struct QuidTeam
{
	var string TeamName;
	var Texture MedLogo;
	var Texture SmallLogo;
	var Texture TinyLogo;
	var int nWins,nLoses;
	var int nTotalPoints;
};
var QuidTeam teams[4];
var int nTeams;
var int teamStandings[4];

struct QuidGameInfo
{
	var bool bPlayed;
	var int home,visitor;
	var int otherHome,otherVisitor;		//off screen teams.
	var string level;
	var int HomeScore,VisitorScore;		//filled in after play.
	var int otherHomeScore,otherVisitorScore;		//faked up after play.
};
var QuidGameInfo games[16];
var int nCurGame;
var int nGames;
var bool bFinals;

var string FinalLevelNames[4];

var bool bSortError;		//for debugging.
var HPMessageBox ConfirmQuit;
var string WString,LString,PtsString;



function UnlockQuidditch(string name)
{
local Texture tempTexture;

	switch(caps(name))
		{
		case "BROOM":
			unlocked=1;
			break;
		case "LEAGUE":
			unlocked=2;
			break;
		}
	SaveConfig();

		//set the correct button bitmaps
	if(unlocked>0)
		tempTexture=Texture'BroomstickPracticeTexture';
	else
		tempTexture=Texture'BroomstickPracticeLockedTexture';
	StartPracticeButton.UpTexture=tempTexture;
	StartPracticeButton.DownTexture=tempTexture;
	StartPracticeButton.OverTexture=tempTexture;

	if(unlocked>1)
		tempTexture=Texture'QuidLeagueTexture';
	else
		tempTexture=Texture'QuidLeagueLockedTexture';
//	tempTexture=Texture'QuidLeagueTexture';
	StartMatchButton.UpTexture=tempTexture;
	StartMatchButton.DownTexture=tempTexture;
	StartMatchButton.OverTexture=tempTexture;

}

function Created()
{
local int i;
local Texture tempTexture;
local float x,y;
local float w,h;

	Super.Created(); 

	ForwardButton = UWindowButton(CreateWindow(class'UWindowButton',
		 WinWidth-68,WinHeight-44,64,40));

	ForwardButton.Register(self);
	ForwardButton.UpTexture=Texture'FERightArrowUpIcon';
	ForwardButton.DownTexture=Texture'FERightArrowOverIcon';
	ForwardButton.OverTexture=Texture'FERightArrowOverIcon';


	BackButton = UWindowButton(CreateWindow(class'UWindowButton',
		 4,WinHeight-44,64,40));

	BackButton.Register(self);
	BackButton.UpTexture=Texture'FELeftArrowUpIcon';
	BackButton.DownTexture=Texture'FELeftArrowOverIcon';
	BackButton.OverTexture=Texture'FELeftArrowOverIcon';


	StartTextWindow = UWindowWrappedTextArea( CreateControl(class'UWindowWrappedTextArea', 320-200, 240-110, 400, 300) );
	StartTextWindow.Clear();
	StartTextWindow.Font = 2;

		//need to add in reverse order. shrug
//	StartTextWindow.addText("After playing your six matches, the two teams with the most wins will play against each other in the Final. The winner of the Final will be crowned Quidditch Champions. Good luck, Harry! And may the best team win.");
//	StartTextWindow.addText("Welcome to the Secret Hogwarts Quidditch league! Here are the rules. You must play each of the different Hogwarts house teams twice. In each match the team to catch the Snitch wins.");
	StartTextWindow.addText(GetLocalizedString("Quidditch_08"));	//"Welcome to the Secret Hogwarts Quidditch league! Here are the rules. You must play each of the different Hogwarts house teams twice. In each match the team to catch the Snitch wins.");


	x=320-128;
	y=240-80;
	if(unlocked>0)
		tempTexture=Texture'BroomstickPracticeTexture';
	else
		tempTexture=Texture'BroomstickPracticeLockedTexture';

	StartPracticeButton = UWindowButton(CreateControl(class'UWindowButton',x-(tempTexture.USize/2),y,tempTexture.USize,tempTexture.VSize));
	StartPracticeButton.setFont(F_HPMenuLarge);
	StartPracticeButton.TextColor.r=200;
	StartPracticeButton.TextColor.g=200;
	StartPracticeButton.TextColor.b=200;
	StartPracticeButton.Align=TA_Center;
//	StartPracticeButton.setText("Broomstick Practice");
	StartPracticeButton.UpTexture=tempTexture;
	StartPracticeButton.DownTexture=tempTexture;
	StartPracticeButton.OverTexture=tempTexture;
//	StartPracticeButton.ToolTipString="Practice flying your broomstick";


	x=320+128;
	if(unlocked>1)
		tempTexture=Texture'QuidLeagueTexture';
	else
		tempTexture=Texture'QuidLeagueLockedTexture';
	StartMatchButton = UWindowButton(CreateControl(class'UWindowButton',x-(tempTexture.USize/2),y,tempTexture.USize,tempTexture.VSize));
	StartMatchButton.setFont(F_HPMenuLarge);
	StartMatchButton.TextColor.r=200;
	StartMatchButton.TextColor.g=200;
	StartMatchButton.TextColor.b=200;
	StartMatchButton.Align=TA_Center;
//	StartMatchButton.setText("Quidditch Match");
	StartMatchButton.UpTexture=tempTexture;
	StartMatchButton.DownTexture=tempTexture;
	StartMatchButton.OverTexture=tempTexture;
//	StartPracticeButton.ToolTipString="Play in Quidditch league";

	PageTitle = UWindowButton(CreateControl(class'UWindowButton',320-100,85,200,25));
	PageTitle.setFont(F_HPMenuLarge);
	PageTitle.TextColor.r=255;
	PageTitle.TextColor.g=255;
	PageTitle.TextColor.b=255;
	PageTitle.Align=TA_Center;
	PageTitle.setText("XXXXXX");

	WString=GetLocalizedString("quidditch_11");
	LString=GetLocalizedString("quidditch_12");
	PtsString=GetLocalizedString("quidditch_13");
	

	SetCurScreen("START");

}

	//revisit:This is a dup of the one in FEBook. Make this generaly avail somewhere.
function ScaleAndDraw(Canvas canvas,float x,float y,Texture tex,optional bool bCenter)
{
local float fx,fy;

	fx=(canvas.SizeX/640.0);
	fy=(canvas.SizeY/480.0);
fx=1;fy=1;
	if(bCenter)
		{
		x=x-(tex.USize/2);
		y=y-(tex.VSize/2);
		}

	DrawStretchedTexture( canvas, x*fx, y*fy, tex.USize*fx,tex.VSize*fy,tex);

}
function PreSwitchPage()
{
	if(unlocked>0)
		StartPracticeButton.ShowWindow();

	if(unlocked>1)
		StartMatchButton.ShowWindow();

		//make sure we start on the "Start" page.
	SetCurScreen("START");
}
function drawFinalResults(Canvas canvas)
{
local float w,h;
local int i;
local string tmpStr;


/*	Canvas.Font=Font'HPBase.InkFont';
	TextSize(canvas,"Final Results", w, h);
	Root.SetPosScaled(canvas,320-(w/2),240-150);
	Canvas.DrawText("Final Results");
*/
	if(games[nCurGame].homeScore>games[nCurGame].visitorScore)
		{
		ScaleAndDraw(canvas,320,260-85,teams[games[nCurGame].home].MedLogo,true);
		}
	else
		ScaleAndDraw(canvas,320,260-85,teams[games[nCurGame].visitor].MedLogo,true);

	tmpStr=GetLocalizedString("quidditch_16");		//champion
	TextSize(canvas,tmpStr, w, h);
	Root.SetPosScaled(canvas,320-(w/2),240);
	Canvas.DrawText(tmpStr);

//	drawTotals(canvas);

}

function drawResults(Canvas canvas)
{
local float w,h;
local int i;

/*	Canvas.Font=Font'HPBase.InkFont';
	TextSize(canvas,"Round X Results", w, h);
	Root.SetPosScaled(canvas,320-(w/2),240-150);
	Canvas.DrawText("Round "$nCurGame $" Results");
*/
	ScaleAndDraw(canvas,320-128,260-120,teams[games[nCurGame-1].home].SmallLogo,true);
	Root.SetPosScaled(canvas,320-74,260-120);
	Canvas.DrawText(games[nCurGame-1].homeScore);

	ScaleAndDraw(canvas,320+128,260-120,teams[games[nCurGame-1].visitor].SmallLogo,true);
	Root.SetPosScaled(canvas,320+74,260-120);
	Canvas.DrawText(games[nCurGame-1].visitorScore);

	ScaleAndDraw(canvas,320-128,260-60, teams[games[nCurGame-1].otherHome].SmallLogo,true);
	Root.SetPosScaled(canvas,320-74,260-60);
	Canvas.DrawText(games[nCurGame-1].otherHomeScore);

	ScaleAndDraw(canvas,320+128,260-60, teams[games[nCurGame-1].otherVisitor].SmallLogo,true);
	Root.SetPosScaled(canvas,320+74,260-60);
	Canvas.DrawText(games[nCurGame-1].otherVisitorScore);


	ScaleAndDraw(canvas,320,260-120,Texture'FESmallVSTexture',true);
	ScaleAndDraw(canvas,320,260-60,Texture'FESmallVSTexture',true);
	
	drawTotals(canvas);

}
function SortTeams()
{
local int t,o;
local int pos;

		//for debugging
	teamStandings[0]=99;
	teamStandings[1]=99;
	teamStandings[2]=99;
	teamStandings[3]=99;
		//for debugging

	for(t=0;t<nTeams;t++)
		{
		pos=0;
		for(o=0;o<nTeams;o++)
			{
			if(o==t)
				continue;
			if(teams[t].nWins<teams[o].nWins)
				pos++; 
			else if	(teams[t].nWins==teams[o].nWins)		//win tie
				{
				if(teams[t].nTotalPoints<teams[o].nTotalPoints)	//compart total points
					pos++;
				else if(teams[t].nTotalPoints==teams[o].nTotalPoints)	//total point tie. Hopefully rare!
					{
					//pos++;
					teams[t].nTotalPoints+=10;		//Fake it. Kludge! Hope this works... :)
					}
				}	
			}

			//for debugging
		if(teamStandings[pos]!=99)
			bSortError=true;			
			//for debugging

		teamStandings[pos]=t;
		}
}

function drawTotals(Canvas canvas)
{
local float w,h;
local int i;

	SortTeams();

	TextSize(canvas,"___________________________________", w, h);
	Root.SetPosScaled(canvas,320-(w/2),248);
	Canvas.DrawText("___________________________________");

	if(bSortError)
		Canvas.DrawText("SORT ERROR!!!");

//	Root.SetPosScaled(canvas,370,245);
//	Canvas.DrawText("W     L     Pts");

	Root.SetPosScaled(canvas,370,245);
	Canvas.DrawText(WString);

	Root.SetPosScaled(canvas,410,245);
	Canvas.DrawText(LString);

	Root.SetPosScaled(canvas,450,245);
	Canvas.DrawText(PtsString);

	for(i=0;i<nTeams;i++)
		{
		ScaleAndDraw(canvas,320-128,285+(i*35),teams[teamStandings[i]].TinyLogo,true);
//		Root.SetPosScaled(canvas,370,270+(i*35));
//		Canvas.DrawText(teams[teamStandings[i]].nWins $"      " $teams[teamStandings[i]].nLoses $"      " $teams[teamStandings[i]].nTotalPoints);

		Root.SetPosScaled(canvas,370,270+(i*35));
		Canvas.DrawText(teams[teamStandings[i]].nWins);

		Root.SetPosScaled(canvas,410,270+(i*35));
		Canvas.DrawText(teams[teamStandings[i]].nLoses);

		Root.SetPosScaled(canvas,450,270+(i*35));
		Canvas.DrawText(teams[teamStandings[i]].nTotalPoints);
		}
}


function DrawMatchup(Canvas canvas)
{
local float w,h;

	ScaleAndDraw(canvas,320-128,260-75,teams[games[nCurGame].home].MedLogo,true);
	ScaleAndDraw(canvas,320+128,260-75,teams[games[nCurGame].visitor].MedLogo,true);
	ScaleAndDraw(canvas,320,260-75,Texture'FEVSTexture',true);

	if(!bFinals)
		{
		ScaleAndDraw(canvas,320-128,260+75,teams[games[nCurGame].otherHome].MedLogo,true);
		ScaleAndDraw(canvas,320+128,260+75,teams[games[nCurGame].otherVisitor].MedLogo,true);
		ScaleAndDraw(canvas,320,260+75,Texture'FEVSTexture',true);
		}


}
function DrawStart(Canvas canvas)
{
local float w,h;
local bool saveState;
local string tmpStr;
	

	saveState=Canvas.bCenter;

//	Canvas.Font=Font'HPBase.InkFont';
//	Canvas.bCenter=true;

	tmpStr=GetLocalizedString("quidditch_02");	//broomstick practice.

	TextSize(canvas,tmpStr, w, h);
	Root.SetPosScaled(canvas, ((320-128)-(w/2)),(240+50));
	Canvas.DrawText(tmpStr);

	tmpStr=GetLocalizedString("quidditch_03");	//quidditch match
	TextSize(canvas,tmpStr, w, h);
	Root.SetPosScaled(canvas, ((320+128)-(w/2)),(240+50));
	Canvas.DrawText(tmpStr);

	Canvas.bCenter=saveState;

	
}
function DrawInstructions(Canvas canvas)
{
local float w,h;
	
	
}


function Paint(Canvas canvas,float x,float y)
{

	ScaleAndDraw(canvas,0,0,Texture'FEQuidBackTexture1');
	ScaleAndDraw(canvas,256,0,Texture'FEQuidBackTexture2');
	ScaleAndDraw(canvas,512,0,Texture'FEQuidBackTexture3');
	
	ScaleAndDraw(canvas,0,256,Texture'FEQuidBackTexture4');
	ScaleAndDraw(canvas,256,256,Texture'FEQuidBackTexture5');
	ScaleAndDraw(canvas,512,256,Texture'FEQuidBackTexture6');

	switch(caps(curScreen))
		{
		case "START":
			drawStart(canvas);
			break;
		case "INSTRUCTIONS":
			drawInstructions(canvas);
			break;
		case "MATCHUP":
			drawMatchup(canvas);
			break;
		case "RESULTS":
			drawResults(canvas);
			break;
		case "FINALRESULTS":
			drawFinalResults(canvas);
			break;
		}

	super.Paint(canvas, x, y);
	
}

function string InsertNumber(string str,int value)
{
local string tmp;
local int off;

	off=instr(str,"#");
	if(off<0)	//no # found.
		return(str);

	return(left(str,off) $value $right(str,(len(str)-off)-1));
}

function SetCurScreen(string screenName)
{
	
	curScreen=screenName;
	switch(caps(screenName))
		{
		case "START":
			ForwardButton.hideWindow();
			BackButton.showWindow();

			StartPracticeButton.showWindow();
			StartMatchButton.showWindow();
								
			StartTextWindow.hideWindow();
			PageTitle.setText("");

			break;
		case "INSTRUCTIONS":
			ForwardButton.showWindow();
			BackButton.showWindow();

			StartPracticeButton.hideWindow();
			StartMatchButton.hideWindow();
								
			StartTextWindow.showWindow();
			PageTitle.setText(GetLocalizedString("Quidditch_07"));
	
			break;
		case "MATCHUP":
			ForwardButton.showWindow();
			BackButton.showWindow();

			StartPracticeButton.hideWindow();
			StartMatchButton.hideWindow();
								
			StartTextWindow.hideWindow();
			if(!bFinals)
				{	//round #
				PageTitle.setText(InsertNumber(GetLocalizedString("Quidditch_09"),nCurGame+1));
				}
			else
				{	//finals
				PageTitle.setText(GetLocalizedString("Quidditch_14"));
				}

			break;
		case "FINALRESULTS":
		case "RESULTS":
			if(!bFinals)
				{	//round # results
				PageTitle.setText(InsertNumber(GetLocalizedString("Quidditch_10"),nCurGame));
//				PageTitle.setText(GetLocalizedString("Quidditch_10") $" " $(nCurGame+1));
				}
			else
				{	//finals
				PageTitle.setText(GetLocalizedString("Quidditch_15"));
				}
			ForwardButton.showWindow();
			BackButton.hideWindow();

			StartPracticeButton.hideWindow();
			StartMatchButton.hideWindow();
								
			StartTextWindow.hideWindow();
			break;
		}
}
function handleForward()
{
	switch(caps(curScreen))
		{
		case "START":
			break;
		case "INSTRUCTIONS":
			SetCurScreen("MATCHUP");
			break;
		case "MATCHUP":
			StartGame();
			break;
		case "RESULTS":
			SetCurScreen("MATCHUP");
			break;
		case "FINALRESULTS":
			SetCurScreen("START");
			break;

		}
}
function handleBackward()
{
	switch(caps(curScreen))
		{
		case "START":
			FEBook(book).ChangePageNamed("main");
			break;
		case "INSTRUCTIONS":
			SetCurScreen("START");
			break;
		case "MATCHUP":
			 // AMM
			 if( nCurGame == 0 )
			 {
				  SetCurScreen("START");
			 }
			 else
			 {
				  SetCurScreen("RESULTS");
			 }
			 break;
		case "RESULTS":
			break;
		}
}

//**************************************************************************
// AMM
function bool KeyEvent( byte/*EInputKey*/ Key, byte/*EInputAction*/ Action, FLOAT Delta )
{
	if(Action==1/*IST_Press*/ && Key==0x1b/*IK_Escape*/ )
	{
//		FEBook(book).ChangePageNamed("MAIN");

		ConfirmQuit = doHPMessageBox(
			//	GetLocalizedString("report_buttons_04"), //Quit Game;
				GetLocalizedString("report_buttons_05"), //"Are you sure you want to quit this game?"
				GetLocalizedString("main_menu_09"),// "Yes"
				GetLocalizedString("main_menu_10") //"No"
				);

		return true;
	}

	return false;
}

function WindowDone(UWindowWindow W)
{
	if(W == ConfirmQuit)
		{
		if(ConfirmQuit.Result == ConfirmQuit.button1.text)
			{
			FEBook(book).ChangePageNamed("MAIN");
			}
		ConfirmQuit = None;
		}
}
function Notify(UWindowDialogControl C, byte E)
{
	if(e==DE_Click)
		{
		switch(c)								
			{
			case ForwardButton:
				handleForward();
				break;
			case BackButton:
				handleBackward();
				break;

			case StartPracticeButton:
				if(unlocked>0)
				{
					FEBook(book).bPlayingQuidditch = True;
					FEBook(book).RunURL( "Lev_Tut2.unr", false );
				}
				break;

			case StartMatchButton:
				if(unlocked>1)
					{
					NewMatch();
					SetCurScreen("INSTRUCTIONS");
					}
				break;

			}
		}
}

function NewMatch()
{
local int i;

	bFinals=false;
	nCurGame=0;
	for(i=0;i<nGames;i++)
		{
		games[i].bPlayed=false;
		games[i].HomeScore=0;
		games[i].VisitorScore=0;
		}
	for(i=0;i<nTeams;i++)
		{
		teams[i].nWins=0;
		teams[i].nLoses=0;
		teams[i].nTotalPoints=0;
		}
}

function StartGame()
{

	if(bFakeGames)	//for debugging
		{		
		FinishGame(0,0);
		return;
		}

	if ( games[nCurGame].level != "" )
		{
		FEBook(book).bPlayingQuidditch = True;
		FEBook(book).RunURL( games[nCurGame].level, false );
		FEBook(book).CloseBook();
		}
	else
		FinishGame( 0, 0 );	// Griffindore didn't play game
}

function bool DoesTeam0WinLeagueWithThisScore( int Team0Score, int OpponentScore )
{
	// Call before calling FinishGame to determine if Team0 wins the league
	// with the given scores from the pending game.  Must pass same scores
	// to finish game when ready.
	local bool	bWonLeague;

	if ( bFinals )
	{
		if ( Games[ nCurGame ].Home == 0 )
		{
			bWonLeague = ( Games[ nCurGame ].HomeScore    + Team0Score )
					   > ( Games[ nCurGame ].VisitorScore + OpponentScore );
		}
		else
		{
			bWonLeague = ( Games[ nCurGame ].VisitorScore + Team0Score )
					   > ( Games[ nCurGame ].HomeScore    + OpponentScore );
		}
	}
	else
		bWonLeague = false;

	return bWonLeague;
}

function FinishGame( int Team0Score, int OpponentScore )
{
local int oh,ov;
local bool bTeam0Played;

	FEBook(book).bPlayingQuidditch = False;
	bTeam0Played = games[nCurGame].home == 0 || games[nCurGame].visitor == 0;

	if ( bTeam0Played )
		{
		if ( games[nCurGame].home == 0 )	// If team 0 was home team
			{
			games[nCurGame].HomeScore=Team0Score;
			games[nCurGame].VisitorScore=OpponentScore;
			}
		else
			{
			games[nCurGame].HomeScore=OpponentScore;
			games[nCurGame].VisitorScore=Team0Score;
			}

		if ( games[nCurGame].HomeScore > games[nCurGame].VisitorScore )
			{
			teams[games[nCurGame].home].nWins++;
			teams[games[nCurGame].visitor].nLoses++;

			}
		else
			{
			teams[games[nCurGame].visitor].nWins++;
			teams[games[nCurGame].home].nLoses++;
			}
		teams[games[nCurGame].home].nTotalPoints+=games[nCurGame].HomeScore;
		teams[games[nCurGame].visitor].nTotalPoints+=games[nCurGame].VisitorScore;
		}

		//fake the results of the off screen game
	if ( !bFinals || !bTeam0Played )
		{
		games[nCurGame].OtherHomeScore=(6+rand(8))*10;
		games[nCurGame].OtherVisitorScore=(6+rand(8))*10;

		//handle tie
		if(games[nCurGame].OtherHomeScore==games[nCurGame].OtherVisitorScore)
			games[nCurGame].OtherHomeScore+=10;
	
		if(games[nCurGame].OtherHomeScore>games[nCurGame].OtherVisitorScore)
			{
			games[nCurGame].OtherHomeScore+=150;
			teams[games[nCurGame].otherHome].nWins++;
			teams[games[nCurGame].otherVisitor].nLoses++;
			}
		else
			{
			games[nCurGame].OtherVisitorScore+=150;
			teams[games[nCurGame].otherVisitor].nWins++;
			teams[games[nCurGame].otherHome].nLoses++;
			}
		teams[games[nCurGame].otherHome].nTotalPoints+=games[nCurGame].OtherHomeScore;
		teams[games[nCurGame].otherVisitor].nTotalPoints+=games[nCurGame].OtherVisitorScore;
		}



		//Time for finals?
	if(!bFinals)
		{
		nCurGame++;
		if(nCurGame==nGames)
			{
				//its finals time!
			bFinals=true;
			SortTeams();
			games[nCurGame].home=teamStandings[0];
			games[nCurGame].visitor=teamStandings[1];

			if(teamStandings[0]==0)	//Is Griff home team for the finals?
				games[nCurGame].level=FinalLevelNames[teamStandings[1]];
			else if(teamStandings[1]==0)	//Is Griff away team for the finals?
				games[nCurGame].level=FinalLevelNames[teamStandings[0]];
			else
				{
				games[nCurGame].level="";	//Griff didnt make the finals.
				games[nCurGame].otherHome = games[nCurGame].home;
				games[nCurGame].otherVisitor = games[nCurGame].visitor;
				}

			}
		SetCurScreen("RESULTS");
		}
	else
		SetCurScreen("FINALRESULTS");

		//Make sure book is open and on QuidMatch page.
	hpconsole(root.console).MenuBook.OpenBook("QUIDMATCH");

}

defaultproperties
{
     teams(0)=(TeamName="Griffindor",MedLogo=Texture'HPMenu.Icons.FEGrifLogoMed',SmallLogo=Texture'HPMenu.Icons.FEGrifLogoSmall',TinyLogo=Texture'HPMenu.Icons.FEGrifLogoTiny')
     teams(1)=(TeamName="Ravenclaw",MedLogo=Texture'HPMenu.Icons.FERaveLogoMed',SmallLogo=Texture'HPMenu.Icons.FERaveLogoSmall',TinyLogo=Texture'HPMenu.Icons.FERaveLogoTiny')
     teams(2)=(TeamName="Hufflepuff",MedLogo=Texture'HPMenu.Icons.FEHuffLogoMed',SmallLogo=Texture'HPMenu.Icons.FEHuffLogoSmall',TinyLogo=Texture'HPMenu.Icons.FEHuffLogoTiny')
     teams(3)=(TeamName="Slytherin",MedLogo=Texture'HPMenu.Icons.FESlytLogoMed',SmallLogo=Texture'HPMenu.Icons.FESlytLogoSmall',TinyLogo=Texture'HPMenu.Icons.FESlytLogoTiny')
     nTeams=4
     games(0)=(visitor=3,otherHome=1,otherVisitor=2,Level="Quid_SlythA.unr")
     games(1)=(visitor=1,otherHome=2,otherVisitor=3,Level="Quid_RavenA.unr")
     games(2)=(visitor=2,otherHome=1,otherVisitor=3,Level="Quid_HuffleA.unr")
     games(3)=(home=3,otherHome=2,otherVisitor=1,Level="Quid_SlythB.unr")
     games(4)=(home=1,otherHome=3,otherVisitor=2,Level="Quid_RavenB.unr")
     games(5)=(home=2,otherHome=3,otherVisitor=1,Level="Quid_HuffleB.unr")
     nGames=6
     FinalLevelNames(1)="Quid_RavenC.unr"
     FinalLevelNames(2)="Quid_HuffleC.unr"
     FinalLevelNames(3)="Quid_SlythC.unr"
}
