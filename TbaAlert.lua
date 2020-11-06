TbaAlert = createClass(TbaBase,"TbaAlert")

function TbaAlert:ctor()
	TbaBase.ctor(self)
	self.name = "alert"
end

function  TbaAlert:OnStart()
	TbaBase.OnStart(self);
	self:Check();
end

function TbaAlert:OnProcess()
	TbaBase.OnProcess(self)
	self:Check();
end

function TbaAlert:Check()
	if math.random(100) < 20 then
		if math.random(100) < 30 then
			self.parent:Add(TbaAttack.new());
		end
		
		self:Abort();
	end
end
