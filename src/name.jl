export PBE, LDA, GW, Hard, Soft, PotentialName

const Maybe{T} = Union{T,Nothing}

abstract type ExchangeCorrelation end
abstract type LocalDensityApproximation <: ExchangeCorrelation end
abstract type GeneralizedGradientApproximation <: ExchangeCorrelation end
struct PerdewBurkeErnzerhof <: GeneralizedGradientApproximation end
const LDA = LocalDensityApproximation
const PBE = PerdewBurkeErnzerhof

struct NumberOfElectrons
    value::Float64
end

abstract type Method end
struct GreenFunction <: Method end
const GW = GreenFunction

abstract type Pseudization end
struct AllElectron <: Pseudization end
const AE = AllElectron

abstract type ValenceStates end
struct SemicoreP <: ValenceStates end
struct SemicoreD <: ValenceStates end
struct SemicorePS <: ValenceStates end
struct Lanthanides{N} <: ValenceStates end
Lanthanides(N::Integer) = Lanthanides{N}()

abstract type Rigidity end
struct Hard <: Rigidity end
struct Soft <: Rigidity end

abstract type Generation end
struct New <: Generation end
struct Old <: Generation end

"""
    PotentialName(element, num_electrons, pseudization, valence_states, rigidity, method, generation)

A composite type that represents a VASP pseudopotential by combining its constituent parts.

The fields correspond to different components of the potential's name, such as the element,
valence electron count, and method-specific suffixes. Unspecified components can be `nothing`.

# Examples
```jldoctest
julia> PotentialName(:Si, nothing, nothing, nothing, nothing, nothing, nothing)
Si

julia> PotentialName(:Ti, nothing, nothing, nothing, Soft(), nothing, New())
Ti_sv_new
```
"""
struct PotentialName
    "the chemical symbol of the element (e.g., `:H`, `:Si`)"
    element::Symbol
    "the number of valence electrons"
    num_electrons::Maybe{NumberOfElectrons}
    "the pseudization scheme (e.g., `AE()`)"
    pseudization::Maybe{Pseudization}
    "specification of semicore or f-electron states"
    valence_states::Maybe{ValenceStates}
    "the hardness or softness of the potential (e.g., `Hard()`)"
    rigidity::Maybe{Rigidity}
    "the calculation method (e.g., `GW()`)"
    method::Maybe{Method}
    "the generation of the potential (e.g., `New()`)"
    generation::Maybe{Generation}
end

Base.show(io::IO, x::NumberOfElectrons) =
    print(io, x.value < 1 ? string(x.value)[2:end] : x.value)  # Ignore the leading `0` for small numbers
Base.show(io::IO, ::Method) = print(io, "")
Base.show(io::IO, ::GreenFunction) = print(io, "_GW")
Base.show(io::IO, ::Pseudization) = print(io, "")
Base.show(io::IO, ::AllElectron) = print(io, "_AE")
Base.show(io::IO, ::ValenceStates) = print(io, "")
Base.show(io::IO, ::SemicoreP) = print(io, "_pv")
Base.show(io::IO, ::SemicoreD) = print(io, "_d")
Base.show(io::IO, ::SemicorePS) = print(io, "_sv")
Base.show(io::IO, ::Lanthanides{N}) where {N} = print(io, "_$N")
Base.show(io::IO, ::Hard) = print(io, "_h")
Base.show(io::IO, ::Soft) = print(io, "_s")
Base.show(io::IO, ::New) = print(io, "_new")
Base.show(io::IO, ::Old) = print(io, "")
function Base.show(io::IO, item::PotentialName)
    for field in fieldnames(typeof(item))
        if getfield(item, field) !== nothing
            print(io, getfield(item, field))
        end
    end
    return nothing
end
