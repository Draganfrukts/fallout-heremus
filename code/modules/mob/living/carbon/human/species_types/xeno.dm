/datum/species/xeno
	// A cloning mistake, crossing human and xenomorph DNA
	name = "Xenomorph Hybrid"
	id = "xeno"
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,CAN_SCAR,HAS_FLESH,HAS_BONE)
	mutant_bodyparts = list("xenotail"="Xenomorph Tail","xenohead"="Standard","xenodorsal"="Standard", "mam_body_markings" = list(),"mcolor" = "0F0","mcolor2" = "0F0","mcolor3" = "0F0", "legs" = "Plantigrade","deco_wings"= "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/xeno
	gib_types = list(/obj/effect/gibspawner/xeno/xenoperson, /obj/effect/gibspawner/xeno/xenoperson/bodypartless)
	skinned_type = /obj/item/stack/sheet/animalhide/xeno
	exotic_bloodtype = "X*"
	damage_overlay_type = "xeno"
	liked_food = MEAT
	species_type = "alien"
