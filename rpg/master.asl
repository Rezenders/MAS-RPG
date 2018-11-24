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

+!teste
	<-	makeArtifact(SchName, "ora4mas.nopl.SchemeBoard",["src/org/org.xml", playRpg],SchArtId);
		debug(inspector_gui(on))[artifact_id(SchArtId)];
		setArgumentValue(playRpg,"Id",Id)[artifact_id(SchArtId)];
		.my_name(Me); setOwner(Me)[artifact_id(SchArtId)];  // I am the owner of this scheme!
		focus(SchArtId);
		addScheme(SchName);  // set the group as responsible for the scheme
		.


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
