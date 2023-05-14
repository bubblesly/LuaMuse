require("note")
require("scale")

Mode = {
  MAJOR = 0,
  MINOR = 1
}

Direction = {
  ASCENDING = 0,
  DESCENDING = 1
}


local Tonality = {}
Tonality.__index = Tonality

setmetatable(Tonality, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})
--[[
function Tonality.new(tonic_offset, mode)
  local self = setmetatable({}, Tonality)
  self.tonic_offset = tonic_offset
  self.mode = mode
  return self
end

function Tonality.get_scale_name(self)
  return self.get_scale().notes[1].print() .. self.getModeName()
end

function Tonality.getModeName(self)
  if self.mode == Mode.MAJOR then
    return "Major"
  elseif self.mode == Mode.MINOR then
    return "Minor"
  else return "ERROR"
end

function Tonality.get_scale(self)
  -- Returns the tonic offset or its relative major if we're in minor
  function get_major_tonic_offset(self)
    if self.mode == Mode.MAJOR then
      return self.tonic_offset
    elseif self.mode == Mode.MINOR then
      return (self.tonic_offset + 9) % 12
    end
  end
  function iterate_on_circle_of_fifths(tonic_offset, dir, max_depth, pos, scale)
    if max_depth < 0 then
      return nil -- we went too far
    else if pos == tonic_offset then
      return scale
    end
    local newScale = nil
    if dir == Direction.ASCENDING then
      pos = (pos + 7) % 12
      newScale = scale:rotate(5):alter(7, 1)
    else
      pos = (pos + 5) % 12
      newScale = scale:rotate(4):alter(4, -1)
    end
    return iterate_on_circle_of_fifths(tonic_offset, dir, max_depth - 1, pos, newScale)
  end
  local maj_tonic = self:get_major_tonic_offset()
  local scale = Scale:c_major()
  local result = iterate_on_circle_of_fifths(maj_tonic, Direction.ASCENDING, 6, 0, scale)
  if result == nil then
    result = iterate_on_circle_of_fifths(maj_tonic, Direction.DESCENDING, 5, 0, scale)
  end
  if self.mode == Mode.MINOR then
    result = result:rotate(6)
  end
  return result
end

function Tonality.get_scale_notes_semitones(self)
  return self:get_scale().to_semitones
end
]]

function Tonality.new(tonic, mode)
  local self = setmetatable({}, Tonality)
  self.tonic = tonic
  self.mode = mode
  return self
end

function Tonality:get_scale()
  local alterations = mode:get_alterations(IONIAN.intervals)
  return Scale.c_major()
    :add_alterations(alterations)
    :transpose(self.tonic)
end
