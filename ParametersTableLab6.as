﻿class ParametersTableLab6 {
	public static var subvariantsNum = 10;
	private static var variants:Array = new Array(
		new Array(
			{B:758, p1:312.0, t1:20, b:1.000, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.838, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.789, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.729, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.668, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.608, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.547, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.487, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.426, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.366, D:0.00095},
			{B:758, p1:312.0, t1:20, b:0.305, D:0.00095}
		),
		new Array(
			{B:758, p1:296.0, t1:20, b:1.000, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.909, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.824, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.765, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.684, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.611, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.545, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.472, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.398, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.332, D:0.0008},
			{B:758, p1:296.0, t1:20, b:0.244, D:0.0008}
		)
	);
	// Не очень здорово, т.к. нарушается однообразность, в других лабораторных
	// нет вложенных массивов.
	public static function getSubvariant(variant:Array, sv:Number):Object {
		if(sv < 0 || sv >= subvariantsNum) 
			return null;
		return variant[sv];
	}
	public static function getVariant():Object {
		return variants[Utils.randRange(0, variants.length - 1)];
	}
}
