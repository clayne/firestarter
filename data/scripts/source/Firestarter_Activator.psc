ScriptName Firestarter_Activator extends ObjectReference
{An attempt at a no-state activator.}

import PO3_SKSEFunctions

; Game data we need to use for all of them.
Sound property pFailureSound auto
MiscObject property Firewood01 auto
Formlist property FS_Smokers_List auto

; Activator-specific data, set in the CK.
bool property pActivationAdvancesState auto
bool property pActivationCostsFirewood auto
; should be a property, but hard-coding for now
int kFirewoodCost = 3
Activator property pActivationState auto

; Does this campfire state have a timer?
bool property pHasTimer auto
float property pTimerLen auto ; this is in hours; must be converted to days
Activator property pTimerState auto

bool bIsManaged = false
bool bNeedsDelete = true

function initializeFireState()
    bIsManaged = true
    if pHasTimer
        RegisterForSingleUpdateGameTime(0.124)
    endif
endFunction

; We squash very very nearby smoke chimney objects, otherwise we'll have
; baffling smoke rising from dead fires. :(
function stifleSmokers()
    ObjectReference[] smokers = FindAllReferencesOfType(self, FS_Smokers_List, 300.0)
    int i = 0
    while i < smokers.Length
        ObjectReference ref = smokers[i]
        ref.Disable(true)
        i += 1
    endWhile
endFunction

; Called when the player activates the item, and also when this is
; first instantiated in the world.
event OnActivate(ObjectReference akActionRef)
    if !bIsManaged
        self.stifleSmokers()
        bNeedsDelete = false
        self.initializeFireState()
    endif

    Actor player = Game.GetPlayer()

    if pActivationAdvancesState
        if pActivationCostsFirewood
            ; if player has 3 firewood, take them & fuel the fire
            if player.GetItemCount(Firewood01) >= kFirewoodCost
                player.RemoveItem(Firewood01, kFirewoodCost)
                replaceSelf(pActivationState)
            else
                Debug.Notification("You need at least " + kFirewoodCost + " firewood to stoke the fire.")
                pFailureSound.Play(player)
            endif
        else
            replaceSelf(pActivationState)
        endif
        ; There might be an else here to handle cooking. IDEK.
    endif
endEvent

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
    nextState.initializeFireState()

    if bNeedsDelete
        Utility.Wait(0.1)
        self.Delete()
    endIf

endFunction
