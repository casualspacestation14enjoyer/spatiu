/obj/structure/spatiudoor
	name = "airlock door"
	icon = 'icons/obj/doors/spatiu_doors.dmi'
	icon_state = "airlock_closed"
	density = TRUE
	anchored = TRUE
	var/base_icon = "airlock"
	var/access_requirement = 0
	var/locked = FALSE
	var/opening_sound
	var/closing_sound

/obj/structure/spatiudoor/RightClick(mob/living/user)
	if(locked)
		return
	if(density) // CLOSED
		flick("[base_icon]-opening",src)
		//icon_state = "[base_icon]-open"
		density = FALSE
		playsound(src, opening_sound, 60)
	else
		flick("[base_icon]-closing",src)
		//icon_state = "[base_icon]-closed"
		density = TRUE
		playsound(src, closing_sound, 60)

/obj/structure/spatiudoor/indoor
	name = "door"
	icon_state = "door_closed"
	base_icon = "door"

/obj/structure/spatiudoor/manual
	name = "door"
	icon_state = "manual_closed"
	base_icon = "manual"