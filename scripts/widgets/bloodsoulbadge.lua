local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"

local BloodSoulBadge = Class(Widget, function(self, owner)
    Widget._ctor(self, "BloodSoulBadge")
    
    self.owner = owner
    
    -- 使用游戏内置图标
    self.bg = self:AddChild(Image("images/hud.xml", "health.tex"))
    self.bg:SetScale(0.8, 0.8)
    self.bg:SetTint(0.8, 0, 0, 1) -- 设置为红色
    
    -- 添加血魂值文本
    self.num = self:AddChild(Text(NUMBERFONT, 28))
    self.num:SetPosition(0, 0)
    self.num:SetString("100")
    
    -- 添加标签文本
    self.label = self:AddChild(Text(NUMBERFONT, 16))
    self.label:SetPosition(0, -25)
    self.label:SetString("血魂")
    
    -- 初始化血魂值
    self.current = 100
    self.max = 100
    
    -- 更新显示
    self:UpdateDisplay()
end)

function BloodSoulBadge:SetPercent(percent)
    self.current = math.floor(percent * self.max)
    self:UpdateDisplay()
end

function BloodSoulBadge:UpdateDisplay()
    self.num:SetString(tostring(self.current))
    
    -- 根据血魂值改变颜色
    if self.current > 66 then
        self.bg:SetTint(0.8, 0, 0, 1) -- 鲜红色
    elseif self.current > 33 then
        self.bg:SetTint(0.6, 0, 0, 1) -- 暗红色
    else
        self.bg:SetTint(0.4, 0, 0, 1) -- 深红色
    end
end

return BloodSoulBadge 