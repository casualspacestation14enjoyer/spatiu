//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/hotkeys_help()
	set name = "zHelp-Controls"
	set category = "Options"

	mob.hotkey_help()


/mob/proc/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\tw = north
\ta = west
\ts = south
\td = east
\tq = left hand
\te = right hand
\tr = throw
\tf = fixed eye (strafing mode)
\tSHIFT + f = look up
\tz = drop
\tx = cancel / resist grab
\tc = parry/dodge
\tv = stand up / lay down
\t1 thru 4 = change intent (current hand)
\tmouse wheel = change aim height
\tg = give
\t<B></B>h = bite
\tj = jump
\tk = kick
\tl = steal
\tt = say something
\tALT = sprint
\tCTRL + ALT = sneak
\tLMB = Use intent/Interact (Hold to channel)
\tRMB = Special Interaction
\tMMB = give/kick/jump/steal/spell
\tMMB (no intent) = Special Interaction
\tSHIFT + LMB = Examine something
\tSHIFT + RMB = Focus
\tCTRL + LMB = TileAtomList
\tCTRL + RMB = Point at something
</font>"}

	to_chat(src, hotkey_mode)

/client/verb/set_fixed()
	set name = "IconSize"
	set category = "Options"

	if(winget(src, "mapwindow.map", "icon-size") == "64")
		to_chat(src, "Stretch-to-fit... OK")
		winset(src, "mapwindow.map", "icon-size=0")
	else
		to_chat(src, "64x... OK")
		winset(src, "mapwindow.map", "icon-size=64")

/client/verb/changefps()
	set category = "Options"
	set name = "ChangeFPS"
	if(!prefs)
		return
	var/newfps = input(usr, "Enter new FPS", "New FPS", 100) as null|num
	if (!isnull(newfps))
		prefs.clientfps = clamp(newfps, 1, 1000)
		fps = prefs.clientfps
		prefs.save_preferences()

/*
/client/verb/set_blur()
	set name = "AAOn"
	set category = "Options"

	winset(src, "mapwindow.map", "zoom-mode=blur")

/client/verb/set_normal()
	set name = "AAOff"
	set category = "Options"

	winset(src, "mapwindow.map", "zoom-mode=normal")*/
