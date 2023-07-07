class FEFolioPage expands baseFEPage;

// Imports for all available images of wizard cards so far

#EXEC TEXTURE IMPORT NAME=WizCardAdalbertBigTexture		FILE=TEXTURES\Folio\Cards\Adalbertbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardBertieBigTexture		FILE=TEXTURES\Folio\Cards\bertiebig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardBowmanBigTexture		FILE=TEXTURES\Folio\Cards\bowmanbig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardBurdockBigTexture		FILE=TEXTURES\Folio\Cards\burdockbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardCassandraBigTexture	FILE=TEXTURES\Folio\Cards\cassandrabig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardCorneliusBigTexture	FILE=TEXTURES\Folio\Cards\corneliusbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardDerwentBigTexture		FILE=TEXTURES\Folio\Cards\derwentbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardDumbledoreBigTexture	FILE=TEXTURES\Folio\Cards\dumbledorbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardEdgarBigTexture		FILE=TEXTURES\Folio\Cards\edgarbig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardElladoraBigTexture		FILE=TEXTURES\Folio\Cards\elladorabig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardGiffordBigTexture		FILE=TEXTURES\Folio\Cards\giffordbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardGodricBigTexture		FILE=TEXTURES\Folio\Cards\godricbig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardHarryBigTexture		FILE=TEXTURES\Folio\Cards\harrybig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardHelgaBigTexture		FILE=TEXTURES\Folio\Cards\helgabig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardHengistBigTexture		FILE=TEXTURES\Folio\Cards\hengistbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardIgnatiaBigTexture		FILE=TEXTURES\Folio\Cards\ignatiabig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardMerlinBigTexture		FILE=TEXTURES\Folio\Cards\merlinbig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardMorganBigTexture		FILE=TEXTURES\Folio\Cards\morganbig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardNewtBigTexture			FILE=TEXTURES\Folio\Cards\newtbig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardRodericBigTexture		FILE=TEXTURES\Folio\Cards\rodericbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardRowenaBigTexture		FILE=TEXTURES\Folio\Cards\rowenabig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardSalizarBigTexture		FILE=TEXTURES\Folio\Cards\salizarbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardTillyBigTexture		FILE=TEXTURES\Folio\Cards\Tillybig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardUricBigTexture			FILE=TEXTURES\Folio\Cards\uricbig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardHerpoBigTexture		FILE=TEXTURES\Folio\Cards\herpobig.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=WizCardAdalbertSmallTexture	FILE=TEXTURES\Folio\Cards\adalbertsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardBertieSmallTexture		FILE=TEXTURES\Folio\Cards\bertiesmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardBowmanSmallTexture		FILE=TEXTURES\Folio\Cards\bowmansmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardBurdockSmallTexture	FILE=TEXTURES\Folio\Cards\burdocksmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardCassandraSmallTexture	FILE=TEXTURES\Folio\Cards\cassandrasmall.bmp	GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardCorneliusSmallTexture	FILE=TEXTURES\Folio\Cards\corneliussmall.bmp	GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardDerwentSmallTexture	FILE=TEXTURES\Folio\Cards\derwentsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardDumbledoreSmallTexture	FILE=TEXTURES\Folio\Cards\dumbledorsmall.bmp	GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardEdgarSmallTexture		FILE=TEXTURES\Folio\Cards\edgarsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardElladoraSmallTexture	FILE=TEXTURES\Folio\Cards\elladorasmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardGiffordSmallTexture	FILE=TEXTURES\Folio\Cards\giffordsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardGodricSmallTexture		FILE=TEXTURES\Folio\Cards\godricsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardHarrySmallTexture		FILE=TEXTURES\Folio\Cards\harrysmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardHelgaSmallTexture		FILE=TEXTURES\Folio\Cards\helgasmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardHengistSmallTexture	FILE=TEXTURES\Folio\Cards\hengistsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardIgnatiaSmallTexture	FILE=TEXTURES\Folio\Cards\ignatiasmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardMerlinSmallTexture		FILE=TEXTURES\Folio\Cards\merlinsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardMorganSmallTexture		FILE=TEXTURES\Folio\Cards\morgansmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardNewtSmallTexture		FILE=TEXTURES\Folio\Cards\newtsmall.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardRodericSmallTexture	FILE=TEXTURES\Folio\Cards\rodericsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardRowenaSmallTexture		FILE=TEXTURES\Folio\Cards\rowenasmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardSalizarSmallTexture	FILE=TEXTURES\Folio\Cards\salizarsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardTillySmallTexture		FILE=TEXTURES\Folio\Cards\Tillysmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardUricSmallTexture		FILE=TEXTURES\Folio\Cards\uricsmall.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardHerpoSmallTexture		FILE=TEXTURES\Folio\Cards\herposmall.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=FolioArrowLeft		FILE=TEXTURES\Folio\leftarrow.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FolioArrowLeftDown	FILE=TEXTURES\Folio\leftarrowdown.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FolioArrowLeftOver	FILE=TEXTURES\Folio\leftarrowover.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FolioArrowRight		FILE=TEXTURES\Folio\rightarrow.bmp			GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FolioArrowRightDown	FILE=TEXTURES\Folio\rightarrowdown.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FolioArrowRightOver	FILE=TEXTURES\Folio\rightarrowover.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF

