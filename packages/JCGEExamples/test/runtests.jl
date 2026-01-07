using Test
using JCGEExamples
using JCGEExamples.StandardCGE
using JCGEExamples.SimpleCGE
using JCGEExamples.LargeCountryCGE
using JCGEExamples.TwoCountryCGE
using JCGEExamples.MonopolyCGE
using JCGEExamples.QuotaCGE
using JCGEExamples.ScaleEconomyCGE
using JCGEExamples.DynCGE
using JCGEExamples.CamCGE
using JCGEExamples.CamMCP
using JCGEKernel
using JCGEBlocks
using JuMP
using Ipopt
import MathOptInterface as MOI

@testset "JCGEExamples" begin
    sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
    spec = StandardCGE.model(sam_path=sam_path)
    @test spec.name == "StandardCGE"

    lrg_sam = joinpath(LargeCountryCGE.datadir(), "sam_2_2.csv")
    lrg_spec = LargeCountryCGE.model(sam_path=lrg_sam)
    @test lrg_spec.name == "LargeCountryCGE"

    two_spec = TwoCountryCGE.model()
    @test two_spec.name == "TwoCountryCGE"

    mon_sam = joinpath(MonopolyCGE.datadir(), "sam_2_2.csv")
    mon_spec = MonopolyCGE.model(sam_path=mon_sam)
    @test mon_spec.name == "MonopolyCGE"

    quo_sam = joinpath(QuotaCGE.datadir(), "sam_2_2.csv")
    quo_spec = QuotaCGE.model(sam_path=quo_sam)
    @test quo_spec.name == "QuotaCGE"

    irs_sam = joinpath(ScaleEconomyCGE.datadir(), "sam_2_2.csv")
    irs_spec = ScaleEconomyCGE.model(sam_path=irs_sam)
    @test irs_spec.name == "ScaleEconomyCGE"

    dyn_spec = DynCGE.model()
    @test dyn_spec.name == "DynCGE"

    cam_spec = CamCGE.model()
    @test cam_spec.name == "CamCGE"

    cammcp_spec = CamMCP.model()
    @test cammcp_spec.name == "CamMCP"

end

