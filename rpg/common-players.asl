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
