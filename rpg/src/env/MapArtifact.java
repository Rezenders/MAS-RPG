package rpg;

import jason.asSyntax.Atom;
import cartago.*;
import java.util.Map;
import java.util.HashMap;

public class MapArtifact extends Artifact {

	Map<String,Position> playersPosition = new HashMap<String,Position>();

	public void init(){

	}

	@OPERATION public void enter_map(int h, int v){
		String agentName = getCurrentOpAgentId().getAgentName();
		Position agentPos = new Position(h,v);
		playersPosition.put(agentName, agentPos);
	}

}

class Position{
	int horizontal;
	int vertical;

	public Position(int h, int v){
		horizontal = h;
		vertical = v;
	}
}
