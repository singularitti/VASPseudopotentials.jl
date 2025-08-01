const FLOAT_REGEX = r"((?:[0-9]*[.])?[0-9]+)?"
const HEAD_REGEX = r"([a-zA-Z]+)" * FLOAT_REGEX

struct ParseError <: Exception
    msg::String
end

function Base.tryparse(::Type{PotentialName}, str::AbstractString)
    head_match = match(HEAD_REGEX, str)
    if head_match === nothing
        return nothing
    end
    element = Symbol(head_match[1])
    num_str = head_match[2]
    num_electrons = num_str === nothing ? nothing : Base.parse(Float64, num_str)
    hard_soft = if occursin("_h", str)
        Hard()
    elseif occursin("_s", str)
        Soft()
    else
        nothing
    end
    lanthanide_match = match(r"_([23])\b", str)
    valence_states = if occursin("_sv", str)
        SemicorePS()
    elseif occursin("_pv", str)
        SemicoreP()
    elseif occursin("_d", str)
        SemicoreD()
    elseif lanthanide_match !== nothing
        # Match lanthanide suffixes like _2 or _3, ensuring they are whole suffixes
        Lanthanides{parse(Int64, lanthanide_match[1])}()
    else
        nothing
    end
    pseudization = occursin("_AE", str) ? AE() : nothing
    method = occursin("_GW", str) ? GW() : nothing
    new_old = occursin("_new", str) ? New() : nothing
    return PotentialName(
        element, method, pseudization, valence_states, num_electrons, hard_soft, new_old
    )
end

function Base.parse(::Type{PotentialName}, str::AbstractString)
    result = tryparse(PotentialName, str)
    if result === nothing
        throw(ParseError("could not parse potential name: \"$str\"!"))
    end
    return result
end

# See https://github.com/JuliaLang/julia/blob/3903fa5/base/missing.jl#L18-L19
Base.showerror(io::IO, ex::ParseError) = print(io, "ParseError: ", ex.msg, '!')
