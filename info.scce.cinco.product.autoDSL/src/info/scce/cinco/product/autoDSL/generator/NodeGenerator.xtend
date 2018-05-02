package info.scce.cinco.product.autoDSL.generator

import graphmodel.Node
import info.scce.cinco.product.autoDSL.rule.rule.Addition
import info.scce.cinco.product.autoDSL.rule.rule.Decision
import info.scce.cinco.product.autoDSL.rule.rule.Input
import info.scce.cinco.product.autoDSL.rule.rule.Less
import info.scce.cinco.product.autoDSL.rule.rule.LessOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.LogicalAnd
import info.scce.cinco.product.autoDSL.rule.rule.LogicalOr
import info.scce.cinco.product.autoDSL.rule.rule.Maximum
import info.scce.cinco.product.autoDSL.rule.rule.Minimum
import info.scce.cinco.product.autoDSL.rule.rule.Multiplication
import info.scce.cinco.product.autoDSL.rule.rule.Negation
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.PIDController
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Subtraction
import info.scce.cinco.product.autoDSL.rule.rule.util.RuleSwitch
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarInput
import info.scce.cinco.product.autoDSL.rule.rule.DirectNumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.ControlFlowDecisionTrue
import info.scce.cinco.product.autoDSL.rule.rule.ControlFlowDecisionFalse
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.DirectBooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.Output
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanGuardOutput
import info.scce.cinco.product.autoDSL.rule.rule.Greater
import info.scce.cinco.product.autoDSL.rule.rule.GreaterOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.Division
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import javax.xml.stream.events.Comment
import java.util.Iterator
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import java.util.HashMap
import info.scce.cinco.product.autoDSL.rule.rule.Load
import info.scce.cinco.product.autoDSL.rule.rule.StoredPIDController
import info.scce.cinco.product.autoDSL.rule.rule.SaveNumber
import info.scce.cinco.product.autoDSL.rule.rule.SaveBoolean
import info.scce.cinco.product.autoDSL.rule.rule.LoadBoolean
import info.scce.cinco.product.autoDSL.rule.rule.LoadNumber
import info.scce.cinco.product.autoDSL.sharedMemory.sharedmemory.SharedMemory
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput

class NodeGenerator extends RuleSwitch<CharSequence> {
	
	var HashMap<Integer, String> knownMemory =  new HashMap<Integer, String>()
	
	override casePIDController(PIDController op)'''
		//PID Controller
		«op.outputs.head.referenceOutput» = pid«IDHasher.GetStringHash(op.id)».calculate(«op.inputs.head.referenceInput», «op.inputs.last.referenceInput», 0.1);
		
		«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseNegation(Negation op)'''
	//Negation Operator
	«op.booleanOutputs.head.referenceOutput» = !«op.booleanInputs.head.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseAddition(Addition op)'''
	//Addition Operator
	«op.outputs.head.referenceOutput» = «FOR input : op.inputs SEPARATOR '+'»«
									input.referenceInput»«
								ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMultiplication(Multiplication op)'''
	//Multiplication Operator
	«op.outputs.head.referenceOutput» = «FOR input : op.inputs SEPARATOR '*'»«
									input.referenceInput»«
								ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMaximum(Maximum op)'''
	//Max Operator
	double «IDHasher.GetStringHash(op.id)»[] = {«FOR  input : op.inputs SEPARATOR ','»«
						input.referenceInput»«
						ENDFOR»};
	«op.outputs.head.referenceOutput» = ACCPlusPlus::Utility::max(«IDHasher.GetStringHash(op.id)»,«op.inputs.length»);
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMinimum(Minimum op)'''
	//Min Operator
	double «IDHasher.GetStringHash(op.id)»[] = {«FOR  input : op.inputs SEPARATOR ','»«
							input.referenceInput»«
						ENDFOR»};
	«op.outputs.head.referenceOutput» = ACCPlusPlus::Utility::min(«IDHasher.GetStringHash(op.id)»,«op.inputs.length»);
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLogicalAnd(LogicalAnd op)'''
	//And Operator
	«op.outputs.head.referenceOutput» = «FOR in : op.inputs SEPARATOR '&&'»«
										in.referenceInput»«
									ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLogicalOr(LogicalOr op)'''
	//Or Operator
	«op.outputs.head.referenceOutput» = «FOR in : op.inputs SEPARATOR '||'»«
											in.referenceInput»«
										ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseSubtraction(Subtraction op)'''
	//Substraction Operator
	«op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» - «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseDivision(Division op)'''
	//Division Operator
	«op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» / «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLess(Less op)'''
	//Less Operator
	«op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» < «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLessOrEqual(LessOrEqual op)'''
	//LessOrEqual Operator
	«op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» <= «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseGreater(Greater op)'''
	//Greater Operator
	«op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» > «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseGreaterOrEqual(GreaterOrEqual op)'''
	//GreaterOrEqual Operator
	«op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» >= «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseDecision(Decision d)'''
	if(«d.booleanInputs.head.referenceInput»){
		«d.outgoing.filter(ControlFlowDecisionTrue).head.getTargetElement.doSwitch»
	}«IF !d.outgoing.filter(ControlFlowDecisionFalse).nullOrEmpty» else{
		«d.outgoing.filter(ControlFlowDecisionFalse).head.getTargetElement.doSwitch»
	}«ENDIF»
	'''
	
