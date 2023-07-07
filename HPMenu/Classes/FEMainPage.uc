class FEMainPage expands baseFEPage;

#EXEC TEXTURE IMPORT NAME=HPLogoTexture	 FILE=TEXTURES\FE\HPLogo.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
//#EXEC TEXTURE IMPORT NAME=HPLogoTexture	 FILE=TEXTURES\FE\BookPiece6.bmp GROUP="Icons" FLAGS=2 MIPS=OFF


var UWindowButton NewGameButton;
var UWindowSmallButton LoadGameButton;
var UWindowButton OptionsButton;
var UWindowButton CreditsButton;
var UWindowButton ExitButton;
var UWindowButton QuidButton;
var UWindowButton LangButton;
var UWindowButton LogoWindow;

var UWindowButton LevSelectButton;

var baseFEPage	LevSelectPage;

var string LegalText;

var HPMessageBox ConfirmExit;

var UWindowSmallButton VersionButton;

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	if(HPConsole(root.console).bDebugMode!=LevSelectButton.bWindowVisible)
		{ 
		if(HPConsole(root.console).bDebugMode)
			{
			LangButton.ShowWindow();
			LevSelectButton.ShowWindow();
			CreditsButton.ShowWindow();
			VersionButton.ShowWindow();
			}
		else
			{
			LangButton.HideWindow();
			LevSelectButton.HideWindow();
			CreditsButton.HideWindow();
			VersionButton.HideWindow();
			}
		}

//log("here");		
}

function Paint(Canvas canvas,float x,float y)
{
local float w,h;
local font saveFont;

	saveFont=canvas.font;
	canvas.font=root.fonts[0];
	TextSize(canvas,LegalText, w, h);
	Root.SetPosScaled(canvas,WinWidth-w,WinHeight-h);
	Canvas.DrawText(LegalText);
	canvas.font=saveFont;
}

function Created()
{
local int i;
local Texture tempTexture;
local float x,y;

	Super.Created(); 

//	x=(WinWidth/2)-45;
	x=(WinWidth/2)-55;
	y=360;
	NewGameButton = UWindowButton(CreateControl(class'UWindowButton', x,y,140, 25));
	NewGameButton.setFont(F_HPMenuLarge);
	NewGameButton.TextColor.r=250;
	NewGameButton.TextColor.g=250;
	NewGameButton.TextColor.b=250;

	NewGameButton.bColorOver=true;
	NewGameButton.OverColor.r=250;
	NewGameButton.OverColor.g=5;
	NewGameButton.OverColor.b=5;

	NewGameButton.Align=TA_Center;
	NewGameButton.setText((GetLocalizedString("main_menu_03",NewGameButton.ToolTipString )));		//"Start Game");
//	NewGameButton.ToolTipString="Start or Resume a game";

//	NewGameButton.DownSound=Sound'HPSounds.Magic_sfx.pickups.beans_good';
	y+=22;

	OptionsButton = UWindowButton(CreateControl(class'UWindowButton', x,y,140, 25));
	OptionsButton.setFont(F_HPMenuLarge);
	OptionsButton.TextColor.r=250;
	OptionsButton.TextColor.g=250;
	OptionsButton.TextColor.b=250;
	OptionsButton.bColorOver=true;
	OptionsButton.OverColor.r=250;
	OptionsButton.OverColor.g=5;
	OptionsButton.OverColor.b=5;

	OptionsButton.Align=TA_Center;
	OptionsButton.setText((GetLocalizedString("main_menu_04",OptionsButton.ToolTipString )));		
//	OptionsButton.setText("Options");
//	OptionsButton.ToolTipString="Adjust game options";
//	OptionsButton.DownSound=Sound'HPSounds.Magic_sfx.pickups.beans_good';	//beancounter pickup_page
	y+=22;

	QuidButton = UWindowButton(CreateControl(class'UWindowButton',x,y,140, 25));
	QuidButton.setFont(F_HPMenuLarge);
	QuidButton.TextColor.r=250;
	QuidButton.TextColor.g=250;
	QuidButton.TextColor.b=250;
	QuidButton.bColorOver=true;
	QuidButton.OverColor.r=250;
	QuidButton.OverColor.g=5;
	QuidButton.OverColor.b=5;

	QuidButton.Align=TA_Center; 
	QuidButton.setText((GetLocalizedString("main_menu_05",QuidButton.ToolTipString )));		
//	QuidButton.setText("Quidditch"); 
//	QuidButton.ToolTipString="Quidditch League";
//	QuidButton.DownSound=Sound'HPSounds.Magic_sfx.pickups.beancounter';	//beancounter pickup_page
	y+=22; 

	ExitButton = UWindowButton(CreateControl(class'UWindowButton',x,y,140, 25));
	ExitButton.setFont(F_HPMenuLarge);
	ExitButton.TextColor.r=250;
	ExitButton.TextColor.g=250;
	ExitButton.TextColor.b=250;
	ExitButton.bColorOver=true;
	ExitButton.OverColor.r=250;
	ExitButton.OverColor.g=5;
	ExitButton.OverColor.b=5;

	ExitButton.Align=TA_Center; 
	ExitButton.setText((GetLocalizedString("main_menu_06",ExitButton.ToolTipString )));		
//	ExitButton.setText("Exit"); 
//	ExitButton.ToolTipString="Exit to Windows";
//	ExitButton.DownSound=Sound'HPSounds.Menu_SFX.s_menu_click';
	y+=22; 


	x=20;
	y=390;
	LevSelectButton = UWindowButton(CreateControl(class'UWindowButton',x,y,140, 25));
	LevSelectButton.setFont(F_HPMenuLarge);
	LevSelectButton.TextColor.r=250;
	LevSelectButton.TextColor.g=250;
	LevSelectButton.TextColor.b=250;
	LevSelectButton.bColorOver=true;
	LevSelectButton.OverColor.r=250;
	LevSelectButton.OverColor.g=5;
	LevSelectButton.OverColor.b=5;

	LevSelectButton.Align=TA_Center; 
	LevSelectButton.setText("Level Select"); 
	LevSelectButton.HideWindow();		//starts hidden.
	LevSelectButton.ToolTipString="Debug level select";
	y+=20; 

	LangButton = UWindowButton(CreateControl(class'UWindowButton',x,y,140, 25));
	LangButton.setFont(F_HPMenuLarge);
	LangButton.TextColor.r=250;
	LangButton.TextColor.g=250;
	LangButton.TextColor.b=250;
	LangButton.bColorOver=true;
	LangButton.OverColor.r=250;
	LangButton.OverColor.g=5;
	LangButton.OverColor.b=5;

	LangButton.Align=TA_Center; 
	LangButton.setText("Language"); 
	LangButton.HideWindow();		//starts hidden.
	LangButton.ToolTipString="Debug language browser";
	y+=20; 



	CreditsButton = UWindowButton(CreateControl(class'UWindowButton',x,y,140, 25));
	CreditsButton.setFont(F_HPMenuLarge);
	CreditsButton.TextColor.r=250;
	CreditsButton.TextColor.g=250;
	CreditsButton.TextColor.b=250;
	CreditsButton.bColorOver=true;
	CreditsButton.OverColor.r=250;
	CreditsButton.OverColor.g=5;
	CreditsButton.OverColor.b=5;

	CreditsButton.Align=TA_Center; 
	CreditsButton.setText("Credits"); 
	CreditsButton.HideWindow();		//starts hidden.
	CreditsButton.ToolTipString="";
	y+=20; 

	LegalText=Localize("all","legal_title_01","Pickup");

/*	tempTexture=Texture'HPLogoTexture';
	LogoWindow = UWindowButton(CreateWindow(class'UWindowButton',
		0,50,tempTexture.USize,tempTexture.VSize));

//	log("Logo texture:"$tempTexture $" " $tempTexture.USize $" " $tempTexture.VSize);
	LogoWindow.UpTexture=tempTexture;
	LogoWindow.DownTexture=tempTexture;
	LogoWindow.OverTexture=tempTexture;
*/

	VersionButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton',WinWidth-40,WinHeight-30,40, 25));
	VersionButton.setFont(F_Normal);
	VersionButton.TextColor.r=250;
	VersionButton.TextColor.g=250;
	VersionButton.TextColor.b=250;
	VersionButton.Align=TA_Center; 
	VersionButton.setText(class'Version'.default.version); 
	VersionButton.HideWindow();	//debug mode only.

}
function WindowDone(UWindowWindow W)
{
	if(W == ConfirmExit)
		{
		if(ConfirmExit.Result == ConfirmExit.button1.text)
			{
			Root.DoQuitGame();
			}
		ConfirmExit = None;
		}
}

