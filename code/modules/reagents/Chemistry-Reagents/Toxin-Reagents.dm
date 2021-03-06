
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Toxin"
	id = "toxin"
	synth_cost = 5
	can_synth = 1
	description = "A toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	var/toxpwr = 1.5

/datum/reagent/toxin/on_mob_life(var/mob/living/M as mob)
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM)
	..()
	return

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	synth_cost = 10
	can_synth = 2
	description = "A powerful poison derived from certain species of mushroom."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 1

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	synth_cost = 3
	description = "Might cause unpredictable mutations. Keep away from children."
	color = "#13BC5E" // rgb: 19, 188, 94
	toxpwr = 0

/datum/reagent/toxin/mutagen/reaction_mob(var/mob/living/carbon/M, var/method=TOUCH, var/reac_volume)
	if(!..())
		return
	if(!istype(M) || !M.dna)
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	if((method==VAPOR && prob(min(33, reac_volume))) || method==INGEST || method == PATCH)
		randmuti(M)
		if(prob(98))
			randmutb(M)
		else
			randmutg(M)
		domutcheck(M, null)
		updateappearance(M)
	..()

/datum/reagent/toxin/mutagen/on_mob_life(var/mob/living/carbon/M)
	if(istype(M))
		M.apply_effect(5,IRRADIATE,0)
	..()
	return

/datum/reagent/toxin/plasma
	name = "Plasma"
	id = "plasma"
	synth_cost = 10
	can_synth = 0 //no, plasma is a limiting factor in the gameplay
	description = "Plasma in its liquid form."
	color = "#500064" // rgb: 80, 0, 100
	toxpwr = 3

/datum/reagent/toxin/plasma/on_mob_life(var/mob/living/M as mob)
	if(holder.has_reagent("inaprovaline"))
		holder.remove_reagent("inaprovaline", 2*REM)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.adjustPlasma(20)
	..()
	return

/datum/reagent/toxin/plasma/reaction_obj(var/obj/O, var/reac_volume)
	/*if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg/slime))
		var/obj/item/weapon/reagent_containers/food/snacks/egg/slime/egg = O
		if (egg.grown)
			egg.Hatch()*/
	if((!O) || (!reac_volume))	return 0
	O.atmos_spawn_air(SPAWN_TOXINS|SPAWN_20C, reac_volume)

/datum/reagent/toxin/plasma/reaction_turf(var/turf/simulated/T, var/reac_volume)
	if(istype(T))
		T.atmos_spawn_air(SPAWN_TOXINS|SPAWN_20C, reac_volume)
	return

/datum/reagent/toxin/plasma/reaction_mob(var/mob/living/M, var/method=TOUCH, var/reac_volume)//Splashing people with plasma is stronger than fuel!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 5)
		return

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	synth_cost = 3
	can_synth = 2
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	color = "#C8A5DC" // rgb: 200, 165, 220
	toxpwr = 0

/datum/reagent/toxin/lexorin/on_mob_life(var/mob/living/M as mob)
	if(M.stat != DEAD)
		if(prob(33))
			M.take_organ_damage(1*REM, 0)
		M.adjustOxyLoss(5)
		M.losebreath++
		if(prob(20))
			M.emote("gasp")
	..()
	return

/datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	synth_cost = 5
	can_synth = 0
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0

/datum/reagent/toxin/slimejelly/on_mob_life(var/mob/living/M as mob)
	if(prob(10))
		M << "<span class='danger'>Your insides are burning!</span>"
		M.adjustToxLoss(rand(20,60)*REM)
	else if(prob(40))
		M.heal_organ_damage(5*REM,0)
	..()
	return

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	synth_cost = 5
	can_synth = 0
	description = "Useful for dealing with undesirable customers."
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0

/datum/reagent/toxin/minttoxin/on_mob_life(var/mob/living/M as mob)
	if (M.disabilities & FAT)
		M.gib()
	..()
	return

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	synth_cost = 5
	description = "A deadly neurotoxin produced by the dreaded spess carp."
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	synth_cost = 5
	can_synth = 2
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5

