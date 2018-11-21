level(1).
exp(0).
class(fighter).

!spawn_adventurer.

+!set_attributes
	<- 	.random(C); .random(S);	.random(I);
		+constitution(8 + math.round(C*5) mod 5);
		+strength(8 + math.round(S*5) mod 5 );
		+intelligence(8+ math.round(I*5) mod 5);
		?constitution(Cons);
		+hp(10 + ( (Cons-10) div 2 )).

+!spawn_adventurer
	<-!set_attributes;
	.random(X); .random(Y);
	+position( math.round(X*6) mod 6, math.round(Y*6) mod 6).
