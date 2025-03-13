local assets = {
    Asset("ANIM", "anim/bloodedge.zip"),
    Asset("ANIM", "anim/bloodedge_ground.zip"),
    Asset("ATLAS", "images/inventoryimages/bloodedge.xml"),
    Asset("IMAGE", "images/inventoryimages/bloodedge.tex"),
}

-- 新增专属装备检查函数
local function CheckOwner(inst, owner)
    return owner:HasTag("ragna")
end

-- 创建一个变量来存储回调函数
local function OnAttack(inst, owner)
    if owner.components.health then
        owner.components.health:DoDelta(5)
    end
end

local function OnEquip(inst, owner)
    -- 确保只有拉格纳角色可以装备
    if not CheckOwner(inst, owner) then
        owner.components.inventory:DropItem(inst)
        if owner.components.talker then
            owner.components.talker:Say(STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLOODEDGE_LOCKED)
        end
        return
    end
    
    owner.AnimState:OverrideSymbol("swap_object", "bloodedge", "swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    
    -- 使用存储的回调函数
    if owner.components.health then
        inst:ListenForEvent("onattack", function() OnAttack(inst, owner) end, owner)
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    -- 正确移除事件监听器
    inst:RemoveEventCallback("onattack", function() OnAttack(inst, owner) end, owner)
end

local function MainFunction()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bloodedge_ground")
    inst.AnimState:SetBuild("bloodedge_ground")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("weapon")
    inst:AddTag("raga_unique") -- 新增专属标签
    
    -- 禁用地图图标（可选）
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("bloodedge.tex")

    MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "bloodedge"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bloodedge.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    inst.components.equippable.restrictedtag = "ragna" -- 确保绑定角色标签

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetRange(3, 5)
    inst.components.weapon:SetElectric()

    -- 保留这些标签
    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")

    MakeHauntableLaunch(inst)

    return inst
end

-- 在字符串表中添加新提示
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLOODEDGE_LOCKED = "这把剑在抗拒我的使用！"
STRINGS.CHARACTERS.RAGNA.DESCRIBE.BLOODEDGE = "老伙计，让我们大闹一场吧！"

return Prefab("common/inventory/bloodedge", MainFunction, assets)