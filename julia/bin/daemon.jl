#!/usr/bin/env julia
using Sockets
using NeuraBash
const EX=NeuraBash.MVPExec
const sessions=Dict{String,EX.SessionContext}(); const session_lock=ReentrantLock()
u32be(x::UInt32)=UInt8[(x>>24)&0xff,(x>>16)&0xff,(x>>8)&0xff,x&0xff]
u64be(x::UInt64)=UInt8[(x>>s)&0xff for s in 56:-8:0]
read_exact(io,n)=begin b=read(io,n); length(b)==n||throw(EOFError()); b end
read_u32(io)=foldl((a,x)->(a<<8)|UInt32(x),read_exact(io,4);init=UInt32(0))
read_u64(io)=foldl((a,x)->(a<<8)|UInt64(x),read_exact(io,8);init=UInt64(0))
function response(io,status,out,err)
 write(io,codeunits("NBR1")); write(io,u32be(UInt32(status))); write(io,u64be(UInt64(length(out)))); write(io,u64be(UInt64(length(err)))); write(io,out); write(io,err); flush(io)
end
function handle(sock)
 try
  read_exact(sock,4)==Vector{UInt8}(codeunits("NBP1"))||error("bad protocol magic")
  sidlen=Int(read_u32(sock)); flags=read_u32(sock); srclen=Int(read_u64(sock)); inlen=Int(read_u64(sock))
  sid=String(read_exact(sock,sidlen)); src=String(read_exact(sock,srclen)); input=Vector{UInt8}(read_exact(sock,inlen)); root=(flags&UInt32(1))!=0
  ctx=lock(session_lock) do; get!(sessions,sid) do; EX.SessionContext(); end; end
  try
   out,status=EX.execute_segment(ctx,src,input,root); response(sock,status,out,UInt8[])
  catch e
   cls=e isa NeuraBash.JULSyntax.JULParseError||e isa NeuraBash.CoreOps.MathParseError ? "ParseError" : e isa DomainError ? "MathDomainError" : e isa ArgumentError ? "ArgumentError" : "JuliaError"
   code=cls=="MathDomainError" ? 65 : cls=="JuliaError" ? 70 : 64
   response(sock,code,UInt8[],Vector{UInt8}(codeunits("$cls: $(sprint(showerror,e))\n")))
  end
 catch e
  try response(sock,70,UInt8[],Vector{UInt8}(codeunits("DaemonError: $(sprint(showerror,e))\n"))) catch end
 finally
  close(sock)
 end
end
function main(args)
 length(args)==2&&args[1]=="--socket"||error("usage: daemon.jl --socket PATH"); path=args[2]; ispath(path)&&rm(path;force=true); mkpath(dirname(path))
 server=listen(path); chmod(path,0o600)
 while true; sock=accept(server); @async handle(sock) end
end
main(ARGS)
