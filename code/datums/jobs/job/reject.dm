/datum/job/reject
	job_category = JOB_CAT_MARINE
	access = ALL_ANTAGONIST_ACCESS
	minimal_access = ALL_ANTAGONIST_ACCESS
	skills_type = /datum/skills/crafty
	faction = FACTION_REJECTS

// Reject's Grunt
/datum/outfit/job/reject/grunt/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.set_species("Reject Grunt")

	H.name = GLOB.namepool[/datum/namepool/reject/grunt].random_name(H)
	H.real_name = H.name

/datum/job/reject/grunt
	title = "Reject Grunt"
	outfit = /datum/outfit/job/reject/grunt
	multiple_outfits = TRUE
	outfits = list(
		/datum/outfit/job/reject/grunt/akimbo,
		/datum/outfit/job/reject/grunt/smg)

/datum/outfit/job/reject/grunt
	name = "Reject Grunt"
	jobtype = /datum/job/reject/grunt

	id = /obj/item/card/id/silver
	ears = /obj/item/radio/headset/distress/reject
	w_uniform = /obj/item/clothing/under/ // custom
	shoes = /obj/item/clothing/shoes/ // brown boots
	wear_suit = /obj/item/clothing/suit/armor/ // custom grunt armor
	gloves = /obj/item/clothing/gloves/ //black

// Grunt Akimbo Pistols
/datum/outfit/job/reject/grunt/akimbo

// Grunt SMG
/datum/outfit/job/reject/grunt/smg

// Reject's Medic
/datum/outfit/job/reject/medic/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.set_species("Reject Medic")

	H.name = GLOB.namepool[/datum/namepool/reject/medic].random_name(H)
	H.real_name = H.name

/datum/job/reject/medic
	title = "Reject Medic"
	outfit = /datum/outfit/job/reject/medic


/datum/outfit/job/reject/medic
	name = "Reject Medic"
	jobtype = /datum/job/reject/medic

	id = /obj/item/card/id
	belt = /obj/item/storage/belt/marine/sectoid
	head = /obj/item/clothing/head/helmet/sectoid
	ears = /obj/item/radio/headset/distress/sectoid
	w_uniform = /obj/item/clothing/under/sectoid
	glasses = /obj/item/clothing/glasses/night/sectoid
	shoes = /obj/item/clothing/shoes/sectoid
	wear_suit = /obj/item/clothing/suit/armor/sectoid
	gloves = /obj/item/clothing/gloves/sectoid
	r_store = /obj/item/stack/medical/heal_pack/gauze/sectoid
	l_store = /obj/item/explosive/grenade/sectoid
	back = /obj/item/weapon/gun/rifle/sectoid_rifle


/datum/outfit/job/sectoid/grunt/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/red, SLOT_IN_BELT)

// Reject's Medic
/datum/outfit/job/reject/medic/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.set_species("Reject Medic")

	H.name = GLOB.namepool[/datum/namepool/reject/medic].random_name(H)
	H.real_name = H.name

/datum/job/reject/medic
	title = "Reject Medic"
	outfit = /datum/outfit/job/reject/medic

/datum/outfit/job/reject/medic
	name = "Reject Medic"
	jobtype = /datum/job/reject/medic

	id = /obj/item/card/id
	belt = /obj/item/storage/belt/marine/sectoid
	head = /obj/item/clothing/head/helmet/sectoid
	ears = /obj/item/radio/headset/distress/sectoid
	w_uniform = /obj/item/clothing/under/sectoid
	glasses = /obj/item/clothing/glasses/night/sectoid
	shoes = /obj/item/clothing/shoes/sectoid
	wear_suit = /obj/item/clothing/suit/armor/sectoid
	gloves = /obj/item/clothing/gloves/sectoid
	r_store = /obj/item/stack/medical/heal_pack/gauze/sectoid
	l_store = /obj/item/explosive/grenade/sectoid
	back = /obj/item/weapon/gun/rifle/sectoid_rifle


/datum/outfit/job/sectoid/grunt/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/red, SLOT_IN_BELT)

//Reject's Specialist
/datum/outfit/job/reject/specialist/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.set_species("Reject Specialist")

	H.name = "The Seraph"
	H.real_name = H.name

/datum/job/reject/specialist
	title = "Reject Specialist"
	outfit = /datum/outfit/job/reject/specialist

/datum/outfit/job/sectoid/specialist
	name = "Reject Specialist"
	jobtype = /datum/job/reject/specialist

	id = /obj/item/card/id
	belt = /obj/item/storage/belt/marine/sectoid
	head = /obj/item/clothing/head/helmet/sectoid
	ears = /obj/item/radio/headset/distress/sectoid
	w_uniform = /obj/item/clothing/under/sectoid
	glasses = /obj/item/clothing/glasses/night/sectoid
	shoes = /obj/item/clothing/shoes/sectoid
	wear_suit = /obj/item/clothing/suit/armor/sectoid/shield
	gloves = /obj/item/clothing/gloves/sectoid
	r_store = /obj/item/stack/medical/heal_pack/gauze/sectoid
	l_store = /obj/item/explosive/grenade/sectoid
	back = /obj/item/weapon/gun/rifle/sectoid_rifle


/datum/outfit/job/sectoid/specialist/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/red, SLOT_IN_BELT)


//Reject's Leader
/datum/outfit/job/reject/leader/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.set_species("Reject Leader")

	H.name = GLOB.namepool[/datum/namepool/reject/leader].random_name(H)
	H.real_name = H.name

/datum/job/reject/leader
	job_category = JOB_CAT_COMMAND
	title = "Reject Leader"
	outfit = /datum/outfit/job/reject/leader

/datum/outfit/job/sectoid/leader
	name = "Reject Leader"
	jobtype = /datum/job/reject/leader

	id = /obj/item/card/id
	belt = /obj/item/storage/belt/marine/sectoid
	head = /obj/item/clothing/head/helmet/sectoid
	ears = /obj/item/radio/headset/distress/sectoid
	w_uniform = /obj/item/clothing/under/sectoid
	glasses = /obj/item/clothing/glasses/night/sectoid
	shoes = /obj/item/clothing/shoes/sectoid
	wear_suit = /obj/item/clothing/suit/armor/sectoid/shield
	gloves = /obj/item/clothing/gloves/sectoid
	r_store = /obj/item/stack/medical/heal_pack/gauze/sectoid
	l_store = /obj/item/explosive/grenade/sectoid
	back = /obj/item/weapon/gun/rifle/sectoid_rifle


/datum/outfit/job/sectoid/leader/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/sectoid_rifle, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/red, SLOT_IN_BELT)
