import hooks;
import abilities;
from abilities import AbilityHook;
import target_filters;
import systems;
import orders;
#section server
import util.target_search;
#section all

class DealInstantStellarDamage : AbilityHook {
	Document doc("Deal a single instant amount of damage to the stored target stellar object. Damages things like stars and planets.");
	Argument targ(TT_Object);
	Argument dmg(AT_SysVar, doc="Damage to deal.");

#section server
    void activate(Ability@ abl, any@ data, const Targets@ targs) const override {
		if(abl.obj is null)
			return;
		auto@ objTarg = targ.fromConstTarget(targs);
		if(objTarg is null)
			return;

		Object@ obj = objTarg.obj;
		if(obj is null)
			return;

		double amt = dmg.fromSys(abl.subsystem, efficiencyObj=abl.obj);
		if(obj.isPlanet)
			cast<Planet>(obj).dealPlanetDamage(amt);
		else if(obj.isStar)
			cast<Star>(obj).dealStarDamage(amt);
	}
#section all
};