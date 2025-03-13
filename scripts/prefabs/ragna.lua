local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    --Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("ANIM", "anim/ragna.zip"),
}

-- 角色基础属性
TUNING.RAGNA_HEALTH = 200
TUNING.RAGNA_HUNGER = 150
TUNING.RAGNA_SANITY = 120

-- 初始物品
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.RAGNA = {
    "bloodedge",  -- 血刃
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.RAGNA
end
local prefabs = FlattenTree(start_inv, true)

-- 复活相关
local function onbecamehuman(inst)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ragna_speed_mod", 1.1)  -- 略微提高移动速度
end

local function onbecameghost(inst)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ragna_speed_mod")
end

local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

-- 客户端初始化
local function common_postinit(inst) 
    inst.MiniMapEntity:SetIcon("ragna.tex")
    
    -- 添加角色特殊标签
    inst:AddTag("ragna")
    inst:AddTag("bloodedge")
    inst:AddTag("azuregrimoire")
end

-- 服务端初始化
local function master_postinit(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    
    -- 使用独特的声音
    inst.soundsname = "wilson"  -- 临时使用威尔逊的声音
    
    -- 基础属性设置
    inst.components.health:SetMaxHealth(TUNING.RAGNA_HEALTH)
    inst.components.hunger:SetMax(TUNING.RAGNA_HUNGER)
    inst.components.sanity:SetMax(TUNING.RAGNA_SANITY)
    
    -- 战斗属性
    inst.components.combat.damagemultiplier = 1.25  -- 伤害提升
    
    -- 饥饿速度
    inst.components.hunger.hungerrate = 1.2 * TUNING.WILSON_HUNGER_RATE
    
    -- 血之收割效果：击杀生物回复生命值
    inst:ListenForEvent("killed", function(inst, data)
        if data.victim and data.victim.components.health then
            inst.components.health:DoDelta(5)
        end
    end)
    
    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("ragna", prefabs, assets, common_postinit, master_postinit) 