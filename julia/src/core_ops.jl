module CoreOps

using LinearAlgebra
export core_ops_registry, invoke_core, register_core!
export core_type, text_split, text_join, bytes_length
export vector_abs, vector_sum, vector_max, vector_min, matrix_shape, matrix_rank
export check_equal, check_approximate, math_eval, MathParseError

const CORE_OPS = Dict{Symbol,Function}()
core_ops_registry() = CORE_OPS

register_core!(name::Symbol, f::Function) = (CORE_OPS[name]=f; f)
function invoke_core(name::Symbol,args...;kwargs...)
    f=get(CORE_OPS,name,nothing); f===nothing && throw(ArgumentError("unknown CORE operation: $name"))
    f(args...;kwargs...)
end

core_type(x)=string(typeof(x))
text_split(s::AbstractString,sep::AbstractString)=split(String(s),String(sep);keepempty=true)
text_join(xs::AbstractVector{<:AbstractString},sep::AbstractString)=join(xs,String(sep))
bytes_length(x::AbstractVector{UInt8})=length(x)
vector_abs(x::AbstractVector{<:Number})=abs.(x)
vector_sum(x::AbstractVector{<:Number})=sum(x)
vector_max(x::AbstractVector)=isempty(x) ? throw(ArgumentError("vector.max: empty vector")) : maximum(x)
vector_min(x::AbstractVector)=isempty(x) ? throw(ArgumentError("vector.min: empty vector")) : minimum(x)
matrix_shape(x::AbstractMatrix)=[size(x,1),size(x,2)]
matrix_rank(x::AbstractMatrix{<:Number};atol=nothing)=atol===nothing ? rank(x) : rank(x;atol=atol)
check_equal(a,b)=a==b
function check_approximate(a,b;atol::Real=0.0,rtol::Real=1e-8)
    if a isa AbstractArray || b isa AbstractArray
        (a isa AbstractArray && b isa AbstractArray) || return false
        size(a)==size(b) || return false
        return all(abs(x-y)<=atol+rtol*abs(y) for (x,y) in zip(a,b))
    end
    abs(a-b)<=atol+rtol*abs(b)
end

struct MathParseError <: Exception
    message::String
end
Base.showerror(io::IO,e::MathParseError)=print(io,"ParseError: ",e.message)
struct MathToken
    kind::Symbol
    text::String
end
mutable struct MathParser
    toks::Vector{MathToken}
    pos::Int
end

const MATH_FUNCS=Dict{String,Function}(
"abs"=>abs,"sqrt"=>sqrt,"cbrt"=>cbrt,"exp"=>exp,"log"=>log,"log2"=>log2,"log10"=>log10,
"sin"=>sin,"cos"=>cos,"tan"=>tan,"asin"=>asin,"acos"=>acos,"atan"=>atan,
"sinh"=>sinh,"cosh"=>cosh,"tanh"=>tanh,"floor"=>floor,"ceil"=>ceil,"round"=>round,
"min"=>min,"max"=>max,"sum"=>sum,"prod"=>prod)

function _math_tokens(s::String)
    toks=MathToken[]; i=firstindex(s)
    while i<=lastindex(s)
        c=s[i]
        if isspace(c); i=nextind(s,i); continue end
        if isdigit(c)||c=='.'
            j=i; seen_dot=c=='.'; seen_exp=false; j=nextind(s,j)
            while j<=lastindex(s)
                d=s[j]
                if isdigit(d); j=nextind(s,j)
                elseif d=='.'&&!seen_dot&&!seen_exp; seen_dot=true; j=nextind(s,j)
                elseif (d=='e'||d=='E')&&!seen_exp
                    seen_exp=true; j=nextind(s,j)
                    if j<=lastindex(s)&&(s[j]=='+'||s[j]=='-'); j=nextind(s,j) end
                else; break
                end
            end
            txt=String(SubString(s,i,prevind(s,j))); txt=="."&&throw(MathParseError("invalid numeric literal"))
            push!(toks,MathToken(:number,txt)); i=j; continue
        end
        if isletter(c)||c=='_'
            j=nextind(s,i)
            while j<=lastindex(s)&&(isletter(s[j])||isdigit(s[j])||s[j]=='_'); j=nextind(s,j) end
            push!(toks,MathToken(:ident,String(SubString(s,i,prevind(s,j))))); i=j; continue
        end
        j=nextind(s,i)
        if j<=lastindex(s)
            pair=string(c,s[j])
            if pair in ("==","!=","<=",">="); push!(toks,MathToken(:op,pair)); i=nextind(s,j); continue end
        end
        if c in ('+','-','*','/','%','^','(',')','[',']',',','<','>')
            k=c=='(' ? :lparen : c==')' ? :rparen : c=='[' ? :lbracket : c==']' ? :rbracket : c==',' ? :comma : :op
            push!(toks,MathToken(k,string(c))); i=nextind(s,i); continue
        end
        throw(MathParseError("unexpected character $(repr(c))"))
    end
    push!(toks,MathToken(:eof,"")); toks
