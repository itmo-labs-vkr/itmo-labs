class ParametersTableLab3 {
	private static var variants:Array = new Array(
		{B:756, p1:19.6, h1:2834.5, p2:0.784, G:0.00682, tw1:14.0, tw2:25.5, Gw:0.3413},
		{B:756, p1:19.6, h1:2830.1, p2:0.784, G:0.00681, tw1:12.8, tw2:17.9, Gw:0.3407},
		{B:756, p1:19.6, h1:2856.9, p2:0.784, G:0.00681, tw1:14.1, tw2:37.8, Gw:0.3407}
	);
	public static function getVariant():Object {
		return variants[Utils.randRange(0, variants.length - 1)];
	}
}
