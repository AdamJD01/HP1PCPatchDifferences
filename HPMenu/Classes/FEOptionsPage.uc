class FEOptionsPage expands baseFEPage;

#EXEC TEXTURE IMPORT NAME=FEOverOptionTexture	 FILE=TEXTURES\Options\overoption.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEOverOption3Texture	 FILE=TEXTURES\Options\overoption3.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEOverOption4Texture	 FILE=TEXTURES\Options\overoption4.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#EXEC TEXTURE IMPORT NAME=FEOverOption5Texture	 FILE=TEXTURES\Options\overoption5.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

var bool bInitialized;

var string OldSettings;

// Mouse label
var UWindowButton OptionsLabel;
var localized string optionsText;


var UWindowLabelControl VideoLabel;
var localized string videoText;

// Resolution
var HPMenuOptionCombo ResolutionCombo;
var localized string ResolutionText;

// Color Depth
var HPMenuOptionCombo ColorDepthCombo;
var localized string ColorDepthText;
var localized string BitsText;

// Brightness
var UWindowHSliderControl BrightnessSlider;
var localized string BrightnessText;

// Sensitivity
var UWindowHSliderControl SensitivitySlider;

var localized string DetailLevel[5];

// Texture Detail
var HPMenuOptionCombo TextureDetailCombo;
var localized string TextureDetailText;
var int OldTextureDetail;

// Object Detail
var HPMenuOptionCombo ObjectDetailCombo;
var localized string ObjectDetailText;

var UWindowLabelControl AudioLabel;
var localized string audioText;

// Music Volume
var UWindowHSliderControl MusicVolumeSlider;
var localized string MusicVolumeText;

// Sound Volume
var UWindowHSliderControl SoundVolumeSlider;
var localized string SoundVolumeText;

// Controls Label
var UWindowLabelControl ControlLabel;
var localized string controlText;

// Mouse labels
var UWindowLabelControl MouseHiLabel, MouseLoLabel;
var localized string mouseHiText, mouseLoText;

// Mouse Sensitivity
var UWindowEditControl SensitivityEdit;
var localized string SensitivityText;

var UWindowCheckbox MouseSmoothCheck;
var localized string MouseSmoothText;

var HPMessageBox ConfirmSettings;

var localized string ConfirmSettingsTitle;
var localized string ConfirmSettingsText;
var localized string ConfirmSettingsCancelTitle;
var localized string ConfirmSettingsCancelText;

var UWindowLabelControl KeyboardLabel;
var localized string KeyboardText;


// Keyboard settings
//------------------
var string RealKeyName[255];
var localized string LocalizedKeyName[255];
var localized string LabelList[8];
var localized string OrString;
var UWindowLabelControl KeyNames[8];
var HPMenuRaisedButton KeyButtons[8];
var string AliasNames1[8];
var string AliasNames2[8];
var string AliasNames3[8];
var int BoundKey1[8];
var int BoundKey2[8];
var UWindowButton SelectedButton;
var bool bPolling;
var int Selection;

// auto jump control
var UWindowCheckbox AutoJumpCheck;
var localized string AutoJumpText;

// invert flying control
var UWindowCheckbox InvertBroomCheck;
var localized string InvertBroomText;

// Difficulty
//var UWindowComboControl DifficultyCombo;
var localized string DifficultyText;
var localized string DifficultyLevel[3];

var localized string MouseSensitivityText;

var localized string HighText;
var localized string MediumText;
var localized string LowText;

var Color PurpleColour, BlueColour;
var int vertSpacing [8];

var sound buttonClickSound;



function LocalizeStrings()
{
local int i;
local string tmpStr;

		//options_02	Resolution
	ResolutionText=GetLocalizedString("options_02");	//"Resolution"

		//options_03	Colour Depth
	ColorDepthText=GetLocalizedString("options_03");	//"Color Depth"

		//options_04	Brightness
	BrightnessText=GetLocalizedString("options_04");	//"Brightness"

		//options_05	Texture Detail
	TextureDetailText=GetLocalizedString("options_05");	//"Texture Detail"

		//options_12	Object Detail
	ObjectDetailText=GetLocalizedString("options_12");	//"Object Detail"

		//options_13	Audio
	audioText=GetLocalizedString("options_13");	//"Audio"

		//options_14	Music Volume
	MusicVolumeText=GetLocalizedString("options_14");	//"Music Volume"

		//options_15	Sound Volume
	SoundVolumeText=GetLocalizedString("options_15");	//"Sound Volume"

		//options_07	High
	HighText=GetLocalizedString("options_07");	//"High";

		//options_08	Medium
	MediumText=GetLocalizedString("options_08");	//"Medium";

		//options_10	Low
	LowText=GetLocalizedString("options_10");	//"Low";

		//options_06	Very High
	DetailLevel[0]=GetLocalizedString("options_06");	//"Very High"

		//options_07	High
	DetailLevel[1]=GetLocalizedString("options_07");	//"High"
		//options_08	Medium
	DetailLevel[2]=GetLocalizedString("options_08");	//"Medium"
		//options_10	Low
	DetailLevel[3]=GetLocalizedString("options_10");	//"Low"

		//options_11	Very Low
	DetailLevel[4]=GetLocalizedString("options_11");	//"Very Low"

		//options_16	Controls
	ControlText=GetLocalizedString("options_16");	//"Controls"
		//options_07	High
	MouseHiText=GetLocalizedString("options_07");	//"High"
		//options_10	Low
	MouseLoText=GetLocalizedString("options_10");	//"Low"

		//options_17	Mouse Speed
	MouseSensitivityText=GetLocalizedString("options_17");	//"Mouse Sensitivity"

		//options_21	Forward
	LabelList[0]=GetLocalizedString("options_21");	//"Forward"
		//options_22	Backward
	LabelList[1]=GetLocalizedString("options_22");	//"Back"
		//options_23	Turn Left
	LabelList[2]=GetLocalizedString("options_23");	//"Turn left"
		//options_24	Turn Right
	LabelList[3]=GetLocalizedString("options_24");	//"Turn right"
		//options_25	Jump
	LabelList[4]=GetLocalizedString("options_25");	//"Jump"
		//options_26	Use Wand
	LabelList[5]=GetLocalizedString("options_26");	//"Fire Wand"

		//flying_02	Speed Up
	LabelList[6]=GetLocalizedString("flying_02");	//"Speed up" // broom
		//flying_03	Slow Down
	LabelList[7]=GetLocalizedString("flying_03");	//"Slow down" // broom

		//options_20	Keyboard
	KeyboardText=GetLocalizedString("options_20");	//"Keyboard"
 
		//flying_04	Invert Broom Control
	InvertBroomText=GetLocalizedString("flying_04");	//"Invert Broom"

		//options_01	Options
	optionsText=GetLocalizedString("options_01");	//"OPTIONS"

	for(i=0;i<255;i++)
		{
			//build number part. I wish i could do a sprintf("%03d");
		tmpStr="000" $i;
		tmpStr="localized_keyname_" $right(tmpStr,3);
		LocalizedKeyName[i]=localize("all", tmpStr,"pickup2");
//		log("Parse:"$tmpStr $" " $LocalizedKeyName[i]);

		}

/*     LocalizedKeyName[37]=GetLocalizedString("options_29");	//"Left"
     LocalizedKeyName[38]=GetLocalizedString("options_27");	//"Up"
     LocalizedKeyName[39]=GetLocalizedString("options_30");	//"Right"
     LocalizedKeyName[40]=GetLocalizedString("options_28");	//"Down"

     LocalizedKeyName[17]=GetLocalizedString("options_31");	//"Ctrl"
     LocalizedKeyName[18]=GetLocalizedString("options_32");	//"Alt"
     LocalizedKeyName[8]=GetLocalizedString("options_35");	//"Backspace"
     LocalizedKeyName[32]=GetLocalizedString("options_33");	//"Space"
     LocalizedKeyName[27]=GetLocalizedString("options_34");	//"Escape"
*/
/***************Not Used**************************/
	MouseSmoothText="Mouse Smoothing";

	DifficultyText="Difficulty";
	DifficultyLevel[0]="Easy";
	DifficultyLevel[1]="Medium";
	DifficultyLevel[2]="Hard";
/***************Not Used**************************/

	videoText=Localize("all","videoText","Pickup");	//Video
	OrString=" "$Localize("all","OrString","Pickup")$" ";	//" or ";
	AutoJumpText=Localize("all","AutoJumpText","Pickup");	//"Auto Jump";

	ConfirmSettingsTitle=Localize("all","ConfirmSettingsTitle","Pickup");	//"Confirm Video Settings Change";
	ConfirmSettingsText=Localize("all","ConfirmSettingsText","Pickup");	//"Are you sure you wish to keep these new video settings?";
	ConfirmSettingsCancelTitle=Localize("all","ConfirmSettingsCancelTitle","Pickup");	//"Video Settings Change";
	ConfirmSettingsCancelText=Localize("all","ConfirmSettingsCancelText","Pickup");	//"Your previous video settings have been restored.";
	BitsText=Localize("all","BitsText","Pickup");	//"bit";
	
}


