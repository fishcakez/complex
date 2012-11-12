-record(complex,
	{
		real = 0 :: float() | integer(),
		imag = 0 :: float() | integer()
	}).

-type complex() :: #complex{}.

-define(IS_COMPLEX(Term), is_record(Term, complex)).