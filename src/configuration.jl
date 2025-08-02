using AnonymousEnums: @anonymousenum

export AzimuthalQuantumNumber, Subshell, count_valence_electrons

@anonymousenum AzimuthalQuantumNumber::UInt8 s p d f g h i

struct Subshell
    principal::Int8
    azimuthal::AzimuthalQuantumNumber
    occupation::Float64
end

count_valence_electrons(config) = sum(s.occupation for s in config)
count_valence_electrons(subshell::Subshell) = subshell.occupation
count_valence_electrons(::Missing) = 0

Base.:*(a::Subshell, b::Subshell) = [a, b]
Base.:*(a::Subshell, b::AbstractVector) = [a; b]
Base.:*(a::AbstractVector, b::Subshell) = [a; b]
Base.:*(a::AbstractVector{Subshell}, b::AbstractVector{Subshell}) = [a; b]

Base.show(io::IO, s::Subshell) = print(io, "$(s.principal)$(s.azimuthal)^{$(s.occupation)}")
Base.show(io::IO, ::MIME"text/plain", c::AbstractVector{Subshell}) = print(io, join(c, " "))
