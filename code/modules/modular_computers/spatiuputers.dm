/obj/machinery/spatiuputer
	name = "computer"
	desc = "A computer, it has a floppy disk port."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "old"
	var/on = FALSE
	anchored = TRUE
	density = FALSE
	var/sysfile = "vitals_os" // flavor
	var/executefromdisk = FALSE // run command programs from floppy
	var/obj/item/floppy/disk
	var/list/recentcommands = list()

/obj/machinery/spatiuputer/attack_hand(mob/user)
	if(on)
		return ..()
	playsound(src, "button", 100)
	sleep(4)
	playsound(src, 'sound/effects/computer/bootup.ogg', 60)
	sleep(3 SECONDS)
	on = TRUE
	update_icon()

/obj/machinery/spatiuputer/RightClick(mob/living/user)
	if(user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_RESTRAINED|INCAPACITATION_KNOCKOUT))
		return
	if(!CanPhysicallyInteract(user))
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

/obj/machinery/spatiuputer/Initialize(mapload, d)
	. = ..()
	update_icon()

/obj/machinery/spatiuputer/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]0"
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]b"

/obj/machinery/spatiuputer/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if (!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/spatiuputer/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/floppy))
		if(!on)
			return
		user.drop_item()
		O.forceMove(src)
		disk = O
		playsound(src, 'sound/effects/computer/audiotapein.ogg', 60)
		return
	return ..()

/obj/machinery/spatiuputer/proc/sendmessage(var/message, var/mob/living/L) // the mob living var is a holdover from worse code, i realized i could do it better but im leaving this here, since im too lazy
	recentcommands += message
	playsound(src, 'sound/effects/computer/consolebeep.ogg', 50)
	for(var/mob/living/L in view(2,src))
		to_chat(L, "<font color=#4af626>[message]</font>")

/obj/machinery/spatiuputer/proc/send2logs(var/message)
	recentcommands += message

/obj/machinery/spatiuputer/proc/processcommand(var/command, var/mob/living/carbon/human/H)
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
		if("sysinfo","systeminfo")
			sleep(3)
			sendmessage("SYSTEM INFORMATION",H)
			sleep(3)
			sendmessage("--------------",H)
			sleep(3)
			sendmessage("operating system: [sysfile].os",H)
			sleep(3)
			sendmessage("sysversion: 3.1",H)
			sleep(3)
			if(disk)
				sendmessage(":F drive is loaded!",H)
			else
				sendmessage(":F drive is null",H)
			sleep(3)
			sendmessage("registeredowner: N/A",H)
			sleep(1)
			sendmessage("terminalid: N/A",H)
			sleep(1)
			sendmessage("productkey: N/A",H)
			sendmessage("WARNING: OS is unregistered! Possible pirated copy.",H)
			sleep(3)
			sendmessage("diagnostics: SAFE",H)
		if("music","sing")
			sleep(3)
			sendmessage("Now accepting input.",H)
			var/print = input(H, "Command Prompt", name)
			if(!print)
				sleep(10)
				sendmessage("Error 204",H)
				return
			playsound(src, "keyboardlong", 40)
			sleep(5)
			var/tosing = splittext(print,",")
			if(tosing)
				for(var/i in tosing)
					sleep(3)
					playsound(src, "sound/effects/computer/beepsound[i].ogg", 60)
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
			sendmessage("INPUT ACCEPTED [print], VOICE MODULATOR STARTING...", H)
			sleep(10)
			sendmessage("Modulated. Playback activated",H)
			sleep(4)
			speak(print)
		if("clear","clearlogs")
			sleep(3)
			playsound(src, 'sound/effects/computer/cargo_starttp.ogg', 100)
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
				playsound(src, 'sound/effects/computer/audiotapein.ogg', 60)
				disk.forceMove(src.loc)
				disk = null
			else
				sendmessage(":F drive is null",H)
		if("logs","showlogs","probe","probe.exe")
			sleep(3)
			playsound(src, 'sound/effects/computer/cargo_endtp.ogg', 60)
			sendmessage("probe.cmd initiated.",H)
			send2logs("LOGGED: probe.cmd launched")
			for (var/item in recentcommands)
				sleep(3)
				to_chat(H, "<font size='1'>[item]</font>")
		else
			sleep(5)
			sendmessage("Unknown Command",H)

