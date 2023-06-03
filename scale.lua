require("note")
require("array")

Scale = {}
Scale.__index = Scale

setmetatable(Scale, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Scale.new(notes)
  local self = setmetatable({}, Scale)
  self.notes = notes
  return self
end

function Scale:clone()
  return Scale(Array(self.notes):clone())
end

function Scale:transpose(new_tonic)
  local transpose_distance = new_tonic.name - self.notes[1].name
  local semi_tones = Array{2, 2, 1, 2, 2, 2, 1}
    :rotate_values(self.notes[1].name - NotesNames.C)
  local rotated_semi_tones = semi_tones:rotate_values(transpose_distance)
  local rotation_induced_alterations = semi_tones
    :diff_values(rotated_semi_tones)
    :acc_table_values()
  local self_alterations = Array(self.notes):map(function(n) return n.alteration end)
  local final_alterations = rotation_induced_alterations
    :map(
      function(alt)
        return alt + new_tonic.alteration 
      end)
    :push_head(new_tonic.alteration)
    :pop_tail()
    :zip(self_alterations)
    :map(function(elt)
      return elt[1] + elt[2]
    end)
  return Scale(Array(self.notes)
    :rotate_values(transpose_distance)
    :zip(final_alterations)
    :map(function(elt)
      return Note(elt[1].name, elt[2])
    end))
end

function Scale.get_major(tonic_note)
  return Scale.c_major():transpose(tonic_note)
end

function Scale.c_major()
  return Scale({
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0)
  })
end

--[[
  Returns a new scale based on self, rotated from note_offset
  note_offset: 
   * 1 => root, no rotation
   * 2 => 2nd
   * 3 => 3rd
   etc

]]
function Scale:rotate(note_offset)
  local notes = Array(self.notes):rotate_values(note_offset - 1)
  return Scale(notes)
end

--[[
  Returns a new scale based on self, adding an alteration
  note_offset: 
   * 1 => root
   * 2 => 2nd
   * 3 => 3rd
   etc
  alteration:
   * +1 note is raised by a semitone
   * -1 note is lowered by a semitone
]]
function Scale:add_alteration(note_offset, alteration)
  local new_scale = self:clone()
  new_scale.notes[note_offset].alteration = new_scale.notes[note_offset].alteration + alteration
  return new_scale
end

function Scale:add_alterations(alterations)
  local new_alterations = Array(self.notes)
    :map(function(n) return n.alteration end)
    :zip(alterations)
    :map(function(e) return e[1] + e[2] end)
  local new_notes = Array(self.notes)
    :zip(new_alterations)
    :map(function(e) return Note(e[1].name, e[2]) end)
  return Scale(new_notes)
end

function Scale:to_semitones()
  local result = {}
  local last = 0
  local st = 0
  for i = 1, 7 do
    st = self.notes[i]:to_semitone()
    -- we want the scale to be ascending
    if st < last then
      st = st + 12
    end
    last = st
    table.insert(result, st)
  end
  return result
end

function Scale:get_downward_enharmonic()
  return Scale(Array(self.notes):map(function(note) return note:get_downward_enharmonic() end))
end

function Scale:get_upward_enharmonic()
  return Scale(Array(self.notes):map(function(note) return note:get_upward_enharmonic() end))
end

function Scale:tostring()
  local f = function(acc, n)
    return acc .. " " .. n:tostring()
  end
  return Array(self.notes):fold_left("{", f) .. "}"
end

function Scale:get_distance(other_scale)
  function compare_scales(ref, scale)
    local f = function(acc, elt)
      if elt ~= 0 then
        return acc + 1
      else
        return acc
      end
    end
    local alterations_diff = Array(scale.notes)
      :zip(ref.notes)
      :map(function(e) return e[1].alteration - e[2].alteration end)
    return alterations_diff:fold_left(0, f)
  end
  function align_scales(ref, scale)
    local rotation = (ref.notes[1].name - scale.notes[1].name + 8) % 7
    return scale:rotate(rotation)
  end

  function align_downward(ref, scale)
    local rotation = (ref.notes[1].name - scale.notes[1].name + 8) % 7
    return scale:rotate(rotation)
  end

  local aligned = align_scales(self, other_scale)
  local closest_up_or_downward = aligned
    :rotate(7)
    :get_upward_enharmonic()
  if self.notes[1].alteration - aligned.notes[1].alteration > 0 then
    closest_up_or_downward = aligned
      :rotate(2)
      :get_downward_enharmonic()
  end
  print(compare_scales(self, aligned))
  print(compare_scales(self, closest_up_or_downward))
  print(self:tostring())
  print(other_scale:tostring())
  print(aligned:tostring())
  print(closest_up_or_downward:tostring())
  return math.min(compare_scales(self, aligned), compare_scales(self, closest_up_or_downward)) 
end