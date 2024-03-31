Scriptname CFAnim_PlayerAliasScript extends ReferenceAlias

Actor Property PlayerRef Auto

FormList Property CFAnim_WoodList Auto
FormList Property CFAnim_WoodShavingList Auto
FormList Property CFAnim_FoodList Auto
FormList Property CFAnim_BookList Auto
FormList Property CFAnim_AddWoodList Auto
FormList Property CFAnim_AddTinderList Auto
FormList Property CFAnim_AddFuelList Auto
FormList Property CFAnim_IgnoreList Auto

Furniture Property _Camp_Campfire Auto

GlobalVariable Property _Camp_LastUsedCampfireSize Auto
GlobalVariable Property CFAnim_Trigger Auto
GlobalVariable Property CFAnim_ToggleMenu Auto
GlobalVariable Property CFAnim_InterruptAnimations Auto
GlobalVariable Property CFAnim_EnableAddFuel Auto
GlobalVariable Property CFAnim_EnableAddTinder Auto
GlobalVariable Property CFAnim_EnableReplenishFuel Auto
GlobalVariable Property CFAnim_EnableChopWood Auto
GlobalVariable Property CFAnim_EnableShaveWood Auto
GlobalVariable Property CFAnim_EnableTearBook Auto
GlobalVariable Property CFAnim_EnableCookFood Auto
GlobalVariable Property CFAnim_RepeatChopWood Auto
GlobalVariable Property CFAnim_RepeatReplenishFuel Auto
GlobalVariable Property CFAnim_RepeatTearBook Auto
GlobalVariable Property CFAnim_RepeatShaveWood Auto
GlobalVariable Property CFAnim_RepeatCookFood Auto

Float iIdleValue
Float fScale
Float[] fPositionArray
Float[] fRotationArray

Bool isBusy
Bool doCancel
Bool dontChop
Bool[] bDontRepeatArray

Form fDisplayItem
Form fDisplaySecondaryItem

Event OnSit(ObjectReference akFurniture)

    Form baseForm = akFurniture.GetBaseObject()
	If baseForm.HasKeywordString("Camping_CampfireCookingShared") || baseForm.HasKeywordString("CraftingCampfire") || baseForm.HasKeywordString("_Camp_Crafting_Campfire")
		If _Camp_LastUsedCampfireSize.GetValue() >= 1
			CFAnim_Trigger.SetValue(100)
		Else
			CFAnim_Trigger.SetValue(10)
		EndIf

		iIdleValue = CFAnim_Trigger.GetValue()
		Utility.Wait(0.2)
		bDontRepeatArray = New Bool [5]
		dontChop = False
		GoToState("Campfire")
	EndIf
EndEvent

State Campfire
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		fDisplaySecondaryItem = akBaseItem

		If CFAnim_AddFuelList.HasForm(akBaseItem) && CFAnim_EnableAddFuel.GetValue()
			If !isBusy || CFAnim_InterruptAnimations.GetValue()
				DoAnim(20)
			EndIf
		ElseIf CFAnim_AddTinderList.HasForm(akBaseItem) && CFAnim_EnableAddTinder.GetValue()
			If !isBusy || CFAnim_InterruptAnimations.GetValue()
				DoAnim(30)
			EndIf
		ElseIf CFAnim_BookList.HasForm(akBaseItem) && CFAnim_EnableTearBook.GetValue()
			If !isBusy || CFAnim_InterruptAnimations.GetValue()
				If !bDontRepeatArray[0] || CFAnim_RepeatTearBook.GetValue()
					DoAnim(40)
					bDontRepeatArray[0] = True
				EndIf
			EndIf
		ElseIf CFAnim_WoodList.HasForm(akBaseItem) && CFAnim_EnableChopWood.GetValue()
			If !isBusy || CFAnim_InterruptAnimations.GetValue()
				If !bDontRepeatArray[1] || CFAnim_RepeatChopWood.GetValue()
					DoAnim(50)
				EndIf
			EndIf
		ElseIf CFAnim_WoodShavingList.HasForm(akBaseItem) && CFAnim_EnableShaveWood.GetValue()
			If !isBusy || CFAnim_InterruptAnimations.GetValue()
				If !bDontRepeatArray[2] || CFAnim_RepeatShaveWood.GetValue()
					DoAnim(60)
					bDontRepeatArray[2] = True
				EndIf
			EndIf
		ElseIf CFAnim_AddWoodList.HasForm(akBaseItem) && CFAnim_EnableReplenishFuel.GetValue()
			If !isBusy || CFAnim_InterruptAnimations.GetValue()
				If !bDontRepeatArray[3] || CFAnim_RepeatReplenishFuel.GetValue()
					DoAnim(70)
					bDontRepeatArray[3] = True
				EndIf
			EndIf
		EndIf
	EndEvent

	Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		If !CFAnim_IgnoreList.HasForm(akBaseItem)
			fDisplayItem = akBaseItem

			If CFAnim_FoodList.HasForm(akBaseItem) && CFAnim_EnableCookFood.GetValue()
				If !isBusy || CFAnim_InterruptAnimations.GetValue()
					If !bDontRepeatArray[4] || CFAnim_RepeatCookFood.GetValue()
						DoAnim(80)
						bDontRepeatArray[4] = True
					EndIf
				EndIf
			EndIf
		Else
			dontChop = True
		EndIf
	EndEvent

	Event OnGetUp(ObjectReference akFurniture)
		CFAnim_Trigger.SetValue(0)
		GoToState("")
	EndEvent
