require('tracks/clip')

ClipIndex = {}
ClipIndex.__index = ClipIndex

setmetatable(ClipIndex, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClipIndex.new()
  local self = {}
  setmetatable(self, ClipIndex)
  self.clips = {}
  return self
end

function ClipIndex:addClip(clip)
  table.insert(self.clips, clip)
end

function ClipIndex:getIntersectingClips(position)
  local intersection = {}
  for i,clip in pairs(self.clips) do 
    if clip.position <= position and clip.position + clip.duration > position then
      table.insert(intersection, clip)
    end
  end
  return intersection
end