#define CRADLE_NOTICE_SUCCESS 1
#define CRADLE_NOTICE_DEATH 2
#define CRADLE_NOTICE_NO_RECORD 3
#define CRADLE_NOTICE_NO_POWER 4
#define CRADLE_NOTICE_XENO_FUCKERY 5
#define CRADLE_NOTICE_IDIOT_EJECT 6
#define CRADLE_NOTICE_FORCE_EJECT 7
//Cradle
//This code is so shit, I don't even want to fix it. If someone wants to, please fix var/repairing never being used and try to make sense of the procs
//Like auto_start() gets called 20 seconds after the machine says it's starting, which seems to be turning on the machine, but immediately calls repair_op() which pops out the occupant ???????

/obj/machinery/robotic_cradle
	name = "robotic cradle"
	desc = "A highly experimental robotic maintenence machine using a bath of industrial nanomachines to quickly restore any robotic machine inserted."
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	density = TRUE
	max_integrity = 350
	soft_armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 100, FIRE = 30, ACID = 30)
	//It uses power
	use_power = ACTIVE_POWER_USE
	idle_power_usage = 15
	active_power_usage = 10000 // It rebuilds you from nothing...

	///This var is used to see if the machine is currently repairing or not.
	var/repairing = FALSE
	///This var is the reference used for the patient
	var/mob/living/carbon/human/occupant
	///This var is in reference to the radio the cradle uses to speak to the crew
	var/obj/item/radio/headset/mainship/doc/radio

/obj/machinery/robotic_cradle/Initialize(mapload)
	. = ..()
	radio = new(src)

/obj/machinery/robotic_cradle/Destroy()
	do_eject(forceeject = TRUE)
	if(radio)
		QDEL_NULL(radio)
	return ..()

/obj/machinery/robotic_cradle/update_icon_state()
	if(occupant && !(machine_stat & NOPOWER))
		icon_state = "borgcharger1"
		return ..()
	icon_state = "borgcharger0"

/obj/machinery/robotic_cradle/power_change()
	. = ..()
	if(is_operational() || !occupant)
		return
	visible_message("[src] engages the safety override, ejecting the occupant.")
	repairing = FALSE
	go_out(CRADLE_NOTICE_NO_POWER)

/obj/machinery/robotic_cradle/process()
	if(!occupant)
		return

	if(occupant.stat == DEAD)
		say("Patient has expired.")
		repairing = FALSE
		go_out(CRADLE_NOTICE_DEATH)
		return

	if(!repairing)
		return

///This proc handles the actual repair once the timer is up, ejection of the healed robot and radio message of ejection.
/obj/machinery/robotic_cradle/proc/repair_op()
	if(QDELETED(occupant) || occupant.stat == DEAD)
		if(!ishuman(occupant))
			stack_trace("Non-human occupant made its way into the autodoc: [occupant] | [occupant?.type].")
		visible_message("[src] buzzes.")
		go_out(CRADLE_NOTICE_DEATH) //kick them out too.
		return

	occupant.revive()
	visible_message("\The [src] clicks and opens up having finished the requested operations.")
	repairing = FALSE
	go_out(CRADLE_NOTICE_SUCCESS)

/obj/machinery/robotic_cradle/attack_alien(mob/living/carbon/xenomorph/xeno_attacker, damage_amount = xeno_attacker.xeno_caste.melee_damage, damage_type = BRUTE, armor_type = MELEE, effects = TRUE, armor_penetration = xeno_attacker.xeno_caste.melee_ap, isrightclick = FALSE)
	if(!occupant)
		to_chat(xeno_attacker, span_xenowarning("There is nothing of interest in there."))
		return
	if(xeno_attacker.status_flags & INCORPOREAL || xeno_attacker.do_actions)
		return
	visible_message(span_warning("[xeno_attacker] begins to pry the [src]'s cover!"), 3)
	playsound(src,'sound/effects/metal_creaking.ogg', 25, 1)
	if(!do_after(xeno_attacker, 2 SECONDS))
		return
	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, 1)
	go_out()

