/mob/proc/getorgan()
	return

/mob/living/carbon/getorgan(organ)
	if(organsystem) //If the mob has an organ system, you should give the name of the organ, i.e. "brain"
		return organsystem.getorgan(organ)
	return (locate(organ) in internal_organs) //If the mob does not have an organ system, we fall back on the old system where you give the path, i.e. /obj/item/organ/brain

/mob/proc/add_organ()
	return

//Adds an organ DATUM to the organsystem (used for suborgans). You probably shouldn't call this proc in most cases
/mob/living/carbon/add_organ(var/datum/organ/organ)
	if(organsystem)
		return organsystem.add_organ(organ)
	else return 0

mob/living/carbon/exists(var/organname)
	if(organsystem)
		var/datum/organ/O = getorgan(organname)
		return O.exists()
	else
		return 1

/mob/proc/getlimb()
	return

/mob/living/carbon/human/getlimb(typepath)
	return (locate(typepath) in organs)

mob/proc/exists(var/organname)
	return 1

/mob/proc/get_internal_organs(zone)
	return

//Return all the datum/organ/internal that are the selected organ's suborgans
/mob/living/carbon/get_internal_organs(zone)
	var/list/returnorg = list()

	var/datum/organ/PO = getorgan(zone)
	if(PO && PO.exists() && isorgan(PO.organitem))
		if(istype(PO, /datum/organ/internal))	//If we've already found an internal organ we can skip the next step
			returnorg += PO
			return returnorg
		var/obj/item/organ/OI = PO.organitem
		for(var/organname in OI.suborgans)
			if(!(organname == "eyes" || organname == "mouth"))	//They're their own damage zones
				var/datum/organ/RO = OI.suborgans[organname]
				if(RO.exists() && istype(RO, /datum/organ/internal))	//Only internal organs, not limbs etc.
					returnorg += RO
	return returnorg

/mob/proc/has_organ_slot()
	return 0

//Returns whether the zone has a slot for the organ
/mob/living/carbon/has_organ_slot(zone, organname)
	var/datum/organ/PO = getorgan(zone)
	if(PO && PO.exists())
		if(isorgan(PO.organitem))
			var/obj/item/organ/OI = PO.organitem
			var/datum/organ/RO = OI.suborgans[organname]
			return (RO && !RO.exists())
	return 0

/mob/proc/get_cyberimps()
	return 0

//How many cybernetic implants in this zone?
/mob/living/carbon/get_cyberimps(zone)
	var/datum/organ/PO = getorgan(zone)
	var/i = 0
	if(PO && PO.exists())
		if(isorgan(PO.organitem))
			var/obj/item/organ/OI = PO.organitem
			for(var/organname in OI.suborgans)
				var/datum/organ/RO = OI.suborgans[organname]
				if(RO && RO.exists() && istype(RO, /datum/organ/internal/cyberimp))
					i++
	return i

proc/isorgan(atom/A)
	return istype(A, /obj/item/organ)

proc/isinternalorgan(atom/A)
	return istype(A, /obj/item/organ/internal)