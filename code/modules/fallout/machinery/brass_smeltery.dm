#define LOG_BURN_TIMER 15 SECONDS
#define MAXIMUM_BURN_TIMER 10 MINUTES
#define TIME_PER_BRASS 10 SECONDS

/obj/machinery/brass_smeltery
	name = "brass smeltery"
	desc = "An advanced piece of machinery that produces brass alloy."
	icon = 'icons/obj/waterpurifier.dmi'
	icon_state = "purifier"

	flags_1 = NODECONSTRUCT_1
	move_resist = INFINITY
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	use_power = NO_POWER_USE
	density = TRUE

	/// Whether the smeltery is currently burning fuel
	var/activated = FALSE
	/// How much fuel the smeltery currently is loaded with (1 fuel per sheet of wood).
	var/fuel_added = 0
	/// Timer until smeltery stops producing
	var/flame_expiry_timer
	/// Timer until a new sheet of brass is made
	var/brass_production_timer
	/// How much brass the smeltery contains.
	var/brass = 0

/obj/machinery/brass_smeltery/attackby(obj/item/T, mob/user)
	if(istype(T, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/wood = T
		var/space_remaining = MAXIMUM_BURN_TIMER - burn_time_remaining()
		var/space_for_logs = round(space_remaining / LOG_BURN_TIMER)
		if(space_for_logs < 1)
			to_chat(user, "<span class='warning'>You can't fit any more of [T] in [src]!</span>")
			return
		var/logs_used = min(space_for_logs, wood.amount)
		wood.use(logs_used)
		adjust_fuel_timer(LOG_BURN_TIMER * logs_used)
		user.visible_message("<span class='notice'>[user] tosses some \
			wood into [src].</span>", "<span class='notice'>You add \
			some fuel to [src].</span>")
		if(!activated)
			ignite()
	else
		. = ..()

/obj/machinery/brass_smeltery/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	. = ..()
	if(!brass)
		to_chat(user, "<span class='warning'>There's no brass in the smeltery to take out!</span>")
		return 
	var/brass_to_take = input(user, "How much brass would you like to take out?", "Brass Smeltery") as num
	if(brass_to_take)
		brass_to_take = min(brass_to_take, brass)
		brass -= brass_to_take
		new /obj/item/stack/sheet/brass(loc, brass_to_take)

/obj/machinery/brass_smeltery/proc/adjust_light()
	if(!activated)
		set_light(0)
		return
	set_light(5)

/obj/machinery/brass_smeltery/process()
	if(!activated)
		return
	
	if(world.time > brass_production_timer)
		brass++
		brass_production_timer = world.time + TIME_PER_BRASS

	if(world.time > flame_expiry_timer)
		put_out()
		return

/obj/machinery/brass_smeltery/proc/adjust_fuel_timer(amount)
	if(activated)
		flame_expiry_timer += amount
		if(burn_time_remaining() < MAXIMUM_BURN_TIMER)
			flame_expiry_timer = world.time + MAXIMUM_BURN_TIMER
	else
		fuel_added = clamp(fuel_added + amount, 0, MAXIMUM_BURN_TIMER)

/obj/machinery/brass_smeltery/proc/burn_time_remaining()
	if(activated)
		return max(0, flame_expiry_timer - world.time)
	else
		return max(0, fuel_added)

/obj/machinery/brass_smeltery/proc/ignite()
	activated = TRUE
	flame_expiry_timer = world.time + fuel_added
	brass_production_timer = world.time + TIME_PER_BRASS
	fuel_added = 0
	update_icon()
	adjust_light()

/obj/machinery/brass_smeltery/proc/put_out()
	activated = FALSE
	update_icon()
	adjust_light()

/obj/machinery/brass_smeltery/examine(mob/user)
	. += ..()
	if(activated)
		. += "<span class='notice'>[src] contains enough fuel to last [CEILING(burn_time_remaining()/600, 1)] minute[CEILING(burn_time_remaining()/600, 1) != 1 ? "s" : ""].</span>"
	if(brass)
		. += "<span class='notice'>[src] contains [brass] brass sheet[brass != 1 ? "s" : ""].</span>"


