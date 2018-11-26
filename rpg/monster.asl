Status::hp(5).
Status::armor_points(12).
Equip::weapon(dagger, 1, 4, 2).


+!init_monster[scheme(Sch)]
	<-	joinWorkspace("rpgOrg",Workspace);
		lookupArtifact(Sch,SchArtId);
		focus(SchArtId);

		?goalArgument(Sch,setupTable,"Id",Id);
		lookupArtifact(Id,ArtId);
		Sch::focus(ArtId);

		adoptRole("monster");
		commitMission(mSlayAdventurers);

		+Attr::constitution(9);
		+Attr::strength(7);
		+Attr::intelligence(7);
		+Attr::dexterity(15);
		.send("master", achieve, resume(spawn_monster[scheme(Sch)]));
		.
+Attr::constitution(C)
	<-	-+Attr::constitution_mod((C-10) div 2).

+Attr::strength(S)
	<-	-+Attr::strength_mod((S-10) div 2).

+Attr::intelligence(I)
	<-	-+Attr::intelligence_mod((I-10) div 2).

+Attr::dexterity(D)
	<-	-+Attr::dexterity_mod((D-10) div 2).

+!battle_adventurers[scheme(Sch)]
	<-	!attack_turn[scheme(Sch)];
		!battle_adventurers[scheme(Sch)];
		.

-!battle_adventurers[scheme(Sch)]
	<- .print("Battle ended!");
		.

+!attack_turn[scheme(Sch)]
	<-	!find_nearest_adventurer(Adventurer)[scheme(Sch)];
		!attack(Adventurer)[scheme(Sch)];
		.

+!took_damage(Damage)
	<-	?Status::hp(HP);
		-+Status::hp(HP-Damage);
		.

+!find_nearest_adventurer(Adventurer)[scheme(Sch)]
	<- 	.my_name(Me); .term2string(Me, SMe); ?Sch::monster(SMe, X, Y);
		.findall([((X-X2)**2 + (Y-Y2)**2)**(1/2), N],Sch::adventurer(N, X2, Y2), Dists);
		if(Dists  \== []){
			.min(Dists,[D, Adventurer]);
		}else{
			Adventurer = [];
		}
		.

+!attack(Adventurer)[scheme(Sch)] : Adventurer \== []
	<-	.print("[Translation from unknown language] You will be obliterated ",Adventurer, "!!!");
		.random(D); //TODO: implementar artefato para dados
		.random(D2);
		// ?Attr::strength_mod(SM); Nao funciona n sei pq
		Attack = 4 + (1 + math.round(D*20) mod 20); Damage = -1 + 2+ (1 + math.round(D2*8) mod 8); //TODO:Tirar informação dos dados a partir da weapon
		.send(master, achieve, test_attack(Adventurer, Attack ,Damage, Sch));
		.suspend;
		.

+!resume(G)
	<-	.resume(G);
		.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
