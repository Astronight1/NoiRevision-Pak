-- taken from CGB
local function RespawnItemboxTime(mo)
	if not (gametyperules & GTR_CIRCUIT) then return end
	if not (mo.valid) then return end
	if (mo.fuse == 35) then
		local time = 8;
		mo.fuse = time;
		--mo.extravalue2 = (35 - time); --for ringbox
	end
end
addHook("MobjThinker", RespawnItemboxTime, MT_RANDOMITEM);
