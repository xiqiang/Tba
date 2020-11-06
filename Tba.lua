
Tba = createClass(nil,"Tba")

-- 行为接入
function Tba:OnJoin()
end

-- 行为开始
function Tba:OnStart()
end

-- 行为更新
function Tba:OnProcess(deltaTime)
end

-- 行为暂停
function Tba:OnSuspend()
end

-- 行为恢复
function Tba:OnResume()
end

-- 行为结束
function Tba:OnAbort()
end

-- 帧更新
function Tba:OnUpdate(deltaTime)
end

-- 对兄弟行为加入时的反应
function Tba:OnDisturb(other)
	return "none"
end

-- 子行为接入
function Tba:OnChildJoin(child)
end

-- 子行为开始
function Tba:OnChildStart(child)
end

-- 子行为暂停
function Tba:OnChildSuspend(child)
end

-- 子行为恢复
function Tba:OnChildResume(child)
end

-- 子行为结束
function Tba:OnChildAbort(child)
end

function Tba:ctor()
	self.childs = {}
	self.newChilds = {}
	self.waitSiblings = {}
	self.state = "initial"

	self.CmdFun = 
	{
		initial 	= { run = Tba.DelegateStart,  suspend = nil,                 abort = nil               },
		running 	= { run = self.OnProcess,     suspend = Tba.DelegateSuspend, abort = nil               },
		suspended 	= { run = Tba.DelegateResume, suspend = nil,                 abort = nil               },
		aborting 	= { run = nil,                suspend = nil,                 abort = Tba.DelegateAbort },
	}
end	

-- 是否活动
function Tba:IsActive()
	if #self.waitSiblings > 0 then
		return false
	else
		local parent = self.parent
		return parent == nil or Tba.IsActive(parent)
	end
	return true
end

-- 结束
function Tba:Abort()
	if self.state == "aborting" then
		return
	end

	Tba.Execute(self, "abort")
	self:Clear()
end

-- 添加子行为
function Tba:Add(child)
	local disturb, funs = Tba.Disturb(child, self)
	if not disturb then
		return
	end
	
	table.insert(self.newChilds, child)
	child.parent = self
	child:DelegateJoin()

	local DisturbFun = Tba.DisturbFun
	for k,v in pairs(funs) do
		local fun = DisturbFun[v]
		if fun then
			fun(k, child)
		end
	end

	return child
end

-- 移除子行为
function Tba:Remove(child)
	child:Abort()
end

-- 清空子行为
function Tba:Clear()
	local childs = self.childs
	for i = 1,#childs do
		local c = childs[i]
		c:Abort()
	end	
	
	local newChilds = self.newChilds
	for i = 1,#newChilds do
		local c = newChilds[i]
		c:Abort()
	end
end

Tba.CmdState = 
{
	initial 	= { run = "running", 	suspend = "initial",	abort = "aborting"	},
	running 	= { run = "running", 	suspend = "suspended",	abort = "aborting"	},
	suspended 	= { run = "running", 	suspend = "suspended",	abort = "aborting"	},
	aborting 	= { run = "aborting", 	suspend = "aborting",	abort = "aborting"	},
}

Tba.DisturbFun = 
{
	none 		= nil,
	oppose 		= nil,
	abort 		= function(self, other) self:Abort() end,
	represe		= function(self, other) table.insert(other.waitSiblings, self) end,
	wait 		= function(self, other) table.insert(self.waitSiblings, other) end,
}

function Tba:Update(deltaTime)
    local childs = self.childs
    local newChilds = self.newChilds

    local ncc = #newChilds
    if ncc > 0 then
		for i = 1,ncc do
			local c = newChilds[i]
			table.insert(childs, c)
			newChilds[i] = nil
		end	
	end

	local cc = #childs
	if cc > 0 then
		local Update = Tba.Update
		local i = 1

		while i <= cc do
			local child = childs[i]			
			if child.invalid then
				table.remove(childs, i)
				cc = cc - 1
			else
				Update(child, deltaTime)				
				i = i + 1				
			end
		end
	end	

	local Execute = Tba.Execute
	if self.state ~= "aborting" then
		if Tba.IsActive(self) then
			self:OnUpdate()	
			if #childs + #newChilds == 0 then
				Execute(self, "run", deltaTime)
			else
				Execute(self, "suspend")
			end
		else
			Execute(self, "suspend")
		end
	else
		Execute(self, "abort")
		self.invalid = true
	end
end

function Tba:Disturb(parent)
	local Collect = Tba.DistrubCollect
	local funs = {}

	if not Collect(funs, self, parent.childs) then
		return false
	end
	if not Collect(funs, self, parent.newChilds) then
		return false
	end
	
	return true, funs
end

function Tba.DistrubCollect(funs, tba, siblings)
	for i = 1,#siblings do
		local s = siblings[i]
		if s.state ~= "aborting" then
			local disturb = s:OnDisturb(tba)
			if disturb ~= "oppose" then
				funs[s] = disturb
			else
				return false
			end
		end
	end

	return true
end

function Tba:Execute(cmd, param)
	local fun = self.CmdFun[self.state][cmd]
	self.state = Tba.CmdState[self.state][cmd]
	
	if fun then
		fun(self, param)
	end
end

function Tba:DelegateJoin()
	self:OnJoin()
	local parent = self.parent
	if parent then
		parent:OnChildJoin(self)
	end
end

function Tba:DelegateStart()
	self:OnStart()
	local parent = self.parent
	if parent then
		parent:OnChildStart(self)
	end
end

function Tba:DelegateSuspend()
	self:OnSuspend()
	local parent = self.parent
	if parent then
		parent:OnChildSuspend(self)
	end
end

function Tba:DelegateResume()
	self:OnResume()
	local parent = self.parent
	if parent then
		parent:OnChildResume(self)
	end
end

function Tba:DelegateAbort()
	local parent = self.parent	
	if parent then
		local Raise = Tba.Raise
		Raise(self, parent.childs)
		Raise(self, parent.newChilds)
	end

	self:OnAbort()
	local parent = self.parent
	if parent then
		parent:OnChildAbort(self)
	end
end

function Tba:Raise(siblings)
	local Leave = Tba.RaiseLeave
	for i = 1,#siblings do
		local s = siblings[i]
		Leave(self, s.waitSiblings)
	end
end

function Tba.RaiseLeave(self, array)
	for i = 1,#array do
		local c = array[i]
		if c == self then
			table.remove(array, i)
			return
		end
	end
end
