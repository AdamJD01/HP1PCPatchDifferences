//=============================================================================
// FEReportPage - Report Card for book
//=============================================================================
class FEReportPage extends baseFEPage;

#EXEC TEXTURE IMPORT NAME=BookReportGreenSand	FILE=TEXTURES\FE\Report\greensand.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=BookReportBlueSand	FILE=TEXTURES\FE\Report\bluesand.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=BookReportPurpleSand	FILE=TEXTURES\FE\Report\purplesand.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=BookReportRedSand		FILE=TEXTURES\FE\Report\redsand.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=BookReportYellowSand	FILE=TEXTURES\FE\Report\yellowsand.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=BeanBadgeTexture		FILE=TEXTURES\FE\Report\beans.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=PointBadgeTexture		FILE=TEXTURES\FE\Report\harrypoints.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=CardBadgeTexture		FILE=TEXTURES\FE\Report\wizardcards.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=GreenUpTexture		FILE=TEXTURES\FE\Report\GreenUp.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=BlueUpTexture			FILE=TEXTURES\FE\Report\BlueUp.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=PurpleUpTexture		FILE=TEXTURES\FE\Report\PurpleUp.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=GreenDownTexture		FILE=TEXTURES\FE\Report\GreenDown.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=BlueDownTexture		FILE=TEXTURES\FE\Report\BlueDown.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=PurpleDownTexture		FILE=TEXTURES\FE\Report\PurpleDown.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=GreenOverTexture		FILE=TEXTURES\FE\Report\GreenOver.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=BlueOverTexture		FILE=TEXTURES\FE\Report\BlueOver.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=PurpleOverTexture		FILE=TEXTURES\FE\Report\PurpleOver.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

var float TimePassed;

var int cardX, cardY;

struct HousePointAnimData
{
	var float StartTime;
	var Texture Sand;
	var float sandPosX;
	var int numPoints;
};

var HousePointAnimData housePoints [4];
var int maxPoints;

var UWindowButton QuitButton;
var UWindowButton OptionsButton;
var UWindowButton FolioButton;
var UWindowButton ResumeButton;

var UWindowButton QuitLabel;
var UWindowLabelControl OptionsLabel;
var UWindowLabelControl FolioLabel;


var UWindowButton BeanBadge;
var UWindowButton PointBadge;
var UWindowButton CardBadge;

var HPMessageBox ConfirmQuit;

var UWindowLabelControl numBeansLabel;
var UWindowLabelControl numCardsLabel;
var UWindowLabelControl numPointsLabel;