EndState

Function DoAnim(Int iAnimationType)
	isBusy = True
	doCancel = True

	If CFAnim_ToggleMenu.GetValue()
		PO3_SKSEFunctions.HideMenu("Crafting Menu")
	EndIf

	Utility.Wait(0.1)
	doCancel = False

	If iAnimationType == 20 ; Add fuel
		CFAnim_Trigger.SetValue(iAnimationType)
		If IED.GetScriptVersion()
			CreateDisplays(1)
		Else
			WaitForCancel(2.1)
		EndIf
	ElseIf iAnimationType == 30 ; Add tinder
		CFAnim_Trigger.SetValue(iAnimationType)
		If IED.GetScriptVersion()
			CreateDisplays(2)
		Else
			WaitForCancel(2.1)
		EndIf
	ElseIf iAnimationType == 40 ; Tearing book
		CFAnim_Trigger.SetValue(iAnimationType)
		WaitForCancel(1.8)
	ElseIf iAnimationType == 50 ; Chopping wood
		If !dontChop
			CFAnim_Trigger.SetValue(iAnimationType)
			bDontRepeatArray[1] = True
			If IED.GetScriptVersion()
				CreateDisplays(4)
			Else
				WaitForCancel(7.5)
			EndIf
		EndIf
	ElseIf iAnimationType == 60 ; Shaving wood
		CFAnim_Trigger.SetValue(iAnimationType)
		WaitForCancel(3.3)
	ElseIf iAnimationType == 70 ; Replenishing fuel
		CFAnim_Trigger.SetValue(iAnimationType)
		If IED.GetScriptVersion()
			CreateDisplays(5)
		Else
			WaitForCancel(1.6)
		EndIf
		iIdleValue = 100
	ElseIf iAnimationType == 80 ; Cooking
		CFAnim_Trigger.SetValue(iAnimationType)
		If IED.GetScriptVersion()
			CreateDisplays(6)
		Else
			WaitForCancel(7.8)
		EndIf
	EndIf

	If CFAnim_ToggleMenu.GetValue()
		PO3_SKSEFunctions.ShowMenu("Crafting Menu")
	EndIf

	CFAnim_Trigger.SetValue(iIdleValue)
	isBusy = False
	dontChop = False
EndFunction

Function WaitForCancel(Float fTimeToWait)
	If fTimeToWait > 0
		Float fTimeFrag = fTimeToWait / 10
		While fTimeToWait && PlayerRef.GetAnimationVariableBool("bAnimationDriven") && !doCancel
			Utility.Wait(fTimeFrag)
			fTimeToWait -= fTimeFrag
		EndWhile
	EndIf
EndFunction

