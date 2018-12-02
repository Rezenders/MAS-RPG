Status::level(1).
Status::class(fighter).
Attr::attack_bonus(0).

!name.

+!set_attributes[scheme(Sch)]
	<-
		!roll_status(C); !roll_status(S); !roll_status(I); !roll_status(D);
		+Attr::constitution(C);
		+Attr::strength(S);
		+Attr::intelligence(I);
		+Attr::dexterity(D);

		?Attr::constitution_mod(Cons);
		+Status::hp(10 + Cons);
		+Status::max_hp(10 + Cons);
		.

+!level_up[scheme(Sch)]
	<-	?Attr::constitution(C);
		?Attr::strength(S);
		?Attr::intelligence(I);
		?Attr::dexterity(D);
		-+Attr::constitution(C+1);
		-+Attr::strength(S+1);
		-+Attr::intelligence(I+1);
		-+Attr::dexterity(D+1);

		Sch::roll_dice(1, 12, D1);
		?Attr::constitution_mod(Cons);
		?Status::max_hp(HP);
		-+Status::hp(HP + Cons + D1);
		-+Status::max_hp(HP + Cons + D1);

		?Status::level(L);
		-+Status::level(L + 1);
		.

+!roll_status(R)
	<- 	Sch::roll_dice(1, 6, D1);
		Sch::roll_dice(1, 6, D2);
		Sch::roll_dice(1, 6, D3);
		Sch::roll_dice(1, 6, D4);
		.min([D1, D2, D3, D4], LD);
		R = D1 + D2 + D3 + D4 - LD;
		.

+!equip_initial_items
	<-	+Equip::weapon(sword, 1, 8, 0);
		+Equip::armor(7);
		.

+!join_table[scheme(Sch)]
	<-	?goalArgument(Sch,setupTable,"Id",Id);

		.concat("map_",Id, MId);
		lookupArtifact(MId, MArtId);
		Sch::focus(MArtId);

		?Sch::mapSize(H,V);
		Sch::roll_dice(1, math.round(H/2), D1);
		Sch::roll_dice(1, math.round(V/2), D2);
		Sch::enter_map( D1, D2);
		.

+!create_adventurer[scheme(Sch)]
	<-	?goalArgument(Sch,setupTable,"Id",Id);
		.concat("dice_",Id, DId);
		lookupArtifact(DId, DArtId);
		Sch::focus(DArtId);

		!set_attributes[scheme(Sch)];
		!equip_initial_items;
		.

+!roll_initiative[source(Source), scheme(Sch)]
	<- 	Sch::roll_dice(1, 20, I);
		.my_name(Me);
		.send(Source, tell, Sch::initiative(Me, 1 + I));
		.

+!play_turn[source(Source),scheme(Sch)]
	<-	!find_nearest_monster(Monster)[scheme(Sch)];
		!move_towards_monster(Monster)[scheme(Sch)];
		!attack(Monster)[scheme(Sch)];
		.my_name(Me);
		.send(Source, resume, inform_turn(Me)[scheme(Sch)]);
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
		Sch::roll_dice(1, 20, Attack);
		?Attr::attack_bonus(AB);

		?Attr::strength_mod(SM);
		?Equip::weapon(WN, ND, TD, BD);
		Sch::roll_dice(ND, TD, D2);
		Damage = SM + D2 + BD;

		.send(master, achieve, test_attack(Monster, Attack + AB ,Damage)[scheme(Sch)]);
		.suspend;
		.

+!attack(Monster)[scheme(Sch)]
	<-	!move_towards_monster(Monster)[scheme(Sch)].

in_range(Monster) :- my_name(Me) & Sch::adventurer(Me, H, V) & Sch::monster(Monster, H2, V2) & adj(H, V, H2, V2).

{ include("common-agents.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
