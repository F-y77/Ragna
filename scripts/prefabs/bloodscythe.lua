local Assets = { 
    -- 动画文件
    Asset("ANIM", "anim/bloodscythe.zip"),
    Asset("ANIM", "anim/bloodscythe_ground.zip"),
    -- 物品栏图标
    Asset("ATLAS", "images/inventoryimages/bloodscythe.xml"),
    Asset("IMAGE", "images/inventoryimages/bloodscythe.tex"),
}

-- 检查是否为拉格纳
local function CheckOwner(inst, owner)
    return owner:HasTag("ragna")
end

-- 攻击效果：每次攻击恢复10点生命值，有25%概率造成额外伤害
local function OnAttack(inst, owner, target)
    if owner.components.health then
        -- 生命恢复效果
        owner.components.health:DoDelta(10)
        
        -- 25%概率造成额外伤害
        if math.random() < 0.25 and target.components.health then
            target.components.health:DoDelta(-20)
            -- 播放特效
            if target.components.combat then
                target:PushEvent("attacked", {attacker = owner, damage = 20})
            end
        end
    end
end

-- 装备时的效果
local function OnEquip(inst, owner)
    -- 检查是否为拉格纳
    if not CheckOwner(inst, owner) then
        owner.components.inventory:DropItem(inst)
        if owner.components.talker then
            owner.components.talker:Say("这把武器只有拉格纳才能驾驭。")
        end
        return
    end
    
    -- 更换手持动画
    owner.AnimState:OverrideSymbol("swap_object", "bloodscythe", "swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    
    -- 添加攻击事件监听
    inst:ListenForEvent("onattack", function(owner, data) 
        OnAttack(inst, owner, data.target) 
    end, owner)
end

-- 卸下装备时的效果
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    -- 移除攻击事件监听
    inst:RemoveEventCallback("onattack", OnAttack, owner)
end

-- 主函数：创建武器实体
local function MainFunction()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    -- 添加小地图图标
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("bloodscythe.tex")

    -- 设置地面显示动画
    inst.AnimState:SetBank("bloodscythe_ground")
    inst.AnimState:SetBuild("bloodscythe_ground")
    inst.AnimState:PlayAnimation("anim")

    -- 添加标签
    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("bloodscythe")
    inst:AddTag("ragna_unique")

    MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- 添加组件
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "bloodscythe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bloodscythe.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    inst.components.equippable.restrictedtag = "ragna"

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(85)         -- 基础伤害85
    inst.components.weapon:SetRange(6, 8)        -- 攻击范围6-8

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/bloodscythe", MainFunction, Assets) 