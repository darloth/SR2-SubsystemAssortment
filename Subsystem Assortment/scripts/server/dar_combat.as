import statuses;

uint typeMask = DF_Flag1 | DF_Flag2;

enum DamageTypes {
	DT_Generic = 0,
	DT_Projectile,
	DT_Energy,
	DT_Explosive,
	DT_IgnoreDR,
};

DamageFlags QuadDRPenalty = DF_Flag3;
DamageFlags ReachedInternals = DF_Flag4;
DamageFlags AlwaysFullDR = DF_Flag5;

void WeakProjDamage(Event& evt, double Amount, double Pierce, double Suppression) {
	DamageEvent dmg;
	dmg.damage = Amount * double(evt.efficiency) * double(evt.partiality);
	dmg.partiality = evt.partiality;
	dmg.pierce = Pierce;
	dmg.impact = evt.impact;

	@dmg.obj = evt.obj;
	@dmg.target = evt.target;
	dmg.source_index = evt.source_index;
	
	dmg.flags |= DT_Projectile;
	dmg.flags |= AlwaysFullDR;

	evt.target.damage(dmg, -1.0, evt.direction);
	
	if(Suppression > 0 && evt.target.isShip) {
		double r = evt.target.radius;
		double suppress = Suppression * double(evt.efficiency) * double(evt.partiality) / (r*r*r);
		cast<Ship>(evt.target).suppress(suppress);
	}
}
