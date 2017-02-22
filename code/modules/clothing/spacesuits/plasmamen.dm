// PLASMEN SHIT
// CAN'T WEAR UNLESS YOU'RE A PINK SKELETON
/obj/item/clothing/suit/space/eva/plasmaman
	name = "plasmaman suit"
	desc = "A special containment suit designed to protect a plasmaman's volatile body from outside exposure and quickly extinguish it in emergencies."
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_casing,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword/saber,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank)
	slowdown = 0
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 20)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	species_restricted = list("Plasmaman")
	flags = STOPSPRESSUREDMAGE
	autoextinguish = 1

	icon_state = "plasmaman_suit"
	item_state = "plasmaman_suit"

	actions_types = list(/datum/action/item_action/eject_depleted_cartridges)
	var/extinguisher_cart_type = /obj/item/weapon/extinguisher/cartridge
	var/obj/item/weapon/extinguisher/cartridge/cart1
	var/obj/item/weapon/extinguisher/cartridge/cart2
	var/next_extinguish = 0
	var/extinguish_cooldown = 10 SECONDS

/obj/item/clothing/suit/space/eva/plasmaman/New()
	if(!cart1)
		cart1 = new extinguisher_cart_type(src)
	if(!cart2)
		cart2 = new extinguisher_cart_type(src)
	..()

/obj/item/clothing/suit/space/eva/plasmaman/examine(mob/user)
	..(user)
	var/extinguishes_left = 0
	if(cart1)
		extinguishes_left += cart1.reagents.total_volume / cart1.volume_per_use
	if(cart2)
		extinguishes_left += cart2.reagents.total_volume / cart2.volume_per_use
	to_chat(user, "<span class='info'>This suit can automatically extinguish [extinguishes_left] more times.</span>")

/obj/item/clothing/suit/space/eva/plasmaman/auto_extinguish(var/mob/living/carbon/human/H)
	if(istype(H) && istype(H.head, /obj/item/clothing/head/helmet/space/eva/plasmaman)) //Only extinguish if the mob's wearing the whole suit.
		if(next_extinguish > world.time)
			return

		var/extinguish = 0
		if(cart1 && cart1.try_use())
			extinguish = 1
		else if(cart2 && cart2.try_use())
			to_chat(H, "<span class='notice'>Primary cartridge absent or depleted, extinguishing from secondary cartridge.</span>")
			extinguish = 1
		else
			to_chat(H, "<span class='warning'>Unable to extinguish, all cartridges absent or depleted. Replenish immediately.</span>")

		if(extinguish)
			next_extinguish = world.time + extinguish_cooldown
			..() //Extinguish the mob with the parent proc.

/obj/item/clothing/suit/space/eva/plasmaman/proc/eject_depleted_cartridges(mob/user)
	if(cart1 && cart1.reagents.total_volume < cart1.max_water)
		cart1.forceMove(get_turf(loc))
		user.put_in_hands(cart1)
		cart1 = null
	if(cart2 && cart2.reagents.total_volume < cart2.max_water)
		cart2.forceMove(get_turf(loc))
		user.put_in_hands(cart2)
		cart2 = null

	if(!cart1 || !cart2)
		to_chat(usr, "<span class='notice'>You eject the depleted extinguisher cartridges from \the [src].</span>")
	else
		to_chat(usr, "<span class='notice'>No extinguisher cartridges were ejected from \the [src].</span>")

/obj/item/clothing/suit/space/eva/plasmaman/attack_self(mob/user)
	eject_depleted_cartridges(user)

/obj/item/clothing/suit/space/eva/plasmaman/attackby(var/obj/item/A as obj, mob/user as mob, params)
	..()
	if(istype(A, extinguisher_cart_type))
		if(cart1 && cart2)
			to_chat(user, "<span class='notice'>There's already cartridges in \the [src].</span>")
		else
			var/obj/item/weapon/extinguisher/cartridge/cart = A
			user.remove_from_mob(cart)
			if(!cart1)
				cart1 = cart
			else if(!cart2)
				cart2 = cart
			cart.forceMove(src)
			to_chat(user, "<span class='notice'>You load the extinguisher cartridge into \the [src].</span>")

/obj/item/clothing/head/helmet/space/eva/plasmaman
	name = "plasmaman helmet"
	desc = "A special containment helmet designed to protect a plasmaman's volatile body from outside exposure and quickly extinguish it in emergencies."
	flags = STOPSPRESSUREDMAGE
	species_restricted = list("Plasmaman")

	icon_state = "plasmaman_helmet0"
	item_state = "plasmaman_helmet0"
	var/base_state = "plasmaman_helmet"
	var/brightness_on = 4 //luminosity when on
	var/on = 0
	actions_types = list(/datum/action/item_action/toggle_helmet_light)