#EXEC TEXTURE IMPORT NAME=WizCardMissingBigTexture		FILE=TEXTURES\Folio\Cards\missingcardbig.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=WizCardMissingSmallTexture	FILE=TEXTURES\Folio\Cards\missingcardsmall.bmp		GROUP="Icons" FLAGS=2 MIPS=OFF

var Color PurpleColour, purpleBright;

// var for text under big bitmap

var UWindowWrappedTextArea WizardDescription;

// vars for specific wizard card stuff

var UWindowButton  LargeCardBmp;
var UWindowButton  SmallCardBmp [4];
var int	wizardIDs [4];
var int selectedCardID;

var UWindowButton ForwardButton;
var UWindowButton BackButton;

var baseHarry harry;
var int PageNum;

var UWindowLabelControl TitleLabel;

function Texture GetBigTexture (int Id)
{
	switch(Id)
	{
	case 101: return Texture'WizCardDumbledoreBigTexture';
	case  2: return Texture'WizCardCorneliusBigTexture';
	case 69: return Texture'WizCardBertieBigTexture';
	case 17: return Texture'WizCardMorganBigTexture';
	case 41: return Texture'WizCardGodricBigTexture';
	case 72: return Texture'WizCardHelgaBigTexture';
	case 49: return Texture'WizCardElladoraBigTexture';
	case  1: return Texture'WizCardMerlinBigTexture';
	case 10: return Texture'WizCardBurdockBigTexture';
	case 18: return Texture'WizCardUricBigTexture';
	case 57: return Texture'WizCardGiffordBigTexture';
	case 83: return Texture'WizCardRodericBigTexture';
	case 100: return Texture'WizCardHarryBigTexture';
	case 82: return Texture'WizCardRowenaBigTexture';
	case 19: return Texture'WizCardNewtBigTexture';
	case  8: return Texture'WizCardDerwentBigTexture';
	case 48: return Texture'WizCardSalizarBigTexture';
	case 47: return Texture'WizCardEdgarBigTexture';
	case 28: return Texture'WizCardTillyBigTexture';
	case 37: return Texture'WizCardCassandraBigTexture';
	case 24: return Texture'WizCardAdalbertBigTexture';
	case 62: return Texture'WizCardIgnatiaBigTexture';
	case 96: return Texture'WizCardHengistBigTexture';
	case 35: return Texture'WizCardBowmanBigTexture';
	case 11: return Texture'WizCardHerpoBigTexture';
	}

	return None;
}

