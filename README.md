[![CI](https://github.com/bitorhugo/dispatch-solvers/actions/workflows/ci.yml/badge.svg)](https://github.com/bitorhugo/dispatch-solvers/actions/workflows/ci.yml)

# dispatch-solvers
Composing problem types with solver algorithms

## How dispatch picks a solver

`solve` is a single generic function that owns two methods:

```julia
solve(problem::RootFindingProblem, solver::Bisection)
solve(problem::RootFindingProblem, solver::NewtonRaphson)
```

When you call `solve(prob, NewtonRaphson(1.0, x -> 2x))`, Julia looks at the
runtime types of *all* arguments and runs the most specific method that matches.
If nothing matches, as in `solve(prob, nothing)`, you get a `MethodError`.
`NewtonRaphson` was added by writing a new method next to the old one, so the
`Bisection` code was never touched.

In Python you would write one `solve` function with an
`isinstance(solver, ...)` branch per solver, and every new solver means editing
that function. In Java you would put a `solve(problem)` method on each solver
class. That avoids the branch, but it only dispatches on the receiver (`solver`),
so choosing by the problem type as well needs extra machinery such as the
visitor pattern or overloads, which are resolved at compile time. Julia dispatches on every
argument at runtime, so adding a new problem type or a new solver is the same
move: write another method.

### Compared with Common Lisp (CLOS)

Julia's model comes most directly from CLOS. In both, methods belong to a
generic function rather than a class, and dispatch looks at every required
argument at runtime. The same solvers in Common Lisp:

```lisp
(defgeneric solve (problem solver))
(defmethod solve ((problem root-finding-problem) (solver bisection)) ...)
(defmethod solve ((problem root-finding-problem) (solver newton-raphson)) ...)
```

The differences:

- **Ambiguity.** CLOS orders applicable methods left to right by argument, so
  the first argument's specificity wins ties. Julia treats all arguments
  symmetrically, and if no single method is most specific it raises a
  `MethodError` for the ambiguity rather than picking one.
- **Method combination.** CLOS has `:before`, `:after` and `:around` methods
  and `call-next-method`. Julia has none of these; one method runs, and
  reusing a less specific one means calling it explicitly with `invoke`.
- **Types.** CLOS dispatches on classes, which can inherit slots, and on `eql`
  values. In Julia only concrete types have fields, abstract types like
  `Solver` exist only to group them, and dispatch also covers type
  parameters (`Vector{Float64}` vs `Vector{Int}`).
- **Performance.** Julia compiles a specialized version of each method for the
  concrete argument types it sees, so when types are known ahead of time, the
  dispatch is resolved during compilation and costs nothing at runtime. That is
  why numeric code can be written with dispatch everywhere.

## Tests

Run locally from the repo root:

```sh
julia --project=. -e 'using Pkg; Pkg.test()'
```