/datum/reagent/toxin/zombiepowder/on_mob_life(var/mob/living/carbon/M as mob)
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(0.5*REM)
	M.Weaken(5)
	M.silent = max(M.silent, 5)
	M.tod = worldtime2text()
	..()
	return

/datum/reagent/toxin/zombiepowder/on_mob_delete(mob/M)
	M.status_flags &= ~FAKEDEATH
	..()

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	synth_cost = 5
	description = "A powerful hallucinogen. Not a thing to be messed with."
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0

/datum/reagent/toxin/mindbreaker/on_mob_life(var/mob/living/M)
	M.hallucination += 10
	..()
	return

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	synth_cost = 1
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1

/datum/reagent/toxin/plantbgone/reaction_obj(var/obj/O, var/reac_volume)
	if(istype(O,/obj/structure/alien/weeds/))
		var/obj/structure/alien/weeds/alien_weeds = O
		alien_weeds.health -= rand(15,35) // Kills alien weeds pretty fast
		alien_weeds.healthcheck()
	else if(istype(O,/obj/effect/glowshroom)) //even a small amount is enough to kill it
		qdel(O)
	else if(istype(O,/obj/effect/spacevine))
		var/obj/effect/spacevine/SV = O
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/reaction_mob(var/mob/living/M, var/method=TOUCH, var/reac_volume)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.wear_mask) // If not wearing a mask
			var/damage = min(round(0.4*reac_volume, 0.1),10)
			C.adjustToxLoss(damage)

/datum/reagent/toxin/plantbgone/weedkiller
	name = "Weed Killer"
	id = "weedkiller"
	description = "A harmful toxic mixture to kill weeds. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75


/datum/reagent/toxin/pestkiller
	name = "Pest Killer"
	id = "pestkiller"
	synth_cost = 1
	description = "A harmful toxic mixture to kill pests. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1

/datum/reagent/toxin/pestkiller/reaction_mob(var/mob/living/M, var/method=TOUCH, var/reac_volume)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.wear_mask) // If not wearing a mask
			var/damage = min(round(0.4*reac_volume, 0.1),10)
			C.adjustToxLoss(damage)

/datum/reagent/toxin/spore
	name = "Spore Toxin"
	id = "spore"
	description = "A toxic spore cloud which blocks vision when ingested."
	color = "#9ACD32"
	toxpwr = 0.5

/datum/reagent/toxin/spore/on_mob_life(var/mob/living/M as mob)
	M.damageoverlaytemp = 60
	M.eye_blurry = max(M.eye_blurry, 3)
	..()
	return


/datum/reagent/toxin/spore_burning
	name = "Burning Spore Toxin"
	id = "spore_burning"
	description = "A burning spore cloud."
	color = "#9ACD32"
	toxpwr = 0.5

/datum/reagent/toxin/spore_burning/on_mob_life(var/mob/living/M as mob)
	..()
	M.adjust_fire_stacks(2)
	M.IgniteMob()

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	synth_cost = 4
	description = "A powerful sedative."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/chloralhydrate/on_mob_life(var/mob/living/M as mob)
	switch(current_cycle)
		if(1 to 5)
			M.confused += 2
			M.drowsyness += 2
		if(5 to 25)
			M.sleeping += 1
		if(25 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss((current_cycle - 25)*REM)
	..()
	return

/datum/reagent/toxin/beer2	//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/beer2/on_mob_life(var/mob/living/M as mob)
	switch(current_cycle)
		if(1 to 50)
			M.sleeping += 1
		if(51 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss((current_cycle - 50)*REM)
	..()
	return

/datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds"
	id = "coffeepowder"
	description = "Finely ground coffee beans, used to make coffee."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5

/datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves"
	id = "teapowder"
	description = "Finely shredded tea leaves, used for making tea."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.5

/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Mute Toxin"
	id = "mutetoxin"
	synth_cost = 5
	can_synth = 2
	description = "A toxin that temporarily paralyzes the vocal cords."
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0

/datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/M)
	M.silent = max(M.silent, 3)
	..()

/datum/reagent/toxin/staminatoxin
	name = "Tirizene"
	id = "tirizene"
	description = "A toxin that affects the stamina of a person when injected into the bloodstream."
	color = "#6E2828"
	data = 13
	toxpwr = 0

/datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/M)
	M.adjustStaminaLoss(REM * data)
	data = max(data - 1, 3)
	..()

