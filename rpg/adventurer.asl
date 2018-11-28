Status::level(1).
Status::exp(0).
Status::class(fighter).

!name.

+!set_attributes
	<- 	.random(C); .random(S);	.random(I); .random(D);
		+Attr::constitution(11 + math.round(C*5) mod 5);
		+Attr::strength(11 + math.round(S*5) mod 5 );
		+Attr::intelligence(11+ math.round(I*5) mod 5);
		+Attr::dexterity(11+ math.round(D*5) mod 5);

		?Attr::constitution_mod(Cons);
		+Status::hp(10 + Cons);
		?Attr::dexterity_mod(Dex);
		+Status::armor_points(10 + Dex);
		.

+!equip_initial_items
	<-	+Equip::weapon(sword, 1, 8, 0);
		+Equip::armor(7);
		.

+!enter_adventurer[scheme(Sch)]
	<-	?goalArgument(Sch,setupTable,"Id",Id);
		lookupArtifact(Id,ArtId);
		Sch::focus(ArtId);
		.random(X); .random(Y);
		Sch::enter_map( math.round(X*6) mod 6, math.round(Y*6) mod 6);
		.

+!create_adventurer[scheme(Sch)]
	<-	!set_attributes;
		!equip_initial_items;
		.

+!roll_initiative[source(Source), scheme(Sch)]
	<- 	.random(I);
		.my_name(Me);
		.send(Source, tell, Sch::initiative(Me, 1 + math.round(I*20 mod 20)));
		.

+!play_turn[source(Source),scheme(Sch)]
	<-	!find_nearest_monster(Monster)[scheme(Sch)];
		!move_towards_monster(Monster)[scheme(Sch)];
		!attack(Monster)[scheme(Sch)];
		.my_name(Me);
		.send(Source, achieve, resume(inform_turn(Me))[scheme(Sch)]);
		.

+!find_nearest_monster(Monster)[scheme(Sch)]
	<- 	.my_name(Me); .term2string(Me, SMe); ?Sch::adventurer(SMe, X, Y);
		.findall([((X-X2)**2 + (Y-Y2)**2)**(1/2), N],Sch::monster(N, X2, Y2), Dists);
		if(Dists  \== []){
			.min(Dists,[D, Monster]);
		}else{
			Monster = [];
		}
		.

+!move_towards_monster(Monster)[scheme(Sch)]: not in_range(Monster)
	<-	.print("I'm going to catch you ", Monster);
		?my_name(Me); ?Sch::adventurer(Me, X, Y);
		?Sch::monster(Monster, X2, Y2);
		!move_possibilities(X, Y, P);
		!calc_distances(X2, Y2, P, Dists);
		!best_move(Dists, BX, BY);
		.print("Moving from [",X,",",Y,"] to ","[",BX,",",BY,"]");
		Sch::move(Me, BX, BY);
		.

+!move_towards_monster(Monster)[scheme(Sch)].

+!attack(Monster)[scheme(Sch)] : Monster \== [] & in_range(Monster)
	<-	.print("Prepare to be destroyed ", Monster, "!!!!");
		.random(D); //TODO: implementar artefato para dados
		.random(D2); ?Attr::strength_mod(SM);
		Attack = (1+ math.round(D*20) mod 20);
		?Equip::weapon(WN, ND, TD, BD); Damage = SM + ND*(1 + math.round(D2*TD) mod TD) + BD; //TODO:Rolar ND dados 
		.send(master, achieve, test_attack(Monster,Attack ,Damage, Sch));
		.suspend;
		.
+!attack(Monster)[scheme(Sch)]
	<-	!move_towards_monster(Monster)[scheme(Sch)].

in_range(Monster) :- my_name(Me) & Sch::adventurer(Me, H, V) & Sch::monster(Monster, H2, V2) & adj(H, V, H2, V2).



{ include("common-agents.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
