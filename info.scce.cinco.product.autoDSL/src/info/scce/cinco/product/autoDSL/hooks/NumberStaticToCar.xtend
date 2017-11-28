package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.*

class NumberStaticToCar extends CincoCustomAction<NumberStaticInput> {
	
	override getName() {
		"Convert to: Car input"
	}
	
	override execute(NumberStaticInput inp) {
		val x = inp.x as int
		val y = inp.y as int
		val cont = inp.container
		inp.delete
		if (cont instanceof CommutableOperation)
			(cont as CommutableOperation).newNumberCarInput(x, y)
		else
			(cont as NonCommutableOperation).newNumberCarInput(x, y)
	}
	
}