/datum/reagent/toxin/polonium
	name = "Polonium"
	id = "polonium"
	synth_cost = 10
	can_synth = 2
	description = "Cause significant Radiation damage over time."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/polonium/on_mob_life(var/mob/living/M as mob)
	M.radiation += 4
	..()

/datum/reagent/toxin/histamine
	name = "Histamine"
	id = "histamine"
	synth_cost = 3
	description = "A dose-dependent toxin, ranges from annoying to incredibly lethal."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0

/datum/reagent/toxin/histamine/on_mob_life(var/mob/living/M as mob)
	if(prob(50))
		switch(pick(1, 2, 3, 4))
			if(1)
				M << "<span class='danger'>You can barely see!</span>"
				M.eye_blurry = 3
			if(2)
				M.emote("cough")
			if(3)
				M.emote("sneeze")
			if(4)
				if(prob(75))
					M << "You scratch at an itch."
					M.adjustBruteLoss(2*REM)
	..()

/datum/reagent/toxin/histamine/overdose_process(var/mob/living/M as mob)
	M.adjustOxyLoss(1*REM)
	M.adjustBruteLoss(1*REM)
	M.adjustToxLoss(1*REM)
	..()

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde"
	id = "formaldehyde"
	synth_cost = 3
	description = "Deals a moderate amount of Toxin damage over time. 10% chance to decay into 10-15 histamine."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/formaldehyde/on_mob_life(var/mob/living/M as mob)
	if(prob(5))
		M.reagents.add_reagent("histamine",pick(5,15))
		M.reagents.remove_reagent("formaldehyde",1)
	..()

/datum/reagent/toxin/venom
	name = "Venom"
	id = "venom"
	synth_cost = 2
	can_synth = 2
	description = "Will deal scaling amounts of Toxin and Brute damage over time. 15% chance to decay into 5-10 histamine."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/venom/on_mob_life(var/mob/living/M as mob)
	toxpwr = 0.05*volume
	M.adjustBruteLoss((0.1*volume)*REM)
	if(prob(15))
		M.reagents.add_reagent("histamine",pick(5,10))
		M.reagents.remove_reagent("venom",1)
	..()

/datum/reagent/toxin/neurotoxin2
	name = "Neurotoxin"
	id = "neurotoxin2"
	synth_cost = 4
	can_synth = 2
	description = "Deals toxin and brain damage up to 60 before it slows down, causing confusion and a knockout after 18 elapsed cycles."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/neurotoxin2/on_mob_life(var/mob/living/M as mob)
	if(M.brainloss + M.toxloss <= 60)
		M.adjustBrainLoss(1*REM)
		M.adjustToxLoss(1*REM)
	if(current_cycle >= 18)
		M.sleeping += 1
	..()

/datum/reagent/toxin/cyanide
	name = "Cyanide"
	id = "cyanide"
	synth_cost = 2
	description = "Deals toxin damage, alongside some oxygen loss. 8% chance of stun and some extra toxin damage."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.75

/datum/reagent/toxin/cyanide/on_mob_life(var/mob/living/M as mob)
	if(prob(5))
		M.losebreath += 1
	if(prob(4))
		M << "You feel horrendously weak!"
		M.Stun(2)
		M.adjustToxLoss(2*REM)
	..()

