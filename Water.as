class Water
{
	//profiling
	static var iter_Ts:Number = 0;
	static var iter_P:Number  = 0;
	static var iter_h:Number  = 0;
	static var iter_hsv:Number = 0;
	static var iter_hsl:Number = 0;
	static var iter_r:Number = 0;
	static var iter_rol:Number = 0;
	static var iter_rov:Number = 0;
	static var iter_roPh:Number = 0;
	static var iter_find_ro:Number = 0;
	static var iter_find_T:Number = 0;
	
	//Pressure    P, kPa
	//Temperature T, Celsius
	//Density 	  ro, kg/m3
	//Enthalpy 	  h, kJ/kg
	public function Ts(Ps:Number):Number
	{
		Water.iter_Ts++;
		
		var beta    = Math.pow(Ps * 0.001, 0.25);
		var beta_sq = Math.pow(beta, 2);
		var E =        beta_sq + nsA[2]*beta + nsA[5];
		var F = nsA[0]*beta_sq + nsA[3]*beta + nsA[6];
		var G = nsA[1]*beta_sq + nsA[4]*beta + nsA[7];
		var D = 2*G/(-F - Math.sqrt(F*F - 4*E*G));
		var Ts = (nsA[9] + D - Math.sqrt(Math.pow(nsA[9] + D, 2) - 4*(nsA[8] + nsA[9]*D)))/2;
		return Ts - 273.15;
	}
	
	public function P(_ro:Number, _T:Number):Number
	{
		Water.iter_P++;
		
		var d = _ro/roc;
		var t = Tc/(_T + 273.15);
		return _ro*R*(273.15 + _T)*(1 + d*fird(d, t));
	}
	
	public function h(ro:Number, T:Number):Number
	{
		Water.iter_h++;	

		var d = ro/roc;
		var t = Tc/(T + 273.15);
		return R*(T + 273.15)*(1 + t*(fot(d, t) + firt(d, t)) + d*fird(d, t));
	}
	
	//enthalpy of saturated vapor
	public function hsv(_Ps:Number):Number
	{
		Water.iter_hsv++;
		
		var _Ts = Ts(_Ps);
		return h(rov(_Ps, _Ts), _Ts);
	}
	
	public function hsl(_Ps:Number):Number
	{
		Water.iter_hsl++;
		
		var _Ts = Ts(_Ps);
		return h(rol(_Ps, _Ts), _Ts);
	}
	
	public function r(_Ps:Number):Number
	{
		Water.iter_r++;
		
		return hsv(_Ps) - hsl(_Ps);
	}
					 
	//density of vapor
	public function rov(_P:Number, _T:Number):Number
	{
		Water.iter_rov++;
		
		return find_ro(_P, _T, 0, 0.01);
	}
	
	//density of liquid
	public function rol(_P:Number, _T:Number):Number
	{
		Water.iter_rol++;
		
		return find_ro(_P, _T, 1100, -10);
	}
	
	public function roPh(_P:Number, _h:Number):Number
	{
		Water.iter_roPh++;
		
		//надо будет добавить поддержку в области газа
		var hl = hsl(_P);
		var hv = hsv(_P);
		var _Ts = Ts(_P);
		var ro_v = rov(_P, _Ts);
		var ro_l = rol(_P, _Ts);
		
		//in case of wet steam
		if(_h < hv && _h > hl && _P < Pc)
		{
			this.lastT = _Ts;
			return 1/((_h - hl)/(hv - hl) * (1/ro_v - 1/ro_l) + 1/ro_l);
		}
		
		var ra, rb;
		if(_P >= Pc)
		{
			ra = 0;
			rb = 1200;
		}
		else
			if(_h > hv) //steam
			{
				ra = 0;
				rb = ro_v;
			}
			else //liquid
			{
				ra = ro_l;
				rb = 1200;
			}
			
		var rm, hm;
		/*while(Math.abs(rb - ra) > 0.001)
		{
			rm = (ra + rb)/2;
			this.lastT = find_T(_P, rm, _Ts);
			hm = h(rm, this.lastT);
			if(hm < _h)
				rb = rm;
			else
				ra = rm;
		}*/
		do {
			rm = (ra + rb)/2;
			this.lastT = find_T(_P, rm, _Ts);
			hm = h(rm, this.lastT);
			if(hm < _h)
				rb = rm;
			else
				ra = rm;
		} while(Math.abs(hm - _h) > 0.1);
		return rm;
	}
	
	public function getLastT():Number
	{
		return this.lastT;
	}

//-----------------------------------------------------------------------------
//additional internal functions
//-----------------------------------------------------------------------------
	private function find_ro(_P:Number, _T:Number, _ro0:Number, _dro:Number)
	{
		Water.iter_find_ro++;
		
		var ro0 = _ro0;
		var ro1 = ro0 + _dro;
		var f0  = P(ro0, _T) - _P;
		var f1, ro2;
		
		do
		{
			f1  = P(ro1, _T) - _P;
			ro2 = ro1 - (ro1 - ro0)*f1/(f1 - f0);
			ro0 = ro1;
			f0  = f1;
			ro1 = ro2;
		} while(Math.abs(ro1 - ro0) > 0.0001);
		return ro2;
	}
	
	private function find_T(_P:Number, _ro:Number, Tmin:Number)
	{
		Water.iter_find_T++;
		
		var T0 = Tmin;
		var T1 = T0 + 1;
		var T, P0, P1;
		P0 = P(_ro, T0);
		while(Math.abs(T0 - T1) > 0.1) {
			P1 = P(_ro, T1);
			T = T0 + (_P - P0)/(P1 - P0)*(T1 - T0);
			P0 = P1;
			T0 = T1;
			T1 = T;
		}
		return T0;
	}
	
//-----------------------------------------------------------------------------
//internal stuff
//-----------------------------------------------------------------------------
	static private var nsA:Array = new Array(
		0.11670521452767e+4,
		-0.72421316703206e+6,
		-0.17073846940092e+2,
		0.12020824702470e+5,
		-0.32325550322333e+7,
		0.14915108613530e+2,
		-0.48232657361591e+4,
		0.40511340542057e+6,
		-0.23855557567849,
		0.65017534844798e+3);
	
	static private var Tc:Number  = 647.096;
	static private var Pc:Number  = 2.206e+4;
	static private var roc:Number = 322;
	static private var R:Number   = 0.46151805;
	static public  var Cp:Number  = 4.18;
	
	private var lastT:Number;
	
	static private var nIGA:Array = new Array(
		-8.32044648201,
		6.6832105268,
		3.00632,
		0.012436,
		0.97315,
		1.27950,
		0.96956,
		0.24873);
	
	static private var gammaA:Array = new Array(
		0,
		0,
		0,
		1.28728967,
		3.53734222,
		7.74073708,
		9.24437796,
		27.5075105);
	
	static private var nA:Array = new Array(
		//0 - 9
		0.12533547935523e-1,
		0.78957634722828e+1,
		-0.87803203303561e+1,
		0.31802509345418,
		-0.26145533859358,
		-0.78199751687981e-2,
		0.88089493102134e-2,
		-0.66856572307965,
		0.20433810950965,
		-0.66212605039687e-4,
		
		//10 - 19
		-0.19232721156002,
		-0.25709043003438,
		0.16074868486251,
		-0.40092828925807e-1,
		0.39343422603254e-6,
		-0.75941377088144e-5,
		0.56250979351888e-3,
		-0.15608652257135e-4,
		0.11537996422951e-8,
		0.36582165144204e-6,
		
		//20 - 29
		-0.13251180074668e-11,
		-0.62639586912454e-9,
		-0.10793600908932,
		0.17611491008752e-1,
		0.22132295167546,
		-0.40247669763528,
		0.58083399985759,
		0.49969146990806e-2,
		-0.31358700712549e-1,
		-0.74315929710341,
		
		//30 - 39
		0.47807329915480,
		0.20527940895948e-1,
		-0.13636435110343,
		0.14180634400617e-1,
		0.83326504880713e-2,
		-0.29052336009585e-1,
		0.38615085574206e-1,
		-0.20393486513704e-1,
		-0.16554050063734e-2,
		0.19955571979541e-2,
		
		//40 - 49
		0.15870308324157e-3,
		-0.16388568342530e-4,
		0.43613615723811e-1,
		0.34994005463765e-1,
		-0.76788197844621e-1,
		0.22446277332006e-1,
		-0.62689710414685e-4,
		-0.55711118565645e-9,
		-0.19905718354408,
		0.31777497330738,
		
		//50 - 55
		-0.11841182425981,
		-0.31306260323435e2,
		0.31546140237781e2,
		-0.25213154341695e4,
		-0.14874640856724,
		0.31806110878444);	
	
	static private var cA:Array = new Array(
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		2,
		3,
		3,
		3,
		3,
		4,
		6,
		6,
		6,
		6,
		0,
		0,
		0,
		3.5,
		3.5);
	
	static private var dA:Array = new Array(
		1,
		1,
		1,
		2,
		2,
		3,
		4,
		1,
		1,
		1,
		2,
		2,
		3,
		4,
		4,
		5,
		7,
		9,
		10,
		11,
		13,
		15,
		1,
		2,
		2,
		2,
		3,
		4,
		4,
		4,
		5,
		6,
		6,
		7,
		9,
		9,
		9,
		9,
		9,
		10,
		10,
		12,
		3,
		4,
		4,
		5,
		14,
		3,
		6,
		6,
		6,
		3,
		3,
		3,
		0.85,
		0.95);
	
	static private var tA:Array = new Array(
		-0.5,
		0.875,
		1,
		0.5,
		0.75,
		0.375,
		1,
		4,
		6,
		12,
		1,
		5,
		4,
		2,
		13,
		9,
		3,
		4,
		11,
		4,
		13,
		1,
		7,
		1,
		9,
		10,
		10,
		3,
		7,
		10,
		10,
		6,
		10,
		10,
		1,
		2,
		3,
		4,
		8,
		6,
		9,
		8,
		16,
		22,
		23,
		23,
		10,
		50,
		44,
		46,
		50,
		0,
		1,
		4,
		0.2,
		0.2);											

	//internal functions
	private function fird(d:Number, t:Number):Number
	{
		var A:Number = 0;
		for(var i = 0; i <= 6; i++)
			A += nA[i]*dA[i]*Math.pow(d, dA[i]-1)*Math.pow(t, tA[i]);
		for(var i = 7; i <= 50; i++)
			A += nA[i]*Math.exp(-Math.pow(d, cA[i]))*(Math.pow(d, dA[i]-1)*Math.pow(t, tA[i])*(dA[i] - cA[i]*Math.pow(d,cA[i])));
		return A;
	}
	
	private function fot(d:Number, t:Number):Number
	{
		var A = nIGA[1] + nIGA[2]/t;
		for(var i = 3; i <= 7; i++)
			A += nIGA[i]*gammaA[i]*(Math.pow(1 - Math.exp(-gammaA[i]*t), -1) - 1);
		return A;
	}
	
	private function firt(d:Number, t:Number):Number
	{
		var A = 0;
		for(var i = 0; i <= 6; i++)
			A += nA[i]*tA[i]*Math.pow(d, dA[i])*Math.pow(t, tA[i]-1);
		for(var i = 7; i <= 50; i++)
			A += nA[i]*tA[i]*Math.pow(d, dA[i])*Math.pow(t, tA[i]-1)*Math.exp(-Math.pow(d, cA[i]));
		return A;
	}
}