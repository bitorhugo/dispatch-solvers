using Test
using DispatchSolvers

@testset "DispatchSolvers" begin
    @test isapprox(solve(RootFindingProblem((x) -> x^2 - 2), Bisection((0, 2))), 1.414213; atol=1e-6)
    @test_throws MethodError solve(RootFindingProblem((x) -> x^2 - 2), nothing)
end
