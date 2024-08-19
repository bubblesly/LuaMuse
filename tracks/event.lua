require('tracks/track_element')

Event = {}
Event.__index = Event

setmetatable(Event, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
  __index = TrackElement
})

function Event.new(position, type)
  local self = TrackElement(type, position)
  setmetatable(self, Event)
  return self
end
