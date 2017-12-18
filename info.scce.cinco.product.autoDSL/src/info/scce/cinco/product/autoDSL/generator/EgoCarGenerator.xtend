package info.scce.cinco.product.autoDSL.generator

import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL

class EgoCarGenerator {
	
	def generateEgoCar(AutoDSL auto)'''
	package info.scce.cinco.product;
	
	import info.scce.cinco.core.IO;
	
	public class EgoCar{
		private double posM;
		    
		private double velocityMPerSec;
		    
		private final double massKg = 1370.0;
		    
		private final double f0 = 51.0;
		
		private final double f1 = 1.2567;
		
		private final double f2 = 0.4342;
		
		private AutoDSL«IDHasher.GetStringHash(auto.id)» autoDSL;
		
		public EgoCar(double posM, double velocityMPerSec) {
			this.posM = posM;
			this.velocityMPerSec = velocityMPerSec;
			
			autoDSL = new AutoDSL«IDHasher.GetStringHash(auto.id)»();
		}
		
		public void toggleACC(){
			IO.in_GamepadX = !IO.in_GamepadX;
		}
		    
		public void step(double dTimeSec) {
			IO.out_Acceleration = 0.0;
			IO.in_CurrentSpeed = this.velocityMPerSec;
			
			double accel = 0.0;
			if(autoDSL.isInEntryState()){
				accel = IO.in_GamepadThrottle;
				autoDSL.Run();
			}else{
				autoDSL.Run();
				accel = IO.out_Acceleration;
			}
		    
			if (velocityMPerSec == 0 && accel == 0) {
				return;
			}
		        
			double dVel = (accel - (f0 + f1 * velocityMPerSec + f2 * velocityMPerSec * velocityMPerSec) / massKg) * dTimeSec;
			double xDot = velocityMPerSec * dTimeSec;
			
			
			
			final double MAX_VEL = 250 / 3.6;
			double newVel = this.velocityMPerSec + dVel;
			
			if(newVel < 0)
				newVel = 0;
			else if(newVel > MAX_VEL)
				newVel = MAX_VEL;
			
			this.velocityMPerSec = newVel;
			this.posM += xDot;
		}
		    
		public double getPositionM() {
			return posM;
		}
		
		
		public double getVelocity() {
			return velocityMPerSec;
		}
		
	}
	'''
}