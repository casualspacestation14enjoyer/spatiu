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

/decl/hierarchy/outfit/job/spatiu/logisticsofficer
	name = OUTFIT_JOB_NAME("Logistics Officer")
	head = /obj/item/clothing/head/soft
	uniform = /obj/item/clothing/under/logisticsofficer
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/coupon
	belt = /obj/item/clipboard

/obj/item/clothing/under/logisticsofficer
	name = "Logistics Officer Uniform"
	desc = "Despite the fancy name, you still look like what you are."
	icon_state = "qm"
	item_state = "lb_suit"
	worn_state = "qm"

/decl/hierarchy/outfit/job/spatiu/medicalofficer
	name = OUTFIT_JOB_NAME("Medical Officer")
	uniform = /obj/item/clothing/under/medicalofficer
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/white
	belt = /obj/item/storage/belt/medical/full

/obj/item/clothing/under/medicalofficer
	name = "Medical Officer Uniform"
	desc = "Not to be stained by blood, yet."
	icon_state = "medofuniform"
	item_state = "w_suit"
	item_state = "medofuniform"

/obj/item/spatiudefib // I fucking hate the way bay defibs work.
	name = "heart restarter"
	desc = "A several decades outdated model, the best you can get down here."
	icon = 'icons/life/device.dmi'
	icon_state = "defib"
	item_state = "defibunit"

/obj/item/spatiudefib/attack(mob/living/M, mob/living/user, target_zone, special)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		if(target_zone == BP_CHEST)
			playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
			if(!do_after(user, 3 SECONDS, H, TRUE))
				return
			if(H.stat != DEAD)
				playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 0)
				H.resuscitate()

/decl/hierarchy/outfit/job/spatiu/cadet
	name = OUTFIT_JOB_NAME("Cadet")
	head = /obj/item/clothing/head/beret/cadet
	uniform = /obj/item/clothing/under/child_jumpsuit/cadet
	shoes = /obj/item/clothing/shoes/child_shoes

/obj/item/clothing/under/child_jumpsuit/cadet
	name = "Cadet Uniform"
	desc = "It's so fucking ugly."
	icon_state = "cadetuniform"

/obj/item/clothing/head/beret/cadet
	name = "cadet beret"
	desc = "I don't get how you expect kids to wear this piece of shit."
	icon_state = "beret_navy"

/obj/item/clothing/head/helmet/divinghelm
	name = "diving helmet"
	desc = "Old, decrepit, ancient. All viable words to describe this junk, but it is at least one thing. Functional, and in some ways reliable."
	icon_state = "waterhelm"
	item_flags = ITEM_FLAG_STOPPRESSUREDAMAGE | ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	flags_inv = BLOCKHAIR
	permeability_coefficient = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0

/obj/item/clothing/suit/divingsuit
	name = "diving suit"
	desc = "Despite protecting you from the pressure and water, it does jackshit to protect you from lead poisoning."
	icon_state = "watersuit"
	w_class = ITEM_SIZE_LARGE//large item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	item_flags = ITEM_FLAG_STOPPRESSUREDAMAGE | ITEM_FLAG_THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0