function Texture GetSmallTexture (int Id)
{
	switch(Id)
	{
	case 101: return Texture'WizCardDumbledoreSmallTexture';
	case  2: return Texture'WizCardCorneliusSmallTexture';
	case 69: return Texture'WizCardBertieSmallTexture';
	case 17: return Texture'WizCardMorganSmallTexture';
	case 41: return Texture'WizCardGodricSmallTexture';
	case 72: return Texture'WizCardHelgaSmallTexture';
	case 49: return Texture'WizCardElladoraSmallTexture';
	case  1: return Texture'WizCardMerlinSmallTexture';
	case 10: return Texture'WizCardBurdockSmallTexture';
	case 18: return Texture'WizCardUricSmallTexture';
	case 57: return Texture'WizCardGiffordSmallTexture';
	case 83: return Texture'WizCardRodericSmallTexture';
	case 100: return Texture'WizCardHarrySmallTexture';
	case 82: return Texture'WizCardRowenaSmallTexture';
	case 19: return Texture'WizCardNewtSmallTexture';
	case  8: return Texture'WizCardDerwentSmallTexture';
	case 48: return Texture'WizCardSalizarSmallTexture';
	case 47: return Texture'WizCardEdgarSmallTexture';
	case 28: return Texture'WizCardTillySmallTexture';
	case 37: return Texture'WizCardCassandraSmallTexture';
	case 24: return Texture'WizCardAdalbertSmallTexture';
	case 62: return Texture'WizCardIgnatiaSmallTexture';
	case 96: return Texture'WizCardHengistSmallTexture';
	case 35: return Texture'WizCardBowmanSmallTexture';
	case 11: return Texture'WizCardHerpoSmallTexture';
	}

	return None;
}

function string GetWizardText(int ID)
{
	local string	Description;
	local string	OutText;
	local sound		OutSound;

	switch(Id)
	{
		case 24	: Description = "wizard_card_new_11"; break;	//	ADALBERT WAFFLING
		case 29	: Description = "wizard_card_new_13"; break;	//	ARCHIBALD ALDERTON
		case 69	: Description = "wizard_card_new_23"; break;	//	BERTIE BOTT
		case 35	: Description = "wizard_card_new_14"; break;	//	BOWMAN WRIGHT
		case 10	: Description = "wizard_card_new_02"; break;	//	BURDOCK MULDOON
		case 37	: Description = "wizard_card_new_15"; break;	//	CASSANDRA VABLATSKY
		case 2	: Description = "wizard_card_new_10"; break;	//	CORNELIUS AGRIPPA
		case 8	: Description = "wizard_card_new_25"; break;	//	DERWENT SHIMPLING
		case 101: Description = "wizard_card_new_04b"; break;	//	ALBUS DUMBLEDORE
		case 47	: Description = "wizard_card_new_18"; break;	//	EDGAR STROUGLER
		case 49	: Description = "wizard_card_new_20"; break;	//	ELLADORA KETTERIDGE
		case 57	: Description = "wizard_card_new_21"; break;	//	GIFFORD OLLERTON
		case 41	: Description = "wizard_card_new_17"; break;	//	GODRIC GRYFFINDOR
		case 4	: Description = "wizard_card_new_16"; break;	//	GROGAN STUMP
		case 100: Description = "wizard_card_new_03"; break;	//	HARRY POTTER
		case 72	: Description = "wizard_card_new_24"; break;	//	HELGA HUFFLEPUFF
		case 96	: Description = "wizard_card_new_28"; break;	//	HENGIUST OF WOODCROFT
		case 11	: Description = "wizard_card_new_05"; break;	//	HERPO THE FOUL
		case 62	: Description = "wizard_card_new_22"; break;	//	IGNATIA WILDSMITH
		case 1	: Description = "wizard_card_new_01"; break;	//	MERLIN
		case 12	: Description = "wizard_card_new_06"; break;	//	Merwyn the malicious
		case 17	: Description = "wizard_card_new_07"; break;	//	MORGAN LE FAY
		case 19	: Description = "wizard_card_new_09"; break;	//	NEWT SCAMANDER
		case 83	: Description = "wizard_card_new_27"; break;	//	RODERIC PLIMPTON
		case 82	: Description = "wizard_card_new_26"; break;	//	ROWENA RAVENCLAW
		case 48	: Description = "wizard_card_new_19"; break;	//	SALAZAR SLYTHERIN
		case 28	: Description = "wizard_card_new_12"; break;	//	TILLY TOKE
		case 18	: Description = "wizard_card_new_08"; break;	//	URIC THE ODDBALL

		default:
			Description = "";
			break;
	}

	if (Description != "")
	{
		return(GetLocalizedString(Description));
//		Harry.theNarrator.FindDialog(Description, outSound, outText);
//		return outText;
	}

	return "";
}

