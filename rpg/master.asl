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
        // .concat("kobold_",N, Mn); //TODO: Arrumar nome
        .random(X); .random(Y);
        Sch::add_monsters("kobold", 6+ math.round(X*6) mod 6, 6 + math.round(Y*6) mod 6); //TODO: Arrumar nome
        .send(kobold, achieve, init_monster); //TODO: create agent monster dynamically
        -+monsters_spawned(N+1); //usar namespace?
        .
+!test_attack_monster(Monster, Attack, Damage, Sch)[source(S)]//TODO:Enviar mensagem de volta para adventurer contando o status do monstro
    <-  .send(Monster, askOne, Status::armor_points(X), armor_points(AP));
        if(Attack>=AP){
            .send(Monster, askOne, Status::hp(X),hp(HP));
            .print(S," rolled ",Attack," and hit ", Monster);
            .print(S," dealed ", Damage," damage to ", Monster);
            if(HP-Damage > 0){
                .send(Monster, achieve, took_damage(Damage));
            }else{
                .send(Monster, tell, Status::dead[killer(S)]);
                Sch::remove_monsters(Monster);
            }
        }else{
            .print(S," rolled ",Attack," and missed ", Monster);
        }
        .
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
