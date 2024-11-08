/datum/job/spatiu
	total_positions = -1
	create_record = FALSE
	account_allowed = FALSE
	social_class = SOCIAL_CLASS_MIN
	has_email = FALSE
	latejoin_at_spawnpoints = TRUE
	can_be_in_squad = FALSE
	announced = TRUE

/datum/job/spatiu/kapitain
	title = "Kapitain"
	lore = "You're defacto leader of this outpost, do everything you can to make sure this broken wreck is as stable as it can be; while still making sure you leadership is not questioned."
	department = "Commanders"
	department_flag = COM
	req_admin_notify = TRUE
	total_positions = 1
	social_class = SOCIAL_CLASS_MAX
	outfit_type = /decl/hierarchy/outfit/job/spatiu/kapitain

	//Baseline skill defines
	medical_skill = 2
	surgery_skill = 3
	ranged_skill = 5
	melee_skill = 4

	equip(var/mob/living/carbon/human/H)
		..()
		H.voice_in_head(pick(GLOB.lone_thoughts))
		to_chat(H, "<b>Password</b>: [GLOB.cargo_password]")
		H.mind.store_memory("<b>Password</b>: [GLOB.cargo_password]")
		H.add_stats(rand(12,17), rand(10,16), rand(8,12))
		H.fully_replace_character_name("Kpt. [H.real_name]")
		H.assign_random_quirk()

/datum/job/spatiu/marshal
	title = "Marshal"
	lore =  "You know who you are, you're the right hand man of the Kapitain and the best fighter on this damn outpost. Throw conspirators overboard and boast about your pay, you've earned it."
	department = "Commanders"
	department_flag = COM
	req_admin_notify = TRUE
	total_positions = 1
	social_class = SOCIAL_CLASS_MAX
	outfit_type = /decl/hierarchy/outfit/job/spatiu/marshal

	//Baseline skill defines
	medical_skill = 3
	surgery_skill = 3
	ranged_skill = 8
	melee_skill = 6

	equip(var/mob/living/carbon/human/H)
		..()
		H.voice_in_head(pick(GLOB.lone_thoughts))
		H.add_stats(rand(17,20), 10, 9)
		H.fully_replace_character_name("Mar. [H.real_name]")
		H.set_quirk(pick(/datum/quirk/dead_inside,/datum/quirk/tough))