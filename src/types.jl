export PBE, LDA, GW, Hard, Soft, PotentialName

const Maybe{T} = Union{T,Nothing}

abstract type ExchangeCorrelation end
abstract type LocalDensityApproximation <: ExchangeCorrelation end
abstract type GeneralizedGradientApproximation <: ExchangeCorrelation end
struct PerdewBurkeErnzerhof <: GeneralizedGradientApproximation end
const LDA = LocalDensityApproximation
const PBE = PerdewBurkeErnzerhof

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

abstract type HardSoft end
struct Hard <: HardSoft end
struct Soft <: HardSoft end

abstract type NewOld end
struct New <: NewOld end
struct Old <: NewOld end

struct PotentialName
    element::Symbol
    num_electrons::Maybe{Float64}
    pseudization::Maybe{Pseudization}
    valence_states::Maybe{ValenceStates}
    hard_soft::Maybe{HardSoft}
    method::Maybe{Method}
    new_old::Maybe{NewOld}
end

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
