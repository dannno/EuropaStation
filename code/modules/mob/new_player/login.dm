/var/obj/effect/lobby_image = new/obj/effect/lobby_image()

/obj/effect/lobby_image
	name = "ES13"
	desc = "This shouldn't be read."
	icon = 'icons/misc/title.dmi'
	screen_loc = "WEST,SOUTH"

/obj/effect/lobby_image/initialize()
	var/list/known_icon_states = icon_states(icon)
	for(var/lobby_screen in config.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			config.lobby_screens -= lobby_screen

	if(config.lobby_screens.len)
		icon_state = pick(config.lobby_screens)
	else
		icon_state = known_icon_states[1]

/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	src << "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>"

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	client.screen += lobby_image
	my_client = client
	sight |= SEE_TURFS
	player_list |= src

	if (client.ckey in acceptedKeys) //Check if they've already clicked the I ACCEPT info window thing, each round once.
		new_player_panel()
	else
		client.check_server_info()
	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()
