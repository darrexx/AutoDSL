package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput
import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class ToCar extends IOConversion {

//TODO find generic but precise name (will be displayed in ContextMenu) and adjust counterparts for static and port to match.
	override getName() {
		getName("car")
	}
	
	override execute(IO io) {
		val x = io.x as int
		val y = io.y as int
		val op = io.operation
		LayoutManager.prepareConversion(io)
		switch io {
			BooleanInput : op.newBooleanCarInput(x, y)
			BooleanOutput : op.newBooleanCarOutput(x, y)
			NumberInput : op.newNumberCarInput(x, y)
			NumberOutput : op.newNumberCarOutput(x, y)
		}
	}
	
	override canExecute(IO io){
		switch io {
			BooleanInput : io.operation.canNewBooleanCarInput
			BooleanOutput : io.operation.canNewBooleanCarOutput
			NumberInput : io.operation.canNewNumberCarInput
			NumberOutput : io.operation.canNewNumberCarOutput
			default : super.canExecute(io)
		}
	}
	
}