//This proc acts as a heads up to the doctors/engineers about the patient exiting the cradle for whatever reason. Does not warn if the patient itself exits the cradle. it also wipes the memory of who the patient was and readies the cradle for a new patient.
/obj/machinery/robotic_cradle/proc/go_out(notice_code = FALSE)
	if(!occupant)
		return
	occupant.forceMove(drop_location())
	var/reason = "Reason for discharge: Procedural completion."
	switch(notice_code)
		if(CRADLE_NOTICE_SUCCESS)
			playsound(src, 'sound/machines/ping.ogg', 50, FALSE) //All steps finished properly; this is the 'normal' notification.
		if(CRADLE_NOTICE_DEATH)
			playsound(src, 'sound/machines/warning-buzzer.ogg', 50, FALSE)
			reason = "Reason for discharge: Patient has expired."
		if(CRADLE_NOTICE_NO_RECORD)
			playsound(src, 'sound/machines/warning-buzzer.ogg', 50, FALSE)
			reason = "Reason for discharge: Medical records not detected. Alerting security advised."
		if(CRADLE_NOTICE_NO_POWER)
			playsound(src, 'sound/machines/warning-buzzer.ogg', 50, FALSE)
			reason = "Reason for discharge: Power failure."
		if(CRADLE_NOTICE_XENO_FUCKERY)
			playsound(src, 'sound/machines/warning-buzzer.ogg', 50, FALSE)
			reason = "Reason for discharge: Unauthorized manual release. Alerting security advised."
		if(CRADLE_NOTICE_IDIOT_EJECT)
			playsound(src, 'sound/machines/warning-buzzer.ogg', 50, FALSE)
			reason = "Reason for discharge: Unauthorized manual release during repair. Alerting security advised."
		if(CRADLE_NOTICE_FORCE_EJECT)
			playsound(src, 'sound/machines/warning-buzzer.ogg', 50, FALSE)
			reason = "Reason for discharge: Destruction of linked CRADLE Engineering System. Alerting security advised."
	radio.talk_into(src, "<b>Patient: [occupant] has been released from [src] at: [get_area(src)]. [reason]</b>", RADIO_CHANNEL_MEDICAL)
	occupant = null
	update_icon()
	stop_processing()

//This proc is what a robot calls when they try to enter a cradle on their own.
/obj/machinery/robotic_cradle/proc/move_inside_wrapper(mob/living/dropped, mob/dragger)
	if(dragger.incapacitated() || !ishuman(dragger) || !isrobot(dropped))
		return

	if(occupant)
		to_chat(dragger, span_notice("[src] is already occupied!"))
		return

	if(machine_stat & (NOPOWER|BROKEN))
		to_chat(dragger, span_notice("[src] is non-functional!"))
		return

	if(dragger.skills.getRating(SKILL_ENGINEER) < SKILL_ENGINEER_ENGI)
		dropped.visible_message(span_notice("[dropped] fumbles around figuring out how to get into \the [src]."),
		span_notice("You fumble around figuring out how to get into \the [src]."))
		var/fumbling_time = max(0 , SKILL_TASK_TOUGH - ( SKILL_TASK_EASY * dragger.skills.getRating(SKILL_ENGINEER) ))// 8 secs non-trained, 5 amateur
		if(!do_after(dropped, fumbling_time, NONE, src, BUSY_ICON_UNSKILLED))
			return

	dropped.visible_message(span_notice("[dropped] starts climbing into \the [src]."),
	span_notice("You start climbing into \the [src]."))
	if(!do_after(dropped, 1 SECONDS, IGNORE_HELD_ITEM, src, BUSY_ICON_GENERIC))
		return
	if(occupant)
		to_chat(dragger, span_notice("[src] is already occupied!"))
		return
	dropped.stop_pulling()
	dropped.forceMove(src)
	occupant = dropped
	var/implants = list(/obj/item/implant/neurostim)
	var/mob/living/carbon/human/H = occupant
	var/doc_dat
	med_scan(H, doc_dat, implants, TRUE)
	start_processing()
	update_icon()

	say("Automatic mode engaged, initialising procedure.")
	addtimer(CALLBACK(src, PROC_REF(auto_start)), 20 SECONDS)

///Callback to start auto mode on someone entering
/obj/machinery/robotic_cradle/proc/auto_start()
	if(repairing)
		return
	if(!occupant)
		say("Occupant missing, procedures canceled.")
		return
	say("Beginning repair procedure.")
	repair_op()

/obj/machinery/robotic_cradle/MouseDrop_T(mob/dropping, mob/user)
	. = ..()
	move_inside_wrapper(dropping, user)

/obj/machinery/robotic_cradle/verb/move_inside()
	set name = "Enter Cradle"
	set category = "Object"
	set src in oview(1)

	move_inside_wrapper(usr, usr)

/obj/machinery/robotic_cradle/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(.)
		return

	if(istype(I, /obj/item/healthanalyzer) && occupant) //Allows us to use the analyzer on the occupant without taking him out.
		var/obj/item/healthanalyzer/J = I
		J.attack(occupant, user)
		return

