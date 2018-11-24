package rpg;

import jason.asSyntax.Atom;
import cartago.*;
import java.util.Map;
import java.util.HashMap;

public class MapArtifact extends Artifact {

	Map<String,Position> playersPosition = new HashMap<String,Position>();

	public void init(){

	}

}

class Position{
	int horizontal;
	int vertical;

	// public void Positiont(int h,int v){
	// 	horizontal = h;
	// 	vertical = v;
	// }
}
