require('tracks/track_element')

Clip = {}
Clip.__index = Clip

setmetatable(Clip, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
  __index = TrackElement
})

function Clip.new(position, duration, type)
  local self = TrackElement(type, position)
  setmetatable(self, Clip)
  self.duration = duration
  return self
end
