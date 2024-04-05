;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
ScriptName Firestarter_DAK_Perk extends Perk

import Firestarter_Activator

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
    ;BEGIN CODE

	Firestarter_Activator campfire = akTargetRef as Firestarter_Activator
	if campfire
		campfire.doDakActivate()
	endIf

    ;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