// Spatiuputer subtypes

/obj/machinery/spatiuputer/compdesk
	name = "computer desk"
	icon_state = "compdesk"
	sysfile = "computingdesk_os"
	density = TRUE

/obj/machinery/spatiuputer/terminal
	name = "terminal"
	icon_state = "terminal"
	sysfile = "term_os"

/obj/machinery/spatiuputer/big
	name = "computing block"
	icon_state = "bigmachine"
	sysfile = "bigg_os"
	density = TRUE

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

/obj/item/floppy/proc/processcommand(var/command, var/mob/living/carbon/human/H, var/obj/machinery/spatiuputer/PC)
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
			PC.sendmessage("Executing from disk is now disabled.",H)
			PC.executefromdisk = FALSE
		else
			sleep(5)
			PC.sendmessage("Unknown Command",H)

/obj/item/floppy/scrungus
	writtenon = "SCRUNGUS v3.1"

/obj/item/floppy/scrungus/processcommand(command, mob/living/carbon/human/H, obj/machinery/spatiuputer/PC)
	if(!command || !H || !PC)
		return
	switch(command)
		if("scrungus")
			sleep(3)
			PC.sendmessage("SCRUNGUS ACTIVATED.",H)
			for(var/i=0, i<10, i++)
				PC.sendmessage("SCRUNGUS NUMBER [i]",H)
		if("stopexec","stopexecutefromdisk","execfrompc")
			sleep(3)
			PC.sendmessage("Executing from disk is now disabled.",H)
			PC.executefromdisk = FALSE
		else
			sleep(5)
			PC.sendmessage("Unknown Command",H)

/obj/item/floppy/cooker
	writtenon = "FUCKING FOOD THING"
	var/authed = FALSE
	icon_state = "floppy3"

/obj/item/floppy/cooker/processcommand(command, mob/living/carbon/human/H, obj/machinery/spatiuputer/PC)
	if(!command || !H || !PC)
		return
	switch(command)
		if("auth","login","authorize","superuser","su")
			sleep(5)
			if(!authed)
				PC.sendmessage("Login Request",H)
				sleep(2)
				PC.sendmessage("------------",H)
				sleep(5)
				PC.sendmessage("MAJOR SYSTEM INTERCOMMUNICATOR PROGRAM",H)
				sleep(2)
				PC.sendmessage("Please insert credentials",H)
				sleep(1)
				PC.sendmessage("Now accepting input.",H)
				var/print = input(H, "Command Prompt", PC.name)
				if(!print)
					sleep(10)
					PC.sendmessage("Error 204",H)
					return
				playsound(PC, "keyboardlong", 40)
				PC.sendmessage(">[print]",H)
				if(print == GLOB.cook_password)
					sleep(4)
					PC.sendmessage("Authorized.",H)
					authed = TRUE
				else
					sleep(10)
					PC.sendmessage("Error 401",H)
					return
			else
				PC.sendmessage("Login Request",H)
				sleep(2)
				PC.sendmessage("------------",H)
				sleep(5)
				PC.sendmessage("MAJOR SYSTEM INTERCOMMUNICATOR PROGRAM",H)
				sleep(2)
				PC.sendmessage("You are already authorized.",H)
		if("logoff","unauth")
			sleep(3)
			if(authed)
				authed = FALSE
				PC.sendmessage("You have been logged off.",H)
			else
				PC.sendmessage("You are not logged in!",H)
		if("checkfood","checkcans")
			sleep(3)
			if(!authed)
				PC.sendmessage("YOU ARE NOT AUTHORIZED!",H)
				playsound(src, 'sound/effects/computer/harshdeny.ogg', 60)
				return
			PC.sendmessage("There are [GLOB.food_cans] cans left",H)
		if("disablefood")
			sleep(3)
			if(!authed)
				PC.sendmessage("YOU ARE NOT AUTHORIZED!",H)
				playsound(src, 'sound/effects/computer/harshdeny.ogg', 60)
				return
			PC.sendmessage("Emergency rationing disabled.",H)
			GLOB.food_allowed = FALSE
		if("enablefood")
			sleep(3)
			if(!authed)
				PC.sendmessage("YOU ARE NOT AUTHORIZED!",H)
				playsound(src, 'sound/effects/computer/harshdeny.ogg', 60)
				return
			PC.sendmessage("Emergency rationing enabled.",H)
			GLOB.food_allowed = TRUE
		if("addfood","senditoff")
			sleep(3)
			if(!authed)
				PC.sendmessage("YOU ARE NOT AUTHORIZED!",H)
				playsound(src, 'sound/effects/computer/harshdeny.ogg', 60)
				return
			PC.sendmessage("Activating protocol",H)
			var/obj/structure/fluff/controller/C = locate() in world
			for(var/i in C.loaded)
				sleep(2)
				PC.sendmessage("Can found, sending to storage via pneumatic tube",H)
				qdel(i)
				GLOB.food_cans++
			PC.sendmessage("All cans sent",H)

