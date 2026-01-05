# StandardCGE end-to-end runner (build + solve + diagnostics).

using JuMP
using Ipopt
using JCGEKernel
using JCGELibrary
using JCGELibrary.StandardCGE

sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
spec = StandardCGE.model(sam_path=sam_path)

result = JCGEKernel.run!(spec; optimizer=Ipopt.Optimizer, dataset_id="standard_cge")

println("Residual summary: ", result.summary)
