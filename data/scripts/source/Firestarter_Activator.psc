ScriptName Firestarter_Activator extends ObjectReference
{An attempt at a no-state activator.}

import PO3_SKSEFunctions
import FS_Data

FS_Data property pData auto

; Activator-specific data, set in the CK.
bool property pActivationAdvancesState auto
bool property pActivationCostsFirewood auto
Activator property pNextState auto

; Does this campfire state have a timer?
bool property pHasTimer auto
float property pTimerLen auto ; this is in hours; must be converted to days
Activator property pTimerState auto

; This variation's state, so the DAK perk script
; can know what to do for this specific campfire.
String property pStateName auto

; should be a setting, but hard-coding for now
int kFirewoodCost = 3

bool bIsManaged = false
bool bNeedsDelete = true

function startManaging()
    GoToState(self.pStateName)
    bIsManaged = true
    if pHasTimer
        RegisterForSingleUpdateGameTime(0.124)
    endif
endFunction

; We squash very very nearby smoke chimney objects, otherwise we'll have
; baffling smoke rising from dead fires. :(
function stifleSmokers()
    ObjectReference[] smokers = FindAllReferencesOfType(self, pData.FS_Smokers_List, 300.0)
    int i = 0
    while i < smokers.Length
        ObjectReference ref = smokers[i]
        ref.Disable(true)
        i += 1
    endWhile
endFunction

event OnActivate(ObjectReference akActionRef)
    doNormalActivate()
endEvent

function doNormalActivate()
    if !bIsManaged
        self.stifleSmokers()
        bNeedsDelete = false
        self.startManaging()
    endif

    if pActivationAdvancesState
        self.advanceToNextState()
    endif
endFunction

; Called when the timer expires. If we have a next state, we move to it.
Event OnUpdateGameTime()
    if pTimerState != None
        replaceSelf(pTimerState)
    endif
EndEvent

function replaceSelf(Activator next)
    self.UnregisterForUpdateGameTime()
    Firestarter_Activator nextState = self.placeAtMe(next) as Firestarter_Activator
	nextState.SetScale(self.getScale())
	nextState.SetAngle(self.GetAngleX(), self.GetAngleY(), self.GetAngleZ())
	nextState.SetPosition(self.GetPositionX(), self.GetPositionY(), self.GetPositionZ())
	self.Disable(true)
    Utility.Wait(0.1)
    nextState.startManaging()

    if bNeedsDelete
        Utility.Wait(0.1)
        self.Delete()
    endIf

endFunction

function advanceToNextState()
    if !pNextState
        return
    endif

    Actor player = Game.GetPlayer()
    if pActivationCostsFirewood
        ; if player has 3 firewood, take them & fuel the fire
        if player.GetItemCount(pData.Firewood01) >= kFirewoodCost
            player.RemoveItem(pData.Firewood01, kFirewoodCost)
            replaceSelf(pNextState)
        else
            ; TODO translations
            Debug.Notification("You need at least " + kFirewoodCost + " firewood to stoke the fire.")
            pData.UIActivateFail.Play(player)
        endif
    else
        replaceSelf(pNextState)
    endif
endFunction

function useTempFurniture(Furniture furnType)
    ; This code is adapted from Hunterborn's source.
	Actor player = Game.GetPlayer()
	ObjectReference furnitureMarker = player.PlaceAtMe(furnType)
	furnitureMarker.Activate(player)

	; Wait for it to be in use.
	int i = 0
	While !furnitureMarker.IsFurnitureInUse() && i < 100
		i += 1
		Utility.Wait(0.1)
	EndWhile

	; Then wait for it NOT to be in use.
	While furnitureMarker.IsFurnitureInUse()
		Utility.Wait(1)
	EndWhile

	If furnitureMarker
		furnitureMarker.Disable()
		Utility.Wait(0.1)
		furnitureMarker.Delete()
	EndIf
endFunction

; We need versions of our state-varying functions in the empty state.
function doDakActivate()
    ; no-op
endFunction

state State_Clean
    event OnActivate(ObjectReference akActionRef)
        doNormalActivate()
    endEvent

    function doDakActivate()
        ; open up container
    endFunction
endState

state State_Fueled
    event OnActivate(ObjectReference akActionRef)
        doNormalActivate()
    endEvent

    function doDakActivate()
        ; do something only if campfire is installed
    endFunction
endState

state State_Kindled
    event OnActivate(ObjectReference akActionRef)
        ; I am unsure
    endEvent

    function doDakActivate()
        ; do something only if campfire is installed
    endFunction
endState

state State_Burning
    event OnActivate(ObjectReference akActionRef)
        useTempFurniture(pData.FS_Furn_CookingMarker)
    endEvent

    function doDakActivate()
        doNormalActivate()
    endFunction
endState

state State_Roaring
    event OnActivate(ObjectReference akActionRef)
        useTempFurniture(pData.FS_Furn_CookingMarker)
    endEvent

    function doDakActivate()
        useTempFurniture(pData.BedrollGround)
    endFunction
endState

state State_Dying
    event OnActivate(ObjectReference akActionRef)
        doNormalActivate()
    endEvent

    function doDakActivate()
        ; douse fire, get back 2 charcoal
        Actor player = Game.GetPlayer()
        player.addItem(pData.Charcoal, 2)
        ; this speeds up going to the ashes states
        replaceSelf(pTimerState)
    endFunction
endState

state State_Ashes
    event OnActivate(ObjectReference akActionRef)
        doNormalActivate()
    endEvent

    function doDakActivate()
        ; IDK
    endFunction
endState