if get(ENV, "JCGE_SOLVE_TESTS", "0") == "1"
    @testset "JCGEExamples.Solve" begin
        function max_constraint_residual(result)
            max_abs = 0.0
            for eq in result.context.equations
                payload = eq.payload
                if payload isa NamedTuple && haskey(payload, :constraint) && payload.constraint !== nothing
                    obj = JuMP.constraint_object(payload.constraint)
                    val = try
                        JuMP.value(obj.func)
                    catch
                        continue
                    end
                    r = val
                    if obj.set isa MOI.EqualTo
                        r = val - obj.set.value
                    elseif obj.set isa MOI.GreaterThan
                        r = min(0.0, val - obj.set.lower)
                    elseif obj.set isa MOI.LessThan
                        r = max(0.0, val - obj.set.upper)
                    end
                    max_abs = max(max_abs, abs(r))
                end
            end
            return max_abs
        end

        sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
        result = StandardCGE.solve(sam_path=sam_path; optimizer=Ipopt.Optimizer)
        status = MOI.get(result.context.model, MOI.TerminationStatus())
        @test status in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)

        result_simple = SimpleCGE.solve(; optimizer=Ipopt.Optimizer)
        status_simple = MOI.get(result_simple.context.model, MOI.TerminationStatus())
        @test status_simple in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)

        lrg_sam = joinpath(LargeCountryCGE.datadir(), "sam_2_2.csv")
        result_large = LargeCountryCGE.solve(sam_path=lrg_sam; optimizer=Ipopt.Optimizer)
        status_large = MOI.get(result_large.context.model, MOI.TerminationStatus())
        @test status_large in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)

        result_two = TwoCountryCGE.solve(; optimizer=Ipopt.Optimizer)
        status_two = MOI.get(result_two.context.model, MOI.TerminationStatus())
        @test status_two in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)

        mon_sam = joinpath(MonopolyCGE.datadir(), "sam_2_2.csv")
        result_mon = MonopolyCGE.solve(sam_path=mon_sam; optimizer=Ipopt.Optimizer)
        status_mon = MOI.get(result_mon.context.model, MOI.TerminationStatus())
        @test status_mon in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)

        quo_sam = joinpath(QuotaCGE.datadir(), "sam_2_2.csv")
        result_quo = QuotaCGE.solve(sam_path=quo_sam; optimizer=Ipopt.Optimizer)
        status_quo = MOI.get(result_quo.context.model, MOI.TerminationStatus())
        @test status_quo in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)

        irs_sam = joinpath(ScaleEconomyCGE.datadir(), "sam_2_2.csv")
        result_irs = ScaleEconomyCGE.solve(sam_path=irs_sam; optimizer=Ipopt.Optimizer)
        status_irs = MOI.get(result_irs.context.model, MOI.TerminationStatus())
        @test status_irs in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)

        result_dyn = DynCGE.solve(periods=1; optimizer=Ipopt.Optimizer)
        result_dyn = result_dyn[1]
        status_dyn = MOI.get(result_dyn.context.model, MOI.TerminationStatus())
        @test status_dyn in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)

        result_cam = CamCGE.solve(; optimizer=Ipopt.Optimizer)
        status_cam = MOI.get(result_cam.context.model, MOI.TerminationStatus())
        if status_cam in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED, MOI.FEASIBLE_POINT)
            @test true
        else
            @test max_constraint_residual(result_cam) <= 1e-5
        end

        cam_spec = CamCGE.model()
        sectors = cam_spec.model.sets.commodities
        labor = cam_spec.model.sets.factors

        function cam_val(sym::Symbol)
            return JuMP.value(result_cam.context.variables[sym])
        end

        for i in sectors
            x = cam_val(JCGEBlocks.global_var(:x, i))
            int = cam_val(JCGEBlocks.global_var(:int, i))
            cd = cam_val(JCGEBlocks.global_var(:cd, i))
            gd = cam_val(JCGEBlocks.global_var(:gd, i))
            id = cam_val(JCGEBlocks.global_var(:id, i))
            dst = cam_val(JCGEBlocks.global_var(:dst, i))
            @test isapprox(x, int + cd + gd + id + dst; atol=1e-5, rtol=1e-6)
        end

        gr = cam_val(:gr)
        tariff = cam_val(:tariff)
        duty = cam_val(:duty)
        indtax = cam_val(:indtax)
        @test isapprox(gr, tariff + duty + indtax; atol=1e-5, rtol=1e-6)

        govsav = cam_val(:govsav)
        total_gd = sum(cam_val(JCGEBlocks.global_var(:p, i)) * cam_val(JCGEBlocks.global_var(:gd, i)) for i in sectors)
        @test isapprox(gr, total_gd + govsav; atol=1e-5, rtol=1e-6)

        savings = cam_val(:savings)
        hhsav = cam_val(:hhsav)
        deprecia = cam_val(:deprecia)
        fsav = cam_val(:fsav)
        er = cam_val(:er)
        @test isapprox(savings, hhsav + govsav + deprecia + fsav * er; atol=1e-5, rtol=1e-6)

        for lc in labor
            lsum = sum(cam_val(JCGEBlocks.global_var(:l, i, lc)) for i in sectors)
            ls = cam_val(JCGEBlocks.global_var(:ls, lc))
            @test isapprox(lsum, ls; atol=1e-5, rtol=1e-6)
        end
    end
end

if get(ENV, "JCGE_MCP_SOLVE", "0") == "1"
    @testset "JCGEExamples.MCP" begin
        result_mcp = CamMCP.solve()
        @test result_mcp.summary.count >= 0
    end
end


if get(ENV, "JCGE_COMPARE_STANDARD", "0") == "1"
    @testset "JCGEExamples.Compare.StandardCGE" begin
        using Pkg
        Pkg.add("StandardCGE")
        import StandardCGE as StdCGE

        sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
        sam_table = StdCGE.load_sam_table(sam_path)
        std_model, _, _ = StdCGE.solve_model(sam_table; optimizer_attributes=Dict("print_level" => 0))
        std_obj = JuMP.objective_value(std_model)
        std_Xp = JuMP.value.(std_model[:Xp])

        spec = StandardCGE.model(sam_path=sam_path)
        result = JCGEKernel.run!(spec; optimizer=Ipopt.Optimizer, dataset_id="standard_cge_compare")
        ours_model = result.context.model
        ours_obj = JuMP.objective_value(ours_model)
        goods = spec.model.sets.commodities
        ours_Xp = [JuMP.value(result.context.variables[Symbol("Xp_", g)]) for g in goods]

        @test isfinite(std_obj)
        @test isfinite(ours_obj)
        @test isapprox.(ours_Xp, std_Xp; rtol=1e-5, atol=1e-6) |> all
    end
end
