local bumpdivfactor = CV_RegisterVar{
    name = "/bumpdivfactor",
    defaultvalue = 1,
    flags = CV_NETVAR,
    PossibleValue = {MIN = -10000, MAX = 10000}
}

local bumpdisfactor = CV_RegisterVar{
    name = "/bumpdisfactor",
    defaultvalue = 2,
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
    --local o = other.player

    if p.bumpgperiod == 0 --and o.bumpgperiod == 0
        p.mo.momx = bumpdivfactor.value*$/bumpdisfactor.value
        p.mo.momy = bumpdivfactor.value*$/bumpdisfactor.value
        --o.mo.momx = bumpdivfactor.value*$/bumpdisfactor.value
        --o.mo.momy = bumpdivfactor.value*$/bumpdisfactor.value
        --print("CHACHING")
    end

    if p.bumpgperiod < 1 then p.bumpgperiod = bumpcollisiontime.value end
    --if o.bumpgperiod < 1 then o.bumpgperiod = bumpcollisiontime.value end
end

addHook("MobjCollide", reducebumpcode, MT_PLAYER)
addHook("MobjMoveCollide", reducebumpcode, MT_PLAYER)