/obj/item/floppy/communicator
	writtenon = "major-sys intercommunicator"
	var/authed = FALSE
	icon_state = "floppy2"

/obj/item/floppy/communicator/processcommand(command, mob/living/carbon/human/H, obj/machinery/spatiuputer/PC)
	if(!command || !H || !PC)
		return
	switch(command)
		if("auth","login","authorize","superuser","su")
			sleep(5)
			if(!authed)
				PC.sendmessage("Login Request",H)
				sleep(2)
				PC.sendmessage("------------",H)
				sleep(5)
				PC.sendmessage("MAJOR SYSTEM INTERCOMMUNICATOR PROGRAM",H)
				sleep(2)
				PC.sendmessage("Please insert credentials",H)
				sleep(1)
				PC.sendmessage("Now accepting input.",H)
				var/print = input(H, "Command Prompt", PC.name)
				if(!print)
					sleep(10)
					PC.sendmessage("Error 204",H)
					return
				playsound(PC, "keyboardlong", 40)
				PC.sendmessage(">[print]",H)
				if(print == GLOB.cargo_password)
					sleep(4)
					PC.sendmessage("Authorized.",H)
					authed = TRUE
				else
					sleep(10)
					PC.sendmessage("Error 401",H)
					return
			else
				PC.sendmessage("Login Request",H)
				sleep(2)
				PC.sendmessage("------------",H)
				sleep(5)
				PC.sendmessage("MAJOR SYSTEM INTERCOMMUNICATOR PROGRAM",H)
				sleep(2)
				PC.sendmessage("You are already authorized.",H)
		if("logoff","unauth")
			sleep(3)
			if(authed)
				authed = FALSE
				PC.sendmessage("You have been logged off.",H)
			else
				PC.sendmessage("You are not logged in!",H)
		if("foodstamp","printfoodstamp","printcoupon")
			sleep(3)
			if(!authed)
				PC.sendmessage("YOU ARE NOT AUTHORIZED!",H)
				playsound(src, 'sound/effects/computer/harshdeny.ogg', 60)
				return
			playsound(PC, 'sound/effects/computer/print.ogg', 60)
			PC.sendmessage("PRINTING FOOD STAMP. YOU ARE IN EMERGENCY RESPONSE MODE, REMEMBER THAT THIS IS FOR RATIONING.",H)
			sleep(2 SECONDS)
			new /obj/item/coupon(PC.loc)
		if("announce")
			sleep(3)
			if(!authed)
				PC.sendmessage("YOU ARE NOT AUTHORIZED!",H)
				playsound(src, 'sound/effects/computer/harshdeny.ogg', 60)
				return
			PC.sendmessage("Now accepting input.",H)
			var/print = input(H, "Command Prompt", PC.name)
			if(!print)
				sleep(10)
				PC.sendmessage("Error 204",H)
				return
			playsound(PC, "keyboardlong", 40)
			sleep(5)
			PC.sendmessage("INPUT ACCEPTED, VOICE MODULATOR STARTING...", H)
			sleep(10)
			PC.sendmessage("Modulated. Playback activated",H)
			sleep(4)

			// todo: make sure this is announced to only people inside the outpost
			for(var/mob/M in GLOB.living_mob_list_)
				to_chat(M, "<h1><span class='red_team'>The ancient intercom speakers scream to life and a [pick("cheaply modulated voice","booming artifical voice")] reverberates throughout the outpost!</span></h1>")
				to_chat(M, "<h2>[print]</h2>")
				sound_to(M, 'sound/spatiu/intercom.ogg')
		if("doorctrl")
			sleep(3)
			if(!authed)
				PC.sendmessage("YOU ARE NOT AUTHORIZED!",H)
				playsound(src, 'sound/effects/computer/harshdeny.ogg', 60)
				return
			PC.sendmessage("Now accepting input.",H)
			var/print = input(H, "Command Prompt", PC.name)
			if(!print)
				sleep(10)
				PC.sendmessage("Error 204",H)
				return
			playsound(PC, "keyboardlong", 40)
			sleep(5)
			PC.sendmessage("Sending command...",H)
			for(var/obj/machinery/door/blast/id_door/M in world)
				if(M.id == print)
					if(M.density)
						spawn(0)
							M.open()
							return
					else
						spawn(0)
							M.close()
							return
		if("stopexec","stopexecutefromdisk","execfrompc")
			sleep(3)
			PC.sendmessage("Executing from disk is now disabled.",H)
			PC.executefromdisk = FALSE
		else
			sleep(5)
			PC.sendmessage("Unknown Command",H)

