/obj/structure/fluff/fakeplace
	name = "fireplace"
	desc = "On further inspection, it is really just a cheap LED screen."
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "fireplace1"
	anchored = TRUE
	density = FALSE

/obj/structure/fluff/fakeplace/New()
	. = ..()
	set_light(6, 5, "#FF9900")

/obj/structure/phonebooth
	name = "phone booth"
	desc = "This used to allow you to communicate with your loved ones, now when the satellite is down it does nothing."
	icon_state = "phonebooth"
	anchored = TRUE
	density = TRUE

/obj/structure/radiator
	name = "radiator"
	desc = "Keeps you warm."
	icon_state = "radiator"
	var/on = FALSE
	anchored = TRUE
	density = FALSE

/obj/structure/radiator/Process()
	if(!GLOB.reactoron)
		on = FALSE
		return
	if(on)
		var/datum/gas_mixture/env = loc.return_air()
		if(!(env && abs(env.temperature - T20C) <= 0.1))
			var/datum/gas_mixture/removed = env.remove(0.25 * env.total_moles)

			if(removed)
				var/energy_used = min( removed.get_thermal_energy_change(T20C) , 60 GIGAWATTS)

				//removed.add_thermal_energy(energy_used)
				removed.temperature += energy_used
			env.merge(removed)

/obj/structure/capacitor
	name = "electrical capacitor"
	icon = 'icons/effects/96x96.dmi'
	bound_width = 96
	bound_height = 96
	icon_state = "powerstation"
	anchored = TRUE
	density = TRUE

/obj/machinery/heat_generator
	name = "HECMHG-2991_V92"
	desc = "So you don't freeze."
	icon = 'icons/obj/64x64.dmi'
	icon_state = "reactor"
	bound_width = 64
	bound_height = 64
	anchored = TRUE
	density = TRUE
	var/overheating = FALSE
	var/overheat_stoptimer = 3000 // 5 mins
	var/overheat_time = 0

/obj/machinery/heat_generator/proc/bang(var/turf/T , var/mob/living/carbon/M)  // copied from flashbang code
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		if(ishuman(M))
			if(istype(M:l_ear, /obj/item/clothing/ears/earmuffs) || istype(M:r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(HULK in M.mutations)
				ear_safety += 1
			if(istype(M:head, /obj/item/clothing/head/helmet))
				ear_safety += 1

	if(eye_safety < FLASH_PROTECTION_MODERATE)
		M.flash_eyes()
		M.Stun(2)
		M.Weaken(10)

	if((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
		if(ear_safety > 0)
			M.KnockDown()
		else
			M.Stun(10)
			M.Weaken(3)
			if ((prob(14) || (M == src.loc && prob(70))))
				M.ear_damage += rand(1, 10)
			else
				M.ear_damage += rand(0, 5)
				M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= 5)
		if(!ear_safety)
			M.Stun(8)
			M.ear_damage += rand(0, 3)
			M.ear_deaf = max(M.ear_deaf,10)

	else if(!ear_safety)
		M.Stun(4)
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, "<span class='danger'>Your eyes start to burn badly!</span>")
			if (E.damage >= E.min_broken_damage)
				to_chat(M, "<span class='danger'>You can't see anything!</span>")
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
		if (prob(M.ear_damage - 10 + 5))
			to_chat(M, "<span class='danger'>You can't hear anything!</span>")
			M.sdisabilities |= DEAF
	else
		if (M.ear_damage >= 5)
			to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
	M.update_icons()

/obj/machinery/heat_generator/Initialize(mapload, d)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/machinery/heat_generator/proc/turnon()
	new/obj/effect/sparks(src.loc)
	new/obj/effect/effect/smoke/illumination(src.loc, 5, range=30, power=30, color="#ffffff")

	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		bang(get_turf(src), M)

	GLOB.reactoron = TRUE
	playsound(src.loc, 'sound/effects/reactor.ogg', 100, 1)

/obj/machinery/heat_generator/proc/turnoff()
	new/obj/effect/sparks(src.loc)
	new/obj/effect/effect/smoke/illumination(src.loc, 5, range=30, power=30, color="#ffffff")

	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		bang(get_turf(src), M)

	GLOB.reactoron = FALSE
	playsound(src.loc, 'sound/effects/reactor.ogg', 100, 1)

/obj/machinery/heat_generator/proc/goboom()
	if(overheating)
		if(prob(99))
			STOP_PROCESSING(SSobj, src)
			qdel(src)

/obj/machinery/heat_generator/Process()
	if(GLOB.reactoron)
		overheat_time++
		icon_state = "reactor-active"
	else
		icon_state = "reactor"

	if(overheat_time >= overheat_stoptimer/2)
		icon_state = "reactor-melting"
		if(overheat_time >= overheat_stoptimer)
			overheating = TRUE
			if(prob(35)) // give them a little extra time i guess?
				goboom()

	if(locate(/obj/effect/sevenwater) in loc)
		if(GLOB.reactoron)
			STOP_PROCESSING(SSobj, src)
			qdel(src)
		else
			overheating = FALSE
			overheat_time = 0

/obj/structure/fluff/strangelight
	name = "light"
	desc = "You don't know where it leads, what it does or why it's here."
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "cryolight"
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/strangelight/New()
	. = ..()
	set_light(6, 5, "#5b5752")

/obj/structure/fluff/planetdisplay
	name = "planet display"
	desc = "This shows your intense situation."
	icon = 'icons/life/LFWB_USEFUL_BIG.dmi'
	icon_state = "planetdisplay"
	anchored = TRUE
	density = FALSE

/obj/structure/fluff/antena
	name = "antenna"
	desc = "Functioning as intended. Sadly the satellite is fucked and not this."
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "antena2"
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/cryogenic
	name = "sleep chamber"
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "cryochamber3"
	var/icon_base = "cryochamber"
	anchored = TRUE
	density = TRUE
	var/mob/living/carbon/human/contained
	var/opened = FALSE

/obj/structure/fluff/cryogenic/update_icon()
	if(contained)
		icon_state = "[icon_base]1"
	else
		icon_state = "[icon_base]3"
	if(opened)
		icon_state = "[icon_base]0"

/obj/structure/fluff/cryogenic/Process()
	update_icon()
	if(contained)
		contained.SetStasis(3)

/obj/structure/fluff/processor
	name = "saturation processor"
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "a10"
	var/obj/item/trash/warfare_can/sardine/can
	var/obj/item/organ/external/BP
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/processor/RightClick(mob/living/user)
	if(!CanPhysicallyInteract(user))
		return
	if(BP && can)
		to_chat(user, "You flip a switch on the processor and it begins churning!")
		playsound(src, 'sound/effects/mine_arm.ogg', 60)
		sleep(3)
		playsound(src, 'sound/machines/juicer.ogg', 60)
		spawn(5 SECONDS)
			new /obj/item/reagent_containers/food/snacks/warfare/sardine(loc)

/obj/structure/fluff/processor/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/trash/warfare_can/sardine))
		user.drop_item()
		O.forceMove(src)
		can = O
	if(istype(O, /obj/item/organ/external))
		user.drop_item()
		O.forceMove(src)
		BP = O
	else
		return ..()