/obj/item/clothing/head/helmet/space/eva/plasmaman/attack_self(mob/user)
	toggle_light(user)

/obj/item/clothing/head/helmet/space/eva/plasmaman/proc/toggle_light(mob/user)
	on = !on
	icon_state = "[base_state][on]"

	if(on)
		set_light(brightness_on)
	else
		set_light(0)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_head()

	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

// ENGINEERING
/obj/item/clothing/suit/space/eva/plasmaman/atmostech
	name = "plasmaman atmospheric suit"
	icon_state = "plasmamanAtmos_suit"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 0)
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/space/eva/plasmaman/atmostech
	name = "plasmaman atmospheric helmet"
	icon_state = "plasmamanAtmos_helmet0"
	base_state = "plasmamanAtmos_helmet"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 0)
	max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/eva/plasmaman/engineer
	name = "plasmaman engineer suit"
	icon_state = "plasmamanEngineer_suit"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 75)

/obj/item/clothing/head/helmet/space/eva/plasmaman/engineer
	name = "plasmaman engineer helmet"
	icon_state = "plasmamanEngineer_helmet0"
	base_state = "plasmamanEngineer_helmet"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 75)

/obj/item/clothing/suit/space/eva/plasmaman/engineer/ce
	name = "plasmaman chief engineer suit"
	icon_state = "plasmaman_CE"
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/space/eva/plasmaman/engineer/ce
	name = "plasmaman chief engineer helmet"
	icon_state = "plasmaman_CE_helmet0"
	base_state = "plasmaman_CE_helmet"
	max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT


//SERVICE
/obj/item/clothing/suit/space/eva/plasmaman/assistant
	name = "plasmaman assistant suit"
	icon_state = "plasmamanAssistant_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/assistant
	name = "plasmaman assistant helmet"
	icon_state = "plasmamanAssistant_helmet0"
	base_state = "plasmamanAssistant_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/botanist
	name = "plasmaman botanist suit"
	icon_state = "plasmamanBotanist_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/botanist
	name = "plasmaman botanist helmet"
	icon_state = "plasmamanBotanist_helmet0"
	base_state = "plasmamanBotanist_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/chaplain
	name = "plasmaman chaplain suit"
	icon_state = "plasmamanChaplain_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/chaplain
	name = "plasmaman chaplain helmet"
	icon_state = "plasmamanChaplain_helmet0"
	base_state = "plasmamanChaplain_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/clown
	name = "plasmaman clown suit"
	icon_state = "plasmaman_Clown"

/obj/item/clothing/head/helmet/space/eva/plasmaman/clown
	name = "plasmaman clown helmet"
	icon_state = "plasmaman_Clown_helmet0"
	base_state = "plasmaman_Clown_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/mime
	name = "plasmaman mime suit"
	icon_state = "plasmaman_Mime"

/obj/item/clothing/head/helmet/space/eva/plasmaman/mime
	name = "plasmaman mime helmet"
	icon_state = "plasmaman_Mime_helmet0"
	base_state = "plasmaman_Mime_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/service
	name = "plasmaman service suit"
	icon_state = "plasmamanService_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/service
	name = "plasmaman service helmet"
	icon_state = "plasmamanService_helmet0"
	base_state = "plasmamanService_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/janitor
	name = "plasmaman janitor suit"
	icon_state = "plasmamanJanitor_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/janitor
	name = "plasmaman janitor helmet"
	icon_state = "plasmamanJanitor_helmet0"
	base_state = "plasmamanJanitor_helmet"


//CARGO

/obj/item/clothing/suit/space/eva/plasmaman/cargo
	name = "plasmaman cargo suit"
	icon_state = "plasmamanCargo_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/cargo
	name = "plasmaman cargo helmet"
	icon_state = "plasmamanCargo_helmet0"
	base_state = "plasmamanCargo_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/miner
	name = "plasmaman miner suit"
	icon_state = "plasmamanMiner_suit"
	armor = list(melee = 30, bullet = 5, laser = 10, energy = 5, bomb = 50, bio = 100, rad = 50)
	slowdown = 1

/obj/item/clothing/head/helmet/space/eva/plasmaman/miner
	name = "plasmaman miner helmet"
	icon_state = "plasmamanMiner_helmet0"
	base_state = "plasmamanMiner_helmet"
	armor = list(melee = 30, bullet = 5, laser = 10, energy = 5, bomb = 50, bio = 100, rad = 50)


// MEDSCI

/obj/item/clothing/suit/space/eva/plasmaman/medical
	name = "plasmaman medical suit"
	icon_state = "plasmamanMedical_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/medical
	name = "plasmaman medical helmet"
	icon_state = "plasmamanMedical_helmet0"
	base_state = "plasmamanMedical_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/medical/paramedic
	name = "plasmaman paramedic suit"
	icon_state = "plasmaman_Paramedic"

