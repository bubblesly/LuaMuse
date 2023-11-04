local lu = require('luaunit')

require('test/test_array')
require('test/test_degree')
require('test/test_mode')
require('test/test_note')
require('test/test_scale')
require('test/test_chord')
require('test/test_chord_event')
require('test/test_part')

os.exit( lu.LuaUnit.run() )