require("array")
require("note")

Mode = {}
Mode.__index = Mode

setmetatable(Mode, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Mode.new(intervals)
  local self = setmetatable({}, Mode)
  self.intervals = Array(intervals)
  return self
end

function Mode:clone()
  return Mode(self.intervals:clone())
end

function Mode:rotate(offset)
  return Mode(self.intervals:rotate_values(offset))
end

function Mode:alter(pos, alteration)
  local values = self.intervals:clone()
  local size = #values
  local prec = (pos + size - 2) % size + 1
  values[prec] = values[prec] + alteration
  values[pos] = values[pos] - alteration
  return Mode(values)
end

function Mode:get_alterations(ref_mode)
  return self.intervals
    :diff_values(ref_mode.intervals)
    :acc_table_values()
    :rotate_values(6)
end

Mode.IONIAN             = Mode({2, 2, 1, 2, 2, 2, 1})
Mode.DORIAN             = Mode.IONIAN:rotate(1)
Mode.PHRYGIAN           = Mode.IONIAN:rotate(2)
Mode.LYDIAN             = Mode.IONIAN:rotate(3)
Mode.MIXOLYDIAN         = Mode.IONIAN:rotate(4)
Mode.AEOLIAN            = Mode.IONIAN:rotate(5)
Mode.LOCRIAN            = Mode.IONIAN:rotate(6)

Mode.MAJOR              = Mode.IONIAN
Mode.MINOR              = Mode.AEOLIAN

Mode.HARM_MINOR         = Mode.MINOR:alter(7, 1)
Mode.LOCRIAN_NAT6       = Mode.HARM_MINOR:rotate(1)
Mode.IONIAN_SHARP5      = Mode.HARM_MINOR:rotate(2)
Mode.DORIAN_SHARP11     = Mode.HARM_MINOR:rotate(3)
Mode.PHRYGIAN_DOM       = Mode.HARM_MINOR:rotate(4)
Mode.LYDIAN_SHARP2      = Mode.HARM_MINOR:rotate(5)
Mode.SUPER_LOCRIAN_BB7  = Mode.HARM_MINOR:rotate(6)

Mode.MEL_MINOR          = Mode.HARM_MINOR:alter(6, 1)
Mode.DORIAN_B2          = Mode.MEL_MINOR:rotate(1)
Mode.LYDIAN_AUG         = Mode.MEL_MINOR:rotate(2)
Mode.LYDIAN_DOM         = Mode.MEL_MINOR:rotate(3)
Mode.MIXOLYDIAN_B6      = Mode.MEL_MINOR:rotate(4)
Mode.AEOLIAN_B5         = Mode.MEL_MINOR:rotate(5)
Mode.ALTERED_SCALE      = Mode.MEL_MINOR:rotate(6)