function Created()
{
	local int ctlX, ctlY, ctlW, ctlH, labelWidth, labelX, offsetX, offsetY, I;
	local int MusicVolume, SoundVolume;
	local string sens;

	LocalizeStrings();

	LoadExistingKeys();


	OptionsLabel = UWindowButton(CreateControl(class'UWindowButton', 264-140, 17, 280, 25));
	OptionsLabel.SetText(optionsText);
	OptionsLabel.Align=TA_Center;
	OptionsLabel.SetFont(F_HPMenuLarge);
	OptionsLabel.TextColor = purpleColour;
	OptionsLabel.ShowWindow();

	offsetX = 46;
	offsetY = 11;

	ctlX = 160-offsetX;
	labelX = 0;
	ctlY = 60-offsetY;
	ctlH = 17;
	ctlW = 134;
	labelWidth = ctlX-labelX;


	VideoLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ctlX+53, ctlY, ctlW, 1));
	VideoLabel.SetText(VideoText);
	VideoLabel.SetFont(F_Bold);
	VideoLabel.TextColor = BlueColour;
	ctlY = 87-offsetY;

	I = 0;

	// Resolution
	ResolutionCombo = HPMenuOptionCombo(CreateControl(class'HPMenuOptionCombo', labelX, ctlY, ctlX+ctlW-LabelX, 1));
	ResolutionCombo.SetText(ResolutionText);
	ResolutionCombo.SetFont(F_Normal);
	ResolutionCombo.SetEditable(False);
	ResolutionCombo.EditBoxWidth = ctlW;
	ResolutionCombo.TextColor = PurpleColour;
	ctlY += vertSpacing[I++];

	ColorDepthCombo = HPMenuOptionCombo(CreateControl(class'HPMenuOptionCombo', labelX, ctlY, ctlX+ctlW-LabelX, 1));
	ColorDepthCombo.SetText(ColorDepthText);
	ColorDepthCombo.SetFont(F_Normal);
	ColorDepthCombo.SetEditable(False);
	ColorDepthCombo.EditBoxWidth = ctlW;
	ColorDepthCombo.TextColor = PurpleColour;
	ctlY += vertSpacing[I++];

	// Texture Detail
	TextureDetailCombo = HPMenuOptionCombo(CreateControl(class'HPMenuOptionCombo', labelX, ctlY, ctlX+ctlW-LabelX, 1));
	TextureDetailCombo.SetText(TextureDetailText);
	TextureDetailCombo.SetFont(F_Normal);
	TextureDetailCombo.SetEditable(False);
	TextureDetailCombo.EditBoxWidth = ctlW;
	TextureDetailCombo.TextColor = PurpleColour;
	ctlY += vertSpacing[I++];

	// The display names are localized.  These strings match the enums in UnCamMgr.cpp.
	TextureDetailCombo.AddItem(DetailLevel[1], "High");
	TextureDetailCombo.AddItem(DetailLevel[2], "Medium");
	TextureDetailCombo.AddItem(DetailLevel[3], "Low");

	// Object Detail
	ObjectDetailCombo = HPMenuOptionCombo(CreateControl(class'HPMenuOptionCombo', labelX, ctlY, ctlX+ctlW-LabelX, 1));
	ObjectDetailCombo.SetText(ObjectDetailText);
	ObjectDetailCombo.SetFont(F_Normal);
	ObjectDetailCombo.SetEditable(False);
	ObjectDetailCombo.EditBoxWidth = ctlW;
	ObjectDetailCombo.TextColor = PurpleColour;
	ctlY += vertSpacing[I++];

	ObjectDetailCombo.AddItem(DetailLevel[0]);
	ObjectDetailCombo.AddItem(DetailLevel[1]);
	ObjectDetailCombo.AddItem(DetailLevel[2]);
	ObjectDetailCombo.AddItem(DetailLevel[3]);
	ObjectDetailCombo.AddItem(DetailLevel[4]);

	// Brightness
	ctlY -=1;
	BrightnessSlider = HPMenuOptionHSlider(CreateControl(class'HPMenuOptionHSlider', labelX, ctlY, ctlX+ctlW-LabelX+4, 1));
	BrightnessSlider.bNoSlidingNotify = True;
	BrightnessSlider.SetRange(2, 10, 1);
	BrightnessSlider.SetText(BrightnessText);
	BrightnessSlider.SetFont(F_Normal);
	BrightnessSlider.TextColor = PurpleColour;
	ctlY += 33;

	// Sensitivity
	SensitivitySlider = HPMenuOptionHSlider(CreateControl(class'HPMenuOptionHSlider', labelX, ctlY, ctlX+ctlW-LabelX+4, 1));
	SensitivitySlider.bNoSlidingNotify = True;
	SensitivitySlider.SetRange(0.2, 10, 0.2);
	SensitivitySlider.SetText(MouseSensitivityText);
	SensitivitySlider.SetFont(F_Normal);
	SensitivitySlider.TextColor = PurpleColour;
	ctlY += 27;

	MouseHiLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ctlX+115, ctlY, ctlW, 1));
	MouseHiLabel.SetText(MouseHiText);
	MouseHiLabel.SetFont(F_Normal);
	MouseHiLabel.TextColor = PurpleColour;

	MouseLoLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ctlX, ctlY, ctlW, 1));
	MouseLoLabel.SetText(MouseLoText);
	MouseLoLabel.SetFont(F_Normal);
	MouseLoLabel.TextColor = PurpleColour;
	ctlY += 28;


	AudioLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ctlX+53, ctlY, ctlW, 1));
	AudioLabel.SetText(AudioText);
	AudioLabel.SetFont(F_Bold);
	AudioLabel.TextColor = BlueColour;
	ctlY += 26;

	// Music Volume
	MusicVolumeSlider = HPMenuOptionHSlider(CreateControl(class'HPMenuOptionHSlider', labelX, ctlY, ctlX+ctlW-LabelX+4, 1));
	MusicVolumeSlider.SetRange(0, 255, 32);
	MusicVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume"));
	MusicVolumeSlider.SetValue(MusicVolume);
	MusicVolumeSlider.SetText(MusicVolumeText);
	MusicVolumeSlider.SetFont(F_Normal);
	MusicVolumeSlider.TextColor = PurpleColour;
	ctlY += 37;

	// Sound Volume
	SoundVolumeSlider = HPMenuOptionHSlider(CreateControl(class'HPMenuOptionHSlider', labelX, ctlY, ctlX+ctlW-LabelX+4, 1));
	SoundVolumeSlider.SetRange(0, 255, 32);
	SoundVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume"));
	SoundVolumeSlider.SetValue(SoundVolume);
	SoundVolumeSlider.SetText(SoundVolumeText);
	SoundVolumeSlider.SetFont(F_Normal);
	SoundVolumeSlider.TextColor = PurpleColour;


	// Set to Right-hand page
	//-----------------------
	ctlY = 60-offsetY;
	ctlX = 330-offsetX;
	labelX = 485-offsetX;

	// Control Label
	ControlLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', labelX-100, ctlY, ctlW, 1));
	ControlLabel.SetText(ControlText);
	ControlLabel.SetFont(F_Bold);
	ControlLabel.TextColor = BlueColour;
	ctlY = 88-offsetY;

	// keyboard settings

	for (I=0; I<ArrayCount(LabelList); I++)
	{
		KeyNames[I] = UWindowLabelControl(CreateControl(class'UWindowLabelControl', labelX, ctlY, labelWidth, 1));
		KeyNames[I].SetText(LabelList[I]);
		KeyNames[I].SetFont(F_Normal);
		KeyNames[I].TextColor = PurpleColour;


		KeyButtons[I] = HPMenuRaisedButton(CreateControl(class'HPMenuRaisedButton', ctlX, ctlY, ctlW, ctlH));
		KeyButtons[I].DownTexture = Texture'FEOverOptionTexture';
		KeyButtons[I].DisabledTexture = Texture'FEOverOptionTexture';
		KeyButtons[I].OverTexture = Texture'FEOverOption3Texture';
		KeyButtons[I].SetFont(F_Normal);
		KeyButtons[I].bAcceptsFocus = False;
		KeyButtons[I].bIgnoreLDoubleClick = True;
		KeyButtons[I].bIgnoreMDoubleClick = True;
		KeyButtons[I].bIgnoreRDoubleClick = True;

		ctlY += vertSpacing[I];

		// Store away click sound, we are going to blank it for buttons so that we can handle it ourselves ( Call PlayClick() )
		// buttonClickSound is set up repeatedly, oh well, anyone with nonce would have subclassed a button to do this whole business anyway
		buttonClickSound = KeyButtons[I].DownSound;
		KeyButtons[I].DownSound = None;
	}


