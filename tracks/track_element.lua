TrackElement = {}
TrackElement.__index = TrackElement

setmetatable(TrackElement, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function TrackElement.new(type, position)
  local self = setmetatable({}, TrackElement)
  self.type = type
  self.position = position
  return self
end


