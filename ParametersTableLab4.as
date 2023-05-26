class ParametersTableLab4 {
	private static var variants:Array = new Array(
		{B:756, p1:15.68, t1:103.9, t2:208.7, G:0.000146, W:148, Wl:0.221},
		{B:756, p1:31.4,  t1:100,   t2:196.8, G:0.000142, W:128, Wl:0.168},
		{B:756, p1:35.3,  t1:103.1, t2:217.9, G:0.000146, W:156, Wl:0.255}
	);
	public static function getVariant():Object {
		return variants[Utils.randRange(0, variants.length - 1)];
	}
}