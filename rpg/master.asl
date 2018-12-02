monster_level(1,"kobold").
monster_level(2,"axebeak").
monster_level(3,"orc").
monster_level(4,"bugbear").

!start_game("table1").

+!start_game(Id)
   <- 	.print("Starting game.");
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

        .concat("dice_",Id, DId);
        makeArtifact(DId, "rpg.DiceArtifact",[], DArtId);
        Sch::focus(DArtId);

        .concat("map_",Id, MId);
		makeArtifact(MId, "rpg.MapArtifact",[], MArtId);
		Sch::focus(MArtId);
        +Sch::monsters_spawned(0);
        +Sch::level(1);
		.

+!spawn_monster[scheme(Sch)] : Sch::nAdventurer(NA) & Sch::nMonster(NM) & NM < NA & Sch::level(L) & monster_level(L+1,N2)
    <-  ?Sch::monsters_spawned(N);
        ?monster_level(L, Monster);
        .concat(Monster, "_", N, Name); .concat(Monster,".asl",File);
        .create_agent(Name, File);
        .send(Name, achieve, init_monster[scheme(Sch)]);
        .suspend;

        Sch::roll_dice(1, 6, D1);
		Sch::roll_dice(1, 6, D2);
        Sch::add_monsters(Name, 6 + D1, 6 + D2);
        -+Sch::monsters_spawned(N+1); //usar namespace?
        !spawn_monster[scheme(Sch)];
        .

+!spawn_monster[scheme(Sch)] : Sch::nAdventurer(NA) & Sch::nMonster(NM) & NM < 1
    <-  ?Sch::monsters_spawned(N);
        ?Sch::level(L);?monster_level(L,Monster);
        .concat("Boss ", Monster, Name);.concat(Monster,".asl",File);
        .create_agent(Name, File);
        .send(Name, achieve, init_monster[scheme(Sch)]);
        .suspend;

        Sch::roll_dice(1, 6, D1);
        Sch::roll_dice(1, 6, D2);
        Sch::add_monsters(Name, 6 + D1, 6 + D2);
        -+Sch::monsters_spawned(N+1); //usar namespace?
        !spawn_monster[scheme(Sch)];
        .

+!spawn_monster[scheme(Sch)].

+!demand_initiative[scheme(Sch)]
    <-
        .broadcast(achieve, roll_initiative[scheme(Sch)]);
        .abolish(Sch::initiative(_,_));
        .wait(1000);
        .

+!manage_turns[scheme(Sch)]: Sch::nAdventurer(NA) & Sch::nMonster(NM) & NA \== 0 & NM \== 0
    <-  .findall([Init, Name], Sch::initiative(Name, Init), Uinit);
        .sort(Uinit, Oinit);
        .reverse(Oinit, Turns);
        !delegate_turns(Turns)[scheme(Sch)];
        .print("Turn ended \n");
        !manage_turns[scheme(Sch)];
        .

+!manage_turns[scheme(Sch)]: Sch::nAdventurer(NA) & NA \== 0 & Sch::level(L) & monster_level(L+1,N)
    <-  ?Sch::level(L);
        .print("Level ", L, " completed. Prepare for next level! \n");
        -+Sch::level(L+1);
        .findall(Name, Sch::adventurer(Name, X, Y), Adventurers);
        .send(Adventurers, achieve, level_up[scheme(Sch)]);
        .wait(300);
        goalAchieved("manage_turns");
        resetGoal("manageBattle");
        .

+!manage_turns[scheme(Sch)]
    <-  ?Sch::adventurersKilled(AK);
        ?Sch::monstersKilled(MK);
        .print("Battle ended");
        .print("The life of ", AK, " brave adventures were lost while defeating ",MK," monsters.");
        .

+!delegate_turns([H|T])[scheme(Sch)] : Sch::nAdventurer(NA) & Sch::nMonster(NM) & NA \== 0 & NM \== 0
    <-  H =[I,Name];
        !inform_turn(Name)[scheme(Sch)];
        !delegate_turns(T)[scheme(Sch)];
        .

+!delegate_turns([H|T])[scheme(Sch)].

+!delegate_turns([])[scheme(Sch)].

+!inform_turn(Name): .term2string(Name, SName) & (Sch::adventurer(SName,X,Y) | Sch::monster(SName,X,Y))
    <-  .send(Name, achieve, play_turn[scheme(Sch)]);
        .suspend;
        .


+!inform_turn(Name)[scheme(Sch)].

+!test_attack(Receiver, Attack, Damage)[source(Source), scheme(Sch)]
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
        .send(Source, resume, attack(Receiver)[scheme(Sch)]);
        .

-!test_attack(Receiver, Attack, Damage)[source(Source), scheme(Sch)].

+!kqml_received(Sender, resume, Content, MsgId)
    <-  .resume(Content).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
