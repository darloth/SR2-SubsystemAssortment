import ability_effects;
import generic_effects;
import status_effects;

//EmergencyRepair(<Var = "RepairAmount">)
//	Repairs the fleet using this ability based on a subsystem's variable for duration. (Amount is hardcoded to use SV_NanoRepairAmount
class EmergencyRepair : AbilityHook {
	Document doc("Repairs the fleet using this ability based on a subsystem's variable for duration. (Amount is hardcoded to use SV_NanoRepairAmount.");
	Argument durationVarName("DurationVariable", AT_Custom, doc="Name of subsystem variable that specifies duration to repair over.");
	SubsystemVariable durationVar = SubsystemVariable(-1);

	bool instantiate() override {
		int durationIndex = getSubsystemVariable(durationVarName.str);
		if(durationIndex < 0) {
			error("EmergencyRepair(): No Subsystem variable '" + durationVarName.str + "'");
			return false;
		}
		durationVar = SubsystemVariable(durationIndex);
		
		return AbilityHook::instantiate();
	}
	
	bool canActivate(const Ability@ abl, const Targets@ targs, bool ignoreCost) const override {
		Ship@ ship = cast<Ship>(abl.obj);
		if(ship is null)
			return false;
		return true; // Would be nice to check here to see whether the fleet needs healing.
	}
	
#section server
	void activate(Ability@ abl, any@ data, const Targets@ targs) const override {
		if(abl.subsystem is null || !abl.subsystem.has(durationVar))
			return;
		Ship@ ship = cast<Ship>(abl.obj);
		if(ship is null)
			return;
			
		auto@ status = getStatusType("NanoRepairCloud");
		print("applying NanoRepairCloud");
		print("Duration: " + abl.subsystem[durationVar]);
		ship.addStatus(status.id, timer = abl.subsystem[durationVar]);
	}
#section all
};