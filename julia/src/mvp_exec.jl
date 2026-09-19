module MVPExec
using LinearAlgebra
using ..CoreOps
using ..JULSyntax
export SessionContext, execute_segment

mutable struct ToolDef
    body::String
    revision::Int
end
mutable struct SessionContext
    bindings::Dict{String,Any}
    tools::Dict{String,ToolDef}
end
SessionContext()=SessionContext(Dict{String,Any}(),Dict{String,ToolDef}())

decode_text(x)=x isa Vector{UInt8} ? String(x) : x isa String ? x : throw(ArgumentError("expected ByteStream, Bytes, or Text"))

function matrix_read(x,args)
 text=decode_text(x); format="auto"; header=false
 for a in args
  startswith(a,"--format=") ? (format=split(a,"=";limit=2)[2]) :
  a in ("--header","--header=true") ? (header=true) :
  a=="--header=false" ? (header=false) : throw(ArgumentError("matrix.read: unknown option $a"))
 end
 lines=[String(l) for l in split(replace(text,"\r\n"=>"\n","\r"=>"\n"),'\n';keepempty=false) if !isempty(strip(l))]
 isempty(lines)&&throw(ArgumentError("matrix.read: empty input"))
 if format=="auto"
  comma=occursin(',',lines[1]); tab=occursin('\t',lines[1]); comma&&tab&&throw(JULParseError("matrix.read: ambiguous delimiter"))
  format=comma ? "csv" : tab ? "tsv" : "whitespace"
 end
 header&&(lines=lines[2:end]); isempty(lines)&&throw(ArgumentError("matrix.read: no data rows"))
 delim=format=="csv" ? ',' : format=="tsv" ? '\t' : nothing
 rows=Vector{Vector{Float64}}(); ncols=0
 for line in lines
  cells=delim===nothing ? split(strip(line)) : split(line,delim;keepempty=true)
  vals=try Float64[parse(Float64,strip(c)) for c in cells] catch; throw(JULParseError("matrix.read: non-numeric cell")) end
  ncols==0&&(ncols=length(vals)); length(vals)==ncols||throw(JULParseError("matrix.read: ragged input")); push!(rows,vals)
 end
 A=Matrix{Float64}(undef,length(rows),ncols)
 for i in eachindex(rows),j in 1:ncols; A[i,j]=rows[i][j] end
 A
end

function render_value(x)::String
 x===nothing&&return ""; x isa Bool&&return x ? "true\n" : "false\n"
 (x isa Number||x isa AbstractString||x isa Symbol)&&return string(x,'\n')
 x isa AbstractVector&&return isempty(x) ? "" : join(string.(x),"\n")*"\n"
 if x isa AbstractMatrix
  rows=[join(string.(x[i,:]),'\t') for i in axes(x,1)]; return isempty(rows) ? "" : join(rows,"\n")*"\n"
 end
 throw(ArgumentError("no canonical MVP renderer for $(typeof(x))"))
end

function _tool_define!(ctx,stage)
 m=match(r"^tool\.define\s+([A-Za-z_][A-Za-z0-9_-]*)\s+@\{(.*)\}\s*$"s,stage); m===nothing&&return nothing
 name=m.captures[1]; body=strip(m.captures[2]); isempty(body)&&throw(JULParseError("tool.define: empty block"))
 rev=haskey(ctx.tools,name) ? ctx.tools[name].revision+1 : 1; ctx.tools[name]=ToolDef(body,rev)
 "defined $name revision=$rev status=UNTESTED"
end

