-- --[[
-- 	Lua by JugadorXEI#1815 on Discord, @JugadorXEI on Twitter.
-- 	Many thanks to Indev for the initial Version 2 fixes.
-- 	Put "Lua.nowaterskip = true" in your map header to disable waterskips.
-- ]]

-- local NOWATERSKIPVER = 3
-- local VER3_LOCALFIXEDITION = 3

-- if jug_nowaterskip == nil then
-- 	rawset(_G, "jug_nowaterskip", {})
-- end

-- if jug_nowaterskip.ver == nil or jug_nowaterskip.ver < NOWATERSKIPVER then
-- -- start

-- local isWaterSkipEnabled = true

-- jug_nowaterskip.noWaterSkip = function(mobj)
-- 	if isWaterSkipEnabled then return end
-- 	if not mobj or not mobj.valid then return end
-- 	if not mobj.player or not mobj.player.valid then return end

-- 	mobj.waterskip = 2
-- end

-- jug_nowaterskip.noWaterSkipCheckToggle = function()
-- 	isWaterSkipEnabled = false --not (mapheaderinfo[gamemap].nowaterskip == "true")
-- end

-- -- Only hook these once, performance gain in case this script
-- -- is in multiple map packs
-- if jug_nowaterskip.ver == nil then
-- 	addHook("MobjThinker", function(mobj)
-- 		jug_nowaterskip.noWaterSkip(mobj)
-- 	end, MT_PLAYER)
-- end	

-- -- New change to properly account for local state and the older versions.
-- if jug_nowaterskip.ver == nil or jug_nowaterskip.ver < VER3_LOCALFIXEDITION then
-- 	addHook("MapChange", function()
-- 		jug_nowaterskip.noWaterSkipCheckToggle()
-- 	end)
	
-- 	addHook("NetVars", function()
-- 		jug_nowaterskip.noWaterSkipCheckToggle()
-- 	end)
-- end

-- -- end
-- jug_nowaterskip.ver = NOWATERSKIPVER
-- end