rawset(_G, "SafeFreeslot", function (...)
	for _, item in ipairs({...})
		if rawget(_G, item) == nil
			freeslot(item)
		end
	end
end)