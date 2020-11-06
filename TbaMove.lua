TbaMove = createClass(TbaBase,"TbaMove")

function TbaMove:ctor()
	TbaBase.ctor(self)
	self.name = "move"
end

function TbaMove:OnProcess()
	TbaBase.OnProcess(self)
	if math.random(100) < 30 then
		self.parent:Add(TbaAlert.new());
	end

	if math.random(100) < 20 then
		self:Abort();
	end;
end
