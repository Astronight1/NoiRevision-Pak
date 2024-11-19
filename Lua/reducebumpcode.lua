local bumpdivfactor = CV_RegisterVar{
    name = "/bumpdivfactor",
    defaultvalue = 3,
    flags = CV_NETVAR,
    PossibleValue = {MIN = -10000, MAX = 10000}
}

local bumpdisfactor = CV_RegisterVar{
    name = "/bumpdisfactor",
    defaultvalue = 4,
    flags = CV_NETVAR,
    PossibleValue = {MIN = -10000, MAX = 10000}
}

local bumpcollisiontime = CV_RegisterVar{
    name = "/bumpcollisiontime",
    defaultvalue = 8,
    flags = CV_NETVAR,
    PossibleValue = {MIN = -10000, MAX = 10000}
}

addHook("PlayerThink", function(p)
    if p.bumpgperiod == nil
        p.bumpgperiod = 0
    end

    if p.bumpgperiod > 0
        p.bumpgperiod = $-1
    end
end)

local function reducebumpcode(pmo, other) -- took this from old fightclub, thank you MACHTURNE
    if not (pmo.valid and pmo.player) then return end
    if not (other.valid and other.player and other) then return end
    if pmo.z + pmo.height < other.z or pmo.z > other.z + other.height then return end -- this line is actually insane WHY do you need to check for this
    
    local p = pmo.player

    local playerspeed = R_PointToDist2(0, 0, p.mo.momx, p.mo.momy)

    -- if im not in grow, invuln, or im not hyued, and im not in flashtics
    if p.bumpgperiod == 0 and p.invincibilitytimer < 1 and p.growshrinktimer < 1 and p.hyudorotimer < 1 and p.flashing < 1 and playerspeed > 5*FRACUNIT
        p.mo.momx = bumpdivfactor.value*$/bumpdisfactor.value
        p.mo.momy = bumpdivfactor.value*$/bumpdisfactor.value
    end

    if p.bumpgperiod < 1 then p.bumpgperiod = bumpcollisiontime.value end
end

addHook("MobjCollide", reducebumpcode, MT_PLAYER)
addHook("MobjMoveCollide", reducebumpcode, MT_PLAYER)