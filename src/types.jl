export PBE, LDA, GW, Hard, Soft

const Maybe{T} = Union{T,Nothing}

abstract type ExchangeCorrelation end
abstract type LocalDensityApproximation <: ExchangeCorrelation end
abstract type GeneralizedGradientApproximation <: ExchangeCorrelation end
struct PerdewBurkeErnzerhof <: GeneralizedGradientApproximation end
const LDA = LocalDensityApproximation
const PBE = PerdewBurkeErnzerhof

abstract type Method end
struct Standard <: Method end
struct GreenFunction <: Method end
const GW = GreenFunction

abstract type Pseudization end
abstract type AllElectron <: Pseudization end
abstract type ProjectorAugmentedWaves <: AllElectron end
const AE = AllElectron
const PAW = ProjectorAugmentedWaves

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
    method::Maybe{Method}
    pseudization::Maybe{Pseudization}
    valence_states::Maybe{ValenceStates}
    hard_soft::Maybe{HardSoft}
    new_old::Maybe{NewOld}
end

suffix(::Standard) = ""
suffix(::GreenFunction) = "_GW"
suffix(::AllElectron) = "_AE"
suffix(::SemicoreP) = "_pv"
suffix(::SemicoreD) = "_d"
suffix(::SemicorePS) = "_sv"
suffix(::Lanthanides{N}) where {N} = "_$N"
suffix(::Hard) = "_h"
suffix(::Soft) = "_s"
suffix(::New) = "_new"
suffix(::Old) = ""

Base.show(io::IO, item::PotentialName) = print(
    io,
    item.element,
    suffix(item.pseudization),
    suffix(item.valence_states),
    suffix(item.hard_soft),
    suffix(item.method),
    suffix(item.new_old),
)
