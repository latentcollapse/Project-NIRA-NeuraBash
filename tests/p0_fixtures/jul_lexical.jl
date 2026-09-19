using Test
using NeuraBash
const J=NeuraBash.JULSyntax
@testset "JUL lexical" begin
 @test J.split_pipeline("matrix.read |!> matrix.rank")==["matrix.read","matrix.rank"]
 @test J.split_pipeline("math.eval \"1 |!> 2\" |!> core.type")==["math.eval \"1 |!> 2\"","core.type"]
 @test J.split_pipeline("tool.define x @{ a |!> b } |!> core.type")==["tool.define x @{ a |!> b }","core.type"]
 @test J.tokenize_stage("math.eval \"2 + 2\"")==["math.eval","2 + 2"]
 @test J.tokenize_stage("check.equal '$HOME *.jl'")==["check.equal","$HOME *.jl"]
 @test J.tokenize_stage("matrix.rank # ignored")==["matrix.rank"]
 @test J.parse_scalar("true")===true
 @test J.parse_scalar("null")===nothing
 @test J.parse_scalar("9223372036854775808")==big"9223372036854775808"
 @test_throws J.JULParseError J.split_pipeline("matrix.read |!>")
 @test_throws J.JULParseError J.tokenize_stage("math.eval \"unterminated")
end
