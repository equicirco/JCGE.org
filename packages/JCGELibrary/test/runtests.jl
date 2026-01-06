using Test
using JCGELibrary
using JCGELibrary.StandardCGE
using JCGELibrary.SimpleCGE
using JCGEKernel
using JuMP
using Ipopt

@testset "JCGELibrary" begin
    sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
    spec = StandardCGE.model(sam_path=sam_path)
    @test spec.name == "StandardCGE"
end

if get(ENV, "JCGE_SOLVE_TESTS", "0") == "1"
    @testset "JCGELibrary.Solve" begin
        sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
        spec = StandardCGE.model(sam_path=sam_path)
        result = JCGEKernel.run!(spec; optimizer=Ipopt.Optimizer, dataset_id="standard_cge_test")
        @test result.summary.count > 0

        spec_simple = SimpleCGE.model()
        result_simple = JCGEKernel.run!(spec_simple; optimizer=Ipopt.Optimizer, dataset_id="simple_cge_test")
        @test result_simple.summary.count > 0
    end
end
