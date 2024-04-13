--[[
  USAGE:
  Place dump.lua in a CC computer and place a Mekanism peripheral
  on its left side (your left, as you're looking at the front of the computer).

  Then run `dump <out>` and it will generate `dump/<out>.json` and `dump/<out>.lua`
  containing the serialized help data for the Mekanism peripheral.

  Alternatively, you can run `dump <out> <side>` to specify the side of the computer
  where the peripheral is located, or the name of the peripheral type if it's
  connected via wired modem.

  Example: `dump fission fissionReactorLogicAdapter`
]]

local DUMP_DIR = "dump"

local out = arg[1] or "dump"
local side = arg[2] or "left"

local p = peripheral.wrap(side) or peripheral.find(side)
local help = p.help()
local json = textutils.serializeJSON(help)
local lua = textutils.serialize(help)

local function write(ext, text)
  local dir = fs.combine(DUMP_DIR, ext)
  fs.makeDir(dir)
  local path = fs.combine(dir, out .. "." .. ext)
  print("Dumping " .. ext .. " to " .. path)
  local f = fs.open(path, "w+")
  if ext == "lua" then f.write("return ") end
  f.write(text)
  f.flush()
  f.close()
end

write("json", json)
write("lua", lua)
