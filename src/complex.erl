-module(complex).

-compile({no_auto_import, [abs/1]}).

-include("include/complex.hrl").

-export_type([complex/0]).

%%% basic api

-export(
	[
		new/1,
		new/2,
		real/1,
		imag/1,
		conjugate/1,
		to_polar/1,
		from_polar/1
	]).

%%% erlang equivalent api

-export(
	[
		'+'/2,
		'-'/2,
		'/'/2,
		'*'/2,
		abs/1,
		trunc/1,
		round/1
	]).

%%% math equivalent api

-export(
	[
		pi/0,
		sin/1,
		cos/1,
		tan/1,
		asin/1,
		acos/1,
		atan/1,
		atan2/2,
		sinh/1,
		cosh/1,
		tanh/1,
		asinh/1,
		acosh/1,
		atanh/1,
		exp/1,
		log/1,
		log10/1,
		pow/2,
		sqrt/1
	]).

%%% basic api

-spec new(number()) -> complex().
new(Real) ->
	new(Real, 0).

-spec new(number(), number()) -> complex().
new(Real, Imag) when is_number(Real) andalso is_number(Imag) ->
	#complex{real=Real, imag=Imag}.

-spec real(complex()) -> number().
real(#complex{real=Real}) ->
	Real;
real(Real) when is_number(Real) ->
	Real.

-spec imag(complex()) -> number().
imag(#complex{imag=Imag}) ->
	Imag;
imag(Real) when is_number(Real) ->
	0.

-spec conjugate(complex()) -> complex();
		(number()) -> number().
conjugate(Complex = #complex{imag=Imag}) ->
	Complex#complex{imag=-Imag};
conjugate(Real) when is_number(Real) ->
	Real.

-spec to_polar(complex() | number()) -> {number(), number()}.
to_polar(Complex = #complex{real=Real, imag=Imag}) ->
	R = abs(Complex),
	Theta = math:atan2(Imag, Real),
	{R, Theta};
to_polar(Real) when is_number(Real) andalso Real >= 0 ->
	{Real, 0};
to_polar(Real) when is_number(Real) ->
	{-Real, math:pi()}.

-spec from_polar({number(), number()}) -> complex().
from_polar({R, Theta}) ->
	Real = R * math:cos(Theta),
	Imag = R * math:sin(Theta),
	#complex{real=Real, imag=Imag}.

%%% erlang equivalent api

-spec '+'(complex(), complex()) -> complex();
		(complex(), number()) -> complex();
		(number(), complex()) -> complex();
		(number(), number()) -> number().
'+'(#complex{real=RealA,imag=ImagA}, #complex{real=RealB,imag=ImagB}) ->
	Real = RealA + RealB,
	Imag = ImagA + ImagB,
	#complex{real=Real,imag=Imag};
'+'(#complex{real=RealA,imag=ImagA}, RealB) ->
	Real = RealA + RealB,
	#complex{real=Real, imag=ImagA};
'+'(RealA, #complex{real=RealB,imag=ImagB}) ->
	Real = RealA + RealB,
	#complex{real=Real, imag=ImagB};
'+'(RealA, RealB) ->
	RealA + RealB.

-spec '-'(complex(), complex()) -> complex();
		(complex(), number()) -> complex();
		(number(), complex()) -> complex();
		(number(), number()) -> number().
'-'(#complex{real=RealA,imag=ImagA}, #complex{real=RealB,imag=ImagB}) ->
	Real = RealA - RealB,
	Imag = ImagA - ImagB,
	#complex{real=Real,imag=Imag};
'-'(#complex{real=RealA,imag=ImagA}, RealB) ->
	Real = RealA - RealB,
	#complex{real=Real, imag=ImagA};
'-'(RealA, #complex{real=RealB,imag=ImagB}) ->
	Real = RealA - RealB,
	#complex{real=Real, imag=-ImagB};
'-'(RealA, RealB) ->
	RealA - RealB.

-spec '/'(complex(), complex()) -> complex();
		(complex(), number()) -> complex();
		(number(), complex()) -> complex();
		(number(), number()) -> float().
'/'(#complex{real=RealA,imag=ImagA}, #complex{real=RealB,imag=ImagB}) ->
	Denom = (RealB * RealB) + (ImagB * ImagB),
	Real = ((RealA * RealB) + (ImagA * ImagB)) / Denom,
	Imag = ((ImagA * RealB) + (RealA * -ImagB)) / Denom,
	#complex{real=Real,imag=Imag};
'/'(#complex{real=RealA,imag=ImagA}, RealB) ->
	Real = RealA / RealB,
	Imag = ImagA / RealB,
	#complex{real=Real, imag=Imag};
'/'(RealA, #complex{real=RealB,imag=ImagB}) ->
	Denom = (RealB * RealB) + (ImagB * ImagB),
	Real = (RealA * RealB) / Denom,
	Imag = (RealA * -ImagB) / Denom,
	#complex{real=Real, imag=Imag};
'/'(RealA, RealB) ->
	RealA / RealB.

-spec '*'(complex(), complex()) -> complex();
		(complex(), number()) -> complex();
		(number(), complex()) -> complex();
		(number(), number()) -> number().
'*'(#complex{real=RealA,imag=ImagA}, #complex{real=RealB,imag=ImagB}) ->
	Real = (RealA * RealB) - (ImagA * ImagB),
	Imag = (ImagA * RealB) + (RealA * ImagB),
	#complex{real=Real,imag=Imag};
'*'(#complex{real=RealA,imag=ImagA}, RealB) ->
	Real = RealA * RealB,
	Imag = ImagA * RealB,
	#complex{real=Real, imag=Imag};
'*'(RealA, #complex{real=RealB,imag=ImagB}) ->
	Real = RealA * RealB,
	Imag = RealA * ImagB,
	#complex{real=Real, imag=Imag};
'*'(RealA, RealB) ->
	RealA * RealB.

-spec abs(complex() | number()) -> number().
abs(#complex{real=Real, imag=Imag}) when Imag == 0 ->
	erlang:abs(Real);
abs(#complex{real=Real, imag=Imag}) when Real == 0 ->
	erlang:abs(Imag);
abs(#complex{real=Real, imag=Imag}) ->
	math:sqrt(Real*Real + Imag*Imag);
abs(Real) ->
	erlang:abs(Real).

-spec trunc(complex()) -> complex();
		(number()) -> integer().
trunc(#complex{real=Real,imag=Imag}) ->
	Real2 = erlang:trunc(Real),
	Imag2 = erlang:trunc(Imag),
	#complex{real=Real2, imag=Imag2};
trunc(Real) ->
	erlang:trunc(Real).

-spec round(complex()) -> complex();
		(number()) -> integer().
round(#complex{real=Real,imag=Imag}) ->
	Real2 = erlang:round(Real),
	Imag2 = erlang:round(Imag),
	#complex{real=Real2, imag=Imag2};
round(Real) ->
	erlang:round(Real).

%%% math equivalent api

-spec pi() -> float().
pi() ->
	math:pi().

-spec sin(complex()) -> complex();
		(number()) -> float().
sin(#complex{real=Real,imag=Imag}) ->
	Real2 = math:sin(Real) * math:cosh(Imag),
	Imag2 = math:cos(Real) * math:sinh(Imag),
	#complex{real=Real2,imag=Imag2};
sin(Real) ->
	math:sin(Real).

-spec cos(complex()) -> complex();
		(number()) -> float().
cos(#complex{real=Real,imag=Imag}) ->
	Real2 = math:cos(Real) * math:cosh(Imag),
	Imag2 = -math:sin(Real) * math:sinh(Imag),
	#complex{real=Real2,imag=Imag2};
cos(Real) ->
	math:cos(Real).

-spec tan(complex()) -> complex();
		(number()) -> float().
tan(#complex{real=Real,imag=Imag}) ->
	Real2 = Real * 2,
	Imag2 = Imag * 2,
	Denom = math:cos(Real2) + math:cosh(Imag2),
	Real3 = math:sin(Real2) / Denom,
	Imag3 = math:sinh(Imag2) / Denom,
	#complex{real=Real3,imag=Imag3};
tan(Real) ->
	math:tan(Real).

-spec asin(complex()) -> complex();
		(number()) -> float().
asin(#complex{real=Real,imag=Imag}) ->
	{A, B} = asin(Real, Imag),
	Real2 = math:asin(A),
	Imag2 = math:log(B + math:sqrt((B*B) - 1)),
	case Imag >= 0 of
		true ->
			#complex{real=Real2, imag=Imag2};
		false ->
			#complex{real=Real2, imag=-Imag2}
	end;
asin(Real) ->
	math:asin(Real).

-spec acos(complex()) -> complex();
		(number()) -> float().
acos(#complex{real=Real,imag=Imag}) ->
	{A, B} = asin(Real, Imag),
	Real2 = math:acos(A),
	Imag2 = math:log(B + math:sqrt((B*B) - 1)),
	case Imag >= 0 of
		true ->
			#complex{real=Real2, imag=-Imag2};
		false ->
			#complex{real=Real2, imag=Imag2}
	end;
acos(Real) ->
	math:acos(Real).

-spec atan(complex()) -> complex();
		(number()) -> float().
atan(#complex{real=Real,imag=Imag}) ->
	RealSquared = Real * Real,
	A = 2 * Real,
	B = 1 - RealSquared - (Imag*Imag),
	Real2 = 0.5 * math:atan2(A, B),
	C = RealSquared + ((Imag + 1) * (Imag + 1)),
	D = RealSquared + ((Imag - 1) * (Imag - 1)),
	Imag2 = 0.25 * math:log(C / D),
	#complex{real=Real2,imag=Imag2};
atan(Real) ->
	math:atan(Real).

-spec atan2(complex(), complex()) -> complex();
		(complex(), number()) -> complex();
		(number(), complex()) -> complex();
		(number(), number()) -> float().
atan2(RealA, RealB)
		when not ?IS_COMPLEX(RealA) andalso not ?IS_COMPLEX(RealB) ->
	atan2(RealA, RealB);
atan2(NumberA, NumberB) ->
	NumberASquared = '*'(NumberA, NumberA),
	NumberBSquared = '*'(NumberB, NumberB),
	case '+'(NumberASquared, NumberBSquared) of
		#complex{real=One,imag=Zero} when One == 1 andalso Zero == 0 ->
			Real = asin(NumberA),
			Imag = acos(NumberA),
			#complex{real=Real,imag=Imag};
		ComplexC ->
			NumberAi = '*'(#complex{imag=1}, NumberA),
			ComplexD = '+'(NumberAi,NumberB),
			ComplexE = sqrt(ComplexC),
			ComplexF = log('/'(ComplexD, ComplexE)),
			'*'(#complex{imag=-1}, ComplexF)
	end.

-spec sinh(complex()) -> complex();
		(number()) -> float().
sinh(#complex{real=Real,imag=Imag}) ->
	Real2 = math:sinh(Real) * math:cos(Imag),
	Imag2 = math:cosh(Real) * math:sin(Imag),
	#complex{real=Real2,imag=Imag2};
sinh(Real) ->
	math:sinh(Real).

-spec cosh(complex()) -> complex();
		(number()) -> float().
cosh(#complex{real=Real,imag=Imag}) ->
	Real2 = math:cosh(Real) * math:cos(Imag),
	Imag2 = math:sinh(Real) * math:sin(Imag),
	#complex{real=Real2,imag=Imag2};
cosh(Real) ->
	math:cosh(Real).

-spec tanh(complex()) -> complex();
		(number()) -> float().
tanh(#complex{real=Real,imag=Imag}) ->
	Real2 = Real * 2,
	Imag2 = Imag * 2,
	Denom = math:cosh(Real2) + math:cos(Imag2),
	Real3 = math:sinh(Real2) / Denom,
	Imag3 = math:sin(Imag2) / Denom,
	#complex{real=Real3,imag=Imag3};
tanh(Real) ->
	math:tanh(Real).

-spec asinh(complex()) -> complex();
		(number()) -> float().
asinh(Complex = #complex{}) ->
	Complex2 = '+'(1, '*'(Complex,Complex)),
	Complex3 = sqrt(Complex2),
	Complex4 = '+'(Complex, Complex3),
	log(Complex4);
asinh(Real) ->
	math:asinh(Real).

-spec acosh(complex()) -> complex();
		(number()) -> float().
acosh(#complex{real=Real,imag=Imag}) ->
	Imag2 = Imag / 2,
	Real2 = Real / 2,
	Complex3 = sqrt(#complex{real=(Real2+0.5),imag=Imag2}),
	Complex4 = sqrt(#complex{real=(Real2-0.5),imag=Imag2}),
	Complex5 = '+'(Complex3, Complex4),
	#complex{real=Real3,imag=Imag3} = log(Complex5),
	Real4 = Real3 * 2,
	Imag4 = Imag3 * 2,
	#complex{real=Real4,imag=Imag4};
acosh(Real) ->
	math:acosh(Real).

-spec atanh(complex()) -> complex();
		(number()) -> float().
atanh(#complex{real=Real,imag=Imag}) ->
	ComplexA = log(#complex{real=(1+Real),imag=Imag}),
	ComplexB = log(#complex{real=(1-Real),imag=-Imag}),
	ComplexC = '-'(ComplexA, ComplexB),
	'*'(0.5, ComplexC);
atanh(Real) ->
	math:atanh(Real).

-spec exp(complex()) -> complex();
		(number()) -> float().
exp(#complex{real=Real,imag=Imag}) ->
	Real2 = math:exp(Real) * math:cos(Imag),
	Imag2 = math:exp(Real) * math:sin(Imag),
	#complex{real=Real2, imag=Imag2};
exp(Real) ->
	math:exp(Real).

-spec log(complex()) -> complex();
		(number()) -> float().
log(Complex = #complex{}) ->
	{R, Imag} = to_polar(Complex),
	Real = math:log(R),
	#complex{real=Real, imag=Imag};
log(Real) ->
	math:log(Real).

-spec log10(complex()) -> complex();
		(number()) -> float().
log10(#complex{real=Real, imag=Imag}) ->
	Real2 = 0.5 * math:log10((Real*Real)+(Imag*Imag)),
	Imag2 = math:atan2(Imag, Real) / math:log(10),
	#complex{real=Real2, imag=Imag2};
log10(Real) ->
	math:log10(Real).

-spec pow(complex(), complex()) -> complex();
		(complex(), number()) -> complex();
		(number(), complex()) -> complex();
		(number(), number()) -> number().
pow(ComplexA = #complex{}, NumberB) ->
	{R, Theta} = to_polar(ComplexA),
	R2 = pow(R, NumberB),
	Theta2 = '*'(Theta, NumberB),
	Complex2 = '*'(#complex{imag=1}, Theta2),
	'*'(R2, exp(Complex2));
pow(RealA, #complex{real=RealB, imag=ImagB}) ->
	R = math:pow(RealA, RealB),
	Theta = math:log(RealA) * ImagB,
	from_polar({R, Theta});
pow(RealA, RealB) ->
	math:pow(RealA, RealB).

-spec sqrt(complex()) -> complex();
		(number()) -> float().
sqrt(#complex{real=Real, imag=Zero}) when Zero == 0 andalso Real < 0 ->
	Imag = math:sqrt(-Real),
	#complex{imag=Imag};
sqrt(#complex{real=Real, imag=Zero}) when Zero == 0 andalso Real >= 0 ->
	Real2 = math:sqrt(Real),
	#complex{real=Real2};
sqrt(Complex = #complex{real=Real, imag=Imag}) ->
	Abs =  abs(Complex),
	Real2 = math:sqrt((Real + Abs) / 2),
	Imag2 = math:sqrt((Abs - Real) / 2),
	case Imag > 0 of
		true ->
			#complex{real=Real2, imag=Imag2};
		false ->
			#complex{real=Real2, imag=-Imag2}
	end;
sqrt(Real) ->
	math:sqrt(Real).

%%% internal

asin(Real, Imag) ->
	A =  math:sqrt(((Real + 1) * (Real + 1)) + (Imag * Imag)),
	B =  math:sqrt(((Real - 1) * (Real - 1)) + (Imag * Imag)),
	{0.5 * (A - B), 0.5 * (A + B)}.