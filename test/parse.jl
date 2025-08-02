using CSV: CSV
using DataFrames: DataFrame

files = abspath.(readdir(joinpath(@__DIR__, "../data"); join=true))

@testset "Test parsing potential name" begin
    for file in files
        df = CSV.read(file, DataFrame)
        parsed = string.(parse.(PotentialName, df[:, "Potential name"]))
        bench = df[:, "Potential name"]
        @test_skip isempty(symdiff(parsed, bench))  # Does not work for VASP <= 5.2
    end
end