function Created()
{
	local Texture tmpTexture;
	local int i, arrowY;

	// coords for arrows
	arrowY = 400;

	PageNum=0;
	selectedCardID=-1;

		// Do the wizard card display

	LargeCardBmp = UWindowButton(CreateWindow(class'UWindowButton', 182, 31, 256, 256));

	WizardDescription = UWindowWrappedTextArea( CreateControl(class'UWindowWrappedTextArea', 
		236-25, 315, 210, 150) );
	WizardDescription.Clear();
	WizardDescription.SetAbsoluteFont(Font'FontHPMenuLarge');
//	WizardDescription.TextColor = PurpleColour;

	
	SmallCardBmp[0] = UWindowButton(CreateWindow(class'UWindowButton', 49, 130, 128, 128));
	SmallCardBmp[1] = UWindowButton(CreateWindow(class'UWindowButton', 49, 268, 128, 128));
	SmallCardBmp[2] = UWindowButton(CreateWindow(class'UWindowButton', 449, 131, 128, 128));
	SmallCardBmp[3] = UWindowButton(CreateWindow(class'UWindowButton', 451, 268, 128, 128));

	for (i=0; i !=ArrayCount(SmallCardBmp); ++i)
	{
		SmallCardBmp[i].Register(self);
	}

	// forward and back btns
	//----------------------

	ForwardButton = UWindowButton(CreateWindow(class'UWindowButton',
		 485, arrowY, 64,40));

	ForwardButton.Register(self);
	ForwardButton.UpTexture=Texture'FERightArrowUpIcon';
	ForwardButton.DownTexture=Texture'FERightArrowOverIcon';
	ForwardButton.OverTexture=Texture'FERightArrowOverIcon';

	BackButton = UWindowButton(CreateWindow(class'UWindowButton',
		 80, arrowY, 64,40));

	BackButton.Register(self);
	BackButton.UpTexture=Texture'FELeftArrowUpIcon';
	BackButton.DownTexture=Texture'FELeftArrowOverIcon';
	BackButton.OverTexture=Texture'FELeftArrowOverIcon';

	TitleLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 240, 14, 160, 1));
	TitleLabel.SetText(GetLocalizedString("report_buttons_01"));
	TitleLabel.SetFont(F_HPMenuLarge);
	TitleLabel.TextColor = purpleColour;
	TitleLabel.Align = TA_Center;

}

function ShowWindow()
{
	selectedCardID=-1;
	harry = baseHarry(Root.Console.viewport.actor);
	UpdateDisplayDetails ();
	Super.ShowWindow ();
}

function PreOpenBook()
{
	ShowWindow();
}


function DisplayNormalPage ()
{
	local int WizardNum;
	local Texture tmpTexture;
	local int i;

	for (i=0; i!=ArrayCount(SmallCardBmp); ++i)
	{
		WizardNum = PageNum*4 + i;

		log("Card " $harry.WizardCards[WizardNum].ID);

//		if(true)
		if (harry.WizardCards[WizardNum].bHasCard)
		{
			wizardIDs[i] = harry.WizardCards[WizardNum].ID;
			log("Has Card");
		}
		else
		{
			wizardIDs[i] = -1;
			log("No Card");
		}

		log ("Wizard num"@ WizardNum $", ID"@wizardIDs[i]);

		if (wizardIDs[i] != -1)
			tmpTexture = GetSmallTexture(wizardIDs[i]);
		else
			tmpTexture = Texture'WizCardMissingSmallTexture';

		SmallCardBmp[i].UpTexture   = tmpTexture;
		SmallCardBmp[i].DownTexture = tmpTexture;
		SmallCardBmp[i].OverTexture = tmpTexture;
	}

	WizardDescription.clear();
	if (SelectedCardID != -1)
	{
		tmpTexture = GetBigTexture(SelectedCardID);
		WizardDescription.AddText(GetWizardText(SelectedCardID));
	}
	else
	{
		tmpTexture = Texture'WizCardMissingBigTexture';
	}
	LargeCardBmp.UpTexture = tmpTexture;
	LargeCardBmp.DownTexture = tmpTexture;
	LargeCardBmp.OverTexture = tmpTexture;

	feBook(book).curBackground = feBook(book).FolioBackground; // normal background
}

