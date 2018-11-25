monsters_spawned(0).

!start_game("table1").

+!start_game(Id)
   <- // creates a scheme to coordinate the auction
   		.print("Iniciando");
		.concat("sch_",Id,SchName);
		makeArtifact(SchName, "ora4mas.nopl.SchemeBoard",["src/org/org.xml", rpgSch],SchArtId);
		setArgumentValue(setupTable,"Id",Id)[artifact_id(SchArtId)];
		.my_name(Me); setOwner(Me)[artifact_id(SchArtId)];
		focus(SchArtId);
		addScheme(SchName);
		.

+!create_table[scheme(Sch)]
	<-	.print("criando table");
		?goalArgument(Sch,setupTable,"Id",Id)
		makeArtifact(Id, "rpg.MapArtifact",[], ArtId);
		Sch::focus(ArtId);
		.

+!spawn_monster[scheme(Sch)]
    <-  ?monsters_spawned(N);
        .concat("kobold_",N, Mn);
        .random(X); .random(Y);
        Sch::add_monsters(Mn, 6+ math.round(X*6) mod 6, 6 + math.round(Y*6) mod 6);
        .send(kobold, achieve, init_monster); //TODO: create agent monster dynamicly
        -+monsters_spawned(N+1); //usar namespace?
        .

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
