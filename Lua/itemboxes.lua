-- make item boxes respawn near instantly - astro
addHook("MobjThinker", function(mo)
	if not (gametyperules&GTR_CIRCUIT) then return end
	if not (mo.valid) then return end
	if (mo.fuse == TICRATE)
		mo.fuse = 8;
	end
end, MT_RANDOMITEM)