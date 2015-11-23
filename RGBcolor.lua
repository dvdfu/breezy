local RGBColor = {}

local function lerp(a, b, x)
    if x > 1 then x = 1 end
    if x < 0 then x = 0 end
    return a + (b-a) * x
end

function RGBColor.new(r, g, b)
    return {
        r = r,
        g = g,
        b = b
    }
end

function RGBColor.blend(colorA, colorB, mix)
    return {
        r = lerp(colorA.r, colorB.r, mix),
        g = lerp(colorA.g, colorB.g, mix),
        b = lerp(colorA.b, colorB.b, mix)
    }
end

function RGBColor.get(color)
    return color.r, color.g, color.b
end

return RGBColor
