Status::hp(5).
Status::armor_points(12).
Equip::weapon(dagger, 1, 4, 2).

!name.

+!init_monster[scheme(Sch)]
	<-	joinWorkspace("rpgOrg",Workspace);
		lookupArtifact(Sch,SchArtId);
		focus(SchArtId);

		?goalArgument(Sch,setupTable,"Id",Id);
		lookupArtifact(Id,ArtId);
		Sch::focus(ArtId);

		adoptRole("monster");

		+Attr::constitution(9);
		+Attr::strength(7);
		+Attr::intelligence(7);
		+Attr::dexterity(15);
		.send("master", achieve, resume(spawn_monster[scheme(Sch)]));
		.

+!roll_initiative[source(Source), scheme(Sch)]
	<- 	.random(I);
		.my_name(Me);
		.send(Source, tell, Sch::initiative(Me, 1 + math.round(I*20 mod 20)));
		.

+!play_turn[source(Source),scheme(Sch)]
	<-	!find_nearest_adventurer(Adventurer)[scheme(Sch)];
		!move_towards_adventurer(Adventurer)[scheme(Sch)];
		!attack(Adventurer)[scheme(Sch)];
		.my_name(Me);
		.send(Source, achieve, resume(inform_turn(Me))[scheme(Sch)]);
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

+!move_towards_adventurer(Adventurer)[scheme(Sch)]: not in_range(Adventurer)
	<-	.print("[Translation from unknown language] Run while you can ", Adventurer);
		?my_name(Me); ?Sch::monster(Me, X, Y);
		?Sch::adventurer(Adventurer, X2, Y2);
		!move_possibilities(X, Y, P);
		!calc_distances(X2, Y2, P, Dists);
		!best_move(Dists, BX, BY);
		.print("Moving from [",X,",",Y,"] to ","[",BX,",",BY,"]");
		Sch::move(Me, BX, BY);
		.

+!move_towards_adventurer(Adventurer)[scheme(Sch)].

+!attack(Adventurer)[scheme(Sch)] : Adventurer \== [] & in_range(Adventurer)
	<-	.print("[Translation from unknown language] You will be obliterated ",Adventurer, "!!!");
		.random(D); //TODO: implementar artefato para dados
		.random(D2);
		// ?Attr::strength_mod(SM); Nao funciona n sei pq
		Attack = 4 + (1 + math.round(D*20) mod 20); Damage = -1 + 2+ (1 + math.round(D2*8) mod 8); //TODO:Tirar informação dos dados a partir da weapon
		.send(master, achieve, test_attack(Adventurer, Attack ,Damage, Sch));
		.suspend;
		.

+!attack(Adventurer)[scheme(Sch)]
	<-	!move_towards_adventurer(Adventurer)[scheme(Sch)].

in_range(Adventurer) :- my_name(Me) & Sch::adventurer(Adventurer, H, V) & Sch::monster(Me, H2, V2) & adj(H, V, H2, V2).


{ include("common-players.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
