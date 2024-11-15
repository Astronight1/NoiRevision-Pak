-- whoever thought that P_InstaThrust(p, 0, 0)
-- needed to be used for clouds little "hitlag" effect instead of
-- actually just using hitlag needs a lil bompk on the head ngl

-- which means we're gonna have tuh unbullshit these clouds...
local CLOUD_ZTHRUST = 32*FRACUNIT
local CLOUDB_ZTHRUST = 16*FRACUNIT

local function cloudbounce(mobj, collider)
    local p = collider.player
    local playerspeed = R_PointToDist2(0, 0, p.mo.momx, p.mo.momy)

    -- functionally disable normal cloud behaviour
    p.cloud = 0
    p.cloudlaunch = 0
    p.cloudbuf = TICRATE
    --

    print(mobj.scale)

    if mobj.type == MT_AHZ_CLOUD
        p.mo.momz = FixedMul(mobj.scale, CLOUDB_ZTHRUST)
    else
        p.mo.momz = FixedMul(mobj.scale, CLOUD_ZTHRUST)
    end

    p.fastfall = 0
end

-- because there's 3 versions of this shit for some reason
addHook("TouchSpecial", cloudbounce, MT_AHZ_CLOUD)
addHook("TouchSpecial", cloudbounce, MT_AGZ_CLOUD)
addHook("TouchSpecial", cloudbounce, MT_SSZ_CLOUD)