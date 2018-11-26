Status::hp(5).
Status::armor_points(12).
Equip::weapon(dagger, 1, 4, 2).

!init_monster.

+!init_monster
	<-	joinWorkspace("rpgOrg",Workspace);
		adoptRole("monster");
		+Attr::constitution(9);
		+Attr::strength(7);
		+Attr::intelligence(7);
		+Attr::dexterity(15);
		.

+!battle_adventurers[scheme(Sch)] : not Status::dead
	<- 	.print("[Translation from unknown language] You will be obliterated Adventurer!!!");
		.

+!battle_adventurers[scheme(Sch)]
	<- .print("Already dead").

+Status::dead[killer(Adventurer)]
	<- .print("[Translation from unknown language] (Dying)I will haunt your dreams ",Adventurer, "!!!!!!").

+!took_damage(Damage)
	<-	?Status::hp(HP);
		-+Status::hp(HP-Damage);
		.


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
