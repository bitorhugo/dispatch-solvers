module DispatchSolvers

export Problem, Solver, RootFindingProblem, Bisection, solve

abstract type Problem end

struct RootFindingProblem <: Problem
    f::Function
end

abstract type Solver end

struct Bisection <: Solver
    interval::Tuple{Float64, Float64}
end


function solve(problem::RootFindingProblem, solver::Bisection)
    a, b = solver.interval
    tolerance = 1e-8

    while (b - a) > tolerance
        m = (a + b) / 2
        if (problem.f(a) * problem.f(m)) < 0
            b = m
        else
            a = m
        end
    end
    return (a + b) / 2
end


end # DispatchSolvers