/obj/item/clothing/head/helmet/space/eva/plasmaman/medical/paramedic
	name = "plasmaman paramedic helmet"
	icon_state = "plasmaman_Paramedic_helmet0"
	base_state = "plasmaman_Paramedic_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/medical/chemist
	name = "plasmaman chemist suit"
	icon_state = "plasmaman_Chemist"

/obj/item/clothing/head/helmet/space/eva/plasmaman/medical/chemist
	name = "plasmaman chemist helmet"
	icon_state = "plasmaman_Chemist_helmet0"
	base_state = "plasmaman_Chemist_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/medical/cmo
	name = "plasmaman chief medical officer suit"
	icon_state = "plasmaman_CMO"

/obj/item/clothing/head/helmet/space/eva/plasmaman/medical/cmo
	name = "plasmaman chief medical officer helmet"
	icon_state = "plasmaman_CMO_helmet0"
	base_state = "plasmaman_CMO_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/science
	name = "plasmaman scientist suit"
	icon_state = "plasmamanScience_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/science
	name = "plasmaman scientist helmet"
	icon_state = "plasmamanScience_helmet0"
	base_state = "plasmamanScience_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/science/rd
	name = "plasmaman research director suit"
	icon_state = "plasmaman_RD"

/obj/item/clothing/head/helmet/space/eva/plasmaman/science/rd
	name = "plasmaman research director helmet"
	icon_state = "plasmaman_RD_helmet0"
	base_state = "plasmaman_RD_helmet"

//MAGISTRATE
/obj/item/clothing/suit/space/eva/plasmaman/magistrate
	name = "plasmaman magistrate suit"
	icon_state = "plasmaman_HoS"

/obj/item/clothing/head/helmet/space/eva/plasmaman/magistrate
	name = "plasmaman magistrate helmet"
	icon_state = "plasmaman_HoS_helmet0"
	base_state = "plasmaman_HoS_helmet"

//SECURITY

/obj/item/clothing/suit/space/eva/plasmaman/security
	name = "plasmaman security suit"
	icon_state = "plasmamanSecurity_suit"
	armor = list(melee = 15, bullet = 15, laser = 15, energy = 10, bomb = 10, bio = 100, rad = 50)

/obj/item/clothing/head/helmet/space/eva/plasmaman/security
	name = "plasmaman security helmet"
	icon_state = "plasmamanSecurity_helmet0"
	base_state = "plasmamanSecurity_helmet"
	armor = list(melee = 15, bullet = 15, laser = 15, energy = 10, bomb = 10, bio = 100, rad = 50)

/obj/item/clothing/suit/space/eva/plasmaman/security/hos
	name = "plasmaman head of security suit"
	icon_state = "plasmaman_HoS"

/obj/item/clothing/head/helmet/space/eva/plasmaman/security/hos
	name = "plasmaman head of security helmet"
	icon_state = "plasmaman_HoS_helmet0"
	base_state = "plasmaman_HoS_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/security/hop
	name = "plasmaman head of personnel suit"
	icon_state = "plasmaman_HoP"

/obj/item/clothing/head/helmet/space/eva/plasmaman/security/hop
	name = "plasmaman head of personnel helmet"
	icon_state = "plasmaman_HoP_helmet0"
	base_state = "plasmaman_HoP_helmet"

/obj/item/clothing/suit/space/eva/plasmaman/security/captain
	name = "plasmaman captain suit"
	icon_state = "plasmaman_Captain"

/obj/item/clothing/head/helmet/space/eva/plasmaman/security/captain
	name = "plasmaman captain helmet"
	icon_state = "plasmaman_Captain_helmet0"
	base_state = "plasmaman_Captain_helmet"


//IAA/LAWYER
/obj/item/clothing/suit/space/eva/plasmaman/lawyer
	name = "plasmaman lawyer suit"
	icon_state = "plasmamanlawyer_suit"

/obj/item/clothing/head/helmet/space/eva/plasmaman/lawyer
	name = "plasmaman lawyer helmet"
	icon_state = "plasmamanlawyer_helmet0"
	base_state = "plasmamanlawyer_helmet"

//NUKEOPS

/obj/item/clothing/suit/space/eva/plasmaman/nuclear
	name = "blood red plasmaman suit"
	icon_state = "plasmaman_Nukeops"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/gun,/obj/item/ammo_casing,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword/saber,/obj/item/weapon/restraints/handcuffs)

/obj/item/clothing/head/helmet/space/eva/plasmaman/nuclear
	name = "blood red plasmaman helmet"
	icon_state = "plasmaman_Nukeops_helmet0"
	base_state = "plasmaman_Nukeops_helmet"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)
