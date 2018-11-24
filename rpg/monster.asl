Status::hp(5).
Status::armor_points(12).
Equip::weapon(dagger, 1, 4, 2).

!spawn_monster.

+!spawn_monster
	<-	+Attr::constitution(9);
		+Attr::strength(7);
		+Attr::intelligence(7);
		+Attr::dexterity(15);
		.

+!attack_adventurers[scheme(Sch)]
	<- 	.print("Start scheme ",Sch," for monster");
		.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
