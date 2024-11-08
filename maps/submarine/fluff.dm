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

/obj/structure/fluff/strangelight
	name = "light"
	desc = "You don't know where it leads, what it does or why it's here."
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "cryolight"

/obj/structure/fluff/strangelight/New()
	. = ..()
	set_light(6, 5, "#5b5752")

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
	desc = "Ration Control Terminal - v2.3"
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
		playsound(src, 'sound/spatiu/print.ogg', 60)
		qdel(O)
		to_chat(user, "The machine eats up the coupon.")
		sleep(2 SECONDS)
		if(prob(98))
			allowed = TRUE
			to_chat(user, "The machine blinks green.")
		else
			to_chat(user, "...nothing happens.")

/obj/structure/fluff/dispenser/attack_hand(mob/user)
	if(!allowed)
		playsound(src, 'sound/machines/airlock.ogg', 60)
		return
	if(global.food_cans > 0)
		allowed = FALSE
		global.food_cans--
		new /obj/item/reagent_containers/food/snacks/warfare/sardine(loc)
		playsound(src, 'sound/machines/vending_drop.ogg', 60)