/obj/structure/fluff/cannery
	name = "canner"
	desc = "Luckily it's all automated."
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "a13"
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/cannery/attack_hand(mob/user)
	to_chat(user, "You begin to carefully remove a can from the seemingly infinite storage of cans.")
	if(do_after(user, 5 SECONDS, src, TRUE))
		new /obj/item/trash/warfare_can/sardine(loc)

/obj/structure/fluff/controller
	name = "RCT-23"
	desc = "Ration Control Terminal - v2.3. A useless piece of fucking technology that doesn't do anything by itself, you can't even send the food off without using the program."
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "RCT"
	var/list/loaded = list()
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/controller/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/reagent_containers/food/snacks/warfare/sardine))
		to_chat(user, "You load it in.")
		user.drop_item()
		O.forceMove(src)
		loaded += O
	else
		return ..()

/obj/item/coupon
	name = "rationnaire stamp"
	desc = "Eat, you've earned it."
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
	w_class = ITEM_SIZE_TINY

/obj/structure/fluff/dispenser
	name = "RDT-0"
	desc = "Ration Dispenser Terminal - v0.3"
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "RCT0"
	var/allowed = FALSE
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/dispenser/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/coupon))
		playsound(src, 'sound/effects/computer/print.ogg', 60)
		qdel(O)
		to_chat(user, "The machine eats up the coupon.")
		sleep(2 SECONDS)
		if(prob(98))
			allowed = TRUE
			to_chat(user, "The machine blinks green.")
		else
			to_chat(user, "...nothing happens.")

/obj/structure/fluff/dispenser/attack_hand(mob/user)
	if((!allowed && GLOB.food_cans > 0) || !(GLOB.food_allowed))
		playsound(src, 'sound/machines/airlock.ogg', 60)
		return
	allowed = FALSE
	GLOB.food_cans--
	new /obj/item/reagent_containers/food/snacks/warfare/sardine(loc)
	playsound(src, 'sound/machines/vending_drop.ogg', 60)

/obj/structure/portablewaterpump
	name = "PWP-942"
	desc = "A portable water pump of German origin, it doesn't hold up well."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "pscrubber:0"
	density = TRUE
	anchored = FALSE
	var/on = FALSE

/obj/structure/portablewaterpump/update_icon()
	icon_state = "pscrubber:[on]"

/obj/structure/portablewaterpump/Destroy()
	STOP_PROCESSING(SSobj,src)
	return ..()

/obj/structure/portablewaterpump/attack_hand(mob/user)
	playsound(src, "button", 60)
	to_chat(user, "You press the button.")
	on = !on
	update_icon()
	if(on)
		START_PROCESSING(SSobj,src)
	else
		STOP_PROCESSING(SSobj,src)

/obj/structure/portablewaterpump/Process()
	if(!on)
		STOP_PROCESSING(SSobj,src)
		return
	for(var/turf/S in get_all_adjacent_turfs())
		if(!loc.density)
			var/obj/effect/sevenwater/W = locate() in S
			if(W)
				playsound(src, pick('sound/spatiu/gurgle1.ogg','sound/spatiu/gurgle2.ogg','sound/spatiu/gurgle3.ogg','sound/spatiu/gurgle4.ogg'), 65)
				qdel(W)
		if(!S.density)
			var/obj/effect/sevenwater/SW = locate() in S
			if(SW)
				playsound(src, pick('sound/spatiu/gurgle1.ogg','sound/spatiu/gurgle2.ogg','sound/spatiu/gurgle3.ogg','sound/spatiu/gurgle4.ogg'), 65)
				qdel(SW)