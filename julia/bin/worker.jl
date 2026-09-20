#!/usr/bin/env julia
using NeuraBash
using LinearAlgebra
const JS=NeuraBash.JULSyntax
const CO=NeuraBash.CoreOps

function decode_text(x)
    x isa Vector{UInt8}&&return String(x)
    x isa String&&return x
    throw(ArgumentError("expected ByteStream, Bytes, or Text"))
end

function matrix_read(x,args)
    text=decode_text(x); format="auto"; header=false
    for a in args
        if startswith(a,"--format="); format=split(a,"=";limit=2)[2]
        elseif a=="--header"||a=="--header=true"; header=true
        elseif a=="--header=false"; header=false
        else throw(ArgumentError("matrix.read: unknown option $a")) end
    end
    lines=[String(l) for l in split(replace(text,"\r\n"=>"\n","\r"=>"\n"),'\n';keepempty=false) if !isempty(strip(l))]
    isempty(lines)&&throw(ArgumentError("matrix.read: empty input"))
    if format=="auto"
        comma=occursin(',',lines[1]); tab=occursin('\t',lines[1])
        comma&&tab&&throw(JS.JULParseError("matrix.read: ambiguous delimiter"))
        format=comma ? "csv" : tab ? "tsv" : "whitespace"
    end
    format in ("csv","tsv","whitespace")||throw(ArgumentError("matrix.read: unsupported format $format"))
    header&&(lines=lines[2:end]); isempty(lines)&&throw(ArgumentError("matrix.read: no data rows"))
    delim=format=="csv" ? ',' : format=="tsv" ? '\t' : nothing
    rows=Vector{Vector{Float64}}(); ncols=0
    for line in lines
        cells=delim===nothing ? split(strip(line)) : split(line,delim;keepempty=true)
        vals=try Float64[parse(Float64,strip(c)) for c in cells] catch; throw(JS.JULParseError("matrix.read: non-numeric cell")) end
        ncols==0&&(ncols=length(vals)); length(vals)==ncols||throw(JS.JULParseError("matrix.read: ragged input")); push!(rows,vals)
    end
    A=Matrix{Float64}(undef,length(rows),ncols)
    for i in eachindex(rows),j in 1:ncols; A[i,j]=rows[i][j] end
    A
end

function render_value(x)::String
    x===nothing&&return ""
    x isa Bool&&return x ? "true\n" : "false\n"
    (x isa Number||x isa AbstractString||x isa Symbol)&&return string(x,'\n')
    x isa AbstractVector&&return isempty(x) ? "" : join(string.(x),"\n")*"\n"
    if x isa AbstractMatrix
        rows=[join(string.(x[i,:]),'\t') for i in axes(x,1)]
        return isempty(rows) ? "" : join(rows,"\n")*"\n"
    end
    throw(ArgumentError("no canonical MVP renderer for $(typeof(x))"))
end

function execute_stage(value,stage::String)
    toks=JS.tokenize_stage(stage); op=toks[1]; args=toks[2:end]
    if op=="matrix.read"; return matrix_read(value,args),nothing
    elseif op=="matrix.rank"; value isa AbstractMatrix||throw(ArgumentError("matrix.rank expects Matrix")); return LinearAlgebra.rank(value),nothing
    elseif op=="matrix.shape"; value isa AbstractArray||throw(ArgumentError("matrix.shape expects array")); return collect(size(value)),nothing
    elseif op=="matrix.transpose"; value isa AbstractMatrix||throw(ArgumentError("matrix.transpose expects Matrix")); return Matrix(transpose(value)),nothing
    elseif op=="vector.abs"; value isa AbstractVector||throw(ArgumentError("vector.abs expects Vector")); return abs.(value),nothing
    elseif op=="vector.sum"; value isa AbstractVector||throw(ArgumentError("vector.sum expects Vector")); return sum(value),nothing
    elseif op=="vector.max"; value isa AbstractVector||throw(ArgumentError("vector.max expects Vector")); isempty(value)&&throw(ArgumentError("vector.max: empty vector")); return maximum(value),nothing
    elseif op=="vector.min"; value isa AbstractVector||throw(ArgumentError("vector.min expects Vector")); isempty(value)&&throw(ArgumentError("vector.min: empty vector")); return minimum(value),nothing
    elseif op=="text.decode"; return decode_text(value),nothing
    elseif op=="text.lines"
        value isa String||throw(ArgumentError("text.lines expects Text")); lines=String.(split(replace(value,"\r\n"=>"\n","\r"=>"\n"),'\n';keepempty=true)); !isempty(lines)&&isempty(lines[end])&&pop!(lines); return lines,nothing
    elseif op=="core.type"; return string(typeof(value)),nothing
    elseif op=="math.eval"; isempty(args)&&throw(ArgumentError("math.eval requires expression")); return CO.math_eval(join(args," ")),nothing
    elseif op=="check.equal"; length(args)==1||throw(ArgumentError("check.equal requires expected value")); return value==JS.parse_scalar(args[1]),nothing
    elseif op=="check.approximate"
        expected=JS.parse_scalar(args[1]); atol=0.0; rtol=1e-8
        for a in args[2:end]
            startswith(a,"--atol=")&&(atol=parse(Float64,split(a,"=";limit=2)[2]))
            startswith(a,"--rtol=")&&(rtol=parse(Float64,split(a,"=";limit=2)[2]))
        end
        return CO.check_approximate(value,expected;atol=atol,rtol=rtol),nothing
    elseif op=="shell.require"; value isa Bool||throw(ArgumentError("shell.require expects Bool")); return value,value ? 0 : 1
    elseif op=="render.text"||op=="render.pretty"; return render_value(value),:already_rendered
    end
    sym=Symbol(op); reg=CO.core_ops_registry(); haskey(reg,sym)||throw(ArgumentError("unknown JUL operation: $op"))
    CO.invoke_core(sym,value,JS.parse_scalar.(args)...),nothing
end

function main(args)::Int
    root=false; source=nothing; i=1
    while i<=length(args)
        if args[i]=="--root"; root=true
        elseif args[i]=="--source"; i==length(args)&&throw(ArgumentError("--source requires value")); i+=1; source=args[i]
        else throw(ArgumentError("unknown worker option $(args[i])")) end
        i+=1
    end
    source===nothing&&throw(ArgumentError("missing --source"))
    value=root ? nothing : read(stdin); status=0; already=false; stages=JS.split_pipeline(source)
    for (idx,stage) in enumerate(stages)
        value,special=execute_stage(value,stage)
        if special isa Int; idx==length(stages)||throw(JS.JULParseError("shell.require must be final")); status=special
        elseif special===:already_rendered; idx==length(stages)||throw(JS.JULParseError("render must be final")); already=true end
    end
    print(stdout,already ? String(value) : render_value(value)); flush(stdout); status
end

try
    exit(main(ARGS))
catch e
    if e isa JS.JULParseError||e isa CO.MathParseError; println(stderr,sprint(showerror,e)); exit(64)
    elseif e isa ArgumentError||e isa MethodError; println(stderr,"ArgumentError: ",sprint(showerror,e)); exit(64)
    elseif e isa DomainError; println(stderr,"MathDomainError: ",sprint(showerror,e)); exit(65)
    else; println(stderr,"JuliaError: ",sprint(showerror,e)); exit(70) end
end