Function CreateDisplays(Int iTypeOfDisplay)
	Bool isPlayerFemale = PlayerRef.GetActorBase().GetSex()
	If iTypeOfDisplay == 1 ; Add Fuel
		SetItemTransform(iTypeOfDisplay, fDisplayItem)

		If !IED.ItemExistsActor(PlayerRef, "Campfire Animations.esp",  "AddFuel")
			IED.CreateItemActor(PlayerRef, "Campfire Animations.esp", "AddFuel", isPlayerFemale, fDisplayItem, False, "AnimObjectR")
		Else
			IED.SetItemFormActor(PlayerRef, "Campfire Animations.esp", "AddFuel", isPlayerFemale, fDisplayItem)
		EndIf

		IED.SetItemPositionActor(PlayerRef, "Campfire Animations.esp", "AddFuel", isPlayerFemale, fPositionArray)
		IED.SetItemRotationActor(PlayerRef, "Campfire Animations.esp", "AddFuel", isPlayerFemale, fRotationArray)
		IED.SetItemScaleActor(PlayerRef, "Campfire Animations.esp", "AddFuel", isPlayerFemale, fScale)

		Utility.Wait(0.2)
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "AddFuel", isPlayerFemale, True)
		Utility.Wait(0.9)
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "AddFuel", isPlayerFemale, False)
		Utility.Wait(0.7)
	ElseIf iTypeOfDisplay == 2 ; Add Tinder
		SetItemTransform(iTypeOfDisplay, fDisplayItem)

		If !IED.ItemExistsActor(PlayerRef, "Campfire Animations.esp",  "AddTinder")
			IED.CreateItemActor(PlayerRef, "Campfire Animations.esp", "AddTinder", isPlayerFemale, fDisplayItem, False, "AnimObjectR")
		Else
			IED.SetItemFormActor(PlayerRef, "Campfire Animations.esp", "AddTinder", isPlayerFemale, fDisplayItem)
		EndIf

		IED.SetItemPositionActor(PlayerRef, "Campfire Animations.esp", "AddTinder", isPlayerFemale, fPositionArray)
		IED.SetItemRotationActor(PlayerRef, "Campfire Animations.esp", "AddTinder", isPlayerFemale, fRotationArray)
		IED.SetItemScaleActor(PlayerRef, "Campfire Animations.esp", "AddTinder", isPlayerFemale, fScale)

		Utility.Wait(0.2)
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "AddTinder", isPlayerFemale, True)
		Utility.Wait(0.9)
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "AddTinder", isPlayerFemale, False)
		Utility.Wait(0.7)
	ElseIf iTypeOfDisplay == 4 ; Chop wood
		Float fCurrentTime = Utility.GetCurrentRealTime()
		SetItemTransform(iTypeOfDisplay, fDisplayItem)
		Utility.Wait(0.2)

		If !IED.ItemExistsActor(PlayerRef, "Campfire Animations.esp",  "WoodBlockA")
			IED.CreateItemActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fDisplayItem, False, "AnimObjectA")
		Else
			IED.SetItemFormActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fDisplayItem)
		EndIf

		IED.SetItemScaleActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fScale)
		IED.SetItemPositionActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fPositionArray)
		IED.SetItemRotationActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fRotationArray)
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, True)

		fDisplayItem = Game.GetFormFromFile(0x0000808, "Campfire Animations.esp")
		SetItemTransform(iTypeOfDisplay, fDisplayItem, 1)

		If !IED.ItemExistsActor(PlayerRef, "Campfire Animations.esp",  "WoodBlockB")
			IED.CreateItemActor(PlayerRef, "Campfire Animations.esp", "WoodBlockB", isPlayerFemale, fDisplayItem, False, "AnimObjectB")
		Else
			IED.SetItemFormActor(PlayerRef, "Campfire Animations.esp", "WoodBlockB", isPlayerFemale, fDisplayItem)
		EndIf

		IED.SetItemScaleActor(PlayerRef, "Campfire Animations.esp", "WoodBlockB", isPlayerFemale, fScale)
		IED.SetItemPositionActor(PlayerRef, "Campfire Animations.esp", "WoodBlockB", isPlayerFemale, fPositionArray)
		IED.SetItemRotationActor(PlayerRef, "Campfire Animations.esp", "WoodBlockB", isPlayerFemale, fRotationArray)

		SetItemTransform(iTypeOfDisplay, fDisplayItem, 2)
		WaitForCancel(3.65 - (Utility.GetCurrentRealTime() - fCurrentTime))
		fCurrentTime = Utility.GetCurrentRealTime()

		IED.SetItemFormActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fDisplayItem)
		IED.SetItemScaleActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fScale)
		IED.SetItemPositionActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fPositionArray)
		IED.SetItemRotationActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, fRotationArray)

		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "WoodBlockB", isPlayerFemale, True)

		WaitForCancel(3.0 - (Utility.GetCurrentRealTime() - fCurrentTime))
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "WoodBlockA", isPlayerFemale, False)
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "WoodBlockB", isPlayerFemale, False)
	ElseIf iTypeOfDisplay == 5 ; Adding wood
		SetItemTransform(iTypeOfDisplay, fDisplayItem)

		If !IED.ItemExistsActor(PlayerRef, "Campfire Animations.esp",  "AddWood")
			IED.CreateItemActor(PlayerRef, "Campfire Animations.esp", "AddWood", isPlayerFemale, fDisplayItem, False, "AnimObjectB")
		Else
			IED.SetItemFormActor(PlayerRef, "Campfire Animations.esp", "AddWood", isPlayerFemale, fDisplayItem)
		EndIf

		IED.SetItemPositionActor(PlayerRef, "Campfire Animations.esp", "AddWood", isPlayerFemale, fPositionArray)
		IED.SetItemRotationActor(PlayerRef, "Campfire Animations.esp", "AddWood", isPlayerFemale, fRotationArray)
		IED.SetItemScaleActor(PlayerRef, "Campfire Animations.esp", "AddWood", isPlayerFemale, fScale)
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "AddWood", isPlayerFemale, True)
		Utility.Wait(1.2)
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "AddWood", isPlayerFemale, False)
	ElseIf iTypeOfDisplay == 6 ; Cooking
		; Raw food on stick
		Float fCurrentTime = Utility.GetCurrentRealTime()
		SetItemTransform(iTypeOfDisplay, fDisplayItem)

		If !IED.ItemExistsActor(PlayerRef, "Campfire Animations.esp", "CookingFood")
			IED.CreateItemActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fDisplayItem, False, "NPC R Hand [RHnd]")
		Else
			IED.SetItemFormActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fDisplayItem)
			IED.SetItemNodeActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale,  "NPC R Hand [RHnd]")
		EndIf

		IED.SetItemScaleActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fScale)
		IED.SetItemPositionActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fPositionArray)
		IED.SetItemRotationActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fRotationArray)
		Utility.Wait(1.2)

		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, True)

		SetItemTransform(iTypeOfDisplay, fDisplaySecondaryItem)
		WaitForCancel(4.2 - (Utility.GetCurrentRealTime() - fCurrentTime))
		fCurrentTime = Utility.GetCurrentRealTime()
		; Cooked food on stick
		IED.SetItemFormActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fDisplaySecondaryItem)
		IED.SetItemScaleActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fScale)
		IED.SetItemPositionActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fPositionArray)
		IED.SetItemRotationActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, fRotationArray)

		WaitForCancel(3.0 - (Utility.GetCurrentRealTime() - fCurrentTime))
		IED.SetItemEnabledActor(PlayerRef, "Campfire Animations.esp", "CookingFood", isPlayerFemale, False)

		Utility.Wait(0.30)
	EndIf
