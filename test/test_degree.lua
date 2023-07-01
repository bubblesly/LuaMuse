require('../degree')
luaunit = require('luaunit')

TestDegree = {}

function TestDegree:setUp()
end

function TestDegree:tearDown()
end

function TestDegree:testClone()
  local degree = Degree(DegreeNames.II, 1)
  local clone = degree:clone()
  luaunit.assertEquals(clone, Degree(DegreeNames.II, 1))
  luaunit.assertNotIs(clone, degree)
end

function TestDegree:testToStringForSharp()
  local degree = Degree(DegreeNames.II, 1)
  luaunit.assertEquals(degree:tostring(), "♯II")
  luaunit.assertEquals(degree:name_tostring(), "II")
  luaunit.assertEquals(degree:alteration_tostring(), "♯")
end

function TestDegree:testToStringForFlat()
  local degree = Degree(DegreeNames.V, -1)
  luaunit.assertEquals(degree:tostring(), "♭V")
  luaunit.assertEquals(degree:name_tostring(), "V")
  luaunit.assertEquals(degree:alteration_tostring(), "♭")
end
