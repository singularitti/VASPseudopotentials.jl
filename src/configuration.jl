using AnonymousEnums: @anonymousenum

export AzimuthalQuantumNumber, Subshell, count_valence_electrons

@anonymousenum AzimuthalQuantumNumber::UInt8 s p d f g h i
"""
    AzimuthalQuantumNumber

An enum representing the azimuthal quantum number (l), which defines the shape of an
atomic orbital.

# Examples
```jldoctest
julia> instances(AzimuthalQuantumNumber)
(:s, :g, :h, :i, :d, :f, :p)

julia> AzimuthalQuantumNumber(:s)
s::AzimuthalQuantumNumber = 0x00
```
"""
AzimuthalQuantumNumber

"""
    Subshell(principal, azimuthal, occupation)

Represents an atomic subshell, defined by its principal quantum number, azimuthal
quantum number, and electron occupation.

# Arguments
- `principal::Int8`: the principal quantum number (``n``).
- `azimuthal::AzimuthalQuantumNumber`: the azimuthal quantum number (``l``), e.g., `s`, `p`.
- `occupation::Float64`: the number of electrons occupying the subshell.

# Examples
```jldoctest
julia> Subshell(3, AzimuthalQuantumNumber(:d), 5.0)
3d^{5.0}
```
"""
struct Subshell
    principal::Int8
    azimuthal::AzimuthalQuantumNumber
    occupation::Float64
end

"""
    count_valence_electrons(config)

Calculate the total number of valence electrons from an electronic configuration.

# Examples
```jldoctest
julia> config = [Subshell(4, AzimuthalQuantumNumber(:s), 2.0), Subshell(3, AzimuthalQuantumNumber(:d), 10.0)];

julia> count_valence_electrons(config)
12.0
```
"""
count_valence_electrons(config) = sum(s.occupation for s in config)
"""
    count_valence_electrons(subshell::Subshell)

Calculate the total number of valence electrons from a `Subshell`.

# Examples
```jldoctest
julia> subshell = Subshell(4, AzimuthalQuantumNumber(:s), 2.0);

julia> count_valence_electrons(subshell)
2.0
```
"""
count_valence_electrons(subshell::Subshell) = subshell.occupation
count_valence_electrons(::Missing) = missing

Base.:*(a::Subshell, b::Subshell) = [a, b]
Base.:*(a::Subshell, b::AbstractVector) = [a; b]
Base.:*(a::AbstractVector, b::Subshell) = [a; b]
Base.:*(a::AbstractVector{Subshell}, b::AbstractVector{Subshell}) = [a; b]

Base.show(io::IO, s::Subshell) = print(io, "$(s.principal)$(s.azimuthal)^{$(s.occupation)}")
Base.show(io::IO, ::MIME"text/plain", c::AbstractVector{Subshell}) = print(io, join(c, " "))
