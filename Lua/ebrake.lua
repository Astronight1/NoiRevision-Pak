-- buff ebrake a tiny bit to make it stronger then regular breaking - astro
addHook("PlayerThink", function(p)
    local playerspeed = R_PointToDist2(0, 0, p.mo.momx, p.mo.momy)
	if (p.cmd.buttons&BT_ACCELERATE) and (p.cmd.buttons&BT_BRAKE)
        if P_IsObjectOnGround(p.mo) and playerspeed > 6*FRACUNIT
            P_Thrust(p.mo, R_PointToAngle2(p.mo.momx, p.mo.momy, 0, 0), FRACUNIT/5)
        end
    end
end)