ScriptName Firestarter_QuestEvents extends ReferenceAlias

Actor property PlayerRef Auto

; These are the perks that allow us to conditionally check the dynamic
; activation key and trigger a different script fragment if it's pressed.
Perk property FS_DAK_Tend_Perk Auto
Perk property FS_DAK_Sleep_Perk Auto
Perk property FS_DAK_Starter_Perk Auto

event onInit()
	PlayerRef.AddPerk(FS_DAK_Tend_Perk)
	PlayerRef.AddPerk(FS_DAK_Sleep_Perk)
	PlayerRef.AddPerk(FS_DAK_Starter_Perk)
endEvent