/datum/reagent/toxin/questionmark // food poisoning
	name = "Bad Food"
	id = "????"
	description = "????"
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/itching_powder
	name = "Itching Powder"
	id = "itching_powder"
	description = "Lots of annoying random effects, chances to do some brute damage from scratching. 6% chance to decay into 1-3 units of histamine."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/itching_powder/reaction_mob(var/mob/living/M, var/method=TOUCH, var/reac_volume)
	if(method != INGEST)
		M.reagents.add_reagent("itching_powder", reac_volume)
		return

/datum/reagent/toxin/itching_powder/on_mob_life(var/mob/living/M as mob)
	if(prob(15))
		M << "You scratch at your head."
		M.adjustBruteLoss(0.2*REM)
	if(prob(15))
		M << "You scratch at your leg."
		M.adjustBruteLoss(0.2*REM)
	if(prob(15))
		M << "You scratch at your arm."
		M.adjustBruteLoss(0.2*REM)
	if(prob(3))
		M.reagents.add_reagent("histamine",rand(1,3))
		M.reagents.remove_reagent("itching_powder",1)
	..()

/datum/reagent/toxin/initropidril
	name = "Initropidril"
	id = "initropidril"
	synth_cost = 4
	can_synth = 2
	description = "Causes some toxin damage, 5% chances to cause stunning, suffocation, or immediate heart failure."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 2.5

/datum/reagent/toxin/initropidril/on_mob_life(var/mob/living/M as mob)
	if(prob(5))
		var/picked_option = rand(1,3)
		switch(picked_option)
			if(1)
				M.Stun(3)
				M.Weaken(3)
			if(2)
				M.losebreath += 10
				M.adjustOxyLoss(rand(5,25))
			if(3)
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(!H.heart_attack)
						H.visible_message("<span class = 'userdanger'>[H] clutches at their chest as if their heart stopped!</span>")
						H.heart_attack = 1 // rip in pepperoni
					else
						H.losebreath += 10
						H.adjustOxyLoss(rand(5,25))
	..()

/datum/reagent/toxin/pancuronium
	name = "Pancuronium"
	id = "pancuronium"
	synth_cost = 5
	can_synth = 2
	description = "Knocks you out after 10 seconds, 7% chance to cause some oxygen loss."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/pancuronium/on_mob_life(var/mob/living/M as mob)
	if(current_cycle >= 10)
		M.SetParalysis(1)
	if(prob(7))
		M.losebreath += 4
	..()

/datum/reagent/toxin/sodium_thiopental
	name = "Sodium Thiopental"
	id = "sodium_thiopental"
	synth_cost = 5
	can_synth = 2
	description = "Puts you to sleep after 30 seconds, along with some major stamina loss."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/sodium_thiopental/on_mob_life(var/mob/living/M as mob)
	if(current_cycle >= 10)
		M.sleeping += 1
	M.adjustStaminaLoss(5*REM)
	..()

/datum/reagent/toxin/sulfonal
	name = "Sulfonal"
	id = "sulfonal"
	synth_cost = 5
	can_synth = 2
	description = "Deals some toxin damage, and puts you to sleep after 66 seconds."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/sulfonal/on_mob_life(var/mob/living/M as mob)
	if(current_cycle >= 22)
		M.sleeping += 1
	..()

/datum/reagent/toxin/amanitin
	name = "Amanitin"
	id = "amanitin"
	synth_cost = 5
	can_synth = 2
	description = "On the last second that it's in you, it hits you with a stack of toxin damage based on how long it's been in you. The more you use, the longer it takes before anything happens, but the harder it hits when it does."
	reagent_state = LIQUID
	color = "#CF3600"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/amanitin/on_mob_delete(var/mob/living/M as mob)
	M.adjustToxLoss(current_cycle*3*REM)
	..()


/datum/reagent/toxin/coniine
	name = "Coniine"
	id = "coniine"
	synth_cost = 5
	can_synth = 2
	description = "Does moderate toxin damage and oxygen loss."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.06 * REAGENTS_METABOLISM
	toxpwr = 1

