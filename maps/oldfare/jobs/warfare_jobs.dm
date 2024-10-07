/datum/job/assistant
	total_positions = 0

/datum/map/warfare
	allowed_jobs = list(
	/datum/job/assistant,
    /datum/job/soldier/red_soldier/captain,
    /datum/job/soldier/red_soldier/sgt,
    /datum/job/soldier/red_soldier/medic,
	/datum/job/soldier/red_soldier/engineer,
	/datum/job/soldier/red_soldier/sentry,
	/datum/job/soldier/red_soldier/sniper,
	/datum/job/soldier/red_soldier/flame_trooper,
    /datum/job/soldier/red_soldier,
	/datum/job/soldier/red_soldier/scout,
	/datum/job/fortress/red/practitioner,

    /datum/job/soldier/blue_soldier/captain,
    /datum/job/soldier/blue_soldier/sgt,
    /datum/job/soldier/blue_soldier/medic,
	/datum/job/soldier/blue_soldier/engineer,
	/datum/job/soldier/blue_soldier/sniper,
	/datum/job/soldier/blue_soldier/sentry,
	/datum/job/soldier/blue_soldier/flame_trooper,
    /datum/job/soldier/blue_soldier,
	/datum/job/soldier/blue_soldier/scout,
	/datum/job/fortress/blue/practitioner
	)

/mob/living/carbon/human/proc/warfare_language_shit(var/language_name)
	return

/datum/job/assistant
	title = "REDACTED"
	total_positions = 0
	spawn_positions = 0