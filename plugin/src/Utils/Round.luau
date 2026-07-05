return function(value: number, decimalPlaces: number)

    local multiplier = math.pow(10, decimalPlaces or 0)
    return math.round(value * multiplier) / multiplier

end