/datum/reagent/toxin/coniine/on_mob_life(var/mob/living/M as mob)
	M.losebreath += 3
	..()

/datum/reagent/toxin/curare
	name = "Curare"
	id = "curare"
	synth_cost = 5
	can_synth = 2
	description = "Does some oxygen and toxin damage, weakens you after 11 seconds."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/curare/on_mob_life(var/mob/living/M as mob)
	if(current_cycle >= 11)
		M.Weaken(1)
	M.adjustOxyLoss(0.5*REM)
	..()


//ACID


/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	synth_cost = 3
	description = "A strong mineral acid with the molecular formula H2SO4."
	color = "#DB5008" // rgb: 219, 80, 8
	toxpwr = 1
	var/acidpwr = 10 //the amount of protection removed from the armour

/datum/reagent/toxin/acid/reaction_mob(var/mob/living/carbon/C, var/method=TOUCH, var/reac_volume)
	if(!istype(C))
		return
	reac_volume = round(reac_volume,0.1)
	if(method == INGEST)
		C.take_organ_damage(min(6*toxpwr, reac_volume * toxpwr))
		return

	C.acid_act(acidpwr, toxpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_obj(var/obj/O, var/reac_volume)
	if(istype(O.loc, /mob)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	O.acid_act(acidpwr, toxpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_turf(turf/T, reac_volume)
	if (!istype(T))
		return
	reac_volume = round(reac_volume,0.1)
	for(var/obj/O in T)
		O.acid_act(acidpwr, toxpwr, reac_volume)

//2acid
//lmao 2acid
/datum/reagent/toxin/acid/fluacid
	name = "Fluorosulfuric acid"
	id = "facid"
	synth_cost = 3
	can_synth = 2
	description = "Fluorosulfuric acid is a an extremely corrosive chemical substance."
	color = "#8E18A9" // rgb: 142, 24, 169
	toxpwr = 2
	acidpwr = 20

/datum/reagent/toxin/acid/polyacid
	name = "Polytrinic acid"
	id = "pacid"
	synth_cost = 3
	can_synth = 2
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	color = "#8E18A9" // rgb: 142, 24, 169
	toxpwr = 2
	acidpwr = 20


/datum/reagent/toxin/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	synth_cost = 3
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	color = "#C8A5DC" // rgb: 200, 165, 220
	toxpwr = 0

/datum/reagent/impedrezene/on_mob_life(var/mob/living/M as mob)
	M.jitteriness = max(M.jitteriness-5,0)
	if(prob(80)) M.adjustBrainLoss(5*REM)
	if(prob(50)) M.drowsyness = max(M.drowsyness, 3)
	if(prob(10)) M.emote("drool")
	..()
	return

/datum/reagent/toxin/stoxin
	name = "Sleep Toxin"
	id = "stoxin"
	synth_cost = 4
	description = "An effective hypnotic used to treat insomnia."
	color = "#E895CC" // rgb: 232, 149, 204
	toxpwr = 0

/datum/reagent/toxin/stoxin/on_mob_life(var/mob/living/M as mob)
	switch(current_cycle)
		if(1 to 12)
			if(prob(5))	M.emote("yawn")
		if(12 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
		if(15 to 25)
			M.drowsyness  = max(M.drowsyness, 20)
		if(25 to INFINITY) //CAN'T WAKE UP
			M.Paralyse(20)
			M.drowsyness  = max(M.drowsyness, 30)
	..()
	return

/datum/reagent/viral_readaption
	name = "Viral Readaption"
	id = "viral_readaption"
	synth_cost = 10
	can_synth = 0
	description = "???"
	color = "#13BC5E" // rgb: 207, 54, 0

/datum/reagent/viral_readaption/on_mob_life(var/mob/living/M as mob)
	if(prob(1))
		M.take_overall_damage(80,0)
		M << "<span class='userdanger'>You feel like you are being torn apart from the inside!</span>"
		if(!M.stat)
			M.emote("scream")
	..()
	return
