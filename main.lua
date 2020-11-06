require("createClass")
require("TbaBase")
require("TbaIdle")
require("TbaMove")
require("TbaAlert")
require("TbaAttack")
require("printTable")

----------------------------------------------
a = Tba.new()
idle = TbaIdle.new()
a:Add(idle)

for i = 0,100000 do
	a:Update(0.1)
	if i % 1000 == 0 then
		print(" ------------------------ clear() --------------------------")
		idle:Clear()
	end
end

collectgarbage()
printTable(creatureMap)

----------------------------------------------
