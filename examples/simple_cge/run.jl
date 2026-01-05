# SimpleCGE minimal runner.

using JCGECore
using JCGEKernel
using JCGELibrary
using JCGELibrary.SimpleCGE

spec = SimpleCGE.model()
ctx = JCGEKernel.KernelContext()

for block in spec.model.blocks
    JCGECore.build!(block, ctx, spec)
end

println("Built SimpleCGE with variables: ", length(ctx.variables), " equations: ", length(ctx.equations))
