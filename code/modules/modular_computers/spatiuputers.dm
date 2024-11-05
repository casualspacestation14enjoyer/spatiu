/obj/machinery/kaos/spatiuputer
	name = "computer"
	desc = "Computing..."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "old"
	var/on = FALSE
	anchored = TRUE
	density = FALSE
	var/sysfile = "vitals_os" // flavor
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
	switch(command)
		if("shutdown")
			sleep(3)
			sendmessage("Shutting down...",H)
			sleep(10)
			sendmessage("[sysfile].os has exited succesfully.",H)
			send2logs("LOGGED: intentional_shutdown")
			sleep(1)
			on = FALSE
			update_icon()
		if("print")
			sleep(3)
			sendmessage("Now accepting input.",H)
			var/print = input(H, "Command Prompt", name)
			if(!print)
				sendmessage("Error 204",H)
				return
			playsound(src, "keyboardlong", 40)
			sendmessage(print, H)
		if("clear","clearlogs")
			sleep(3)
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
			recentcommands.Cut()
			send2logs("LOGGED: intentional_logclearing")
		if("logs","showlogs","probe","probe.exe")
			sleep(3)
			sendmessage("probe.exe initiated.",H)
			send2logs("LOGGED: probe.exe launched")
			for (var/item in recentcommands)
				sleep(3)
				to_chat(H, "<font size='1'>[item]</font>")
		else
			sleep(5)
			sendmessage("Unknown Command",H)