EndFunction

; --- Function to set transform for the displays. If PapyrusUtil is installed, then reads from json, otherwise sets default values
;
Function SetItemTransform(Int iTypeOfTransform, Form fItemtoFind, Int iTypeOfItem = 0)
	fPositionArray = New Float[3]
	fRotationArray = New Float[3]
	If iTypeOfTransform == 1 ; Adding Fuel Animation
		If !ReadTransformFromJson("BuildFireList", "BuildFireDefault", fItemtoFind.GetWorldModelPath())
			fPositionArray[0] = 0
			fPositionArray[1] = 0
			fPositionArray[2] = 0
			fRotationArray[0] = 0
			fRotationArray[1] = 0
			fRotationArray[2] = 0
			fScale = 1
		EndIf
	ElseIf iTypeOfTransform == 2 ; Adding Tinder Animation
		If !ReadTransformFromJson("BuildFireList", "BuildFireDefault", fItemtoFind.GetWorldModelPath())
			fPositionArray[0] = 0
			fPositionArray[1] = 0
			fPositionArray[2] = 0
			fRotationArray[0] = 0
			fRotationArray[1] = 0
			fRotationArray[2] = 0
			fScale = 1
		EndIf
	ElseIf iTypeOfTransform == 4 ; Chopping Wood Animation
		If iTypeOfItem == 0 ; Main item to chop
			If !ReadTransformFromJson("WoodList", "WoodDefault", fItemtoFind.GetWorldModelPath())
				fPositionArray[0] = 0
				fPositionArray[1] = 10
				fPositionArray[2] = 11
				fRotationArray[0] = 180
				fRotationArray[1] = 0
				fRotationArray[2] = 90
				fScale = 1
			EndIf
		ElseIf iTypeOfItem == 1 ; Wood block A
			fPositionArray[0] = -1
			fPositionArray[1] = 17
			fPositionArray[2] = 9
			fRotationArray[0] = 0
			fRotationArray[1] = 0
			fRotationArray[2] = 0
			fScale = 1
		Else ; Wood block B
			fPositionArray[0] = 5
			fPositionArray[1] = 15.5
			fPositionArray[2] = 9
			fRotationArray[0] = 0
			fRotationArray[1] = 0
			fRotationArray[2] = 0
			fScale = 1
		EndIf
	ElseIf iTypeOfTransform == 5 ; Replenishing Fuel Animation
		If !ReadTransformFromJson("FuelList", "FuelDefault", fItemtoFind.GetWorldModelPath())
			fPositionArray[0] = 4
			fPositionArray[1] = 1
			fPositionArray[2] = 27.5
			fRotationArray[0] = -71.5
			fRotationArray[1] = 6.5
			fRotationArray[2] = 92.5
			fScale = 0.73
		EndIf
	ElseIf iTypeOfTransform == 6 ; Cooking Animation
		If !ReadTransformFromJson("CookingList", "CookingDefault", fItemtoFind.GetWorldModelPath())
			fPositionArray[0] = 21
			fPositionArray[1] = -2.5
			fPositionArray[2] = 9.5
			fRotationArray[0] = -90
			fRotationArray[1] = 0
			fRotationArray[2] = 60
			fScale = 1
		EndIf
	EndIf
