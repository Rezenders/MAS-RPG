package rpg;

import jason.asSyntax.Atom;
import cartago.*;
import java.util.Random;


public class DiceArtifact extends Artifact {

	Random rand = new Random();

	@OPERATION
	public void roll_dice(int diceNumber, int diceFaces, OpFeedbackParam result){
		int sum = 0;
		while(diceNumber > 0){
			sum += rand.nextInt(diceFaces) + 1;
			--diceNumber;
		}
		result.set(sum);
	}
}
