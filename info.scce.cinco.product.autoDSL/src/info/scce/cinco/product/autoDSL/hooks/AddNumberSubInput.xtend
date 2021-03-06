package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

class AddNumberSubInput extends CincoCustomAction<SubRuleOutputs> {

	override getName() {
		"Add Number Output"
	}
	
	override execute(SubRuleOutputs outputs) {
		outputs.newNumberSubInputPort(0,0)
	}
}