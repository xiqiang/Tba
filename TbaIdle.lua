TbaIdle = createClass(TbaBase,"TbaIdle")

function TbaIdle:ctor()
	TbaBase.ctor(self)
	self.name = "idle"
end

function TbaIdle:OnProcess()
	TbaBase.OnProcess(self)
	if math.random(100) < 20 then
		self:Add(TbaMove.new());
	end
	
	if math.random(100) < 20 then
		self:Add(TbaAlert.new())
	end
end
