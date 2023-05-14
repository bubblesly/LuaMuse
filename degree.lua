local SHARP <const> = "♯"
local FLAT <const> = "♭"

DegreeNames = {
  I   = 1,
  II  = 2,
  III = 3,
  IV  = 4,
  V   = 5,
  VI  = 6, 
  VII = 7
}

Degree = {}
Degree.__index = Degree

setmetatable(Degree, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Degree.new(name, alteration)
  local self = setmetatable({}, Degree)
  self.name = name
  self.alteration = alteration
  return self
end

function Degree:clone()
  return Degree(self.name, self.alteration)
end

function Degree:name_tostring()
  if self.name == 1 then
    return "I"
  elseif self.name == 2 then
    return "II"
  elseif self.name == 3 then
    return "III"
  elseif self.name == 4 then
    return "IV"
  elseif self.name == 5 then
    return "V"
  elseif self.name == 6 then
    return "VI"
  elseif self.name == 7 then
    return "VII"
  else
    return "ERROR"
  end
end

function Degree:alteration_tostring()
  if self.alteration == -2 then
    return FLAT .. FLAT
  elseif self.alteration == -1 then
    return FLAT
  elseif self.alteration == 0 then
    return ""
  elseif self.alteration == 1 then
    return SHARP
  elseif self.alteration == 2 then
    return SHARP .. SHARP
  else
    return "ERROR"
  end
end

function Degree:tostring()
  return self:alteration_tostring() .. self:name_tostring()
end