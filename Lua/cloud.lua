-- cloud rewrite by astro

-- whoever thought that P_InstaThrust(p, 0, 0)
-- needed to be used for clouds little "hitlag" effect instead of
-- actually just using hitlag needs a lil bompk on the head ngl

-- which means imma have tuh rewrite these clouds
local CLOUD_ZTHRUST = 32*FRACUNIT
local CLOUDB_ZTHRUST = 16*FRACUNIT

addHook("PlayerThink", function(p)
    -- init var
    if p.l_cloudbuf == nil
        p.l_cloudbuf = 0
    end

    -- if cloud buffer is non-zero, tick it down to zero
    if p.l_cloudbuf
        p.l_cloudbuf = $ - 1
    end
end)

local function cloudbounce(mobj, collider)
    local p = collider.player

    -- functionally disable normal cloud behaviour
    p.cloud = 0
    p.cloudlaunch = 0
    p.cloudbuf = TICRATE
    -- so that it can be easily overriden

    -- delete fastfall
    p.fastfall = 0

    -- check for mobj type for choosing thrust
    -- because that's apparently how this works
    if mobj.type == MT_AHZ_CLOUD
        p.mo.momz = FixedMul(mapobjectscale, CLOUDB_ZTHRUST)
    else
        p.mo.momz = FixedMul(mapobjectscale, CLOUD_ZTHRUST)
    end
    
    -- if our cloud buffer is up, play the sound
    if not p.l_cloudbuf
        S_StartSound(mobj, sfx_s3k8a)
        p.l_cloudbuf = 8
    end
end

-- because there's 3 versions of this shit for some reason
addHook("TouchSpecial", cloudbounce, MT_AHZ_CLOUD)
addHook("TouchSpecial", cloudbounce, MT_AGZ_CLOUD)
addHook("TouchSpecial", cloudbounce, MT_SSZ_CLOUD)