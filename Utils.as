class Utils {
	public static function randRange(min:Number, max:Number):Number {
    	return Math.floor(Math.random() * (max - min + 1)) + min;
	}
	
	/* lower and upper deviations are in percents */
	public static function randVariation(val:Number, ldev:Number, udev:Number):Number {
		var rdev = (udev + ldev) * Math.random() - ldev; /* random deviation in percents */
		return val * (1 + rdev * 0.01);
	}
	
	public static function relPressureToAbsolute(rel:Number, B:Number):Number {
		return rel + B/750*100;
	}
	public static function absPressureToRelative(abs:Number, B:Number):Number {
		return abs - B/750*100;
	}
}