function execute_stage(ctx,value,stage)
 msg=_tool_define!(ctx,stage); msg!==nothing&&return msg,nothing
 toks=tokenize_stage(stage); op=toks[1]; args=toks[2:end]
 if startswith(op,"@")&&length(toks)==1
  name=op[2:end]; haskey(ctx.bindings,name)||throw(ArgumentError("UnknownBindingError: @$name")); return ctx.bindings[name],nothing
 elseif op=="core.bind"
  length(args)==1||throw(ArgumentError("core.bind requires NAME")); name=replace(args[1],r"^@"=>"")
  haskey(ctx.bindings,name)&&throw(ArgumentError("binding $name already exists")); ctx.bindings[name]=value; return value,nothing
 elseif op=="core.drop"
  length(args)==1||throw(ArgumentError("core.drop requires NAME")); name=replace(args[1],r"^@"=>"")
  haskey(ctx.bindings,name)||throw(ArgumentError("UnknownBindingError: @$name")); delete!(ctx.bindings,name); return true,nothing
 elseif op=="matrix.read"; return matrix_read(value,args),nothing
 elseif op=="matrix.rank"; value isa AbstractMatrix||throw(ArgumentError("matrix.rank expects Matrix")); return rank(value),nothing
 elseif op=="matrix.shape"; value isa AbstractArray||throw(ArgumentError("matrix.shape expects array")); return collect(size(value)),nothing
 elseif op=="matrix.transpose"; value isa AbstractMatrix||throw(ArgumentError("matrix.transpose expects Matrix")); return Matrix(transpose(value)),nothing
 elseif op=="matrix.eig"
  value isa AbstractMatrix||throw(ArgumentError("matrix.eig expects Matrix")); ev=eigen(value); vals=ComplexF64.(ev.values)
  order=sortperm(eachindex(vals);by=i->(real(vals[i]),imag(vals[i]))); vals=vals[order]
  "--values-only" in args&&return vals,nothing
  return Dict("values"=>vals,"vectors"=>ComplexF64.(ev.vectors[:,order])),nothing
 elseif op=="vector.abs"; value isa AbstractVector||throw(ArgumentError("vector.abs expects Vector")); return abs.(value),nothing
 elseif op=="vector.sum"; return sum(value),nothing
 elseif op=="vector.max"; return maximum(value),nothing
 elseif op=="vector.min"; return minimum(value),nothing
 elseif op=="text.decode"; return decode_text(value),nothing
 elseif op=="text.lines"
  value isa String||throw(ArgumentError("text.lines expects Text")); ls=String.(split(replace(value,"\r\n"=>"\n","\r"=>"\n"),'\n';keepempty=true)); !isempty(ls)&&isempty(ls[end])&&pop!(ls); return ls,nothing
 elseif op=="core.type"; return string(typeof(value)),nothing
 elseif op=="math.eval"; return math_eval(join(args," ")),nothing
 elseif op=="check.equal"; return value==parse_scalar(args[1]),nothing
 elseif op=="check.approximate"
  expected=parse_scalar(args[1]); atol=0.0; rtol=1e-8
  for a in args[2:end]; startswith(a,"--atol=")&&(atol=parse(Float64,split(a,"=";limit=2)[2])); startswith(a,"--rtol=")&&(rtol=parse(Float64,split(a,"=";limit=2)[2])) end
  return check_approximate(value,expected;atol=atol,rtol=rtol),nothing
 elseif op=="shell.require"; value isa Bool||throw(ArgumentError("shell.require expects Bool")); return value,value ? 0 : 1
 elseif op=="render.text"||op=="render.pretty"; return render_value(value),:already_rendered
 elseif haskey(ctx.tools,op); isempty(args)||throw(ArgumentError("MVP custom tools do not yet accept parameters")); return run_pipeline(ctx,ctx.tools[op].body,value)
 end
 throw(ArgumentError("unknown JUL operation: $op"))
end

function run_pipeline(ctx,source,input)
 value=input; status=0; special=nothing; stages=split_pipeline(source)
 for (idx,stage) in enumerate(stages)
  value,special=execute_stage(ctx,value,stage)
  if special isa Int; idx==length(stages)||throw(JULParseError("shell.require must be final")); status=special
  elseif special===:already_rendered; idx==length(stages)||throw(JULParseError("render must be final")) end
 end
 value,status
end

function execute_segment(ctx,source::String,input::Vector{UInt8},root::Bool)
 value,status=run_pipeline(ctx,source,root ? nothing : input)
 Vector{UInt8}(codeunits(render_value(value))),status
end
end
