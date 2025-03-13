-- 添加必要的全局变量引用
GLOBAL.setmetatable(env, {__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

-- 引入制作栏和科技等级
RECIPETABS = GLOBAL.RECIPETABS
TECH = GLOBAL.TECH
TUNING = GLOBAL.TUNING
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient

local GLOBAL = GLOBAL
local STRINGS = GLOBAL.STRINGS

PrefabFiles = {
	"ragna",
	"ragna_none",
	"bloodedge",
    "bloodscythe",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/ragna.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/ragna.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/ragna.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ragna.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/ragna_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ragna_silho.xml" ),

    Asset( "IMAGE", "bigportraits/ragna.tex" ),
    Asset( "ATLAS", "bigportraits/ragna.xml" ),
	
	Asset( "IMAGE", "images/map_icons/ragna.tex" ),
	Asset( "ATLAS", "images/map_icons/ragna.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ragna.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ragna.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_ragna.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_ragna.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_ragna.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_ragna.xml" ),
	
	Asset( "IMAGE", "images/names_ragna.tex" ),
    Asset( "ATLAS", "images/names_ragna.xml" ),
	
	Asset( "IMAGE", "images/names_gold_ragna.tex" ),
    Asset( "ATLAS", "images/names_gold_ragna.xml" ),

    Asset("ATLAS", "images/inventoryimages/bloodedge.xml"),
    Asset("IMAGE", "images/inventoryimages/bloodedge.tex"),

    Asset("ATLAS", "images/inventoryimages/bloodscythe.xml"),
    Asset("IMAGE", "images/inventoryimages/bloodscythe.tex"),

}

AddMinimapAtlas("images/map_icons/ragna.xml")
AddMinimapAtlas("images/inventoryimages/bloodedge.xml")
AddMinimapAtlas("images/inventoryimages/bloodscythe.xml")

local require = GLOBAL.require

-- The character select screen lines
STRINGS.CHARACTER_TITLES.ragna = "噬血狂战士"
STRINGS.CHARACTER_NAMES.ragna = "拉格纳"
STRINGS.CHARACTER_DESCRIPTIONS.ragna = "*血之镰刃\n*噬血之魂\n*黑兽模式"
STRINGS.CHARACTER_QUOTES.ragna = "\"我是来讨债的！\""
STRINGS.CHARACTER_SURVIVABILITY.ragna = "困难"

-- Custom speech strings
STRINGS.CHARACTERS.RAGNA = require "speech_ragna"

-- The character's name as appears in-game 
STRINGS.NAMES.RAGNA = "拉格纳"
STRINGS.SKIN_NAMES.ragna_none = "拉格纳"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("ragna", "MALE", skin_modes)

-- 设置 bloodedge 武器的描述
STRINGS.NAMES.BLOODEDGE = "血之刃"
STRINGS.RECIPE_DESC.BLOODEDGE = "锋利无比，渴望战斗的利刃。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLOODEDGE = "这把剑似乎在吸取敌人的生命。"

-- ... existing code ...

-- 添加血之刃配方
AddRecipe("bloodedge",
    {
        Ingredient("redgem", 2),           -- 红宝石
        Ingredient("nightmarefuel", 5),    -- 噩梦燃料
        Ingredient("twigs", 4)             -- 树枝
    },
    RECIPETABS.WAR,                       -- 在战斗栏
    TECH.SCIENCE_ONE,                     -- 科技等级：科技机器
    nil,                                  -- placer
    nil,                                  -- min_spacing
    nil,                                  -- nounlock
    nil,                                  -- numtogive
    "ragna",                              -- builder_tag
    "images/inventoryimages/bloodedge.xml") -- atlas

-- 设置血镰描述(无法制作)
STRINGS.NAMES.BLOODSCYTHE = "血镰"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLOODSCYTHE = "这把镰刀散发着不祥的气息..."

-- 添加血魂值UI
AddClassPostConstruct("widgets/statusdisplays", function(self)
    if self.owner and self.owner.prefab == "ragna" then
        self.bloodsoul = self:AddChild(require("widgets/bloodsoulbadge")(self.owner))
        self.bloodsoul:SetPosition(-120, 40, 0)
        
        self.inst:ListenForEvent("bloodsouldelta", function(owner, data)
            if self.bloodsoul then
                self.bloodsoul:SetPercent(data.newpercent)
            end
        end, self.owner)
    end
end)

AddComponentPostInit("health", function(self, inst)
    if inst:HasTag("player") and inst.prefab == "ragna" then
        inst:AddComponent("bloodsoul")
    end
end)


