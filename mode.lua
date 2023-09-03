require("array")
require("note")

Mode = {}
Mode.__index = Mode

setmetatable(Mode, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Mode.new(intervals, name)
  local self = setmetatable({}, Mode)
  self.intervals = Array(intervals)
  self.name = name
  return self
end

function Mode.from_intervals(intervals)
  return Array({
    Mode.IONIAN,
    Mode.DORIAN,
    Mode.PHRYGIAN,
    Mode.LYDIAN,
    Mode.MIXOLYDIAN,
    Mode.AEOLIAN,
    Mode.LOCRIAN,
    Mode.HARM_MINOR,
    Mode.LOCRIAN_NAT6,
    Mode.IONIAN_SHARP5,
    Mode.DORIAN_SHARP11,
    Mode.PHRYGIAN_DOM,
    Mode.LYDIAN_SHARP2,
    Mode.SUPER_LOCRIAN_BB7,
    Mode.MEL_MINOR,
    Mode.DORIAN_B2,
    Mode.LYDIAN_AUG,
    Mode.LYDIAN_DOM,
    Mode.MIXOLYDIAN_B6,
    Mode.AEOLIAN_B5,
    Mode.ALTERED_SCALE        
  }):find(function(m) return (m.intervals:equals(intervals)) end)
end

function Mode:clone()
  return Mode(self.intervals:clone(), name)
end

function Mode:rotate(offset)
  return Mode(self.intervals:rotate_values(offset), "undefined")
end

function Mode:alter(pos, alteration)
  local values = self.intervals:clone()
  local size = #values
  local prec = (pos + size - 2) % size + 1
  values[prec] = values[prec] + alteration
  values[pos] = values[pos] - alteration
  return Mode(values, "undefined")
end

function Mode:get_alterations(ref_mode)
  return self.intervals
    :diff_values(ref_mode.intervals)
    :acc_table_values()
    :rotate_values(6)
end

Mode.IONIAN             = Mode({2, 2, 1, 2, 2, 2, 1}, "Ionian")
Mode.DORIAN             = Mode(Mode.IONIAN.intervals:rotate_values(1), "Dorian")
Mode.PHRYGIAN           = Mode(Mode.IONIAN.intervals:rotate_values(2), "Phrygian")
Mode.LYDIAN             = Mode(Mode.IONIAN.intervals:rotate_values(3), "Lydian")
Mode.MIXOLYDIAN         = Mode(Mode.IONIAN.intervals:rotate_values(4), "Mixolydian")
Mode.AEOLIAN            = Mode(Mode.IONIAN.intervals:rotate_values(5), "Aeolian")
Mode.LOCRIAN            = Mode(Mode.IONIAN.intervals:rotate_values(6), "Locrian")

Mode.MAJOR              = Mode.IONIAN
Mode.MINOR              = Mode.AEOLIAN

Mode.HARM_MINOR         = Mode(Mode.MINOR:alter(7, 1).intervals, "Harmonic minor")
Mode.LOCRIAN_NAT6       = Mode(Mode.HARM_MINOR.intervals:rotate_values(1), "Locrian natural6")
Mode.IONIAN_SHARP5      = Mode(Mode.HARM_MINOR.intervals:rotate_values(2), "Ionian sharp5")
Mode.DORIAN_SHARP11     = Mode(Mode.HARM_MINOR.intervals:rotate_values(3), "Dorian sharp11")
Mode.PHRYGIAN_DOM       = Mode(Mode.HARM_MINOR.intervals:rotate_values(4), "Phrygian dominant")
Mode.LYDIAN_SHARP2      = Mode(Mode.HARM_MINOR.intervals:rotate_values(5), "Lydian sharp2")
Mode.SUPER_LOCRIAN_BB7  = Mode(Mode.HARM_MINOR.intervals:rotate_values(6), "Super Locrian bb7")

Mode.MEL_MINOR          = Mode(Mode.HARM_MINOR:alter(6, 1).intervals, "Melodic minor")
Mode.DORIAN_B2          = Mode(Mode.MEL_MINOR.intervals:rotate_values(1), "Dorian bemol2")
Mode.LYDIAN_AUG         = Mode(Mode.MEL_MINOR.intervals:rotate_values(2), "Lydian augmented")
Mode.LYDIAN_DOM         = Mode(Mode.MEL_MINOR.intervals:rotate_values(3), "Lydian dominant")
Mode.MIXOLYDIAN_B6      = Mode(Mode.MEL_MINOR.intervals:rotate_values(4), "Mixolydian bemol6")
Mode.AEOLIAN_B5         = Mode(Mode.MEL_MINOR.intervals:rotate_values(5), "Aeolian bemol5")
Mode.ALTERED_SCALE      = Mode(Mode.MEL_MINOR.intervals:rotate_values(6), "Altered scale")

