/mob/proc/voice_in_head(message)
	to_chat(src, "<i>...[message]</i>")

GLOBAL_LIST_INIT(lone_thoughts, list(
		"Why are we still here, just to suffer?",
		"Did something happen while we are stuck here?",
		"I miss my family.",
		"Greg died last night.",
		"I do not want to die.",
		"I miss my loved ones.",
		"There is no hope... anymore...",
		"Is any of this real?",
		"My teeth hurt.",
		"I am not ready to die."))

/mob/living/proc/assign_random_quirk()
	if(prob(75))//75% of not choosing a quirk at all.
		return
	if(is_hellbanned())//Hellbanned people will never get quirks.
		return
	var/list/random_quirks = list()
	for(var/thing in subtypesof(/datum/quirk))//Populate possible quirks list.
		var/datum/quirk/Q = thing
		random_quirks += Q
	if(!random_quirks.len)//If there's somewhow nothing there afterwards return.
		return
	var/datum/quirk/chosen_quirk = pick(random_quirks)
	src.quirk = new chosen_quirk
	to_chat(src, "<span class='bnotice'>I was formed a bit different. I am [quirk.name]. [quirk.description]</span>")
	switch(chosen_quirk)
		if(/datum/quirk/cig_addict)
			var/datum/reagent/new_reagent = new /datum/reagent/nicotine
			src.reagents.addiction_list.Add(new_reagent)
		if(/datum/quirk/alcoholic)
			var/datum/reagent/new_reagent = new /datum/reagent/ethanol
			src.reagents.addiction_list.Add(new_reagent)

/decl/hierarchy/outfit/job/spatiu
	name = OUTFIT_JOB_NAME("Crewmember")
	shoes = /obj/item/clothing/shoes/jackboots
	pda_type = null
	l_ear = null
	r_ear = null
	flags = OUTFIT_NO_BACKPACK|OUTFIT_NO_SURVIVAL_GEAR

/decl/hierarchy/outfit/job/spatiu/kapitain
	name = OUTFIT_JOB_NAME("Kapitain")
	uniform = /obj/item/clothing/under/kapitain
	suit = /obj/item/clothing/suit/kapitain
	head = /obj/item/clothing/head/kapitain
	shoes = /obj/item/clothing/shoes/leather
	belt = /obj/item/gun/projectile/revolver/cpt/kapitain

/obj/item/gun/projectile/revolver/cpt/kapitain
	name = "CZ 95-R"
	desc = "The civilian version of the vz. 95-RM."
	icon = 'icons/obj/newguns.dmi'
	icon_state = "revolver2"

/obj/item/clothing/under/kapitain
	name = "Kapitain Uniform"
	desc = "You don't want to wear it but you want to look you have any authority."
	icon_state = "capuniform"
	worn_state = "capuniform"

/obj/item/clothing/suit/kapitain
	name = "Kapitain Jacket"
	desc = "A jacket for the Kapitain. It looks fancy. It looks."
	icon_state = "capcoat"
	item_state = "capcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/head/kapitain
	name = "Ruling Cap"
	desc = "No man rules alone."
	icon_state = "caphat"
	item_state = "caphat"

/decl/hierarchy/outfit/job/spatiu/marshal
	name = OUTFIT_JOB_NAME("Marshal")
	uniform = /obj/item/clothing/under/marshal
	suit = /obj/item/clothing/suit/armor/marshal
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/gun/projectile/pistol/marshal

/obj/item/clothing/under/marshal
	name = "Marshal Uniform"
	desc = "Comfortable, and it has all your armbands and medals on it, how amazing."
	icon_state = "maruniform"
	worn_state = "maruniform"

/obj/item/clothing/suit/armor/marshal
	name = "puffy grey bulletproof vest"
	desc = "A vest that looks more like that of a jacket for a child. It says that is is bulletproof, you doubt it but it provides some protection at least. It's not nearly fancy enough and walking around in it doesn't feel nice."
	icon_state = "marvest"
	item_state = "marvest"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	cold_protection = UPPER_TORSO|LOWER_TORSO
	heat_protection = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/marshal/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1