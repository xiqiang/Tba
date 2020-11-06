-- Get current version number.
local _, _, majorv, minorv, rev = string.find(_VERSION, "(%d).(%d)[.]?([%d]?)")
local VersionNumber = tonumber(majorv) * 100 + tonumber(minorv) * 10 + (((string.len(rev) == 0) and 0) or tonumber(rev))

-- Declare current version number.
TX_VERSION = VersionNumber
TX_VERSION_510 = 510
TX_VERSION_520 = 520
TX_VERSION_530 = 530

----[[
creatureMap = {}
--]]

function createClass(super, name)
	local c = {}

----[[
	c._className = name
--]]	

	function c.new(...)
		local o = {}
		setmetatable(o, c)

----[[
		if TX_VERSION < TX_VERSION_520 then
			local dp = newproxy(true)
			getmetatable(dp).__gc = function(_obj) c.delete(_obj) end
			o.dtor_prox = dp
		end			
		creatureMap[name] = (creatureMap[name] or 0) + 1
--]]

		if c.ctor then c.ctor(o,...) end
		return o
	end

----[[
	function c.delete(o)
		creatureMap[name] = (creatureMap[name] or 0) - 1
		if c.dtor then c.dtor(o) end
	end
--]]

	local s = super or {}
	setmetatable(c, {__index = s})

	if TX_VERSION >= TX_VERSION_520 then
		c.__gc = function(_obj) c.delete(_obj) end
	end 	
	c.__index = c
	return c	
end

--[[
-------------------------------------------

A = createClass()
function A:ctor(v)
	print("A.ctor("..tostring(self)..")")
	self.v = v
end
function A:dtor(v)
	print("A.dtor("..tostring(self)..")")
end

-------------------------------------------

B = createClass(A)
function B:ctor()	
	A.ctor(self, 2)
	print("B.ctor("..tostring(self)..")")	
end
function B:dtor(v)	
	print("B.dtor("..tostring(self)..")")
	A.dtor(self)
end

-------------------------------------------

C = createClass(B)
function C:ctor(v2)	
	B.ctor(self)
	print("C.ctor("..tostring(self)..")")
	self.v2 = v2
end
function C:dtor(v)	
	print("C.dtor("..tostring(self)..")")
	B.dtor(self)
end

-------------------------------------------

D = createClass(C)
function D:ctor()	
	C.ctor(self, "d")
	print("D.ctor("..tostring(self)..")")
end
function D:dtor()		
	print("D.dtor("..tostring(self)..")")
	C.dtor(self)
end

-------------------------------------------
print("Begin test...")

local a = A.new(1)
print("a.v = "..tostring(a.v))
print("a.v2 = "..tostring(a.v2))
local b = B.new()
print("b.v = "..tostring(b.v))
print("b.v2 = "..tostring(b.v2))
local c = C.new("c")
print("c.v = "..tostring(c.v))
print("c.v2 = "..tostring(c.v2))
local d = D.new()
print("d.v = "..tostring(d.v))
print("d.v2 = "..tostring(d.v2))

print("End test.")


-------------------------------------------
]]