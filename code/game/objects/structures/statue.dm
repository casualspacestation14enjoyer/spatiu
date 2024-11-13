/obj/structure/statue
	name = "statue"
	desc = "An incredibly lifelike marble carving."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_male"

/obj/structure/statue/f
	icon_state = "human_female"

/obj/structure/statue/marshal
	name = "statue of the Marshal"
	var/named

/obj/structure/statue/marshal/update_icon()
	..()
	if(named)
		desc = "It is the statue of the Marshal. The plaque reads: \"[named], the brave and courageous Marshal of this Outpost.\"."

/obj/structure/statue/kapitain
	name = "statue of the Kapitain"
	var/named = "John Doe"

/obj/structure/statue/kapitain/update_icon()
	..()
	if(named)
		desc = "It is the statue of the Kapitain of this outpost. The plaque reads: \"[named], the proud and worthy leader of this Outpost.\"."

/obj/structure/statue/verina
	name = "statue"
	desc = "A statue of some ominous looking, robed, figure. There's barely a scratch on it."
	icon = 'icons/obj/64x64.dmi'
	icon_state = "statue"
	anchored = 1
	density = 1
	layer = 4
	bound_height = 32
	bound_width = 64

/obj/structure/statue/verina/broken
	name = "broken statue"
	desc = "A statue of some ominous looking, robed, figure. It's badly damaged."
	icon_state = "statue_broken"