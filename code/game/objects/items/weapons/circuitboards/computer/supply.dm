#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/supplycomp
	name = T_BOARD("supply control console")
	build_path = /obj/machinery/computer/supply

	var/contraband_enabled = 0
	var/emagged = 0

/obj/item/circuitboard/supplycomp/construct(var/obj/machinery/computer/supply/SC)
	if (..(SC))
		SC.can_order_contraband = contraband_enabled
		SC.emagged = emagged
		SC.generateSupplyList()

/obj/item/circuitboard/supplycomp/deconstruct(var/obj/machinery/computer/supply/SC)
	if (..(SC))
		contraband_enabled = SC.can_order_contraband
		emagged = SC.emagged

/obj/item/circuitboard/supplycomp/attackby(obj/item/I as obj, var/mob/user)
	if(I.ismultitool())
		var/catastasis = src.contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		switch( alert("Current receiver spectrum is set to: [catastasis]","Multitool-Circuitboard interface","Switch to [opposite_catastasis]","Cancel") )
		//switch( alert("Current receiver spectrum is set to: " {(src.contraband_enabled) ? ("BROAD") : ("STANDARD")} , "Multitool-Circuitboard interface" , "Switch to " {(src.contraband_enabled) ? ("STANDARD") : ("BROAD")}, "Cancel") )
			if("Switch to STANDARD","Switch to BROAD")
				src.contraband_enabled = !src.contraband_enabled

			if("Cancel")
				return
			else
				user << "DERP! BUG! Report this (And what you were doing to cause it) to Agouri"
	return