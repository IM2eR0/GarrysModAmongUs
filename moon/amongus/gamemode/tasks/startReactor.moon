taskTable = {
	Type: GM.TaskType.Common
	Time: 20
}

if CLIENT
	taskTable.CreateVGUI = =>
		return with vgui.Create "AmongUsTaskBase"
			\Setup with vgui.Create "AmongUsTaskPlaceholder"
				\SetTime taskTable.Time + CurTime!
			\Popup!

return taskTable
