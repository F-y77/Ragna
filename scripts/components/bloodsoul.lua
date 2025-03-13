local BloodSoul = Class(function(self, inst)
    self.inst = inst
    self.current = 100
    self.max = 100
    
    -- 发送血魂值变化事件
    self.inst:ListenForEvent("bloodsouldelta", function(inst, data)
        if self.current ~= data.newvalue then
            self.current = data.newvalue
            self:DoDelta(0)
        end
    end)
end)

function BloodSoul:SetMax(amount)
    self.max = amount
    self.current = math.min(self.current, self.max)
end

function BloodSoul:SetCurrent(amount)
    local old = self.current
    self.current = math.clamp(amount, 0, self.max)
    
    if old ~= self.current then
        self.inst:PushEvent("bloodsouldelta", {
            oldpercent = old / self.max,
            newpercent = self.current / self.max,
            oldvalue = old,
            newvalue = self.current
        })
    end
end

function BloodSoul:DoDelta(delta)
    self:SetCurrent(self.current + delta)
end

function BloodSoul:GetPercent()
    return self.current / self.max
end

function BloodSoul:GetCurrent()
    return self.current
end

return BloodSoul 