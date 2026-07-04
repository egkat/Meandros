local Constants = require(script.Parent.Parent.Data.Constants)
return function(...)

    local hsv = table.pack(...)

    local hueDecimal = hsv[1]
    local saturationDecimal = hsv[2]
    local valueDecimal = hsv[3]

    local hueDegree = `{math.round(hueDecimal * 360)}{Constants.DEGREE_SYMBOL}`
    local saturationPercentage = `{math.round(saturationDecimal * 100)}%`
    local valuePercentage = `{math.round(valueDecimal * 100)}%`

    return `({hueDegree}, {saturationPercentage}, {valuePercentage})`

end
