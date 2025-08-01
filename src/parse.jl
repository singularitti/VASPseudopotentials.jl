const FLOAT_REGEX = r"((?:[0-9]*[.])?[0-9]+)"
const HEAD_REGEX = r"([a-zA-Z]+)" * FLOAT_REGEX

function _tryparse(::Type{PotentialName}, str::AbstractString)
    head_match = match(HEAD_REGEX, str)
    if head_match === nothing
        @error "Could not parse element from potential name: '$str'"
        return nothing
    end
    element = Symbol(head_match[1])
    num_str = head_match[2]
    num_electrons = isempty(num_str) ? nothing : Base.tryparse(Float64, num_str)
    hard_soft = if occursin("_h", str)
        Hard()
    elseif occursin("_s", str)
        Soft()
    else
        nothing
    end
    valence_states = if occursin("_sv", str)
        SemicorePS()
    elseif occursin("_pv", str)
        SemicoreP()
    elseif occursin("_d", str)
        SemicoreD()
    else
        # Match lanthanide suffixes like _2 or _3, ensuring they are whole suffixes
        lanthanide_match = match(r"_([23])\b", str)
        if lanthanide_match === nothing
            nothing
        else
            Lanthanides{parse(Int64, lanthanide_match[1])}()
        end
    end
    pseudization = occursin("_AE", str) ? AE() : nothing
    method = occursin("_GW", str) ? GW() : nothing
    new_old = occursin("_new", str) ? New() : nothing
    return PotentialName(
        element, method, pseudization, valence_states, num_electrons, hard_soft, new_old
    )
end
