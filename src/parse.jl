const FLOAT_REGEX = r"((?:[0-9]*[.])?[0-9]+)?"
const HEAD_REGEX = r"([a-zA-Z]+)" * FLOAT_REGEX

struct ParseError <: Exception
    msg::String
end

function Base.tryparse(::Type{PotentialName}, str::AbstractString)
    str = convert(String, str)  # In case it's not a `String` so `match` won't work
    head_match = match(HEAD_REGEX, str)
    if head_match === nothing
        return nothing
    end
    element = Symbol(head_match[1])
    num_str = head_match[2]
    num_electrons =
        num_str === nothing ? nothing : NumberOfElectrons(tryparse(Float64, num_str))
    rigidity = if occursin("_h", str)
        Hard()
    elseif occursin(r"_s(\b|_)", str)  # Not match `_sv`
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
        Lanthanides(parse(Int8, lanthanide_match[1]))
    else
        nothing
    end
    pseudization = occursin("_AE", str) ? AE() : nothing
    method = occursin("_GW", str) ? GW() : nothing
    generation = occursin("_new", str) ? New() : nothing
    return PotentialName(
        element, num_electrons, pseudization, valence_states, rigidity, method, generation
    )
end
function Base.tryparse(::Type{Subshell}, str::AbstractString)
    str = convert(String, str)  # In case it's not a `String` so `match` won't work
    matched = match(r"(\d+)([spdfghi])\^?{?" * FLOAT_REGEX * r"}?", str)
    if length(matched) != 3
        return nothing
    end
    principal = parse(Int8, matched[1])
    azimuthal = AzimuthalQuantumNumber(Symbol(matched[2]))
    occupation = matched[3] === nothing ? 1.0 : parse(Float64, matched[3])
    return Subshell(principal, azimuthal, occupation)
end

function Base.parse(::Type{T}, str::AbstractString) where {T<:Union{Subshell,PotentialName}}
    result = tryparse(T, str)
    if result === nothing
        throw(ParseError("could not parse type `$T` from \"$str\"!"))
    end
    return result
end

# See https://github.com/JuliaLang/julia/blob/3903fa5/base/missing.jl#L18-L19
Base.showerror(io::IO, ex::ParseError) = print(io, "ParseError: ", ex.msg, '!')
