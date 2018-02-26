local polyfills = require('lib/bpx-lib/polyfills')(env)

local bpx = {}
for key,func in pairs(polyfills) do bpx[key] = func end

-- return the global bpx object for this library
GLOBAL.global('bpx')
GLOBAL.bpx = bpx
