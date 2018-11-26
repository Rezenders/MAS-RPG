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
	
	public void init(){

	}

	@OPERATION
	public void enter_map(int h, int v){
		String agentName = getCurrentOpAgentId().getAgentName();
		Position agentPos = new Position(h,v);
		adventurersPosition.put(agentName, agentPos);
		defineObsProperty("adventurer", agentName, h, v);
	}

	@OPERATION
	public void add_monsters(String monsterName, int h, int v){
		Position agentPos = new Position(h,v);
		monstersPosition.put(monsterName, agentPos);
		defineObsProperty("monster", monsterName, h, v);
	}

	@OPERATION
	public void remove_from_map(String remove_from_map){
		Position posm = monstersPosition.get(remove_from_map);
		Position posp = adventurersPosition.get(remove_from_map);
		if(posm!=null){
			monstersPosition.remove(remove_from_map);
			removeObsPropertyByTemplate("monster", remove_from_map, posm.horizontal, posm.vertical);
			monstersKilled = monstersKilled + 1;
		}else if(posp!=null){
			adventurersPosition.remove(remove_from_map);
			removeObsPropertyByTemplate("adventurer", remove_from_map, posp.horizontal, posp.vertical);
			adventurersKilled = adventurersKilled +1;
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
