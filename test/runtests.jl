using Test
using DispatchSolvers

@testset "DispatchSolvers" begin
    @test isapprox(solve(RootFindingProblem((x) -> x^2 - 2), Bisection((0, 2))), 1.414213; atol=1e-6)
    @test_throws MethodError solve(RootFindingProblem((x) -> x^2 - 2), nothing)

    @test isapprox(solve(RootFindingProblem((x) -> x^2 - 2), NewtonRaphson(1, x -> 2x)), 1.414213; atol=1e-6)
    @test solve(RootFindingProblem((x) -> x^2 - 2), NewtonRaphson(1, x -> 2x)) == sqrt(2)
end