/obj/machinery/robotic_cradle/grab_interact(obj/item/grab/grab, mob/user, base_damage = BASE_OBJ_SLAM_DAMAGE, is_sharp = FALSE)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	if(machine_stat & (NOPOWER|BROKEN))
		to_chat(user, span_notice("\ [src] is non-functional!"))
		return

	if(occupant)
		to_chat(user, span_notice("\ [src] is already occupied!"))
		return

	var/mob/grabbed_mob

	if(ismob(grab.grabbed_thing))
		grabbed_mob = grab.grabbed_thing

	else if(istype(grab.grabbed_thing,/obj/structure/closet/bodybag/cryobag))
		var/obj/structure/closet/bodybag/cryobag/cryobag = grab.grabbed_thing
		if(!cryobag.bodybag_occupant)
			to_chat(user, span_warning("The stasis bag is empty!"))
			return
		grabbed_mob = cryobag.bodybag_occupant
		cryobag.open()
		user.start_pulling(grabbed_mob)

	if(!ishuman(grabbed_mob))
		to_chat(user, span_notice("\ [src] is compatible with humanoid anatomies only!"))
		return

	if(ishumanbasic(grabbed_mob))
		to_chat(user, span_warning("Subject is biological, cannot repair."))
		return

	if(grabbed_mob.abiotic())
		to_chat(user, span_warning("Subject cannot have abiotic items on."))
		return

	if(user.skills.getRating(SKILL_ENGINEER) < SKILL_ENGINEER_ENGI)
		user.visible_message(span_notice("[user] fumbles around figuring out how to put [grabbed_mob] into [src]."),
		span_notice("You fumble around figuring out how to put [grabbed_mob] into [src]."))
		var/fumbling_time = max(0 , SKILL_TASK_TOUGH - ( SKILL_TASK_EASY * user.skills.getRating(SKILL_ENGINEER) ))// 8 secs non-trained, 5 amateur
		if(!do_after(user, fumbling_time, NONE, grabbed_mob, BUSY_ICON_UNSKILLED) || QDELETED(src))
			return

	visible_message("[user] starts putting [grabbed_mob] into [src].", 3)

	if(!do_after(user, 10, IGNORE_HELD_ITEM, grabbed_mob, BUSY_ICON_GENERIC) || QDELETED(src))
		return

	if(occupant)
		to_chat(user, span_notice("[src] is already occupied!"))
		return

	if(!grabbed_mob || !grab)
		return

	grabbed_mob.forceMove(src)
	occupant = grabbed_mob
	update_icon()
	var/implants = list(/obj/item/implant/neurostim)
	var/mob/living/carbon/human/H = occupant
	med_scan(H, null, implants, TRUE)
	start_processing()
	say("Automatic mode engaged, initialising procedure.")
	addtimer(CALLBACK(src, PROC_REF(auto_start)), 20 SECONDS)

	return TRUE

/obj/machinery/robotic_cradle/verb/eject()
	set name = "Eject cradle"
	set category = "Object"
	set src in oview(1)
	if(usr.incapacitated())
		return
	do_eject()

///This proc ejects whomever is inside the cradle, by force if needed depending if the cradle is destroyed or not.
/obj/machinery/robotic_cradle/proc/do_eject(forceeject)
	if(!occupant)
		return
	if(forceeject)
		if(!repairing)
			visible_message("\The [src] is destroyed, ejecting [occupant] and showering them in debris.")
			occupant.take_limb_damage(rand(10,20),rand(10,20))
		else
			visible_message("\The [src] malfunctions as it is destroyed mid-repair, ejecting [occupant] with unfinished repair wounds and showering them in debris.")
			occupant.take_limb_damage(rand(30,50),rand(30,50))
		go_out(CRADLE_NOTICE_FORCE_EJECT)
		return
	if(isxeno(usr) && !repairing) // let xenos eject people hiding inside; a xeno ejecting someone during repair does so like someone untrained
		go_out(CRADLE_NOTICE_XENO_FUCKERY)
		return
	if(!ishuman(usr))
		return
	if(usr == occupant)
		if(repairing)
			to_chat(usr, span_warning("There's no way you're getting out while this thing is operating on you!"))
			return
		else
			visible_message("[usr] engages the internal release mechanism, and climbs out of \the [src].")
	if(usr.skills.getRating(SKILL_ENGINEER) < SKILL_ENGINEER_ENGI)
		usr.visible_message(span_notice("[usr] fumbles around figuring out how to use [src]."),
		span_notice("You fumble around figuring out how to use [src]."))
		var/fumbling_time = max(0 , SKILL_TASK_TOUGH - ( SKILL_TASK_EASY * usr.skills.getRating(SKILL_ENGINEER) ))// 8 secs non-trained, 5 amateur
		if(!do_after(usr, fumbling_time, NONE, src, BUSY_ICON_UNSKILLED) || !occupant)
			return
	if(repairing)
		repairing = FALSE
		if(usr.skills.getRating(SKILL_ENGINEER) < SKILL_ENGINEER_ENGI) //Untrained people will fail to terminate the repair properly.
			visible_message("\The [src] malfunctions as [usr] aborts the rapair in progress.")
			occupant.take_limb_damage(rand(30,50),rand(30,50))
			log_game("[key_name(usr)] ejected [key_name(occupant)] from the cradle during repair causing damage.")
			message_admins("[ADMIN_TPMONTY(usr)] ejected [ADMIN_TPMONTY(occupant)] from the cradle during repair causing damage.")
			go_out(CRADLE_NOTICE_IDIOT_EJECT)
			return
	go_out()

#undef CRADLE_NOTICE_SUCCESS
#undef CRADLE_NOTICE_DEATH
#undef CRADLE_NOTICE_NO_RECORD
#undef CRADLE_NOTICE_NO_POWER
#undef CRADLE_NOTICE_XENO_FUCKERY
#undef CRADLE_NOTICE_IDIOT_EJECT
#undef CRADLE_NOTICE_FORCE_EJECT
