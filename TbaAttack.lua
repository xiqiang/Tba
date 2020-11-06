TbaAttack = createClass(TbaBase,"TbaAttack")

function TbaAttack:ctor()
	TbaBase.ctor(self)
	self.name = "attack"
end

function  TbaAttack:OnStart()
	TbaBase.OnStart(self);
	
	if math.random(100) < 60 then
		self:Add(TbaMove.new());
	end
end

function TbaAttack:OnProcess()
	TbaBase.OnProcess(self)
	if math.random(100) < 20 then
		self:Abort();
	end
end