function Created()
{
local Texture tmpTexture;
local int i, j;
local int y;

	cardX = 8;
	cardY = 75;


	// setup housePoint anim stuff
	//----------------------------

	housePoints[0].startTime = 0;
	housePoints[1].startTime = 0;
	housePoints[2].startTime = 0;
	housePoints[3].startTime = 0;

	housePoints[0].Sand = Texture'BookReportBlueSand';
	housePoints[1].Sand = Texture'BookReportYellowSand';
	housePoints[2].Sand = Texture'BookReportGreenSand';
	housePoints[3].Sand = Texture'BookReportRedSand';

	housePoints[0].sandPosX = 102;
	housePoints[1].sandPosX = housePoints[0].sandPosX + 64;
	housePoints[2].sandPosX = housePoints[1].sandPosX + 64;
	housePoints[3].sandPosX = housePoints[2].sandPosX + 65;

	maxPoints = baseHarry(root.console.viewport.Actor).maxPointsPerHouse;

	BeanBadge=UWindowButton(CreateControl(class'UWindowButton', 31,62,128,128));
	BeanBadge.UpTexture=Texture'BeanBadgeTexture';
	BeanBadge.DownTexture=Texture'BeanBadgeTexture';
	BeanBadge.OverTexture=Texture'BeanBadgeTexture';
	BeanBadge.DownSound = None;


	CardBadge=UWindowButton(CreateControl(class'UWindowButton', 246,62,128,128));
	CardBadge.UpTexture=Texture'CardBadgeTexture';
	CardBadge.DownTexture=Texture'CardBadgeTexture';
	CardBadge.OverTexture=Texture'CardBadgeTexture';

	PointBadge=UWindowButton(CreateControl(class'UWindowButton', 466,62,128,128));
	PointBadge.UpTexture=Texture'PointBadgeTexture';
	PointBadge.DownTexture=Texture'PointBadgeTexture';
	PointBadge.OverTexture=Texture'PointBadgeTexture';
	PointBadge.DownSound = None;

	y=400-45;
	QuitButton=UWindowButton(CreateControl(class'UWindowButton', 107,354,64,64));
//	QuitButton.ToolTipString="Quit this game";
	QuitButton.ShowWindow();
	QuitButton.UpTexture=Texture'BlueUpTexture';
	QuitButton.DownTexture=Texture'BlueDownTexture';
	QuitButton.OverTexture=Texture'BlueOverTexture';

//	QuitLabel=UWindowLabelControl(CreateControl(class'UWindowLabelControl', 107+(32-50),(354+62),100,25));
	QuitLabel=UWindowButton(CreateControl(class'UWindowButton', (107+32)-90,(354+62),180,25));
	QuitLabel.setFont(F_HPMenuLarge);
	QuitLabel.TextColor.r=215;
	QuitLabel.TextColor.g=0;
	QuitLabel.TextColor.b=215;
	QuitLabel.Align=TA_Center;
	QuitLabel.bShadowText=true;
	QuitLabel.ShowWindow();
//	QuitLabel.setText("Quit");

	QuitLabel.setText(GetLocalizedString("report_buttons_04",QuitButton.ToolTipString ));	//Quit, Quit this game.



	OptionsButton=UWindowButton(CreateControl(class'UWindowButton',286,354,64,64));
//	OptionsButton.ToolTipString="Change Options";
	OptionsButton.ShowWindow();
	OptionsButton.UpTexture=Texture'GreenUpTexture';
	OptionsButton.DownTexture=Texture'GreenDownTexture';
	OptionsButton.OverTexture=Texture'GreenOverTexture';

	OptionsLabel=UWindowLabelControl(CreateControl(class'UWindowLabelControl', 286+(32-50),(354+62),100,25));
	OptionsLabel.setFont(F_HPMenuLarge);
	OptionsLabel.TextColor.r=215;
	OptionsLabel.TextColor.g=0;
	OptionsLabel.TextColor.b=215;
	OptionsLabel.Align=TA_Center;
	OptionsLabel.bShadowText=true;
//	OptionsLabel.setText("Options");

	OptionsLabel.setText(GetLocalizedString("report_buttons_02",OptionsButton.ToolTipString ));	//Quit, Quit this game.




	FolioButton=UWindowButton(CreateControl(class'UWindowButton', 450,354,64,64));
//	FolioButton.ToolTipString="Wizard card Folio";
	FolioButton.ShowWindow();
	FolioButton.UpTexture=Texture'PurpleUpTexture';
	FolioButton.DownTexture=Texture'PurpleDownTexture';
	FolioButton.OverTexture=Texture'PurpleOverTexture';

	FolioLabel=UWindowLabelControl(CreateControl(class'UWindowLabelControl', 450+(32-50),(354+62),100,25));
	FolioLabel.setFont(F_HPMenuLarge);
	FolioLabel.TextColor.r=215;
	FolioLabel.TextColor.g=0;
	FolioLabel.TextColor.b=215;
	FolioLabel.Align=TA_Center;
	FolioLabel.bShadowText=true;
//	FolioLabel.setText("Wizard Cards");

	FolioLabel.setText(GetLocalizedString("report_buttons_01",FolioButton.ToolTipString ));	//Quit, Quit this game.



/*	ResumeButton=UWindowButton(CreateControl(class'UWindowButton', 535-50,y,100,120));
	ResumeButton.setFont(F_HPMenuLarge);
	ResumeButton.TextColor.r=215;
	ResumeButton.TextColor.g=0;
	ResumeButton.TextColor.b=215;
	ResumeButton.Align=TA_Center;
	ResumeButton.setText("Back to Game");
	ResumeButton.ToolTipString="Resume the game";
	ResumeButton.ShowWindow();
	ResumeButton.bShadowText=true;
*/

	numBeansLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 
		BeanBadge.WinLeft+45, BeanBadge.WinTop+69, 40, 20));
	numBeanslabel.Align = TA_Center;
	numBeanslabel.setFont(F_HPMenuLarge);
	numBeansLabel.bAlwaysOnTop = True;

	numCardsLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 
		CardBadge.WinLeft+45, numBeansLabel.WinTop, 40, 20));
	numCardsLabel.Align = TA_Center;
	numCardsLabel.setFont(F_HPMenuLarge);
	numCardsLabel.bAlwaysOnTop = True;

	numPointsLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 
		PointBadge.WinLeft+45, numBeansLabel.WinTop, 40, 20));
	numPointsLabel.Align = TA_Center;
	numPointsLabel.setFont(F_HPMenuLarge);
	numPointsLabel.bAlwaysOnTop = True;
}