EndFunction

Bool Function ReadTransformFromJson(String sFileName, String sDefault, String sModelPath)
	; Checks if PapyrusUtil is installed
	If !PapyrusUtil.GetScriptVersion()
		Return False
	EndIf

	String sFilePath = "../StorageUtilData/CampfireAnim/"

	String sItemNif = sModelPath
	; Gets model path and splits it with the delimiter '\' to get the mesh file name
	If StringUtil.Find(sModelPath, "\\") != -1
		String [] sModelPathArray = StringUtil.Split(sModelPath, "\\" )
		sItemNif = sModelPathArray[sModelPathArray.Length - 1]
	EndIf

	; Finds additional files in the folder. This is useful if someone decides to make patch for other items; It's possible to create new files with the same names, but with a prefix/suffix.
	; Example: CookingList_SomeCampfireMod.json
	; The functions below will try to look for the sItemNif in the file above first, then search the default files if not found.
	String[] sFolderArray = JsonUtil.JsonInFolder(sFilePath)
	String sFileNameDefault = sFileName
	Int iArrayIndex = sFolderArray.Length
	Bool doBreak

	If iArrayIndex > 4 ;  If the number of files in the folder is not greater than 4(default configs), there is no need to search for additional files.
		While iArrayIndex && !doBreak
			iArrayIndex -= 1
			If StringUtil.Find(sFolderArray[iArrayIndex], sFileName) != -1 && (sFileName + ".json") != sFolderArray[iArrayIndex]
				If JsonUtil.FloatListCount(sFilePath + sFolderArray[iArrayIndex], sItemNif) > 0
					sFileName = sFolderArray[iArrayIndex]
					doBreak = True
				EndIf
			EndIf
		EndWhile
	EndIf

	; Checks integrity of file
	If !JsonUtil.IsGood(sFilePath + sFileName)
		Return False
	EndIf

	If JsonUtil.FloatListCount(sFilePath + sFileName, sItemNif) > 0 ; Checks if the form has config
		fPositionArray[0] = JsonUtil.FloatListGet(sFilePath + sFileName, sItemNif, 0)
		fPositionArray[1] = JsonUtil.FloatListGet(sFilePath + sFileName, sItemNif, 1)
		fPositionArray[2] = JsonUtil.FloatListGet(sFilePath + sFileName, sItemNif, 2)
		fRotationArray[0] = JsonUtil.FloatListGet(sFilePath + sFileName, sItemNif, 3)
		fRotationArray[1] = JsonUtil.FloatListGet(sFilePath + sFileName, sItemNif, 4)
		fRotationArray[2] = JsonUtil.FloatListGet(sFilePath + sFileName, sItemNif, 5)
		fScale = JsonUtil.FloatListGet(sFilePath + sFileName, sItemNif, 6)
	ElseIf JsonUtil.FloatListCount(sFilePath + sFileNameDefault, sDefault) > 0 ; If not, then read default values
		fPositionArray[0] = JsonUtil.FloatListGet(sFilePath + sFileNameDefault, sDefault, 0)
		fPositionArray[1] = JsonUtil.FloatListGet(sFilePath + sFileNameDefault, sDefault, 1)
		fPositionArray[2] = JsonUtil.FloatListGet(sFilePath + sFileNameDefault, sDefault, 2)
		fRotationArray[0] = JsonUtil.FloatListGet(sFilePath + sFileNameDefault, sDefault, 3)
		fRotationArray[1] = JsonUtil.FloatListGet(sFilePath + sFileNameDefault, sDefault, 4)
		fRotationArray[2] = JsonUtil.FloatListGet(sFilePath + sFileNameDefault, sDefault, 5)
		fScale = JsonUtil.FloatListGet(sFilePath + sFileNameDefault, sDefault, 6)
	Else ; Didn't find config, return false
		Return False
	EndIf

	Return True
EndFunction
