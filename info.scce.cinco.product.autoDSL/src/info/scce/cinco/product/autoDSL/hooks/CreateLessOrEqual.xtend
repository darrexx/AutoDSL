package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.tmprule.tmprule.NonCommutableOperation
import info.scce.cinco.product.autoDSL.tmprule.tmprule.PrimitiveType

//TODO rename or split if necessary
class CreateLessOrEqual extends CincoPostCreateHook<NonCommutableOperation> {
	
	override  postCreate(NonCommutableOperation droppedNode) {
		droppedNode.newInputPort(5, 6).setDatatype(PrimitiveType.NUMBER)
		droppedNode.newInputPort(5, 46).setDatatype(PrimitiveType.NUMBER)
		var result = droppedNode.newOutputPort(6, 66)
		result.setDatatype(PrimitiveType.BOOLEAN)
	}
}