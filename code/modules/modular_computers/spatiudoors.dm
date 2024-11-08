/obj/structure/spatiudoor
	name = "airlock door"
	icon = 'icons/obj/doors/spatiu_doors.dmi'
	icon_state = "airlock_closed"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	var/base_icon = "airlock"
	var/access_requirement = 0
	var/locked = FALSE
	var/doing = FALSE
	var/opaqa = TRUE
	var/timetopen = 40
	var/opening_sound = 'sound/machines/airlock_open_force.ogg'
	var/closing_sound = 'sound/machines/airlock_close_force.ogg'
	var/deny_sound = 'sound/machines/airlock.ogg'

/obj/structure/spatiudoor/RightClick(mob/living/user)
	if(!CanPhysicallyInteract(user))
		return
	if(locked)
		playsound(src, deny_sound, 100)
		return
	if(doing)
		return
	if(timetopen)
		playsound(src, 'sound/machines/airlock_creaking.ogg', 100)
		if(!do_after(user, timetopen, src, TRUE))
			return
	if(density) // CLOSED
		flick("[base_icon]_opening",src)
		icon_state = "[base_icon]_open"
		doing = TRUE
		density = FALSE
		if(opaqa)
			opacity = FALSE
		playsound(src, opening_sound, 100)
	else
		flick("[base_icon]_closing",src)
		icon_state = "[base_icon]_closed"
		doing = TRUE
		density = TRUE
		if(opaqa)
			opacity = TRUE
		playsound(src, closing_sound, 100)
	spawn(3 SECONDS)
		doing = FALSE

/obj/structure/spatiudoor/indoor
	name = "door"
	icon_state = "door_closed"
	base_icon = "door"
	timetopen = 0
	opening_sound = 'sound/machines/airlock_open.ogg'
	closing_sound = 'sound/machines/airlock_close.ogg'

/obj/structure/spatiudoor/manual
	name = "door"
	icon_state = "manual_closed"
	base_icon = "manual"
	timetopen = 0
	opening_sound = 'sound/effects/doorpen.ogg'
	closing_sound = 'sound/effects/doorcreaky.ogg'

/obj/structure/spatiudoor/medical
	name = "door"
	icon_state = "meddoor_closed"
	base_icon = "meddoor"
	timetopen = 0
	opening_sound = 'sound/machines/airlock_open.ogg'
	closing_sound = 'sound/machines/airlock_close.ogg'

/obj/structure/spatiudoor/medical/glass
	icon_state = "g-meddoor_closed"
	base_icon = "g-meddoor"
	opaqa = FALSE
	opacity = FALSE