monsters_spawned(0).

!start_game("table1").

+!start_game(Id)
   <- 	.print("Iniciando");
		.concat("sch_",Id,SchName);
		makeArtifact(SchName, "ora4mas.nopl.SchemeBoard",["src/org/org.xml", rpgSch],SchArtId);
		setArgumentValue(setupTable,"Id",Id)[artifact_id(SchArtId)];
		.my_name(Me); setOwner(Me)[artifact_id(SchArtId)];
		focus(SchArtId);
		addScheme(SchName);
		.

+!create_table[scheme(Sch)]
	<-	.print("Table created, let's play adventures. \n");
		?goalArgument(Sch,setupTable,"Id",Id)
		makeArtifact(Id, "rpg.MapArtifact",[], ArtId);
		Sch::focus(ArtId);
		.

+!spawn_monster[scheme(Sch)]
    <-  ?monsters_spawned(N);
        .concat("kobold_",N, Name);
        .create_agent(Name, "monster.asl");
        .send(Name, achieve, init_monster[scheme(Sch)]);
        .random(X); .random(Y);
        Sch::add_monsters(Name, 6+ math.round(X*6) mod 6, 6 + math.round(Y*6) mod 6);
        -+monsters_spawned(N+1); //usar namespace?
        .suspend;
        .

+!demand_initiative[scheme(Sch)]
    <-  .findall(Name, Sch::monster(Name, X, Y), Monsters);
        .findall(Name, Sch::adventurer(Name, X, Y), Adventurers);
        .concat(Monsters, Adventurers, Participants);
        .send(Participants, achieve, roll_initiative[scheme(Sch)]);
        .wait(1000);
        .

+!manage_turns[scheme(Sch)]
    : .findall(A,Sch::adventurer(A,X,Y),LA) & .findall(M,Sch::monster(M,X2,Y2),LM) & (LA \== [] & LM \== [])
    <-  .findall([Init, Name], Sch::initiative(Name, Init), Uinit);
        .sort(Uinit, Oinit);
        .reverse(Oinit, Turns);
        !delegate_turns(Turns)[scheme(Sch)];
        .print("Turn ended \n");
        !manage_turns[scheme(Sch)];
        .

+!manage_turns[scheme(Sch)]
    <- .print("Battle ended").

+!delegate_turns([H|T])[scheme(Sch)]
    <-  H =[I,Name];
        !inform_turn(Name);
        !delegate_turns(T)[scheme(Sch)];
        .

+!delegate_turns([])[scheme(Sch)].

+!inform_turn(Name) : .term2string(Name, SName) & (Sch::adventurer(SName,X,Y) | Sch::monster(SName,X,Y))
    <-  .send(Name, achieve, play_turn[scheme(Sch)]);
        .suspend;
        .


+!inform_turn(Name).

+!test_attack(Receiver, Attack, Damage, Sch)[source(Source)]
    <-  .send(Receiver, askOne, Status::armor_points(X), armor_points(AP));
        if(Attack>=AP){
            .send(Receiver, askOne, Status::hp(X),hp(HP));
            .print(Source," rolls ", Attack," and hits ", Receiver);
            .print(Source," deals ", Damage," damage to ", Receiver);
            if(HP-Damage > 0){
                .send(Receiver, achieve, took_damage(Damage));
            }else{
                .print(Receiver," died an honarable death!");
                Sch::remove_from_map(Receiver);
                .kill_agent(Receiver);
            }
        }else{
            .print(Source," rolls ",Attack," and misses ", Receiver);
        }
        .send(Source, achieve, resume(attack(Receiver)[scheme(Sch)]));
        . //Sch como annotation

-!test_attack(Receiver, Attack, Damage, Sch)[source(Source)].

+!resume(G)
	<-	.resume(G);
		.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
