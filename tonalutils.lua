require("degree")

local tonalutils = {}

local SHARP <const> = "♯"
local FLAT <const> = "♭"
local HALF_DIMINISHED <const> = "\u{E871}"
local DIMINISHED <const> = "\u{E870}"

function tonalutils.get_alterations(tonality)
  function iterate_on_circle_of_fifths(tonic, direction, max_depth, pos, nb_alterations)
     if max_depth < 0 then
        return 0 -- we went too far
     else if pos == tonic then
        return nb_alterations
     end
     if direction = 0 then
        pos = (pos + 7) % 12
     else
        pos = (pos + 5) % 12
     end
     return iterate_on_circle_of_fifths(tonic, direction, pos, nb_alterations + 1)
  end
  local maj_tonic = tonality.tonic -- major
  if tonality.mode == 1 then -- minor
     maj_tonic = (tonality.tonic + 9) % 12
  end
  local nb_sharps = iterate_on_circle_of_fifths(maj_tonic, 0, 6, 0, 0)
  local nb_flats = iterate_on_circle_of_fifths(maj_tonic, 1, 5, 0, 0)
  return nb_sharps, nb_flats
end

function tonalutils.get_scale_notes_names(tonality)
  
  function add_alterations(notes, alteration, pos, nb_alterations)
     if nb_alterations == 0 then
        return notes
     end
     notes[pos + 1] = notes[pos + 1] .. alteration
     if alteration == SHARP then
        pos = (pos + 7) % 12 
     else
        pos = (pos + 5) % 12
     end
     add_alterations(notes, alteration, pos, nb_alterations - 1)
  end
  nb_sharps, nb_flats = get_alterations(tonality)
  local notes = {"C", "D", "E", "F", "G", "A", "B"}
  notes = add_alterations(notes, SHARP, 3, nb_sharps) -- first sharp is on F
  notes = add_alterations(notes, FLAT, 3, nb_flats) -- first flat is on B
  local scale_offset = 0
  if nb_flats == 0 then
     scale_offset = (nb_sharps * 7) % 12
  else
     scale_offset = (nb_flats * 5) % 12
  end
  local result = {}
  for i=0,6 do
     result[i+1] = notes[(i + scale_offset) % 12 +1]
  end
  return result
end

--[[
  Tonality: struct with
  - tonic: int from 0 to 11
  - mode: 0 major, 1 minor
]]

--[[
  chord_notes is a stack of 3rds
  - root: int from 0 to 11 (0 being C)
  - 3rd: offset in semitones to the root
  - 5th: offset in semitones to the root
  - 7th: offset in semitones to the root
  - 9th: offset in semitones to the root (%12)
  - 11th: offset in semitones to the root (%12)
  - 13th: offset in semitones to the root (%12)
  played_notes: array of booleans (true if a given chord_note has to be played)
]]
function tonalutils.get_chord_name(tonality, chord_notes)
  return "ERROR"
end

function tonalutils.get_semitones(tone, ref)
  return (tone + 12 - ref) % 12
end

function tonalutils.get_note_degree(note, tonality)
  local offset = tonalutils.get_semitones(note, tonality.tonic)
  local result = {}
  if offset == 0 then
    result = {Degree(1, 0)}
  else if offset == 1 then
    result = {Degree(2, -1)}
  else if offset == 2 then
    result = {Degree(2, 0)}
  else if offset == 3 and tonality.mode == 0 then --maj
    result = {Degree(3, -1)}
  else if offset == 3 and tonality.mode == 1  then --min
    result = {Degree(3, 0)}
  else if offset == 4 and tonality.mode == 0 then --maj
    result = {Degree(3, 0)}
  else if offset == 4 and tonality.mode == 1  then --min
    result = {Degree(3, 1)}
  else if offset == 5 then
    result = {Degree(4, 0)}
  else if offset == 6 then
    result = {Degree(5, -1), Degree(4, 1)}
  else if offset == 7 then
    result = {Degree(5, 0)}
  else if offset == 8 and tonality.mode == 0 then --maj
    result = {Degree(5, 1), Degree(6, -1)}
  else if offset == 8 and tonality.mode == 1 then --min
    result = {Degree(6, 0)}
  else if offset == 9 and tonality.mode == 0 then --maj
    result = {Degree(6, 0)}
  else if offset == 9 and tonality.mode == 1 then --min
    result = {Degree(6, 1)}
  else if offset == 10 and tonality.mode == 0 then --maj
    result = {Degree(7, -1)}
  else if offset == 10 and tonality.mode == 1 then --min
    result = {Degree(7, 0)}
  else if offset == 11 and tonality.mode == 0 then --maj
    result = {Degree(7, 0)}
  else if offset == 11 and tonality.mode == 1 then --min
    result = {Degree(7, 1)}
  end
  return result
end

function tonalutils.get_note_name(note, tonality)
  local tonic = tonality.tonic
  local result = "ERROR"
  if tonality.mode == 0 then
  else if tonality.mode == 1 then
    if tonic == 0 then -- C

    else if tonic == 1 then
    else if tonic == 2 then
    else if tonic == 2 then
    else if tonic == 3 then
    else if tonic == 4 then
    else if tonic == 5 then
    else if tonic == 6 then
    else if tonic == 7 then
    else if tonic == 8 then
    else if tonic == 9 then
    else if tonic == 10 then
    else if tonic == 11 then
    else
      result = "ERROR"
    end
  else
    result = "ERROR"
  end
end

function tonalutils.get_triad_chord_name(root, third, fifth, tonality)
  local result = tonalutils.get_note_name(root, tonality)
  if third == 3 && fifth == 6 then
    result = result .. "dim"
  else if third == 3 && fifth == 7 then
    result = result .. "min"
  else if third == 2 && fifth == 7 then
    result = result .. "sus2"
  else if third == 5 && fifth == 7 then
    result = result .. "sus4"
  else if third == 4 && fifth == 7 then
    result = result .. "Maj"
  else if third == 4 && fifth == 8 then
    result = result .. "aug"
  else
    result = result .. "ERROR"
  end
  return result
end

function tonalutils.get_seventh_chord_name(root, third, fifth, seventh, tonality)
  local result = tonalutils.get_note_name(root, tonality)
  if third == 4 && fifth == 7 && seventh == 10 then
    result = result .. "7"
  else if third == 4 && fifth == 7 && seventh == 11 then
    result = result .. "Maj7"
  else if third == 3 && fifth == 7 && seventh == 10 then
    result = result .. "min7"
  else if third == 3 && fifth == 6 && seventh == 10 then
    result = result .. HALF_DIMINISHED
  else if third == 3 && fifth == 6 && seventh == 9 then
    result = result .. DIMINISHED
  else
    result = result .. "ERROR"
  end
  return result
end

return tonalutils
