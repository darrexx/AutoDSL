package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class ToPort extends CincoCustomAction<IO> {
	
	override execute(IO io) {
		val x = io.x as int
		val y = io.y as int
		val cont = io.container as Operation
		io.delete
		switch io {
			BooleanInput : cont.newBooleanInputPort(x, y)
			BooleanOutput : cont.newBooleanOutputPort(x, y)
			NumberInput : cont.newNumberInputPort(x, y)
			NumberOutput : cont.newNumberOutputPort(x, y)
		}
	}
	
}