/obj/item/floppy/engineer
	writtenon = "engineering"
	icon_state = "floppy1"

/obj/item/floppy/engineer/processcommand(command, mob/living/carbon/human/H, obj/machinery/spatiuputer/PC)
	if(!command || !H || !PC)
		return
	switch(command)
		if("togglewater")
			sleep(3)
			PC.sendmessage("Sending command...",H)
			for(var/obj/machinery/door/blast/id_door/M in world)
				if(M.id == "waterinput")
					if(M.density)
						spawn(0)
							M.open()
							return
					else
						spawn(0)
							M.close()
							return
		if("heaton")
			var/fuck = 1
			fuck = 1
			sleep(3)
			PC.sendmessage("Heating redirection process initiated.",H)
			sleep(10)
			for(var/obj/structure/radiator/R in world)
				sleep(rand(5,15))
				playsound(R, "button", 60)
				R.on = TRUE
				START_PROCESSING(SSobj,R)
				PC.sendmessage("Redirected to HEATER[fuck]",H)
				fuck++
		if("heatoff")
			sleep(3)
			PC.sendmessage("Initializing MSP (Master Shutdown Procedure)",H)
			sleep(10)
			for(var/obj/structure/radiator/R in world)
				playsound(R, "button", 60)
				R.on = FALSE
				STOP_PROCESSING(SSobj,R)
		if("reactoron")
			PC.sendmessage("HECMHG-2991_V92 CONTROL",H)
			PC.sendmessage("Hydroelectric C#1@K #3&@ Heat Generator",H)
			sleep(3)
			PC.sendmessage("-----------",H)
			sleep(3)
			PC.sendmessage("M-DRIVER: driver.ctrl-99 PROCEDURE: MONTAUK",H)
			sleep(10)
			PC.sendmessage("In Position.",H)
			sleep(5)
			PC.sendmessage("PROCEEDING")
			sleep(10)
			var/obj/machinery/heat_generator/HG = locate() in world
			if(HG)
				PC.sendmessage("COMPLETE.")
				HG.turnon()
		if("reactoroff")
			PC.sendmessage("HECMHG-2991_V92 CONTROL",H)
			PC.sendmessage("Hydroelectric C#1@K #3&@ Heat Generator",H)
			sleep(3)
			PC.sendmessage("-----------",H)
			sleep(3)
			PC.sendmessage("M-DRIVER: driver.ctrl-99 PROCEDURE: PERTH",H)
			sleep(10)
			PC.sendmessage("In Position.",H)
			sleep(5)
			PC.sendmessage("PROCEEDING")
			sleep(10)
			var/obj/machinery/heat_generator/HG = locate() in world
			if(HG)
				PC.sendmessage("COMPLETE.")
				HG.turnoff()
		if("stopexec","stopexecutefromdisk","execfrompc")
			sleep(3)
			PC.sendmessage("Executing from disk is now disabled.",H)
			PC.executefromdisk = FALSE
		else
			sleep(5)
			PC.sendmessage("Unknown Command",H)