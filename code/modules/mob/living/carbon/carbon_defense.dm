/mob/living/carbon/hitby(atom/movable/AM, skip)
	if(!skip)	//ugly, but easy
		if(in_throw_mode && !get_active_hand())	//empty active hand and we're in throw mode
			if(canmove && !restrained())
				if(istype(AM, /obj/item))
					var/obj/item/I = AM
					if(isturf(I.loc))
						put_in_active_hand(I)
						visible_message("<span class='warning'>[src] catches [I]!</span>")
						throw_mode_off()
						return
		else if(get_active_hand())
			var obj/item/active_hand = get_active_hand()
			if (active_hand.IsDeflect()) //deflection for thrown objects - probably already implemented but too lazy to look for it
				if (istype(AM, /obj/item) && !istype(AM, /obj/item/projectile)) //This doesn't let you deflect bullets or darts
					var/obj/item/I = AM
					if(isturf(I.loc) && I.w_class <= 2)
						playsound(src.loc, 'sound/weapons/bbhit.ogg', 30)
						visible_message("<span class='warning'>[src] deflects [I] with \an [active_hand.name]!</span>")
						var/new_x = I.loc.x + rand(-5,5)
						var/new_y = I.loc.y + rand(-5,5)
						var/newloc = locate(new_x, new_y, I.loc.z)
						I.throw_at(newloc,16,3,src,1)
						return
	..()

/mob/living/carbon/attackby(obj/item/I, mob/user, params)
	if(lying || isslime(src))
		if(user.a_intent == "help")
			for(var/datum/surgery/S in surgeries)
				if(S.next_step(user, src))
					return 1
	..()


/mob/living/carbon/attack_hand(mob/living/carbon/human/user)
	if(!iscarbon(user))
		return

	for(var/datum/disease/D in viruses)
		if(D.IsSpreadByTouch())
			user.ContractDisease(D)

	for(var/datum/disease/D in user.viruses)
		if(D.IsSpreadByTouch())
			ContractDisease(D)

	if(lying || isslime(src))
		if(user.a_intent == "help")
			if(surgeries.len)
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(user, src))
						return 1
	return 0


/mob/living/carbon/attack_paw(mob/living/carbon/monkey/M as mob)
	if(!istype(M, /mob/living/carbon))
		return 0

	for(var/datum/disease/D in viruses)
		if(D.IsSpreadByTouch())
			M.ContractDisease(D)

	for(var/datum/disease/D in M.viruses)
		if(D.IsSpreadByTouch())
			ContractDisease(D)

	if(M.a_intent == "help")
		help_shake_act(M)
		return 0

	if(..()) //successful monkey bite.
		for(var/datum/disease/D in M.viruses)
			ForceContractDisease(D)
		return 1


/mob/living/carbon/attack_slime(mob/living/carbon/slime/M)
	if(..())
		var/power = M.powerlevel + rand(0,3)
		Weaken(power)
		if (stuttering < power)
			stuttering = power
		Stun(power)
		var/stunprob = M.powerlevel * 7 + 10
		if (prob(stunprob) && M.powerlevel >= 8)
			adjustFireLoss(M.powerlevel * rand(6,10))
			updatehealth()
		return 1

/mob/living/carbon/proc/try_dismember(var/obj/item/I, zone)
	if(organsystem && ishuman(src))
		if(zone == "mouth")
			zone = "head"
		var/datum/organ/limb/L = get_organdatum(zone)
		if(!L || !L.exists())
			return 0
		else
			var/datum/organ/O = I.handle_dismemberment(L)
			if(O)
				visible_message("<span class='danger'>[src]'s [O.name] goes flying off!</span>", "<span class='userdanger'>Your [O.name] goes flying off!</span>")
				var/turf/location = src.loc
				if(istype(location, /turf/simulated))
					location.add_blood_floor(src)
				return 1	//Dismemberment succesful
			else
				return 0 //Attack continues normally
	else
		return 0 //If the mob has no organsystem, dismemberment is not possible.

/mob/living/carbon/bullet_act(obj/item/projectile/P, def_zone)
	if(try_dismember(P, def_zone))
		P.nodamage = 1	//So it won't deal damage after dismemberment
	return (..(P , def_zone))

/mob/living/carbon/attacked_by(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!try_dismember(I, def_zone))
		..(I, user, def_zone) //If dismemberment fails, continue with the attack
