+Equip::armor(A)
	<- 	?Status::armor_points(Ap);
		-+Status::armor_points(Ap+A).

+Attr::constitution(C)
	<-	-+Attr::constitution_mod((C-10) div 2).

+Attr::strength(S)
	<-	-+Attr::strength_mod((S-10) div 2).

+Attr::intelligence(I)
	<-	-+Attr::intelligence_mod((I-10) div 2).

+Attr::dexterity(D)
	<-	-+Attr::dexterity_mod((D-10) div 2).

+Attr::dexterity_mod(D): Equip::armor(A)
	<-	-+Status::armor_points(10 + D + A).

+Attr::dexterity_mod(D)
	<-	-+Status::armor_points(10 + D).


+!name <- .my_name(Me); .term2string(Me, SMe); +my_name(SMe).


+!kqml_received(Sender, resume, Content, MsgId)
    <- .resume(Content).

// +!resume(G)
// 	<-	.resume(G);
// 		.

+!took_damage(Damage)
	<-	?Status::hp(HP);
		-+Status::hp(HP-Damage);
		.

+!move_possibilities(X, Y, P)
	<- .concat([[X+1,Y]],[[X-1,Y]],[[X,Y+1]],[[X,Y-1]], P).

+!calc_distances(X, Y, [H|T], Dists)
	<-	H = [X2, Y2];
		D = ( math.abs(X-X2) + math.abs(Y-Y2));
		!calc_distances(X,Y,T, D2);
		.concat([[D,X2,Y2]], D2, Dists);
		.

+!calc_distances(X, Y, [], Dists)
	<-	Dists = [].

+!best_move(Dists, X, Y)
	<-	.min(Dists,D);
		D = [D2, X, Y];
		.

+!move(X, Y, [H|T])[scheme(Sch)]
	<-	H = [D, X2, Y2];
		if(isOcuppied(X2,Y2)){
			!move(X,Y,T)[scheme(Sch)]
		}else{
			.my_name(Me);
			Sch::move(Me, X2, Y2);
			.print("Moving from [",X,",",Y,"] to ","[",X2,",",Y2,"]");
		}
		.

+!move(X, Y, [])[scheme(Sch)]
	<- .print("Not moving").

adj(X1,Y,X2,Y) :- X2 == X1+1.
adj(X1,Y,X2,Y) :- X2 == X1-1.
adj(X,Y1,X,Y2) :- Y2 == Y1+1.
adj(X,Y1,X,Y2) :- Y2 == Y1-1.

isOcuppied(X,Y) :- Sch::adventurer(_, X, Y) | Sch::monster(_, X, Y).
