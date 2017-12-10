package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.IO

class CreateIO extends CincoPostCreateHook<IO> {
	
	override postCreate(IO io) {
		LayoutManager.rearrangePostCreate(io)
	}
	
}