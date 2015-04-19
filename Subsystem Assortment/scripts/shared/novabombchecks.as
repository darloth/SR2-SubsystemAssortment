import designs;

bool checkNovaBomb(Design& design, Subsystem& sys) {
	bool errors = false;
	if(checkContiguous(design, sys))
		errors = true;
	if(checkExposedAllDirections(design, sys))
		errors = true;
	return errors;
}

bool checkExposedAllDirections(Design& design, Subsystem& sys) {
	array<bool> hasExposed(6, false);
	for(uint i = 0, cnt = sys.hexCount; i < cnt; ++i) {
		vec2u hex = sys.hexagon(i);
		for(uint n = 0; n < 6; ++n) {
			if(design.hull.isExteriorInDirection(hex, HexGridAdjacency(n)))
				hasExposed[n] = true;
		}
	}
	
	for(uint dir = 0; dir < 6; ++dir) {
		if(hasExposed[dir] == false) {
			design.addError(true, "Not exposed on all sides", sys, null, vec2u());
			return true;
		}
	}

	return false;
}