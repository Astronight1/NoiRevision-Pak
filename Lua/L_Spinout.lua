--spinout lua by freeman#2651
--reduces wipeout timer constantly if its not on its own
--to prevent infinite wipeout dumb shit that I hate
--work in progress

addHook("PlayerThink", function(p)
	if p and p.valid and p.mo and not p.spectator then
		if p.lastspinouttimer == nil then p.lastspinouttimer = 0 end
		if p.spinouttimer and p.spinouttimer == p.lastspinouttimer and leveltime % 2 then
			p.spinouttimer = max($-1,0)
		end
		p.lastspinouttimer = p.spinouttimer
	end
end)
