#Complex Number Library

##Use

Works for both real and imaginary calculations with the same API as the OTP math
module. Also includes `'+'/2`, `'-'/2`, `'*'/2`, `'/'/2`, `abs/1`, `round/1` and
`trunc/1`.

The record `#complex{}` is stable and can be abused by using the following code:
``` erlang
-include_lib("complex/include/complex.hrl").
```
`complex.hrl` also includes a macro for use in guards:
``` erlang
my_func(Term) when ?IS_COMPLEX(Term) ->
	Term.
```
##TODO

* Add tests (currently NO TESTS!)
* Add `erf/1`, `erfc/1`