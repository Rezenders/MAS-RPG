package rpg;

import jason.asSyntax.Atom;
import cartago.*;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;


public class MapArtifact extends Artifact {

	Map<String,Position> playersPosition = new HashMap<String,Position>();
	Map<String,Position> monstersPosition = new HashMap<String,Position>();

	public void init(){

	}

	@OPERATION
	public void enter_map(int h, int v){
		String agentName = getCurrentOpAgentId().getAgentName();
		Position agentPos = new Position(h,v);
		playersPosition.put(agentName, agentPos);
		defineObsProperty("adventurer", agentName, h, v);
	}

	@OPERATION
	public void add_monsters(String monsterName, int h, int v){
		Position agentPos = new Position(h,v);
		monstersPosition.put(monsterName, agentPos);
		defineObsProperty("monster", monsterName, h, v);
	}

	@OPERATION
	public void remove_monsters(String monsterName){
		Position pos = monstersPosition.get(monsterName);
		monstersPosition.remove(monsterName);
		removeObsPropertyByTemplate("monster", monsterName, pos.horizontal, pos.vertical);
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
