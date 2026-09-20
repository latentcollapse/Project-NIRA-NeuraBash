module NeuraBash
__precompile__(true)
include("core_ops.jl")
include("jul_syntax.jl")
include("mvp_exec.jl")
using .CoreOps
using .JULSyntax
using .MVPExec
export CoreOps, JULSyntax, MVPExec
export core_ops_registry, invoke_core
end