/*
	// Mouse label
	MouseLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ctlX-10, ctlY, ctlW, 1));
	MouseLabel.SetText(MouseText);
	MouseLabel.SetFont(F_Normal);
	ctlY += 25;
*/
/*
	// Mouse Sensitivity
	SensitivityEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ctlX, ctlY, ctlW, 1));
	SensitivityEdit.SetText(SensitivityText);
	SensitivityEdit.SetFont(F_Normal);
	SensitivityEdit.SetNumericOnly(True);
	SensitivityEdit.SetNumericFloat(True);
	SensitivityEdit.SetMaxLength(4);
	SensitivityEdit.Align = TA_Right;
	Sens = string(GetPlayerOwner().MouseSensitivity);
	i = InStr(Sens, ".");
	SensitivityEdit.SetValue(Left(Sens, i+3));
	ctlY += 25;
*/

/*
	// Mouse Smoothing
	MouseSmoothCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', ctlX, ctlY, ctlW, 1));
	MouseSmoothCheck.bChecked = GetPlayerOwner().bMaxMouseSmoothing;
	MouseSmoothCheck.SetText(MouseSmoothText);
	MouseSmoothCheck.SetFont(F_Normal);
	MouseSmoothCheck.Align = TA_Right;
	ctlY += 25;
*/

	// Auto Jump checkbox
	AutoJumpCheck = HPMenuOptionCheckBox(CreateControl(class'HPMenuOptionCheckBox', ctlX, ctlY, 160, 1));
	AutoJumpCheck.bChecked = GetPlayerOwner().bAutoJump;
	AutoJumpCheck.SetText(AutoJumpText);
	AutoJumpCheck.SetFont(F_Normal);
	AutoJumpCheck.TextColor = PurpleColour;
	ctlY += 20;

	// Invert broom checkbox
	InvertBroomCheck = HPMenuOptionCheckBox(CreateControl(class'HPMenuOptionCheckBox', ctlX, ctlY, 160, 1));
	InvertBroomCheck.bChecked = IsFlyingControlInverted ();
	InvertBroomCheck.SetText(InvertBroomText);
	InvertBroomCheck.SetFont(F_Normal);
	InvertBroomCheck.TextColor = PurpleColour;

