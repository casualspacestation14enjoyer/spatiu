/obj/machinery/kaos/spatiuputer
	name = "computer"
	desc = "Computing..."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "old"
	var/on = FALSE
	anchored = TRUE
	density = FALSE
	var/sysfile = "vitals_os" // flavor
	var/executefromdisk = FALSE // run command programs from floppy
	var/obj/item/floppy/disk
	var/list/recentcommands = list()

/obj/machinery/kaos/spatiuputer/attack_hand(mob/user)
	if(on)
		return ..()
	playsound(src, "button", 60)
	sleep(4)
	playsound(src, 'sound/effects/computer/bootup.ogg', 60)
	on = TRUE
	update_icon()

/obj/machinery/kaos/spatiuputer/RightClick(mob/living/user)
	if(user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_RESTRAINED|INCAPACITATION_KNOCKOUT))
		return
	if(!on)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		playsound(src, "keyboardlong", 40)
		var/command = input(H, "Command Prompt", name)
		if(!command)
			return
		processcommand(command, H)

/obj/machinery/kaos/spatiuputer/Initialize(mapload, d)
	. = ..()
	update_icon()

/obj/machinery/kaos/spatiuputer/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]0"
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]b"

/obj/machinery/kaos/spatiuputer/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if (!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/kaos/spatiuputer/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/floppy))
		if(!on)
			return
		user.drop_item()
		O.forceMove(src)
		disk = O
		playsound(src, 'sound/effects/computer/bootup.ogg', 60)
		return
	return ..()

/obj/machinery/kaos/spatiuputer/proc/sendmessage(var/message, var/mob/living/L)
	recentcommands += message
	to_chat(L, "<font color=#4af626>[message]</font>")

/obj/machinery/kaos/spatiuputer/proc/send2logs(var/message, var/mob/living/L)
	recentcommands += message

/obj/machinery/kaos/spatiuputer/proc/processcommand(var/command, var/mob/living/carbon/human/H)
	if(!command || !H)
		return
	playsound(src, "keyboardlong", 40)
	sendmessage(">[command]",H)
	if(executefromdisk && disk)
		disk.processcommand(command, H, src)
		return
	switch(command)
		if("shutdown")
			sleep(3)
			sendmessage("Shutting down...",H)
			sleep(10)
			sendmessage("[sysfile].os has exited succesfully.",H)
			sleep(3)
			sendmessage("Goodbye!",H)
			send2logs("LOGGED: intentional_shutdown")
			sleep(1)
			on = FALSE
			update_icon()
		if("print")
			sleep(3)
			sendmessage("Now accepting input.",H)
			var/print = input(H, "Command Prompt", name)
			if(!print)
				sleep(10)
				sendmessage("Error 204",H)
				return
			playsound(src, "keyboardlong", 40)
			sleep(5)
			sendmessage(print, H)
		if("speak")
			sleep(3)
			sendmessage("Now accepting input.",H)
			var/print = input(H, "Command Prompt", name)
			if(!print)
				sleep(10)
				sendmessage("Error 204",H)
				return
			playsound(src, "keyboardlong", 40)
			sleep(5)
			speak(print)
		if("clear","clearlogs")
			sleep(3)
			playsound(src, 'sound/effects/computer/bootup.ogg', 60)
			sendmessage("Now clearing logs...",H)
			sendmessage("2%",H)
			sleep(3)
			sendmessage("[rand(6,11)]%",H)
			sleep(rand(3,8))
			sendmessage("[rand(12,56)]%",H)
			sleep(rand(3,8))
			sendmessage("[rand(56,99)]%",H)
			sleep(rand(3,4))
			sendmessage("100%",H)
			sleep(4)
			sendmessage("Success!",H)
			recentcommands.Cut()
		if("execfromdisk","executefromdisk","disk","floppy")
			sleep(3)
			if(disk)
				sendmessage("Now executing from :F drive.",H)
				executefromdisk = TRUE
			else
				sendmessage(":F drive is null",H)
		if("eject")
			sleep(3)
			if(disk)
				sendmessage("Eject complete",H)
				disk.forceMove(src.loc)
				disk = null
			else
				sendmessage(":F drive is null",H)
		if("logs","showlogs","probe","probe.exe")
			sleep(3)
			playsound(src, 'sound/effects/computer/bootup.ogg', 60)
			sendmessage("probe.cmd initiated.",H)
			send2logs("LOGGED: probe.cmd launched")
			for (var/item in recentcommands)
				sleep(3)
				to_chat(H, "<font size='1'>[item]</font>")
		else
			sleep(5)
			sendmessage("Unknown Command",H)

// Spatiuputer subtypes

/obj/machinery/kaos/spatiuputer/compdesk
	name = "computer desk"
	icon_state = "compdesk"
	sysfile = "computingdesk_os"

/obj/machinery/kaos/spatiuputer/terminal
	name = "terminal"
	icon_state = "terminal"
	sysfile = "term_os"

/obj/machinery/kaos/spatiuputer/big
	name = "computing block"
	icon_state = "bigmachine"
	sysfile = "bigg_os"

// floppy disks

/obj/item/floppy
	name = "floppy disk"
	desc = "Just enough inches to keep all the programs you could ever want."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "floppy0"
	drop_sound = null
	var/writtenon

/obj/item/floppy/examine(mob/user, distance)
	. = ..()
	if(writtenon)
		to_chat(user, "There is something written on it. \"[writtenon]\"")

/obj/item/floppy/proc/processcommand(var/command, var/mob/living/carbon/human/H, var/obj/machinery/kaos/spatiuputer/PC)
	if(!command || !H || !PC)
		return
	switch(command)
		if("defrag")
			sleep(3)
			playsound(PC, 'sound/effects/computer/bootup.ogg', 60)
			PC.sendmessage("Defragmentation process initiated..",H)
			PC.sendmessage("2%",H)
			sleep(3)
			PC.sendmessage("[rand(6,11)]%",H)
			sleep(rand(8,15))
			PC.sendmessage("[rand(12,56)]%",H)
			sleep(rand(8,13))
			PC.sendmessage("[rand(56,99)]%",H)
			sleep(rand(4,8))
			PC.sendmessage("100%",H)
			sleep(4)
			PC.sendmessage("Defragmented! Optimized by [rand(1,98)]%.",H)
		if("stopexec","stopexecutefromdisk","execfrompc")
			sleep(3)
			sendmessage("Executing from disk is now disabled.",H)
			executefromdisk = FALSE
		else
			sleep(5)
			PC.sendmessage("Unknown Command",H)