function bool KeyEvent( byte/*EInputKey*/ Key, byte/*EInputAction*/ Action, FLOAT Delta )
{
	if(Action==1 && key==0x1b )	// Escape to exit program
		{
		ConfirmExit = doHPMessageBox(
			GetLocalizedString("main_menu_08"), //"Are you sure you want to exit?"
			GetLocalizedString("main_menu_09"),// "Yes"
			GetLocalizedString("main_menu_10") //"No"
			);
		}
}
function Notify(UWindowDialogControl C, byte E)
{



	if(e==DE_Click)
		{
		switch(c)								
			{
			case NewGameButton:
				FEBook(book).ChangePageNamed("SLOT");
				break;
			case LoadGameButton:
				FEBook(book).ChangePageNamed("load");
				break;
			case OptionsButton:
				FEBook(book).ChangePageNamed("options");
				break;
			case CreditsButton:
				if(HPConsole(root.console).bDebugMode)
//					FEBook(book).ChangePageNamed("CREDITSPAGE");
					FEBook(book).ShowCredits();
				break;
			case ExitButton:
				if(HPConsole(root.console).bDebugMode)
					Root.DoQuitGame();
				else			
					ConfirmExit = doHPMessageBox(
						GetLocalizedString("main_menu_08"), //"Are you sure you want to exit?"
						GetLocalizedString("main_menu_09"),// "Yes"
						GetLocalizedString("main_menu_10") //"No"
						);
			// MessageBox("Exit", "Are you sure you want to exit to windows?", MB_YesNo, MR_No, MR_None, 10);
				break;
			case QuidButton:
				FEBook(book).ChangePageNamed("QuidMatch");
				break;
			case LevSelectButton:
				FEBook(book).ChangePageNamed("levselect");
				break;
			case LangButton:
				FEBook(book).ChangePageNamed("LANG");
				break;

			}
		}
}

defaultproperties
{
}
