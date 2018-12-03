package rpg;

import jason.asSyntax.Atom;
import cartago.*;
import java.util.Map;
import java.util.HashMap;

import java.awt.Graphics;
import java.awt.Color;
import java.awt.Graphics2D;
import javax.swing.JFrame;
import javax.swing.JPanel;
import java.awt.geom.Ellipse2D;


public class MapArtifact extends Artifact {

	Map<String,Position> adventurersPosition = new HashMap<String,Position>();
	Map<String,Position> monstersPosition = new HashMap<String,Position>();

	int adventurersKilled = 0;
	int monstersKilled = 0;

	int nAdventurer = 0;
	int nMonster = 0;

	int hSize = 12;
	int vSize = 12;

	JFrame frame = new JFrame("Rpg");
	RpgView rpgView = new RpgView();

	public void init(){
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(600,640);
		frame.setLocationRelativeTo(null);
		frame.setVisible(true);
		frame.add(rpgView);

		defineObsProperty("nAdventurer", nAdventurer);
		defineObsProperty("nMonster", nMonster);
		defineObsProperty("adventurersKilled", nMonster);
		defineObsProperty("monstersKilled", nMonster);
		defineObsProperty("mapSize", hSize, vSize);
	}

	private void update_map(){
		rpgView.set_agents(adventurersPosition, monstersPosition);
		rpgView.repaint();
	}

	@OPERATION
	public void enter_map(int h, int v){
		String agentName = getCurrentOpAgentId().getAgentName();
		Position agentPos = new Position(h,v);
		adventurersPosition.put(agentName, agentPos);
		defineObsProperty("adventurer", agentName, h, v);

		nAdventurer = nAdventurer + 1;
		getObsProperty("nAdventurer").updateValue(nAdventurer);
		update_map();
	}

	@OPERATION
	public void add_monsters(String monsterName, int h, int v){
		Position agentPos = new Position(h,v);
		monstersPosition.put(monsterName, agentPos);
		defineObsProperty("monster", monsterName, h, v);

		nMonster = nMonster + 1;
		getObsProperty("nMonster").updateValue(nMonster);
		update_map();
	}

	@OPERATION
	public void remove_from_map(String agentName){
		Position posm = monstersPosition.get(agentName);
		Position posp = adventurersPosition.get(agentName);
		if(posm!=null){
			monstersPosition.remove(agentName);
			removeObsPropertyByTemplate("monster", agentName, posm.h, posm.v);
			monstersKilled = monstersKilled + 1;
			getObsProperty("monstersKilled").updateValue(monstersKilled);

			nMonster = nMonster - 1;
			getObsProperty("nMonster").updateValue(nMonster);
		}else if(posp!=null){
			adventurersPosition.remove(agentName);
			removeObsPropertyByTemplate("adventurer", agentName, posp.h, posp.v);
			adventurersKilled = adventurersKilled +1;
			getObsProperty("adventurersKilled").updateValue(adventurersKilled);

			nAdventurer = nAdventurer -1;
			getObsProperty("nAdventurer").updateValue(nAdventurer);
		}
		update_map();
	}

	@OPERATION
	public void move(String agentName, int h, int v){
		Position posm = monstersPosition.get(agentName);
		Position posp = adventurersPosition.get(agentName);
		Position agentPos = new Position(h,v);

		if(posm!=null){
			monstersPosition.put(agentName, agentPos);
			getObsPropertyByTemplate("monster", agentName, posm.h, posm.v).updateValues(agentName, h, v);
		}else if(posp!=null){
			adventurersPosition.put(agentName, agentPos);
			getObsPropertyByTemplate("adventurer", agentName, posp.h, posp.v).updateValues(agentName, h, v);
		}
		update_map();
	}
}

class Position{
	public int h;
	public int v;

	public Position(int h1, int v1){
		h = h1;
		v = v1;
	}
}

class RpgView extends JPanel {
	Map<String,Position> adventurersPosition = new HashMap<String,Position>();
	Map<String,Position> monstersPosition = new HashMap<String,Position>();

    public void paintComponent(Graphics g){
        super.paintComponent(g);
        Graphics2D g2 = (Graphics2D) g;
		int diameter = 50;

		Position pos = new Position(0,0);
		for (Map.Entry<String, Position> entry : adventurersPosition.entrySet()){
			pos = entry.getValue();
			g2.setColor(Color.BLUE);
			g2.fill(new Ellipse2D.Double((pos.h-1)*diameter, (pos.v-1)*diameter, diameter, diameter));
		}
		for (Map.Entry<String, Position> entry : monstersPosition.entrySet()){
			pos = entry.getValue();
			g2.setColor(Color.RED);
			g2.fill(new Ellipse2D.Double((pos.h-1)*diameter, (pos.v-1)*diameter, diameter, diameter));
		}

    }

    public void set_agents(Map<String,Position> aP, Map<String,Position> mP){
        adventurersPosition = aP;
        monstersPosition = mP;
    }
}