/*
	// Difficulty
	DifficultyCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', ctlX, ctlY, ctlW, 1));
	DifficultyCombo.SetText(DifficultyText);
	DifficultyCombo.SetFont(F_Normal);
	DifficultyCombo.SetEditable(False);
	DifficultyCombo.EditBoxWidth = 100;
	ctlY += 25;

	DifficultyCombo.AddItem(DifficultyLevel[0]);
	DifficultyCombo.AddItem(DifficultyLevel[1]);
	DifficultyCombo.AddItem(DifficultyLevel[2]);
*/
	LoadAvailableSettings ();
}

function PlayClick()
{
    if( buttonClickSound != None )
    {
        GetPlayerOwner().PlaySound( buttonClickSound, SLOT_Interact );
    }
}
 



function BeforePaint(Canvas C, float X, float Y)
{
	local int I;

	for (I=0; I<ArrayCount(KeyButtons); I++ )
	{
		if ( BoundKey1[I] == 0 )
			KeyButtons[I].SetText("");
		else
		if ( BoundKey2[I] == 0 )
			KeyButtons[I].SetText(LocalizedKeyName[BoundKey1[I]]);
		else
			KeyButtons[I].SetText(LocalizedKeyName[BoundKey1[I]]$OrString$LocalizedKeyName[BoundKey2[I]]);
	}
}

function LoadAvailableSettings ()
{
	local float Brightness;
	local string ParseString;
	local string CurrentDepth;
	local int P, I;
	local string TempStr;

	bInitialized = false;

	// Load available video drivers and current video driver here.

	ResolutionCombo.Clear();
	ParseString = GetPlayerOwner().ConsoleCommand("GetRes");
	P = InStr(ParseString, " ");
	while (P != -1) 
	{
			//limit to supported resolutions
		TempStr=Left(ParseString, P);
		if(TempStr~="512x384" || TempStr~="640x480" || TempStr~="800x600" || TempStr~="1024x768")
			ResolutionCombo.AddItem(Left(ParseString, P));

		ParseString = Mid(ParseString, P+1);
		P = InStr(ParseString, " ");
	}

		//limit to supported resolutions
	if(ParseString~="512x384" || ParseString~="640x480" || ParseString~="800x600" || ParseString~="1024x768")
		ResolutionCombo.AddItem(ParseString);
	ResolutionCombo.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));

	ColorDepthCombo.Clear();
	ParseString = GetPlayerOwner().ConsoleCommand("GetColorDepths");
	P = InStr(ParseString, " ");
	while (P != -1) 
	{
		ColorDepthCombo.AddItem(Left(ParseString, P)@BitsText, Left(ParseString, P));
		ParseString = Mid(ParseString, P+1);
		P = InStr(ParseString, " ");
	}
	ColorDepthCombo.AddItem(ParseString@BitsText, ParseString);
	CurrentDepth = GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth");
	ColorDepthCombo.SetValue(CurrentDepth@BitsText, CurrentDepth);

	Brightness = int(float(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager Brightness")) * 10);
	BrightnessSlider.SetValue(Brightness);

	OldTextureDetail = Max(0, TextureDetailCombo.FindItemIndex2(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail")));
	TextureDetailCombo.SetSelectedIndex(OldTextureDetail);

	ObjectDetailCombo.SetSelectedIndex(GetPlayerOwner().ObjectDetail);
	SensitivitySlider.SetValue(GetPlayerOwner().MouseSensitivity);

//	difficultyCombo.SetSelectedIndex(GetPlayerOwner().Difficulty);

	bInitialized = true;
}

function SwitchFlyingControlAliases ()
{
	local string tmp;
	tmp = AliasNames2[0];
	AliasNames2[0] = AliasNames2[1];
	AliasNames2[1] = tmp;

	log("Flying control aliases switched");
}

function bool IsFlyingControlInverted ()
{
/*	if (AliasNames2[0] ~= "button bBroomPitchUp")
		return false;
	else
		return true;
		*/

	return baseHarry(GetPlayerOwner()).bInvertBroomPitch;
}

function LoadExistingKeys()
{
	local int I, J, pos;
	local string KeyName;
	local string Alias;

	// capitalise all aliases to simplify comparison code
	for (J=0; J<ArrayCount(AliasNames1); J++)
	{
		AliasNames1[J] = Caps(AliasNames1[J]);
		AliasNames2[J] = Caps(AliasNames2[J]);
		AliasNames3[J] = Caps(AliasNames3[J]);
	}


	for (I=0; I<ArrayCount(LabelList); I++)
	{
		BoundKey1[I] = 0;
		BoundKey2[I] = 0;
	}

	for (I=0; I<255; I++)
	{
		KeyName = GetPlayerOwner().ConsoleCommand( "KEYNAME "$i );

		RealKeyName[i] = KeyName;
		if ( KeyName != "" )
		{
			Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING "$KeyName );
			if ( Alias != "" )
			{
				log("OptionPage keyname "$I $" is " $keyname $", KeyBinding Alias is " $Alias);

				Alias=Caps(Alias);

				// Are any of the aliases that we use stored in this alias string ?

				for (J=0; J<ArrayCount(AliasNames1); J++)
				{
					if (InStr (Alias, AliasNames1[J]) != -1)
					{
						if ( BoundKey1[J] == 0 )
							BoundKey1[J] = i;
						else
						if ( BoundKey2[J] == 0)
							BoundKey2[J] = i;
/*
						if (j==0) // this is the up key, so check if broom is inverted
						{
							if (InStr (Alias, AliasNames2[0]) == -1)
								SwitchFlyingControlAliases ();
						}
*/
						break;
					}
				}//endfor
			}
		}
	}//endfor

}



function BrightnessChanged()
{
	if(bInitialized)
	{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$(BrightnessSlider.Value / 10));
		GetPlayerOwner().ConsoleCommand("FLUSH");
	}
}

//-----------------------------------------------------------------------------------------------

function SettingsChanged()
{
	local string NewSettings;

	if(bInitialized)
	{
		OldSettings = GetPlayerOwner().ConsoleCommand("GetCurrentRes")$"x"$GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth");
		NewSettings = ResolutionCombo.GetValue()$"x"$ColorDepthCombo.GetValue2();

		if(NewSettings != OldSettings)
		{
			log("Screen Settings Changed");
			GetPlayerOwner().ConsoleCommand("SetRes "$NewSettings);

			LoadAvailableSettings();
			ConfirmSettings = doHPMessageBox(ConfirmSettingsText, 
						GetLocalizedString("main_menu_09"),// "Yes"
						GetLocalizedString("main_menu_10"), //"No"
				20);
		}
	}
}

function WindowDone (UWindowWindow W)
{
	if(W == ConfirmSettings)
	{
		if(ConfirmSettings.Result == "" ||
		   ConfirmSettings.Result == GetLocalizedString("main_menu_10")) // "No"
		{
			GetPlayerOwner().ConsoleCommand("SetRes "$OldSettings);

			LoadAvailableSettings();			
			doHPMessageBox(ConfirmSettingsCancelText, "Okay");
		}
		ConfirmSettings = None;
	}
}




function TextureDetailChanged()
{
	if(bInitialized)
	{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail "$TextureDetailCombo.GetValue2());
		OldTextureDetail = TextureDetailCombo.GetSelectedIndex();
	}
}

function ObjectDetailChanged ()
{
	switch (ObjectDetailCombo.GetSelectedIndex())
	{
		case 0: GetPlayerOwner().ObjectDetail = ObjectDetailVeryHigh; break;
		case 1: GetPlayerOwner().ObjectDetail = ObjectDetailHigh; break;
		case 2: GetPlayerOwner().ObjectDetail = ObjectDetailMedium; break;
		case 3: GetPlayerOwner().ObjectDetail = ObjectDetailLow; break;
		case 4: GetPlayerOwner().ObjectDetail = ObjectDetailVeryLow; break;
	}
}

function MusicVolumeChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVolumeSlider.Value);
}

function SoundVolumeChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$SoundVolumeSlider.Value);
}

function SensitivityChanged()
{
	GetPlayerOwner().MouseSensitivity = SensitivitySlider.Value;

	log("Sensitivity changed to " $GetPlayerOwner().MouseSensitivity);
}

function MouseSmoothChanged()
{
	GetPlayerOwner().bMaxMouseSmoothing = MouseSmoothCheck.bChecked;
}

function AutoJumpChanged ()
{
	GetPlayerOwner().AutoJump( AutoJumpCheck.bChecked );
}

function InvertBroomChanged ()
{
/*	SwitchFlyingControlAliases();

	if (BoundKey1[0] != 0)
		GetPlayerOwner().ConsoleCommand("SET Input"@RealKeyName[BoundKey1[0]]@AliasNames1[0]@"|"@AliasNames2[0]);		
	if (BoundKey1[1] != 0)
		GetPlayerOwner().ConsoleCommand("SET Input"@RealKeyName[BoundKey1[1]]@AliasNames1[1]@"|"@AliasNames2[1]);		

	if (BoundKey2[0] != 0)
		GetPlayerOwner().ConsoleCommand("SET Input"@RealKeyName[BoundKey2[0]]@AliasNames1[0]@"|"@AliasNames2[0]);		
	if (BoundKey2[1] != 0)
		GetPlayerOwner().ConsoleCommand("SET Input"@RealKeyName[BoundKey2[1]]@AliasNames1[1]@"|"@AliasNames2[1]);		
	*/

//	baseHarry(GetPlayerOwner()).bInvertBroomPitch = InvertBroomCheck.bChecked;

    // Changed from a direct variable access to a function call.
    baseHarry(GetPlayerOwner()).InvertBroomPitch(InvertBroomCheck.bChecked);

}
/*
function difficultyChanged()
{
	switch (difficultyCombo.GetSelectedIndex())
	{
		case 0: GetPlayerOwner().Difficulty = DifficultyEasy; break;
		case 1: GetPlayerOwner().Difficulty = DifficultyMedium; break;
		case 2: GetPlayerOwner().Difficulty = DifficultyHard; break;
	}
}
*/

function RemoveExistingKey(int KeyNo, string KeyName)
{
	local int I;

	// Remove this key from any existing binding display
	for ( I=0; I<ArrayCount(Boundkey1); I++ )
	{
		if(I != Selection)
		{
			if ( BoundKey2[I] == KeyNo )
				BoundKey2[I] = 0;

			if ( BoundKey1[I] == KeyNo )
			{
				BoundKey1[I] = BoundKey2[I];
				BoundKey2[I] = 0;
			}
		}
	}
}

function SetKey(int KeyNo, string KeyName)
{
	log ("options Setkey"@KeyName);

	if ( BoundKey1[Selection] != 0 )
	{

		// if this key is already chosen, just clear out other slot
		if(KeyNo == BoundKey1[Selection])
		{
			// if 2 exists, remove it it.
			if(BoundKey2[Selection] != 0)
			{
				GetPlayerOwner().ConsoleCommand("SET Input "$RealKeyName[BoundKey2[Selection]]);
				BoundKey2[Selection] = 0;
			}
		}
		else 
		if(KeyNo == BoundKey2[Selection])
		{
			// Remove slot 1
			GetPlayerOwner().ConsoleCommand("SET Input "$RealKeyName[BoundKey1[Selection]]);
			BoundKey1[Selection] = BoundKey2[Selection];
			BoundKey2[Selection] = 0;
		}
		else
		{
			// Clear out old slot 2 if it exists
			if(BoundKey2[Selection] != 0)
			{
				GetPlayerOwner().ConsoleCommand("SET Input "$RealKeyName[BoundKey2[Selection]]);
				BoundKey2[Selection] = 0;
			}

			// move key 1 to key 2, and set ourselves in 1.
			BoundKey2[Selection] = BoundKey1[Selection];
			BoundKey1[Selection] = KeyNo;

			if (AliasNames2[Selection] == "")
				GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames1[Selection]);
			else
			{
				if (AliasNames3[Selection] == "")
					GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames1[Selection]@"|"@AliasNames2[Selection]);		
				else
					GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames1[Selection]@"|"@AliasNames2[Selection]@"|"@AliasNames3[Selection]);		
			}
		}
	}
	else
	{
		BoundKey1[Selection] = KeyNo;

		if (AliasNames2[Selection] == "")
			GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames1[Selection]);
		else
		{
			if (AliasNames3[Selection] == "")
				GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames1[Selection]@"|"@AliasNames2[Selection]);		
			else
				GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames1[Selection]@"|"@AliasNames2[Selection]@"|"@AliasNames3[Selection]);		
		}
	}
}


