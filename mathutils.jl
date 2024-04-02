"""
    @mph2kph(value)

Converts a speed from miles per hour to kilometers per hour.
"""
macro mph2kph(value)
    value = esc(value)
    return :($value * 1.60934)
end

"""
    @kph2mph(value)

Converts a speed from kilometers per hour to miles per hour.
"""
macro kph2mph(value)
    value = esc(value)
    return :($value * 0.621371)
end

"""
    @mach_from_mph(velocity)

Converts a speed from miles per hour to Mach number, where Mach 1 is the speed of sound.
"""
macro mach_from_mph(velocity)
    velocity = esc(velocity)
    return :($velocity / (761.207 * 0.44704))
end

"""
    @mach_from_kph(velocity)

Converts a speed from kilometers per hour to Mach number, where Mach 1 is the speed of sound.
"""
macro mach_from_kph(velocity)
    velocity = esc(velocity)
    return :($velocity / (1225 * 0.54))
end
