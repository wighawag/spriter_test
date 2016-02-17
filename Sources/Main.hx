package;

import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		System.init({
			title: "spriter_test",
			width: 800,
			height: 600,
			samplesPerPixel: 1
			}, initialized);
	}
	
	private static function initialized(): Void {
		var game = new Test();
	}
}