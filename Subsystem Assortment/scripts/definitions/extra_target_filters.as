import target_filters;

//TargetFilterSupports(<Target>)
// Filter <Target> to only allow support ships.
class TargetFilterSupport : TargetFilter {
	Document doc("Restricts target to Support ships.");
	Argument targ(TT_Object);
	Argument allow_null(AT_Boolean, "False", doc="Whether to allow the ability to be triggered on nulls (for example, for toggle deactivates.)");

	string getFailReason(Empire@ emp, uint index, const Target@ targ) const override {
		return "Can only target support ships";
	}

	bool isValidTarget(Empire@ emp, uint index, const Target@ targ) const override {
		if(index != uint(arguments[0].integer))
			return true;
		Object@ obj = targ.obj;
		if(obj is null)
			return allow_null.boolean;
		return obj.isShip && (!obj.hasLeaderAI);
	}
};