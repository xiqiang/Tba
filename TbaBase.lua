require("Tba")

TbaBase = createClass(Tba,"TbaBase")

function TbaBase:ctor()
	Tba.ctor(self)
	self.name = "base"
end

function TbaBase:GetTreeName()
	if self.parent ~= nil then
		if self.parent.GetTreeName then
			return self.parent:GetTreeName().."."..self.name
		else
			return "Tba".."."..self.name
		end
	else
		return self.name
	end
end

TbaBase.DisturbType = 
{
	idle 	= {	idle = "oppose", alert = "wait", 	move = "wait", 		attack = "wait"		},
	alert 	= {	idle = "oppose", alert = "oppose", 	move = "none", 		attack = "abort"	},
	move 	= {	idle = "oppose", alert = "none", 	move = "abort", 	attack = "wait"		},
	attack 	= {	idle = "oppose", alert = "oppose", 	move = "represe", 	attack = "abort"	},
}

function  TbaBase:OnJoin()
	print(self:GetTreeName()..".OnJoin")
end

function  TbaBase:OnStart()
	print(self:GetTreeName()..".OnStart")
end

function TbaBase:OnProcess(deltaTime)
	--print(self:GetTreeName()..".OnProcess")
end

function TbaBase:OnSuspend()
	print(self:GetTreeName()..".OnSuspend")
end

function TbaBase:OnResume()
	print(self:GetTreeName()..".OnResume")
end

function TbaBase:OnAbort()
	print(self:GetTreeName()..".OnAbort")
end

function TbaBase:OnUpdate()
	--print(self:GetTreeName()..".OnUpdate")
end

function TbaBase:OnDisturb(other)
	return TbaBase.DisturbType[self.name][other.name]
end

function TbaBase:OnChildJoin(child)
	print(self:GetTreeName()..".OnChildJoin("..child.name..")")
end

function TbaBase:OnChildStart(child)
	print(self:GetTreeName()..".OnChildStart("..child.name..")")
end

function TbaBase:OnChildSuspend(child)
	print(self:GetTreeName()..".OnChildSuspend("..child.name..")")
end

function TbaBase:OnChildResume(child)
	print(self:GetTreeName()..".OnChildResume("..child.name..")")
end

function TbaBase:OnChildAbort(child)
	print(self:GetTreeName()..".OnChildAbort("..child.name..")")
end
