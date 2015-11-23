local HSVColor = {}

local function lerp(a, b, x)
    if x > 1 then x = 1 end
    if x < 0 then x = 0 end
    return a + (b-a) * x
end

function HSVColor.new(h, s, v)
    return {
        h = h,
        s = s,
        v = v
    }
end

function HSVColor.blend(colorA, colorB, mix)
    local hueA = {
        x = math.cos(colorA.h / 180 * math.pi),
        y = math.sin(colorA.h / 180 * math.pi)
    }
    local hueB = {
        x = math.cos(colorB.h / 180 * math.pi),
        y = math.sin(colorB.h / 180 * math.pi)
    }
    local hue = {
        x = hueA.x * (1-mix) + hueB.x * mix,
        y = hueA.y * (1-mix) + hueB.y * mix
    }
    return {
        h = (math.atan2(hue.y, hue.x) / math.pi * 180) % 360,
        s = lerp(colorA.s, colorB.s, mix),
        v = lerp(colorA.v, colorB.v, mix)
    }
end

function HSVColor.toRGB(color)
    local h, s, v = color.h, color.s, color.v
    local c = s*v
    local hp = h/60
    local x = c*(1-math.abs(hp%2-1))
    local rp, gp, bp = 0, 0, 0
    if hp < 1 then
        rp, gp, bp = c, x, 0
    elseif hp < 2 then
        rp, gp, bp = x, c, 0
    elseif hp < 3 then
        rp, gp, bp = 0, c, x
    elseif hp < 4 then
        rp, gp, bp = 0, x, c
    elseif hp < 5 then
        rp, gp, bp = x, 0, c
    elseif hp < 6 then
        rp, gp, bp = c, 0, x
    end
    local m = v-c
    return (rp+m)*255, (gp+m)*255, (bp+m)*255
end

return HSVColor
