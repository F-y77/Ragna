-- This information tells other players more about the mod
name = "Ragna the Bloodedge"
description = "来自苍翠默示录的噬血狂战士 - 拉格纳\n\n- 血之镰刃使用者\n- 噬血狂战士\n- 黑兽化之力"
author = "Va6gn"
version = "1.0.3"

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
-- forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- Character mods are required by all clients
all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
    "character",
    "blazblue",
    "ragna"
}

--configuration_options = {}

-- 配置选项（如果需要让玩家自定义一些设置，可以在这里添加）
configuration_options = {
    -- {
    --     name = "ragna_health",
    --     label = "拉格纳生命值",
    --     options = {
    --         {description = "标准 (200)", data = 200},
    --         {description = "较高 (250)", data = 250},
    --         {description = "黑兽化 (300)", data = 300}
    --     },
    --     default = 200
    -- }
}
