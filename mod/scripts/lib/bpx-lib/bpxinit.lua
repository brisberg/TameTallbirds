local version = 0.1

local start = GLOBAL.os.clock()
if not table.containskey(GLOBAL, "bpx") or GLOBAL.bpx.version < version then

  local polyfills = require('lib/bpx-lib/polyfills')(env)

  local bpx = {version = version}
  for key,func in pairs(polyfills) do bpx[key] = func end

  -- return the global bpx object for this library
  GLOBAL.bpx = bpx
  -- env.bpx = bpx
end
local endt = GLOBAL.os.clock()
print("BPX Lib loaded in:"..(endt - start))
