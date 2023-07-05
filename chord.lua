require("note")
require("array")

local SHARP <const> = "♯"
local FLAT <const> = "♭"

ThirdSpecs = {
  MAJOR  = 1,
  MINOR  = 2,
  SUS2   = 3,
  SUS4   = 4,
  ABSENT = 5
}

FifthSpecs = {
  PERFECT = 1,
  AUGMENTED = 2,
  DIMINISHED = 3
  ABSENT = 4
}

SeventhSpecs = {
  MAJOR,
  MINOR,
  DIMINISHED,
  ABSENT
}

ChordExtensionNames = {
  NINTH      = 1,
  ELEVENTH   = 2,
  THIRTEENTH = 3
}

ExtensionAlterations = {
  NONE  = 1,
  SHARP = 2,
  FLAT  = 3
}

ChordExtension = {}
ChordExtension.__index = ChordExtension

setmetatable(ChordExtension, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ChordExtension.new(name, alteration = ExtensionAlterations.NONE)
  local self = setmetatable({}, ChordExtension)
  self.name = name
  self.alteration = alteration
  return self
end

function ChordExtension:clone()
  return ChordExtension(self.name, self.alteration)
end

function ChordExtension:tostring()
  local s = ""
  if self.alteration == ExtensionAlterations.FLAT then
    s = s .. FLAT
  elseif self.alteration == ExtensionAlterations.SHARP then
    s = s .. SHARP
  end
  if self.name == ChordExtensionNames.NINTH then
    s = "9"
  elseif self.name == ChordExtensionNames.ELEVENTH then
    s = "11"
  elseif self.name == ChordExtensionNames.THIRTEENTH then
    s = "13"
  else
    s = "ERROR"
  end
  return "(add" .. s .. ")"
end

Chord = {}
Chord.__index = Chord

setmetatable(Chord, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Chord.new(tonic,
  thirdSpec = ThirdSpecs.MAJOR,
  fifthSpec = FifthSpecs.PERFECT,
  seventhSpec = SeventhSpecs.ABSENT,
  extensions = {})
  local self = setmetatable({}, Chord)
  self.tonic = tonic
  self.thirdSpec = thirdSpec
  self.fifthSpec = fifthSpec
  self.seventhSpec = seventhSpec
  self.extensions = Array(extensions)
  return self
end

function Chord.from_scale_and_degree(scale, degree, seventh = false, ninth = false, eleventh = false, thirteenth = false)
  function get_third_spec(tonic_note, scale)
    local third_note = scale:get_note_from_degree(Degree(degree.name + 2))
    local semi_tones = third_note:to_semitone() - tonic_note:to_semitone()
    local spec = ThirdSpecs.MAJOR
    if semi_tones == 3 then
      spec = ThirdSpecs.MINOR
    end
    return spec
  end
  function get_fifth_spec(tonic_note, scale)
    local fifth_note = scale:get_note_from_degree(Degree(degree.name + 4))
    local semi_tones = fifth_note:to_semitone() - tonic_note:to_semitone()
    local spec = FifthSpecs.PERFECT
    if semi_tones == 6 then
      spec = ThirdSpecs.DIMINISHED
    elseif semi_tones == 8 then
      spec = ThirdSpecs.AUGMENTED
    end
    return spec
  end
  function get_seventh_spec(tonic_note, scale, seventh)
    if not seventh then
      return SeventhSpecs.ABSENT
    end
    local seventh_note = scale:get_note_from_degree(Degree(degree.name + 6))
    local semi_tones = seventh_note:to_semitone() - tonic_note:to_semitone()
    local spec = SeventhSpecs.MAJOR
    if semi_tones == 10 then
      spec = SeventhSpecs.MINOR
    elseif semi_tones == 9 then
      spec = SeventhSpecs.DIMINISHED
    end
    return spec
  end
  function get_ext_tones(tonic_note, scale, ninth, eleventh, thirteenth)
    local ext_tones = {}
    if ninth then
      local ninth_note = scale:get_note_from_degree(Degree(degree.name + 1))
      local semi_tones = ninth_note:to_semitone() - tonic_note:to_semitone()
      local alt = ExtensionAlterations.NONE
      if semi_tones == 1 then
        alt = ExtensionAlterations.FLAT
      end
      -- there is no sharp ninth  
      table.insert(ext_tones, ChordExtension(ChordExtensionNames.NINTH, alt)) 
    end
    if eleventh then
      local eleventh_note = scale:get_note_from_degree(Degree(degree.name + 3))
      local semi_tones = eleventh_note:to_semitone() - tonic_note:to_semitone()
      local alt = ExtensionAlterations.NONE
      if semi_tones == 6 then
        alt = ExtensionAlterations.SHARP
      end
      -- there is no flat eleventh  
      table.insert(ext_tones, ChordExtension(ChordExtensionNames.ELEVENTH, alt)) 
    end
    if thirteenth then
      local thirteenth_note = scale:get_note_from_degree(Degree(degree.name + 5))
      local semi_tones = thirteenth_note:to_semitone() - tonic_note:to_semitone()
      local alt = ExtensionAlterations.NONE
      if semi_tones == 8 then
        alt = ExtensionAlterations.FLAT
      end
      -- there is no sharp thirteenth  
      table.insert(ext_tones, ChordExtension(ChordExtensionNames.THIRTEENTH, alt)) 
    end
    return ext_tones
  end
  local tonic_note = scale:get_note_from_degree(degree)
  return Chord(tonic_note,
   get_third_spec(tonic_note, scale),
   get_fifth_spec(tonic_note, scale),
   get_seventh_spec(tonic_note, scale, seventh),
   get_ext_tones(tonic_note, scale, ninth, eleventh, thirteenth))
end

function Chord:clone()
  return Chord(self.tonic:clone(), self.thirdSpec, self.fifthSpec, self.seventhSpec, self.extensions:clone())
end

function Chord:tostring()
  function tonic_tostring()
    return self.tonic:tostring()
  end
  function chordal_tones_tostring()
    if self.seventhSpec == SeventhSpecs.ABSENT then
      if self.fifthSpec == FifthSpecs.DIMINISHED then
        return "dim"
      elseif self.fifthSpec == FifthSpecs.AUGMENTED then
        return "+"
      elseif self.thirdSpec == ThirdSpecs.MAJOR then
        return "maj"
      elseif self.thirdSpec == ThirdSpecs.MINOR then
        return "min"
      elseif self.thirdSpec == ThirdSpecs.SUS2 then
        return "sus2"
      elseif self.thirdSpec == ThirdSpecs.SUS4 then
        return "sus4"
      elseif self.fifthSpec == FifthSpecs.PERFECT then
          return "5"
      else
        return ""
      end
    else if self.seventhSpec == SeventhSpecs.MINOR then
      if self.fifthSpec == FifthSpecs.DIMINISHED then
        return "ø7"
      elseif self.fifthSpec == FifthSpecs.AUGMENTED then
        return "+7"
      elseif self.thirdSpec == ThirdSpecs.MAJOR then
        return "7"
      elseif self.thirdSpec == ThirdSpecs.MINOR then
        return "min7"
      elseif self.thirdSpec == ThirdSpecs.SUS2 then
        return "7sus2"
      elseif self.thirdSpec == ThirdSpecs.SUS4 then
        return "7sus4"
      else
        -- no third, we arbitrarily write it as dominant
        return "7"
      end
    else if self.seventhSpec == SeventhSpecs.MAJOR then
      if self.fifthSpec == FifthSpecs.AUGMENTED then
        return "+7"
      elseif self.thirdSpec == ThirdSpecs.MAJOR then
        return "Δ7"
      elseif self.thirdSpec == ThirdSpecs.MINOR then
        return "minM7"
      elseif self.thirdSpec == ThirdSpecs.SUS2 then
        return "7sus2"
      elseif self.thirdSpec == ThirdSpecs.SUS4 then
        return "7sus4"
      else
        -- no third, we arbitrarily write it as major
        return "Δ7"
      end
    else if self.seventhSpec == SeventhSpecs.DIMINISHED then
      return "°"
    end
    return ""
  end
  function extensions_tostring()
    return self.extensions:fold_left("", function f(acc, e) return acc .. e.tostring() end)
  end
  return tonic_tostring() .. chordal_tones_tostring() .. extensions_tostring()
end