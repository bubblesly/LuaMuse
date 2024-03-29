require("array")

Part = {}
Part.__index = Part

setmetatable(Part, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Part.new(timeSignature, nbBars, chord_events)
  local self = setmetatable({}, Part)
  self.timeSignature = timeSignature
  self.nbBars = nbBars
  local evts = Array(chord_events)
  function less_than(evt1, evt2)
    return evt1.time:to_time_index() < evt1.time:to_time_index()
  end
  evts:sort(less_than)
  self.chord_events = evts
  return self
end

function Part:clone()
  return Part(self.timeSignature, self.nbBars, self.chord_events:clone())
end

function Part:add_chord_event(chord_evt)
  local evts = self.chord_events:clone()
  evts:push_tail(chord_evt)
  return Part(self.timeSignature:clone(), nbBars, evts)
end

function Part:get_current_chord(time)
  local time_index = time:to_time_index()
  local current_chord = nil
  for i,evt in ipairs(self.chord_events) do
    if evt:get_time_index() <= time_index then
      current_chord = evt.chord
    else
      return current_chord
    end
  end
  return current_chord
end