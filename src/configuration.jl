using AnonymousEnums: @anonymousenum

export AzimuthalQuantumNumber, Subshell

@anonymousenum AzimuthalQuantumNumber::UInt8 s p d f g h i

struct Subshell
    principal::Int8
    azimuthal::AzimuthalQuantumNumber
    occupation::Float64
end

const ValenceElectronConfiguration = AbstractVector{Subshell}

Base.:*(a::Subshell, b::Subshell) = [a, b]
Base.:*(a::Subshell, b::ValenceElectronConfiguration) = [a; b]
Base.:*(a::ValenceElectronConfiguration, b::Subshell) = [a; b]
Base.:*(a::ValenceElectronConfiguration, b::ValenceElectronConfiguration) = [a; b]

Base.show(io::IO, s::Subshell) = print(io, "$(s.principal)$(s.azimuthal)^{$(s.occupation)}")
Base.show(io::IO, ::MIME"text/plain", c::ValenceElectronConfiguration) =
    print(io, join(c, " "))
