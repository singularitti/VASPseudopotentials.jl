using AnonymousEnums: @anonymousenum

export AzimuthalQuantumNumber, ElectronConfiguration

@anonymousenum AzimuthalQuantumNumber::UInt8 s p d f g h i

struct ElectronConfiguration
    principal::Int8
    azimuthal::AzimuthalQuantumNumber
    occupation::Float64
end

const ValenceElectronConfiguration = AbstractVector{ElectronConfiguration}

Base.:*(a::ElectronConfiguration, b::ElectronConfiguration) = [a, b]
Base.:*(a::ElectronConfiguration, b::ValenceElectronConfiguration) = [a; b]
Base.:*(a::ValenceElectronConfiguration, b::ElectronConfiguration) = [a; b]
Base.:*(a::ValenceElectronConfiguration, b::ValenceElectronConfiguration) = [a; b]

Base.show(io::IO, e::ElectronConfiguration) =
    print(io, "$(e.principal)$(e.azimuthal)^{$(e.occupation)}")
Base.show(io::IO, ::MIME"text/plain", e::ValenceElectronConfiguration) =
    print(io, join(e, " "))
