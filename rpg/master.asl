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
	<-	.print("Table created, let's play adventures.");
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
        .

+!test_attack(Receiver, Attack, Damage, Sch)[source(Source)]//TODO:Enviar mensagem de volta para adventurer contando o status do monstro
    <-  .send(Receiver, askOne, Status::armor_points(X), armor_points(AP));
        if(Attack>=AP){
            .send(Receiver, askOne, Status::hp(X),hp(HP));
            .print(Source," rolls ",Attack," and hit ", Receiver);
            .print(Source," deals ", Damage," damage to ", Receiver);
            if(HP-Damage > 0){
                .send(Receiver, achieve, took_damage(Damage));
            }else{
                .send(Receiver, tell, Status::dead[killer(Source)]);
                // Sch::remove_monsters(Receiver);
            }
        }else{
            .print(Source," rolls ",Attack," and misses ", Receiver);
        }
        .
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
