local assets = {
	Asset( "ANIM", "anim/ragna.zip" ),
	Asset( "ANIM", "anim/ghost_ragna_build.zip" ),
}

local skins = {
	normal_skin = "ragna",
	ghost_skin = "ghost_ragna_build",
}

return CreatePrefabSkin("ragna_none",
{
	base_prefab = "ragna",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"RAGNA", "CHARACTER", "BASE"},
	build_name_override = "ragna",
	rarity = "Character",
}) 