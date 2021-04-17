local utils = require ("data/scripts/libs/Utils")
require("data/scripts/libs/Context")


utils.enable_debug()
context:inst():put_state('scene', {})
context:inst():enable_dummy()

require ("data/scripts/inst/charas/Player")

local w = {}
p = player:ret(w)
print(p)

