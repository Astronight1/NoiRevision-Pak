freeslot("MT_TRIANGALATION")
freeslot("S_TRIANGALATION")
freeslot("SPR_HYPS")

local spritex = CV_RegisterVar{
	name = "/x",
	defaultvalue = 0,
	flags = CV_NETVAR,
	PossibleValue = {MIN = -10000, MAX = 10000}
}

local spritey = CV_RegisterVar{
	name = "/y",
	defaultvalue = 0,
	flags = CV_NETVAR,
	PossibleValue = {MIN = -10000, MAX = 10000}
}

local spriterolltime = CV_RegisterVar{
	name = "/time",
	defaultvalue = 2,
	flags = CV_NETVAR,
	PossibleValue = {MIN = -10000, MAX = 10000}
}


mobjinfo[MT_TRIANGALATION] = {
	spawnstate = S_TRIANGALATION,
	flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_DONTENCOREMAP|MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY,
	dispoffset = 10,
	height = 48*FRACUNIT
}
states[S_TRIANGALATION] = {
	sprite = SPR_HYPS,
	frame = A|FF_FULLBRIGHT|FF_ANIMATE,
	var1 = 1,
	var2 = 2,
	tics = 8,
	nextstate = S_TRIANGALATION
}

local function TriangleThok(p, playerspeed)
	if P_IsObjectOnGround(p.mo)
		if p.driftlevel >= 400
			-- rainbow
			S_StartSound(p.mo,sfx_thok)
			P_Thrust(p.mo, p.mo.angle, 5*playerspeed/4)
		elseif p.driftlevel >= 300
			-- blue
			S_StartSound(p.mo,sfx_thok)
			P_Thrust(p.mo, p.mo.angle, playerspeed)
		elseif p.driftlevel >= 200
			-- red
			S_StartSound(p.mo,sfx_thok)
			P_Thrust(p.mo, p.mo.angle, playerspeed/2)
		elseif p.driftlevel >= 100
			-- yellow
			S_StartSound(p.mo,sfx_thok)
			P_Thrust(p.mo, p.mo.angle, playerspeed/3)
		elseif p.driftcharge < 0
			-- gray
			S_StartSound(p.mo,sfx_thok)
			P_Thrust(p.mo, p.mo.angle, playerspeed/8)
		end
	end
end

local function Triangalation(p, driftlevel)
	if p.trianglecharge > 0
		if p.triangalation_spawned == 0
			local triangalation = P_SpawnMobjFromMobj(p.mo, 0, 0, 0, MT_TRIANGALATION)
			triangalation.target = p.mo
			triangalation.renderflags = $|RF_DONTDRAW
			p.mo.triangalationobject = triangalation
			p.triangalation_spawned = 1
		end
	end
end

-- local TIMETRANS = function(time, speed, prefix, suffix, debug, minimum, cap)
--     prefix = prefix or "V_"
--     suffix = suffix or "TRANS"
--     speed = speed or 1

--     local level = (time / speed / 10) * 10
--     level = max(10, min(100, level))
    
--     if minimum then level = max($, minimum / 10 * 10) end
--     if cap then level = min($, cap / 10 * 10) end

--     if level == 100 then
--         if debug then print(level) end
--         return 0
--     else
--         if debug then print(level) end
--         return _G[prefix .. (100 - level) .. suffix]
--     end
-- end

local function wrapValue(value, minValue, maxValue)
    local range = maxValue - minValue + 1
    return ((value - minValue) % range + range) % range + minValue
end

local function clamp(value, minValue, maxValue)
	if value < minValue then return minValue end
	if value > maxValue then return maxValue end
	return value
end

addHook("MobjThinker", function(mo)
	if not (mo and mo.valid) then return end
	if mo.owner and mo.owner.valid
		mo.owner.trianglecolor = mo.color
	end
	
end, MT_DRIFTSPARK)

local angle = 0
local checkvis = false
addHook("MobjThinker", function(mo)
	if not (mo and mo.valid and mo.target and mo.target.valid) then return end
		local spinspeed = R_PointToDist2(0, 0, mo.target.player.mo.momx, mo.target.player.mo.momy)
		angle = $+spinspeed
		wrapValue(angle, 0, 359)
		mo.rollangle = FixedAngle(angle)
		local bruh = P_SpawnGhostMobj(mo)
		local cringe = P_SpawnGhostMobj(mo.target)

		--local smoothtrans = TIMETRANS(99-(mo.target.player.trianglecharge or 0),1,"FF_TRANS","", true) or 0

		if mo.target.player.driftlevel < 100 and mo.target.player.driftcharge > -1
			mo.color = SKINCOLOR_GREY
			mo.frame = $|FF_TRANS50
		elseif mo.target.trianglecolor
			mo.color = mo.target.trianglecolor
		end

		if mo.renderflags&RF_DONTDRAW
			mo.renderflags = $&~RF_DONTDRAW
		end

		bruh.fuse = 7
		bruh.frame = $1 | FF_FULLBRIGHT
		cringe.colorized = true
		cringe.frame = $|FF_FULLBRIGHT
		cringe.fuse = ((mo.target.player.driftlevel/100)*2) + 3

		if not checkvis
			checkvis = true
		else
			checkvis = false
		end

		if checkvis
			cringe.renderflags = $|RF_DONTDRAW
		else
			cringe.renderflags = $&~RF_DONTDRAW
		end

		P_MoveOrigin(mo, mo.target.x, mo.target.y, mo.target.z)
end, MT_TRIANGALATION)

addHook("PlayerThink", function(p)
	-- init global players vars
	if not p.trianglecharge
		p.trianglecharge = 0
	end
	
	if not p.triangalation_spawned
		p.triangalation_spawned = 0
	end
	
	if not p.driftlevel
		p.driftlevel = 0
	end
	
-- 	if p.trianglecolor and not driftlevel
-- 		p.trianglecolor = SKINCOLOR_GREY
-- 	end
		
	-- grease cancel
	if p.tiregrease and (p.cmd.buttons&BT_LUAA) then
		p.tiregrease = 0
	end
		
	-- no grease when landing
	if p.mo and p.mo.valid and p.mo.eflags&MFE_JUSTHITFLOOR and p.tiregrease then
		p.tiregrease = 0
	end

	-- trithok
	local driftval = K_GetKartDriftSparkValue(p)
	local driftcharge = min(driftval*4, p.driftcharge)
	
	p.driftlevel = driftcharge*100 / driftval
		
	local playerspeed = R_PointToDist2(0, 0, p.mo.momx, p.mo.momy)
	
	-- tick down tricharge
	if p.trianglecharge > 0 then
		p.trianglecharge = $-1
	end
	
	-- tricharge timelimit
	if p.drift and p.fastfall and p.mo.eflags&MFE_JUSTHITFLOOR then
		p.trianglecharge = 53 -- ~1.5 seconds (53)
	end
	
	-- trithok graphics
	Triangalation(p)

	-- delete trithok graphics if we cant trithok
	if not p.trianglecharge and p.triangalation_spawned == 1
		P_RemoveMobj(p.mo.triangalationobject)
		p.triangalation_spawned = 0
	end
	
	--print(p.trianglecharge)

	-- do da trithok
	if p.trianglecharge and not (p.cmd.buttons&BT_DRIFT) then
		--print("HI")
		TriangleThok(p, playerspeed)
		p.trianglecharge = 0
		p.tiregrease = 0
		P_RemoveMobj(p.mo.triangalationobject)
		p.triangalation_spawned = 0
	end
end)