end

peek(p::MathParser)=p.toks[p.pos]
take!(p::MathParser)=(t=p.toks[p.pos];p.pos+=1;t)
function accept!(p::MathParser,kind::Symbol,text::Union{Nothing,String}=nothing)
    t=peek(p)
    if t.kind==kind&&(text===nothing||t.text==text); p.pos+=1; return true end
    false
end
expect!(p::MathParser,k::Symbol,t::Union{Nothing,String}=nothing)=accept!(p,k,t)||throw(MathParseError("expected $(t===nothing ? k : t), got $(peek(p).text)"))
function _number(txt)
    if occursin('.',txt)||occursin('e',lowercase(txt)); return parse(Float64,txt) end
    b=parse(BigInt,txt); typemin(Int64)<=b<=typemax(Int64) ? Int64(b) : b
end
function _pow(a,b)
    if a isa Integer&&b isa Integer
        if b>=0
            z=big(a)^b; return typemin(Int64)<=z<=typemax(Int64) ? Int64(z) : z
        end
        return Float64(a)^Int(b)
    end
    a^b
end
function _primary(p)
    t=peek(p)
    if t.kind==:number; take!(p); return _number(t.text)
    elseif t.kind==:ident
        take!(p); name=t.text
        name=="pi"&&return Float64(pi); name=="e"&&return Float64(ℯ); name=="Inf"&&return Inf; name=="NaN"&&return NaN
        expect!(p,:lparen); args=Any[]
        if !accept!(p,:rparen)
            push!(args,_comparison(p)); while accept!(p,:comma); push!(args,_comparison(p)) end; expect!(p,:rparen)
        end
        f=get(MATH_FUNCS,name,nothing); f===nothing&&throw(MathParseError("unknown function $name")); isempty(args)&&throw(ArgumentError("$name requires argument"))
        if name=="sqrt"&&length(args)==1&&args[1] isa Real&&args[1]<0; return sqrt(complex(args[1]))
        elseif name=="log"&&length(args)==1&&args[1] isa Real&&args[1]<0; return log(complex(args[1])) end
        return f(args...)
    elseif accept!(p,:lparen); v=_comparison(p); expect!(p,:rparen); return v
    elseif accept!(p,:lbracket)
        vals=Any[]
        if !accept!(p,:rbracket); push!(vals,_comparison(p)); while accept!(p,:comma); push!(vals,_comparison(p)) end; expect!(p,:rbracket) end
        return vals
    end
    throw(MathParseError("expected primary, got $(t.text)"))
end
function _power(p); a=_primary(p); accept!(p,:op,"^") ? _pow(a,_unary(p)) : a end
function _unary(p); accept!(p,:op,"+")&&return +_unary(p); accept!(p,:op,"-")&&return -_unary(p); _power(p) end
function _product(p)
    v=_unary(p)
    while true
        if accept!(p,:op,"*"); v=v*_unary(p)
        elseif accept!(p,:op,"/"); v=v/_unary(p)
        elseif accept!(p,:op,"%"); r=_unary(p); r==0&&throw(DomainError(r,"modulo by zero")); v=mod(v,r)
        else return v end
    end
end
function _sum(p)
    v=_product(p)
    while true
        if accept!(p,:op,"+"); v=v+_product(p)
        elseif accept!(p,:op,"-"); v=v-_product(p)
        else return v end
    end
end
function _comparison(p)
    a=_sum(p); t=peek(p)
    if t.kind==:op&&t.text in ("==","!=","<","<=",">",">=")
        take!(p); b=_sum(p)
        peek(p).kind==:op&&peek(p).text in ("==","!=","<","<=",">",">=")&&throw(MathParseError("chained comparison is not allowed"))
        return t.text=="==" ? a==b : t.text=="!=" ? a!=b : t.text=="<" ? a<b : t.text=="<=" ? a<=b : t.text==">" ? a>b : a>=b
    end
    a
end
function math_eval(source::AbstractString)
    p=MathParser(_math_tokens(String(source)),1); v=_comparison(p); peek(p).kind==:eof||throw(MathParseError("unexpected token $(peek(p).text)")); v
end

function __init__()
    empty!(CORE_OPS)
    register_core!(Symbol("core.type"),core_type); register_core!(Symbol("text.split"),text_split); register_core!(Symbol("text.join"),text_join)
    register_core!(Symbol("bytes.length"),bytes_length); register_core!(Symbol("vector.abs"),vector_abs); register_core!(Symbol("vector.sum"),vector_sum)
    register_core!(Symbol("vector.max"),vector_max); register_core!(Symbol("vector.min"),vector_min); register_core!(Symbol("matrix.shape"),matrix_shape)
    register_core!(Symbol("matrix.rank"),matrix_rank); register_core!(Symbol("check.equal"),check_equal); register_core!(Symbol("check.approximate"),check_approximate)
    register_core!(Symbol("math.eval"),math_eval)
end
end