function ProcessKey( int KeyNo )
{
	local string keyName;
	keyName = RealKeyName[KeyNo];

	log("OptionPage '"$AliasNames1[selection] $"' attempt to set as " $keyNo $":"$KeyName);
	PlayClick();

	if ( (KeyName == "") || (KeyName == "Escape")  
		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) // function keys
		|| ((KeyNo >= 0x30 ) && (KeyNo <= 0x39))// number keys
		|| (KeyNo ==91) || (KeyNo ==92) || (KeyNo == 93) // windows keys
		|| (KeyNo==236) || (keyNo==237)
		) 
		return;

	RemoveExistingKey(KeyNo, KeyName);
	SetKey(KeyNo, KeyName);
}

function bool KeyEvent( byte/*EInputKey*/ KeyNo, byte/*EInputAction*/ Action, FLOAT Delta )
{
	if (Action == 1 
	&& bPolling
	&& keyNo >= 5 // Handle mouse clicks separately

	) // button press
	{
		ProcessKey(KeyNo);

		bPolling = False;
		SelectedButton.bDisabled = False;
		return true;
	}

	return super.KeyEvent(KeyNo, Action, Delta);
}


function Notify(UWindowDialogControl C, byte E)
{
	local int i;

	Super.Notify(C, E);

	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case ResolutionCombo:
		case ColorDepthCombo:
			SettingsChanged();
			break;

		case BrightnessSlider:
			BrightnessChanged();
			break;

		case TextureDetailCombo:
			TextureDetailChanged();
			break;

		case ObjectDetailCombo:
			ObjectDetailChanged();
			break;

		case MusicVolumeSlider:
			MusicVolumeChanged();
			break;

		case SoundVolumeSlider:
			SoundVolumeChanged();
			break;

		case SensitivitySlider:
			SensitivityChanged();
			break;

		case MouseSmoothCheck:
			MouseSmoothChanged();
			break;

		case InvertBroomCheck:
			InvertBroomChanged ();
			break;
/*
		case difficultyCombo:
			difficultyChanged();
			break;
*/
		case AutoJumpCheck:
			autoJumpChanged ();
			break;

		}

	case DE_Click:
		if (bPolling)
		{
			bPolling = False;
			SelectedButton.bDisabled = False;

			if(C == SelectedButton)
			{
				ProcessKey(1);
				return;
			}
		}

		if (UWindowButton(C) != None)
		{
			PlayClick();
			for ( I=0; I<ArrayCount(KeyButtons); I++ )
			{
				if (KeyButtons[I] == C)
				{
					SelectedButton = UWindowButton(C);

					Selection = I;
					log("OptionPage '"$AliasNames1[selection] $"' clicked ...");

					bPolling = True;
					log ("Polling set to true");
					SelectedButton.bDisabled = True;

					return;
				}
			}
		}

		break;

	case DE_RClick:
		if (bPolling)
			{
				bPolling = False;
				SelectedButton.bDisabled = False;

				if(C == SelectedButton)
				{
					ProcessKey(2);
					return;
				}
			}
		break;

	case DE_MClick:
		if (bPolling)
			{
				bPolling = False;
				SelectedButton.bDisabled = False;

				if(C == SelectedButton)
				{
					ProcessKey(4);
					return;
				}			
			}
		break;
	}
}

