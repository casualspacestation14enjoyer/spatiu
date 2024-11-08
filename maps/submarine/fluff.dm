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