from statuses import StatusHook;
import status_effects;

class NanobotHealing : StatusHook {
	Document doc("Repairs the target flagship's fleet based on the repair amount of the Emergency Nano-Repair Cloud subsystem.");

#section server
	bool onTick(Object& obj, Status@ status, any@ data, double time) override {
		if(obj.hasLeaderAI) {
			obj.repairFleet(cast<Ship>(obj).blueprint.getEfficiencySum(SV_NanoRepairAmount) * time);
			return true;
		} else {
			return false;
		}
	}
#section all
};
