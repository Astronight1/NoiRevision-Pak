-- i fucking hate scenery objects having collision
-- like literally why is it a thing i dont care that you can
-- ram into them and break them their hitboxes are actually so
-- annoying holy shit DIE DIE DIE MUDA MUDA MUDA MUDA- MUDAAAAAAAAAAAAAAAAA
addHook("MapLoad", function()
	for mo in mobjs.iterate("mobj")
		if ((mo.flags&MF_SOLID) and (mo.flags&MF_PAIN))-- or ((mo.flags&MF_SCENERY) and (mo.flags&MF_SOLID))
			mo.flags = $|MF_NOGRAVITY|MF_NOCLIPTHING
		end
	end
end)