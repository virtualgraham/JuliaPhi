abstract type Orderable end

function Base.:(<)(a::Orderable, b::Orderable) 
    if !general_eq(a, b, get_unorderable_unless_eq(a))
        error("Unorderable: the following attrs must be equal: $(a.unorderable_unless_eq)")
    end
    return order_by(a) < order_by(b)
end

function general_eq(a, b, attributes)
    for attr in attributes
        a_has = hasproperty(a, attr)
        b_has = hasproperty(b, attr)

        if !a_has && !b_has
            continue
        end

        if !a_has && b_has || a_has && !b_has
            return false
        end

        _a = getproperty(a, attr)
        _b = getproperty(b, attr)

        if attr in (:phi, :alpha)
            if !approxeq(_a, _b)     
                return false
            end
        elseif attr in (:mechanism, :purview)
            if _a === nothing || _b === nothing
                if _a != _b
                    return false
                end
            elseif (_a...) != (_b...)
                return false
            end
        else if a != b
            return false
        end
    end

    return true
end