function DisplayHarryPage ()
{
	local int i, harryID;
	local Texture tmpTexture;

	harryID = harry.WizardCards[24].ID;

	for (i=0; i!=ArrayCount(SmallCardBmp); ++i)
	{
		SmallCardBmp[i].UpTexture   = None;
		SmallCardBmp[i].DownTexture = None;
		SmallCardBmp[i].OverTexture = None;
	}

	feBook(book).curBackground = feBook(book).FolioHarryBackground;


	WizardDescription.Clear();
//	if(true)
	if (harry.WizardCards[24].bHasCard) // do we have the Harry card
	{
		WizardDescription.AddText(GetWizardText(harryID));
		tmpTexture = getBigTexture(harryID);
		selectedCardID = harry.WizardCards[24].ID;
	}
	else
	{
		// need to be localised!!!
		WizardDescription.AddText(
			Localize( "all", "harry_potter_card_objective","Pickup2" )
			//GetLocalizedString("harry_potter_card_objective")
			//"To unlock this secret Wizard Card: collect 24 Wizard Cards and 250 Bertie Bott beans, then defeat He-Who-Must-Not-Be-Named."
			);
		tmpTexture = Texture'WizCardMissingBigTexture';
	}

	LargeCardBmp.UpTexture = tmpTexture;
	LargeCardBmp.DownTexture = tmpTexture;
	LargeCardBmp.OverTexture = tmpTexture;

}



function UpdateDisplayDetails()
{
	log("***Folio updating screen, page" @ PageNum);

	BackButton.bDisabled = (PageNum == 0);
	ForwardButton.bDisabled = (PageNum == 6);

	if (PageNum == 6)
		DisplayHarryPage ();
	else
		DisplayNormalPage ();
}

function Notify(UWindowDialogControl C, byte E)
{
	local int i;

	if(e==DE_Click)
	{
		switch(c)								
		{
		case ForwardButton:
			log ("folio Fwd clicked on page"@ PageNum);
			if (PageNum < 6)
			{
				PageNum +=1;
				UpdateDisplayDetails ();
			}
			return;

		case BackButton:
			log ("folio Bwd clicked on page"@ PageNum);
			if (PageNum > 0)
			{
				PageNum -=1;
				UpdateDisplayDetails ();
			}
			return;
		}

		for (i=0; i !=ArrayCount(SmallCardBmp); ++i)
		{
			if (SmallCardBmp[i] == C)
			{
				log("Folio small card"@ i @"clicked");

				SelectedCardID = wizardIDs[i];
				UpdateDisplayDetails ();
				return;
			}
		}

	}
}

function Paint(Canvas canvas,float x,float y)
{
	local float w,h ;
	local string pageDetails;

	super.Paint(canvas, x, y);

//	TextSize(RemoveAmpersand(Text), W, H);
	canvas.TextSize(pageDetails, W, H);


	Root.SetPosScaled(Canvas, 305- (w/2), 440);

	Canvas.Font= Font'FontHPMenuLarge';

	Canvas.DrawColor = PurpleBright;
	pageDetails = string (PageNum+1) $" / 7";
	Canvas.DrawText(pageDetails);
}

defaultproperties
{
     PurpleColour=(R=80,G=5,B=100)
     purpleBright=(R=160,G=10,B=180)
}
