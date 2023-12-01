//The Rejects
/datum/emergency_call/rejects
	name = "The Rejects"
	base_probability = 15
	alignement_factor = -1
	spawn_type = /mob/living/carbon/human/species/reject
	///number of available special weapon dudes
	var/max_specialists = 1


/datum/emergency_call/rejects/print_backstory(mob/living/carbon/human/H)
	to_chat(H, "<B>You were [pick("made in a TGMC vessel's medbay","created in a TerraGov top-secret lab","created and abandoned by an overconfident scientist","found in an ICC lab raided by TerraGov")] however, were rejected from normal service due to [pick(30;"not being up to TerraGov's regular standards", 40;"making the rest of your team look bad", 10;"constantly oozing a strange liquid", 10;"constantly smelling strange", 10;"being too ugly to look at")].</B>")
	to_chat(H, "<B>You were recruited into a top-secret TerraGov elite squad, code named: The Rejects, because [pick(50;"your skills were too good to pass up", 30;"just look at you, how couldn't they", 10;"you had nowhere else to go", 10;"it was your only choice")].</B>")
	to_chat(H, "")
	to_chat(H, "<B>Today, the TGMC vessel, [SSmapping.configs[SHIP_MAP].map_name], has sent out a distress signal on the orbit of [SSmapping.configs[GROUND_MAP].map_name]. Its time to go in and clean up.</b>")
	to_chat(H, "<B>Ensure that the crew is rescued and whatever threat to the ship is destroyed posthaste. Show them that The Rejects aren't just an urban legend spread by marines.</b>")


/datum/emergency_call/rejects/create_member(datum/mind/M)
	. = ..()
	if(!.)
		return

	var/mob/original = M.current
	var/mob/living/carbon/human/H = .

	M.transfer_to(H, TRUE)
	H.fully_replace_character_name(M.name, H.real_name)

	if(original)
		qdel(original)

	print_backstory(H)
	H.update_hair()

	if(!leader)
		leader = H
		var/datum/job/J = SSjob.GetJobType(/datum/job/reject/leader)
		H.apply_assigned_role_to_spawn(J)
		to_chat(H, span_notice("You are a squad leader of The Rejects, ensure this job is finished up quickly and keep your team safe."))
		return
	if(medics < max_medics)
		var/datum/job/J = SSjob.GetJobType(/datum/job/reject/medic)
		H.apply_assigned_role_to_spawn(J)
		to_chat(H, span_notice("You are a medic of the The Rejects, use your abnormal healing powers to keep your squad healthy."))
		medics++
		return
	if(max_specialists > 0)
		var/datum/job/J = SSjob.GetJobType(/datum/job/reject/specialist)
		H.apply_assigned_role_to_spawn(J)
		to_chat(H, span_notice("You are known only as the Seraph, the specialist of The Rejects. Use your invisibility to your advantange."))
		max_specialists --
		return

	var/datum/job/J = SSjob.GetJobType(/datum/job/reject/grunt)
	H.apply_assigned_role_to_spawn(J)
	to_chat(H, span_notice("You are a grunt for The Rejects, use your enhanced mobility to run and jump your squad to victory."))
