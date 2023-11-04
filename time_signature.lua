
TimeSignature = {}
TimeSignature.__index = TimeSignature

setmetatable(TimeSignature, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function TimeSignature.new(upper, lower)
  local self = setmetatable({}, TimeSignature)
  self.upper = upper
  self.lower = lower
  return self
end

function TimeSignature:clone()
  return TimeSignature(self.upper, self.lower)
end