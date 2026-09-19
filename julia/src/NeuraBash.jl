module NeuraBash
__precompile__(true)
include("core_ops.jl")
include("jul_syntax.jl")
using .CoreOps
using .JULSyntax
export CoreOps, JULSyntax
export core_ops_registry, invoke_core
end
