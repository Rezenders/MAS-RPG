package rpg;

import jason.asSyntax.Atom;
import cartago.*;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;


public class MapArtifact extends Artifact {

	Map<String,Position> adventurersPosition = new HashMap<String,Position>();
	Map<String,Position> monstersPosition = new HashMap<String,Position>();

	int adventurersKilled = 0;
	int monstersKilled = 0;

	int nAdventurer = 0;
	int nMonster = 0;

	public void init(){
		defineObsProperty("nAdventurer", nAdventurer);
		defineObsProperty("nMonster", nMonster);
	}

	@OPERATION
	public void enter_map(int h, int v){
		String agentName = getCurrentOpAgentId().getAgentName();
		Position agentPos = new Position(h,v);
		adventurersPosition.put(agentName, agentPos);
		defineObsProperty("adventurer", agentName, h, v);

		nAdventurer = nAdventurer + 1;
		getObsProperty("nAdventurer").updateValue(nAdventurer);
	}

	@OPERATION
	public void add_monsters(String monsterName, int h, int v){
		Position agentPos = new Position(h,v);
		monstersPosition.put(monsterName, agentPos);
		defineObsProperty("monster", monsterName, h, v);

		nMonster = nMonster + 1;
		getObsProperty("nMonster").updateValue(nMonster);
	}

	@OPERATION
	public void remove_from_map(String agentName){
		Position posm = monstersPosition.get(agentName);
		Position posp = adventurersPosition.get(agentName);
		if(posm!=null){
			monstersPosition.remove(agentName);
			removeObsPropertyByTemplate("monster", agentName, posm.horizontal, posm.vertical);
			monstersKilled = monstersKilled + 1;

			nMonster = nMonster - 1;
			getObsProperty("nMonster").updateValue(nMonster);
		}else if(posp!=null){
			adventurersPosition.remove(agentName);
			removeObsPropertyByTemplate("adventurer", agentName, posp.horizontal, posp.vertical);
			adventurersKilled = adventurersKilled +1;

			nAdventurer = nAdventurer -1;
			getObsProperty("nAdventurer").updateValue(nAdventurer);
		}
	}


}

class Position{
	public int horizontal;
	public int vertical;

	public Position(int h, int v){
		horizontal = h;
		vertical = v;
	}
}