	override caseDirectNumberOutput(DirectNumberOutput out)'''
	//Number Output
	«out.numberCarOutputs.head.referenceOutput» = «out.numberInputs.head.referenceInput»;
	«if(!out.getSuccessors.nullOrEmpty)out.getSuccessors.head.doSwitch»
	'''
	
	override caseDirectBooleanOutput(DirectBooleanOutput out)'''
	//Boolean Output
	«out.booleanCarOutputs.head.referenceOutput» = «out.booleanInputs.head.referenceInput»;
	«if(!out.getSuccessors.nullOrEmpty)out.getSuccessors.head.doSwitch»
	'''	
	override caseBooleanGuardOutput(BooleanGuardOutput out)'''
	//Guard Output
	return «out.booleanInputs.head.referenceInput»;
	'''
	
	override caseSubRule(SubRule rule)'''
	
	«IF !rule.booleanSubInputs.nullOrEmpty»//BooleanSubInputs
	«val Iterator<BooleanSubOutput> refBoolIns = rule.rule.subRuleInputss.head.booleanSubOutputs.iterator»
	«FOR in:rule.booleanSubInputs»
		«refBoolIns.next.referenceOutput» = «in.referenceInput»;
	«ENDFOR»
	«ENDIF»
	
	«IF !rule.numberSubInputs.nullOrEmpty»//NumberSubInputs
	«val Iterator<NumberSubOutput> refNumberIns = rule.rule.subRuleInputss.head.numberSubOutputs.iterator»
	«FOR in:rule.numberSubInputs»
		«refNumberIns.next.referenceOutput» = «in.referenceInput»;
	«ENDFOR»
	«ENDIF»
	
	//SubRule start
	«FOR Node node:rule.rule.operations»
		«IF node.incoming.nullOrEmpty&&!(node instanceof Comment)»
			«node.doSwitch»
		«ENDIF»
	«ENDFOR»
	//SubRule end
	
	«IF !rule.booleanSubOutputs.nullOrEmpty»//BooleanSubOutputs
	«val Iterator<BooleanSubInput> refBoolOuts = rule.rule.subRuleOutputss.head.booleanSubInputs.iterator»
	«FOR out:rule.booleanSubOutputs»
		bool «out.referenceOutput» = «refBoolOuts.next.referenceInput»;
	«ENDFOR»
	«ENDIF»
	
	«IF !rule.numberSubOutputs.nullOrEmpty»//NumberSubOutputs
	«val Iterator<NumberSubInput> refNumberOuts = rule.rule.subRuleOutputss.head.numberSubInputs.iterator»
	«FOR out:rule.numberSubOutputs»
		double «out.referenceOutput» = «refNumberOuts.next.referenceInput»;
	«ENDFOR»
	«ENDIF»
	
	«if(!rule.getSuccessors.nullOrEmpty)rule.getSuccessors.head.doSwitch»
	'''
	
	override caseSubRuleInputs(SubRuleInputs in)'''
	«if(!in.getSuccessors.nullOrEmpty)in.getSuccessors.head.doSwitch»
	'''
	
	override caseSubRuleOutputs(SubRuleOutputs out)'''
	//SubRule Outputs
	«FOR BooleanSubInput port:out.booleanSubInputs»
		«IDHasher.GetStringHash(out.rootElement.id)+"_"+port.identifier» = «port.referenceInput»;
	«ENDFOR»
	«FOR NumberSubInput port:out.numberSubInputs»
		«IDHasher.GetStringHash(out.rootElement.id)+"_"+port.identifier» = «port.referenceInput»;
	«ENDFOR»
	«if(!out.getSuccessors.nullOrEmpty)out.getSuccessors.head.doSwitch»
	'''
	
	override caseSaveNumber(SaveNumber save)'''
	//Saving Data
	SharedMemory::«save.data.rootElement.memoryName».«save.data.label» = «save.inputs.head.referenceInput»;
	«if(!save.getSuccessors.nullOrEmpty)save.getSuccessors.head.doSwitch»
	'''
	
	override caseSaveBoolean(SaveBoolean save)'''
	//Saving Data
	SharedMemory::«save.data.rootElement.memoryName».«save.data.label» = «save.inputs.head.referenceInput»;
	«if(!save.getSuccessors.nullOrEmpty)save.getSuccessors.head.doSwitch»
	'''
	
