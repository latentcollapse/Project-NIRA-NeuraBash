module JULSyntax
export JULParseError, split_pipeline, tokenize_stage, parse_scalar

struct JULParseError <: Exception
    message::String
end
Base.showerror(io::IO, e::JULParseError) = print(io, "ParseError: ", e.message)

function split_pipeline(source::AbstractString)::Vector{String}
    s=String(source)
    isempty(strip(s)) && throw(JULParseError("empty JUL segment"))
    out=String[]; io=IOBuffer(); quote='\0'; escaped=false; comment=false
    paren=bracket=brace=0; i=firstindex(s)
    while i <= lastindex(s)
        c=s[i]
        if comment
            write(io,c); c=='\n' && (comment=false); i=nextind(s,i); continue
        end
        if quote!='\0'
            write(io,c)
            if escaped; escaped=false
            elseif c=='\\' && quote=='"'; escaped=true
            elseif c==quote; quote='\0'
            end
            i=nextind(s,i); continue
        end
        if c=='\'' || c=='"'; quote=c; write(io,c); i=nextind(s,i); continue
        elseif c=='#'; comment=true; write(io,c); i=nextind(s,i); continue
        elseif c=='('; paren+=1
        elseif c==')'; paren-=1; paren>=0 || throw(JULParseError("unmatched ')'"))
        elseif c=='['; bracket+=1
        elseif c==']'; bracket-=1; bracket>=0 || throw(JULParseError("unmatched ']'"))
        elseif c=='{'; brace+=1
        elseif c=='}'; brace-=1; brace>=0 || throw(JULParseError("unmatched '}'"))
        end
        if c=='|' && paren==0 && bracket==0 && brace==0
            j=nextind(s,i)
            if j<=lastindex(s) && s[j]=='!'
                k=nextind(s,j)
                if k<=lastindex(s) && s[k]=='>'
                    stage=strip(String(take!(io))); isempty(stage) && throw(JULParseError("empty JUL stage"))
                    push!(out,stage); i=nextind(s,k); continue
                end
            end
        end
        write(io,c); i=nextind(s,i)
    end
    quote=='\0' || throw(JULParseError("unterminated JUL string"))
    paren==0 || throw(JULParseError("unclosed parentheses"))
    bracket==0 || throw(JULParseError("unclosed list"))
    brace==0 || throw(JULParseError("unclosed map/block"))
    stage=strip(String(take!(io))); isempty(stage) && throw(JULParseError("empty JUL stage"))
    push!(out,stage); out
end

function tokenize_stage(stage::AbstractString)::Vector{String}
    s=String(stage); toks=String[]; io=IOBuffer(); quote='\0'; escaped=false; i=firstindex(s)
    flush_token!() = position(io)==0 ? nothing : push!(toks,String(take!(io)))
    while i<=lastindex(s)
        c=s[i]
        if quote!='\0'
            if escaped
                if c=='n'; write(io,'\n')
                elseif c=='r'; write(io,'\r')
                elseif c=='t'; write(io,'\t')
                elseif c=='\\' || c=='"' || c=='\''; write(io,c)
                else; throw(JULParseError("invalid escape \\$(c)"))
                end
                escaped=false
            elseif c=='\\' && quote=='"'; escaped=true
            elseif c==quote; quote='\0'
            else; write(io,c)
            end
        elseif c=='\'' || c=='"'; quote=c
        elseif isspace(c); flush_token!()
        elseif c=='#'; break
        else; write(io,c)
        end
        i=nextind(s,i)
    end
    quote=='\0' || throw(JULParseError("unterminated JUL string"))
    escaped && throw(JULParseError("dangling escape"))
    flush_token!(); isempty(toks) && throw(JULParseError("empty JUL stage")); toks
end

function parse_scalar(tok::AbstractString)
    s=String(tok)
    s=="true" && return true; s=="false" && return false; s=="null" && return nothing
    if occursin(r"^-?[0-9]+$",s)
        b=parse(BigInt,s); return typemin(Int64)<=b<=typemax(Int64) ? Int64(b) : b
    end
    if occursin(r"^-?(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+|[0-9]+(?:\.[0-9]*)?[eE][+-]?[0-9]+)$",s)
        return parse(Float64,s)
    end
    s
end
end
