/datum/job/spatiu
	total_positions = -1
	create_record = FALSE
	account_allowed = FALSE
	social_class = SOCIAL_CLASS_MIN
	has_email = FALSE
	latejoin_at_spawnpoints = TRUE
	can_be_in_squad = FALSE
	announced = TRUE

	//Baseline skill defines
	medical_skill = 6
	surgery_skill = 4
	ranged_skill = 10
	engineering_skill = 5
	melee_skill = 10
	//Gun skills
	auto_rifle_skill = 10
	semi_rifle_skill = 8
	sniper_skill = 4
	shotgun_skill = 4
	lmg_skill = 4
	smg_skill = 4

/datum/job/kapitain
	title = "Kapitain"
	department = "Commanders"
	department_flag = COM
	total_positions = 1
	social_class = SOCIAL_CLASS_MAX
	outfit_type = /decl/hierarchy/outfit/job/spatiu/kapitain

	equip(var/mob/living/carbon/human/H)
		..()
		H.add_stats(rand(12,17), rand(10,16), rand(8,12))
		H.fully_replace_character_name("Kpt. [H.real_name]")
		H.assign_random_quirk()