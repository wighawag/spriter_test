package;

import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		System.init("spriter_test", 800, 600, initialized);
	}
	
	private static function initialized(): Void {
		var game = new Test();
	}
}