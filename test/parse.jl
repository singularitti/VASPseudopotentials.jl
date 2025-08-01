using CSV: CSV
using DataFrames: DataFrame

files = abspath.(readdir(joinpath(@__DIR__, "../data"); join=true))

@testset "Test parsing files" begin
    for file in files
        df = CSV.read(file, DataFrame)
        parsed = string.(parse.(PotentialName, df[:, "Potential name"]))
        bench = df[:, "Potential name"]
        @test isempty(symdiff(parsed, bench))
    end
end
