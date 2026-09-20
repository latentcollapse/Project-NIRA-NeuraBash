using Test
using NeuraBash
const M=NeuraBash.CoreOps
@testset "math.eval" begin
 @test M.math_eval("2 + 3 * 4")==14
 @test M.math_eval("(2 + 3) * 4")==20
 @test M.math_eval("2^3^2")==512
 @test M.math_eval("-2^2")==-4
 @test M.math_eval("(-2)^2")==4
 @test M.math_eval("2^-2")==0.25
 @test M.math_eval("-5 % 3")==1
 @test M.math_eval("5 % -3")==-1
 @test M.math_eval("9223372036854775807 + 1")==big"9223372036854775808"
 @test M.math_eval("sqrt(-1)")==0.0+1.0im
 @test isinf(M.math_eval("1/0"))
 @test isnan(M.math_eval("0/0"))
 @test_throws DomainError M.math_eval("1%0")
 @test_throws M.MathParseError M.math_eval("1 < 2 < 3")
 @test_throws M.MathParseError M.math_eval("x+1")
end
