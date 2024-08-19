require('tracks/clip')

ClipArray = {}
ClipArray.__index = ClipArray

setmetatable(ClipArray, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClipArray.new(type)
  local self = {}
  setmetatable(self, ClipArray)
  self.type = type
  self.values = {}
  return self
end

function ClipArray:addClip(clip)
  if clip.type ~= self.type then
    return
  else
    self.values[clip.position] = clip
    table.sort(self.values)
  end
end

function ClipArray:getIntersectingClips(position)
  local intersection = {}
  for pos,clip in pairs(self.values) do 
    if pos <= position and pos + clip.duration > position then
      table.insert(intersection, clip)
    end
    if position > pos then
      break
    end
  end
  return intersection
end