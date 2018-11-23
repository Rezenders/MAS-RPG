Status::level(1).
Status::exp(0).
Status::class(fighter).

!spawn_adventurer.

+!set_attributes
	<- 	.random(C); .random(S);	.random(I); .random(D);
		+Attr::constitution(8 + math.round(C*5) mod 5);
		+Attr::strength(8 + math.round(S*5) mod 5 );
		+Attr::intelligence(8+ math.round(I*5) mod 5);
		+Attr::dexterity(8+ math.round(D*5) mod 5);

		?Attr::constitution_mod(Cons);
		+Status::hp(10 + Cons);
		?Attr::dexterity_mod(Dex);
		+Status::armor_points(10 + Dex);
		.

+!equip_initial_items
	<-	+Equip::weapon(sword, 1, 8);
		+Equip::armor(7);
		.
+!initial_position
	<-	.random(X); .random(Y);
		+position( math.round(X*6) mod 6, math.round(Y*6) mod 6).

+!spawn_adventurer
	<-	!set_attributes;
		!equip_initial_items;
		!initial_position;
		.

{ include("common-players.asl") }
