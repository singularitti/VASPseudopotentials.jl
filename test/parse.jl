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

@testset "Test parsing valence electron configurations" begin
    for file in files
        df = CSV.read(file, DataFrame)
        parsed = map(eachrow(df)) do row
            value = row["Valence electron configuration"]
            if value === missing
                missing
            else
                mapreduce(
                    Base.Fix1(parse, Subshell),
                    *,
                    eachsplit(row["Valence electron configuration"]; keepempty=false);
                    init=Subshell[],
                )
            end
        end
        total = map(count_valence_electrons, parsed)
        bench = df[:, "Number of valence electrons"]
        indices = findall(!ismissing, total)
        @test total[indices] ≈ bench[indices] atol = 0.01
    end
end
