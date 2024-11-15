-- whoever thought that P_InstaThrust(p, 0, 0)
-- needed to be used for clouds little "hitlag" effect instead of
-- actually just using hitlag needs a lil bompk on the head ngl

-- which means we're gonna havetuh unbullshit these clouds...
local bullshit = false
local unbullshit = false

local driftstate = 0;
local driftin = 0;

local prevwavedash
local prevwavedashboost
local prevwavedashpower

local multiplier

local function cloudbounce(mobj, collider)
    --if not (p.player) then return end
    --local p = p.player
    local p = collider.player
    local playerspeed = R_PointToDist2(0, 0, p.mo.momx, p.mo.momy)

    -- have to handle drifing manually

    if p.cmd.turning > 0
        multiplier = 1
    elseif p.cmd.turning < 0
        multiplier = -1
    end

    if driftstate == 0
        driftstate = 5 * multiplier
    end

    if unbullshit
        p.wavedash = prevwavedash
        p.wavedashboost = prevwavedashboost
        p.wavedashpower = prevwavedashpower
        
        prevwavedash = 0
        prevwavedashboost = 0
        prevwavedashpower = 0
        
        if p.cmd.buttons&BT_DRIFT
            p.driftcharge = driftin
            --p.drift = driftstate
            p.pflags = $|PF_DRIFTINPUT
            p.pflags = $&~PF_DRIFTEND
        end

        driftstate = 0
        driftin = 0

        bullshit = false
        unbullshit = false
    end

    if bullshit and playerspeed
        unbullshit = true
    end

    if playerspeed <= 1*FRACUNIT
        bullshit = true
    end

    if playerspeed > 1*FRACUNIT and not unbullshit
        prevwavedash = p.wavedash
        prevwavedashboost = p.wavedashboost
        prevwavedashpower = p.wavedashpower
        driftin = p.driftcharge
        driftstate = p.drift
    end

    



    p.drift = driftstate
    --p.pflags = $&~PF_DRIFTEND

    --print(p.drift)
    --print(p.minspeed)
    --print(driftstate)
    --print("------")
end
addHook("TouchSpecial", cloudbounce, MT_AHZ_CLOUD)