function bool DrawSandTimer(Canvas canvas, int i, float time)
{
	local float ToDo, done, tmp, amountLeft;

	local int bottleIntlHeight;

	local float bottle_x, bottle_y;
	local float bottle_intl_x, bottle_intl_y;
	local string strNumPoints;
	local color black,savecolor;


	bottleIntlHeight = 256;	//utb 59;
	bottle_intl_x = 23;
	bottle_intl_y = 1;

	bottle_y = 50;

	done = time/2;

	ToDo = housePoints[i].numPoints;
	ToDo /= maxPoints;
	//log("report card: bottle " $i $" fraction to do " $ToDo);

	if (done > toDo)
		done = toDo;

	if (done > 1)
		amountLeft = bottleIntlHeight - bottleIntlHeight;
	else
		amountLeft = bottleIntlHeight - (done*bottleIntlHeight);

	//log("report card: bottle " $i $" pixels to do " $ToDo);
	
	Root.SetPosScaled(Canvas,cardX + housePoints[i].sandPosX-bottle_intl_x, 
		cardY + bottle_y + amountLeft
		);

	tmp = bottle_intl_y + amountLeft;
	
	Root.DrawTileScaled(Canvas, housePoints[i].sand, 
		256, 256.0f - tmp,		// width, height
		0, tmp,	// x,y
		256, 256.0f - tmp);						// total size of texture

	// Do text underneath the bottle
	//------------------------------

	Root.SetPosScaled(Canvas,cardX + housePoints[i].sandPosX+96, cardY+152);

	if (done == toDo)
		strNumPoints = string(housePoints[i].numPoints);
	else
		strNumPoints = string(int(done*maxPoints));

	savecolor=Canvas.DrawColor;
	Canvas.DrawColor=black;

	Canvas.Font=root.Fonts[F_HPMenuLarge];

	Canvas.DrawText(strNumPoints);
	Canvas.DrawColor=savecolor;
}



function Paint(Canvas canvas,float x,float y)
{
//	log ("FEReport paint x: " $x $" y: " $y);

	local int i;

	local float numbersX, numbersY;

	// Glue in the report card
	//------------------------

//	Canvas.SetPos( cardX, cardY);
	//Canvas.DrawTile(Texture'BookReportCard', 256, 256, 0, 0, 256, 256);
//	FEBook(book).ScaleAndDraw(canvas, cardX, cardY, Texture'BookReportCard');


	// Draw the house point bottles
	//-----------------------------

	for (i=0; i<ArrayCount(housePoints); ++i)
	{
		if (housePoints[i].startTime >= 0 &&
			housePoints[i].startTime < TimePassed
			)
			DrawSandTimer(canvas, i, TimePassed - housePoints[i].startTime);
	}

}

function Tick (float DeltaTime)
{
	TimePassed += DeltaTime;
}

function ShowWindow()
{
	local int numThing;
	local baseHarry playerHarry;

//	log ("Report Page Show window");
	Timepassed = 0;
	super.ShowWindow ();

	playerHarry = baseHarry(root.console.viewport.Actor);

	housepoints[0].numPoints =PlayerHarry.getnumhousePointsRavenclaw ();
	housepoints[1].numPoints =PlayerHarry.getnumHousePointsHufflePuff ();
	housepoints[2].numPoints =PlayerHarry.getnumhousePointsSlytherin ();
	housepoints[3].numPoints =PlayerHarry.getnumHousePointsGryffindor ();

	numThing = baseHarry(root.console.viewport.Actor).numBeans;
	numBeansLabel.SetText(string (numThing));

	numThing = baseHarry(root.console.viewport.Actor).getNumHousePointsHarry ();
	numPointsLabel.SetText(string (numThing));

	numThing = baseHarry(root.console.viewport.Actor).getNumCards ();
	numCardsLabel.SetText(string (numThing)$"/25");

}

function PreOpenBook()
{
//	log ("Report Page pre-open book");
	ShowWindow ();
}

function WindowDone(UWindowWindow W)
{
	if(W == ConfirmQuit)
		{
			//bug fix. So game doesnt save when in menus or quidditch
		Log("SavePointStuff: FEReportPage: set to -1");
		
		if(ConfirmQuit.Result == GetLocalizedString("main_menu_09")) // yes
			{
			FESlotPage(FEBOOK(book).SlotPage).SetSelectedSlot(-1);
			FEBOOK(book).ChangePageNamed("MAIN");
			}
		ConfirmQuit = None;
		}
}

function Notify(UWindowDialogControl C, byte E)
{
local int i;


	if(e==DE_Click)
		{
		switch(c)
			{
			case QuitButton:
				//revisit. Do Confirm.
				ConfirmQuit = doHPMessageBox(
					//	GetLocalizedString("report_buttons_04"), //Quit Game;
						GetLocalizedString("report_buttons_05"), //"Are you sure you want to quit this game?"
						GetLocalizedString("main_menu_09"),// "Yes"
						GetLocalizedString("main_menu_10") //"No"
						);
//				ConfirmQuit = MessageBox("Quit Game", "Are you sure you want to quit this game?", MB_YesNo, MR_No, MR_None, 10);
				break;
			case OptionsButton:
				FEBOOK(book).ChangePageNamed("OPTIONS");
				break;
			case FolioButton:
			case CardBadge:
				FEBOOK(book).ChangePageNamed("FOLIO");
				break;
			case ResumeButton:
				FEBook(book).CloseBook();
				break;


			}
		}
}

defaultproperties
{
}
