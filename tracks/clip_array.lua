require('tracks/clip')
require('tracks/clip_index')

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
    if self.values[clip.position] == nil then
      self.values[clip.position] = ClipIndex.new()
    end
    self.values[clip.position]:addClip(clip)
  end
end

function ClipArray:getIntersectingClips(position)
  local intersection = {}
  for pos,index in pairs(self.values) do 
    local clips = index:getIntersectingClips(position)
    for i,clip in pairs(clips) do 
      table.insert(intersection, clip)
    end
    if position > pos then
      break
    end
  end
  return intersection
end