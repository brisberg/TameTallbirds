local polyfills = modimport('lib/bpx-lib/polyfills')

bpx = {}
for key,func in pairs(polyfills) do bpx[key] = func end

-- return the global bpx object for this library
GLOBAL.bpx = bpx