defaultproperties
{
     optionsText="OPTIONS"
     videoText="Video"
     ResolutionText="Resolution"
     ColorDepthText="Color Depth"
     BitsText="bit"
     DetailLevel(0)="Very High"
     DetailLevel(1)="High"
     DetailLevel(2)="Medium"
     DetailLevel(3)="Low"
     DetailLevel(4)="Very Low"
     TextureDetailText="Texture Detail"
     ObjectDetailText="Object Detail"
     audioText="Audio"
     MusicVolumeText="Music Volume"
     SoundVolumeText="Sound Volume"
     controlText="Controls"
     mouseHiText="High"
     mouseLoText="Low"
     SensitivityText="Sensitivity"
     MouseSmoothText="Mouse Smoothing"
     ConfirmSettingsTitle="Confirm Video Settings Change"
     ConfirmSettingsText="Are you sure you wish to keep these new video settings?"
     ConfirmSettingsCancelTitle="Video Settings Change"
     ConfirmSettingsCancelText="Your previous video settings have been restored."
     KeyboardText="Keyboard"
     LocalizedKeyName(1)="LeftMouse"
     LocalizedKeyName(2)="RightMouse"
     LocalizedKeyName(3)="Cancel"
     LocalizedKeyName(4)="MiddleMouse"
     LocalizedKeyName(5)="Unknown05"
     LocalizedKeyName(6)="Unknown06"
     LocalizedKeyName(7)="Unknown07"
     LocalizedKeyName(8)="Backspace"
     LocalizedKeyName(9)="Tab"
     LocalizedKeyName(10)="Unknown0A"
     LocalizedKeyName(11)="Unknown0B"
     LocalizedKeyName(12)="Unknown0C"
     LocalizedKeyName(13)="Enter"
     LocalizedKeyName(14)="Unknown0E"
     LocalizedKeyName(15)="Unknown0F"
     LocalizedKeyName(16)="Shift"
     LocalizedKeyName(17)="Ctrl"
     LocalizedKeyName(18)="Alt"
     LocalizedKeyName(19)="Pause"
     LocalizedKeyName(20)="CapsLock"
     LocalizedKeyName(21)="Unknown15"
     LocalizedKeyName(22)="Unknown16"
     LocalizedKeyName(23)="Unknown17"
     LocalizedKeyName(24)="Unknown18"
     LocalizedKeyName(25)="Unknown19"
     LocalizedKeyName(26)="Unknown1A"
     LocalizedKeyName(27)="Escape"
     LocalizedKeyName(28)="Unknown1C"
     LocalizedKeyName(29)="Unknown1D"
     LocalizedKeyName(30)="Unknown1E"
     LocalizedKeyName(31)="Unknown1F"
     LocalizedKeyName(32)="Space"
     LocalizedKeyName(33)="PageUp"
     LocalizedKeyName(34)="PageDown"
     LocalizedKeyName(35)="End"
     LocalizedKeyName(36)="Home"
     LocalizedKeyName(37)="Left"
     LocalizedKeyName(38)="Up"
     LocalizedKeyName(39)="Right"
     LocalizedKeyName(40)="Down"
     LocalizedKeyName(41)="Select"
     LocalizedKeyName(42)="Print"
     LocalizedKeyName(43)="Execute"
     LocalizedKeyName(44)="PrintScrn"
     LocalizedKeyName(45)="Insert"
     LocalizedKeyName(46)="Delete"
     LocalizedKeyName(47)="Help"
     LocalizedKeyName(48)="0"
     LocalizedKeyName(49)="1"
     LocalizedKeyName(50)="2"
     LocalizedKeyName(51)="3"
     LocalizedKeyName(52)="4"
     LocalizedKeyName(53)="5"
     LocalizedKeyName(54)="6"
     LocalizedKeyName(55)="7"
     LocalizedKeyName(56)="8"
     LocalizedKeyName(57)="9"
     LocalizedKeyName(58)="Unknown3A"
     LocalizedKeyName(59)="Unknown3B"
     LocalizedKeyName(60)="Unknown3C"
     LocalizedKeyName(61)="Unknown3D"
     LocalizedKeyName(62)="Unknown3E"
     LocalizedKeyName(63)="Unknown3F"
     LocalizedKeyName(64)="Unknown40"
     LocalizedKeyName(65)="A"
     LocalizedKeyName(66)="B"
     LocalizedKeyName(67)="C"
     LocalizedKeyName(68)="D"
     LocalizedKeyName(69)="E"
     LocalizedKeyName(70)="F"
     LocalizedKeyName(71)="G"
     LocalizedKeyName(72)="H"
     LocalizedKeyName(73)="I"
     LocalizedKeyName(74)="J"
     LocalizedKeyName(75)="K"
     LocalizedKeyName(76)="L"
     LocalizedKeyName(77)="M"
     LocalizedKeyName(78)="N"
     LocalizedKeyName(79)="O"
     LocalizedKeyName(80)="P"
     LocalizedKeyName(81)="Q"
     LocalizedKeyName(82)="R"
     LocalizedKeyName(83)="S"
     LocalizedKeyName(84)="T"
     LocalizedKeyName(85)="U"
     LocalizedKeyName(86)="V"
     LocalizedKeyName(87)="W"
     LocalizedKeyName(88)="X"
     LocalizedKeyName(89)="Y"
     LocalizedKeyName(90)="Z"
     LocalizedKeyName(91)="Unknown5B"
     LocalizedKeyName(92)="Unknown5C"
     LocalizedKeyName(93)="Unknown5D"
     LocalizedKeyName(94)="Unknown5E"
     LocalizedKeyName(95)="Unknown5F"
     LocalizedKeyName(96)="NumPad0"
     LocalizedKeyName(97)="NumPad1"
     LocalizedKeyName(98)="NumPad2"
     LocalizedKeyName(99)="NumPad3"
     LocalizedKeyName(100)="NumPad4"
     LocalizedKeyName(101)="NumPad5"
     LocalizedKeyName(102)="NumPad6"
     LocalizedKeyName(103)="NumPad7"
     LocalizedKeyName(104)="NumPad8"
     LocalizedKeyName(105)="NumPad9"
     LocalizedKeyName(106)="GreyStar"
     LocalizedKeyName(107)="GreyPlus"
     LocalizedKeyName(108)="Separator"
     LocalizedKeyName(109)="GreyMinus"
     LocalizedKeyName(110)="NumPadPeriod"
     LocalizedKeyName(111)="GreySlash"
     LocalizedKeyName(112)="F1"
     LocalizedKeyName(113)="F2"
     LocalizedKeyName(114)="F3"
     LocalizedKeyName(115)="F4"
     LocalizedKeyName(116)="F5"
     LocalizedKeyName(117)="F6"
     LocalizedKeyName(118)="F7"
     LocalizedKeyName(119)="F8"
     LocalizedKeyName(120)="F9"
     LocalizedKeyName(121)="F10"
     LocalizedKeyName(122)="F11"
     LocalizedKeyName(123)="F12"
     LocalizedKeyName(124)="F13"
     LocalizedKeyName(125)="F14"
     LocalizedKeyName(126)="F15"
     LocalizedKeyName(127)="F16"
     LocalizedKeyName(128)="F17"
     LocalizedKeyName(129)="F18"
     LocalizedKeyName(130)="F19"
     LocalizedKeyName(131)="F20"
     LocalizedKeyName(132)="F21"
     LocalizedKeyName(133)="F22"
     LocalizedKeyName(134)="F23"
     LocalizedKeyName(135)="F24"
     LocalizedKeyName(136)="Unknown88"
     LocalizedKeyName(137)="Unknown89"
     LocalizedKeyName(138)="Unknown8A"
     LocalizedKeyName(139)="Unknown8B"
     LocalizedKeyName(140)="Unknown8C"
     LocalizedKeyName(141)="Unknown8D"
     LocalizedKeyName(142)="Unknown8E"
     LocalizedKeyName(143)="Unknown8F"
     LocalizedKeyName(144)="NumLock"
     LocalizedKeyName(145)="ScrollLock"
     LocalizedKeyName(146)="Unknown92"
     LocalizedKeyName(147)="Unknown93"
     LocalizedKeyName(148)="Unknown94"
     LocalizedKeyName(149)="Unknown95"
     LocalizedKeyName(150)="Unknown96"
     LocalizedKeyName(151)="Unknown97"
     LocalizedKeyName(152)="Unknown98"
     LocalizedKeyName(153)="Unknown99"
     LocalizedKeyName(154)="Unknown9A"
     LocalizedKeyName(155)="Unknown9B"
     LocalizedKeyName(156)="Unknown9C"
     LocalizedKeyName(157)="Unknown9D"
     LocalizedKeyName(158)="Unknown9E"
     LocalizedKeyName(159)="Unknown9F"
     LocalizedKeyName(160)="LShift"
     LocalizedKeyName(161)="RShift"
     LocalizedKeyName(162)="LControl"
     LocalizedKeyName(163)="RControl"
     LocalizedKeyName(164)="UnknownA4"
     LocalizedKeyName(165)="UnknownA5"
     LocalizedKeyName(166)="UnknownA6"
     LocalizedKeyName(167)="UnknownA7"
     LocalizedKeyName(168)="UnknownA8"
     LocalizedKeyName(169)="UnknownA9"
     LocalizedKeyName(170)="UnknownAA"
     LocalizedKeyName(171)="UnknownAB"
     LocalizedKeyName(172)="UnknownAC"
     LocalizedKeyName(173)="UnknownAD"
     LocalizedKeyName(174)="UnknownAE"
     LocalizedKeyName(175)="UnknownAF"
     LocalizedKeyName(176)="UnknownB0"
     LocalizedKeyName(177)="UnknownB1"
     LocalizedKeyName(178)="UnknownB2"
     LocalizedKeyName(179)="UnknownB3"
     LocalizedKeyName(180)="UnknownB4"
     LocalizedKeyName(181)="UnknownB5"
     LocalizedKeyName(182)="UnknownB6"
     LocalizedKeyName(183)="UnknownB7"
     LocalizedKeyName(184)="UnknownB8"
     LocalizedKeyName(185)="UnknownB9"
     LocalizedKeyName(186)="Semicolon"
     LocalizedKeyName(187)="Equals"
     LocalizedKeyName(188)="Comma"
     LocalizedKeyName(189)="Minus"
     LocalizedKeyName(190)="Period"
     LocalizedKeyName(191)="Slash"
     LocalizedKeyName(192)="Tilde"
     LocalizedKeyName(193)="UnknownC1"
     LocalizedKeyName(194)="UnknownC2"
     LocalizedKeyName(195)="UnknownC3"
     LocalizedKeyName(196)="UnknownC4"
     LocalizedKeyName(197)="UnknownC5"
     LocalizedKeyName(198)="UnknownC6"
     LocalizedKeyName(199)="UnknownC7"
     LocalizedKeyName(200)="Joy1"
     LocalizedKeyName(201)="Joy2"
     LocalizedKeyName(202)="Joy3"
     LocalizedKeyName(203)="Joy4"
     LocalizedKeyName(204)="Joy5"
     LocalizedKeyName(205)="Joy6"
     LocalizedKeyName(206)="Joy7"
     LocalizedKeyName(207)="Joy8"
     LocalizedKeyName(208)="Joy9"
     LocalizedKeyName(209)="Joy10"
     LocalizedKeyName(210)="Joy11"
     LocalizedKeyName(211)="Joy12"
     LocalizedKeyName(212)="Joy13"
     LocalizedKeyName(213)="Joy14"
     LocalizedKeyName(214)="Joy15"
     LocalizedKeyName(215)="Joy16"
     LocalizedKeyName(216)="UnknownD8"
     LocalizedKeyName(217)="UnknownD9"
     LocalizedKeyName(218)="UnknownDA"
     LocalizedKeyName(219)="LeftBracket"
     LocalizedKeyName(220)="Backslash"
     LocalizedKeyName(221)="RightBracket"
     LocalizedKeyName(222)="SingleQuote"
     LocalizedKeyName(223)="UnknownDF"
     LocalizedKeyName(224)="JoyX"
     LocalizedKeyName(225)="JoyY"
     LocalizedKeyName(226)="JoyZ"
     LocalizedKeyName(227)="JoyR"
     LocalizedKeyName(228)="MouseX"
     LocalizedKeyName(229)="MouseY"
     LocalizedKeyName(230)="MouseZ"
     LocalizedKeyName(231)="MouseW"
     LocalizedKeyName(232)="JoyU"
     LocalizedKeyName(233)="JoyV"
     LocalizedKeyName(234)="UnknownEA"
     LocalizedKeyName(235)="UnknownEB"
     LocalizedKeyName(236)="MouseWheelUp"
     LocalizedKeyName(237)="MouseWheelDown"
     LocalizedKeyName(238)="Unknown10E"
     LocalizedKeyName(239)="Unknown10F"
     LocalizedKeyName(240)="JoyPovUp"
     LocalizedKeyName(241)="JoyPovDown"
     LocalizedKeyName(242)="JoyPovLeft"
     LocalizedKeyName(243)="JoyPovRight"
     LocalizedKeyName(244)="UnknownF4"
     LocalizedKeyName(245)="UnknownF5"
     LocalizedKeyName(246)="Attn"
     LocalizedKeyName(247)="CrSel"
     LocalizedKeyName(248)="ExSel"
     LocalizedKeyName(249)="ErEof"
     LocalizedKeyName(250)="Play"
     LocalizedKeyName(251)="Zoom"
     LocalizedKeyName(252)="NoName"
     LocalizedKeyName(253)="PA1"
     LocalizedKeyName(254)="OEMClear"
     LabelList(0)="Forward"
     LabelList(1)="Back"
     LabelList(2)="Turn left"
     LabelList(3)="Turn right"
     LabelList(4)="Jump"
     LabelList(5)="Fire Wand"
     LabelList(6)="Speed up"
     LabelList(7)="Slow down"
     OrString=" or "
     AliasNames1(0)="MoveForward"
     AliasNames1(1)="MoveBackward"
     AliasNames1(2)="RotLeft"
     AliasNames1(3)="RotRight"
     AliasNames1(4)="Jump"
     AliasNames1(5)="AltFire"
     AliasNames1(6)="button bBroomBoost"
     AliasNames1(7)="button bBroomBrake"
     AliasNames2(0)="button bBroomPitchUp"
     AliasNames2(1)="button bBroomPitchDown"
     AliasNames2(2)="button bBroomYawLeft"
     AliasNames2(3)="button bBroomYawRight"
     AliasNames3(2)="StrafeLeft"
     AliasNames3(3)="StrafeRight"
     AutoJumpText="Auto Jump"
     InvertBroomText="Invert Broom"
     DifficultyText="Difficulty"
     DifficultyLevel(0)="Easy"
     DifficultyLevel(1)="Medium"
     DifficultyLevel(2)="Hard"
     PurpleColour=(R=80,G=5,B=100)
     BlueColour=(R=30,G=40,B=220)
     vertSpacing(0)=38
     vertSpacing(1)=40
     vertSpacing(2)=36
     vertSpacing(3)=38
     vertSpacing(4)=40
     vertSpacing(5)=38
     vertSpacing(6)=40
     vertSpacing(7)=40
}
