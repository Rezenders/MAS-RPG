!name.

+!init_monster[scheme(Sch)]
	<-	joinWorkspace("rpgOrg",Workspace);
		adoptRole("monster")[wid(Workspace)];
		lookupArtifact(Sch,SchArtId);
		focus(SchArtId);

		?goalArgument(Sch,setupTable,"Id",Id);
		.concat("dice_",Id, DId);
		lookupArtifact(DId, DArtId);
		Sch::focus(DArtId);

		.concat("map_",Id, MId);
		lookupArtifact(MId, MArtId);
		Sch::focus(MArtId);


		.send("master", resume, spawn_monster[scheme(Sch)]);
		.

+!roll_initiative[source(Source), scheme(Sch)]
	<- 	Sch::roll_dice(1, 20, I);
		.my_name(Me);
		.send(Source, tell, Sch::initiative(Me, 1 + I));
		.

+!play_turn[source(Source),scheme(Sch)]
	<-	!find_nearest_adventurer(Adventurer)[scheme(Sch)];
		!move_towards_adventurer(Adventurer)[scheme(Sch)];
		!attack(Adventurer)[scheme(Sch)];
		.my_name(Me);
		.send(Source, resume, inform_turn(Me)[scheme(Sch)]);
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
	<-	?moving_phrase(Phrase);
		.print(Phrase, Adventurer);
		?my_name(Me); ?Sch::monster(Me, X, Y);
		?Sch::adventurer(Adventurer, X2, Y2);
		!move_possibilities(X, Y, P);
		!calc_distances(X2, Y2, P, UDists);
		.sort(UDists, Dists);
		!move(X, Y, Dists)[scheme(Sch)];
		.

+!move_towards_adventurer(Adventurer)[scheme(Sch)].

+!attack(Adventurer)[scheme(Sch)] : Adventurer \== [] & in_range(Adventurer)
	<-	?attack_phrase(Phrase);
		.print(Phrase, Adventurer, "!!!");
		Sch::roll_dice(1, 20, Attack);
		?Attr::attack_bonus(AB);

		?Equip::weapon(WN, ND, TD, BD);
		Sch::roll_dice(ND, TD, D2);
		?Attr::strength_mod(SM);
		Damage = SM + D2 + BD;

		.send(master, achieve, test_attack(Adventurer, Attack + AB, Damage)[scheme(Sch)]);
		.suspend;
		.

+!attack(Adventurer)[scheme(Sch)]
	<-	!move_towards_adventurer(Adventurer)[scheme(Sch)].

in_range(Adventurer) :- my_name(Me) & Sch::adventurer(Adventurer, H, V) & Sch::monster(Me, H2, V2) & adj(H, V, H2, V2).

{ include("common-agents.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