	override caseLoad(Load load)'''
	«if(!load.getSuccessors.nullOrEmpty)load.getSuccessors.head.doSwitch»
	'''
	
	
	override caseStoredPIDController(StoredPIDController pid)'''
	//Stored PID
	«pid.outputs.head.referenceOutput» = SharedMemory::«pid.data.rootElement.memoryName».«pid.data.label».calculate(«pid.inputs.head.referenceInput», «pid.inputs.last.referenceInput», 0.1);
	
	«if(!pid.getSuccessors.nullOrEmpty)pid.getSuccessors.head.doSwitch»
	'''
	
	override caseNode(Node n)'''/*Node «n.toString» not found*/
	«if(!n.getSuccessors.nullOrEmpty)n.getSuccessors.head.doSwitch»
	'''
	
	def referenceInput(Input in){
		switch in{
			NumberStaticInput :	in.staticValue
			NumberCarInput :	"input."+in.inputtype.toString
			BooleanStaticInput:	in.staticValue
			BooleanCarInput:	"input."+in.inputtype.toString
			default :	if(in.predecessors.nullOrEmpty){
							"/*input not a reference*/"
						}else{
							val out = in.predecessors.head
							if(out instanceof Output){
								out.referenceOutput
							}else{
								"/*input is a reference for something thats not an output*/"
							}
						}
		}	
	}
	
	def referenceOutput(Output out){
		switch out{
			NumberCarOutput :	"output."+out.outputtype.toString
			BooleanCarOutput:	"output."+out.outputtype.toString
			NumberSubOutput:	if(out.container instanceof SubRule){
									IDHasher.GetStringHash(out.id)
								}else{
									IDHasher.GetStringHash(out.rootElement.id)+"_"+out.identifier
								}
			BooleanSubOutput:	if(out.container instanceof SubRule){
									IDHasher.GetStringHash(out.id)
								}else{
									IDHasher.GetStringHash(out.rootElement.id)+"_"+out.identifier
								}
			NumberOutput:		if(out.container instanceof LoadNumber){
									"SharedMemory::"+(out.container as LoadNumber).data.rootElement.memoryName+"."+(out.container as LoadNumber).data.label
								}else{
									"double "+IDHasher.GetStringHash(out.id)
								}
			BooleanOutput:		if(out.container instanceof LoadBoolean){
									"SharedMemory::"+(out.container as LoadBoolean).data.rootElement.memoryName+"."+(out.container as LoadBoolean).data.label
								}else{
									"bool "+IDHasher.GetStringHash(out.id)
								}
		}	
	}
	
	public def generateSubRulePorts(Rule mainRule)'''
	«var HashMap<Integer, Rule> knownSubRules = new HashMap<Integer, Rule>()»
	«FOR rule:mainRule.subRules»
		«IF !knownSubRules.containsValue(rule.rule)»
			«knownSubRules.put(IDHasher.GetIntHash(rule.rule.id),rule.rule)»
			//subRule «IDHasher.GetIntHash(rule.rule.id)»
			«IF !rule.booleanSubInputs.nullOrEmpty»//BooleanSubInputs
			«val Iterator<BooleanSubOutput> refBoolIns = rule.rule.subRuleInputss.head.booleanSubOutputs.iterator»
			«FOR BooleanSubInput in:rule.booleanSubInputs»
				bool «refBoolIns.next.referenceOutput»;
			«ENDFOR»
			«ENDIF»
			
			«IF !rule.numberSubInputs.nullOrEmpty»//NumberSubInputs
			«val Iterator<NumberSubOutput> refNumberIns = rule.rule.subRuleInputss.head.numberSubOutputs.iterator»
			«FOR NumberSubInput in:rule.numberSubInputs»
				double «refNumberIns.next.referenceOutput»;
			«ENDFOR»
			«ENDIF»
			
			«IF !rule.booleanSubOutputs.nullOrEmpty»//BooleanSubOutputs
			«FOR BooleanSubInput out:rule.rule.subRuleOutputss.head.booleanSubInputs»
				bool «IDHasher.GetStringHash(rule.rule.id)+"_"+out.identifier»;
			«ENDFOR»
			«ENDIF»
			
			«IF !rule.numberSubOutputs.nullOrEmpty»//NumberSubOutputs
			«FOR NumberSubInput out:rule.rule.subRuleOutputss.head.numberSubInputs»
				double «IDHasher.GetStringHash(rule.rule.id)+"_"+out.identifier»;
			«ENDFOR»
			«ENDIF»
			
		«ENDIF»
	«ENDFOR»
	'''
	
	def getMemoryName(SharedMemory memory){
		var id = 	IDHasher.GetIntHash(memory.id);
		var name = knownMemory.get(id);
		  
		if(name == null){
		var String[] names = memory.eResource().getURI().lastSegment().split(".sharedMemory").get(0).split("_")
		
		name = "";
		for(String n : names) {
			name = name + n.toFirstUpper
		}
		
		//safe the memory name
		  	knownMemory.put(IDHasher.GetIntHash(name), name)
		}
			
		return "g"+name+"_var";
	}
}