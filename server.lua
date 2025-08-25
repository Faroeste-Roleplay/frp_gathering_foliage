


API = Proxy.getInterface("API")
cAPI = Tunnel.getInterface("API")

local toItem = {
    --- tem spawn
    ["BLACK_CURRANT_DEF"] = "herb_blackcurrant", 
    ["OREGANO_DEF"] = "herb_oregano",
    ["AMERICAN_GINSENG_ROOT_DEF"] = "herb_american_ginseng", 
    ["BLACK_BERRY_DEF"] = "herb_black_berry",
    ["DESERT_SAGE_DEF"] = "herb_desert_sage", 
    ["BURDOCK_ROOT_DEF"] = "herb_burdock_root",
    ["COMMON_BULRUSH_DEF"] = "herb_common_bullrush",
    ["WILD_MINT_DEF"] = "herb_wild_mint",
    ["PARASOL_MUSHROOM_DEF"] = "herb_parasol_mushroom",
    ["RAMS_HEAD_DEF"] = "herb_rams_head",
    ["PRAIRIE_POPPY_DEF"] = "herb_prairie_poppy", 
    ["WILD_FEVERFEW_DEF"] = "herb_wild_feverfew",
    ["WILD_CARROT_DEF"] = "herb_wild_carrot",
    ["ALASKAN_GINSENG_ROOT_DEF"] = "herb_alaskan_ginseng",

        --- não tem spawn
    ["ORCHID_VANILLA_DEF"] = "herb_vanilla_flower",
    ["WINTERGREEN_BERRY_DEF"] = "herb_wintergreen_berry",
    ["VIOLET_SNOWDROP_DEF"] = "herb_violet_snowdrop",
    ["RED_SAGE_DEF"] = "herb_red_sage",
    ["ED_RASPBERRY_DEF"] = "herb_red_raspberry",
    ["OLEANDER_SAGE_DEF"] = "herb_oleander_sage",
    ["MILKWEED_DEF"] = "herb_milkweed",
    ["INDIAN_TOBACCO_DEF"] = "herb_indian_tobacco",
    ["HUMMINGBIRD_SAGE_DEF"] = "herb_hummingbird_sage",
    ["GOLDEN_CURRANT_DEF"] = "herb_golden_currant",
    ["EVERGREEN_HUCKLEBERRY_DEF"] = "herb_evergreen_huckleberry",
    ["ENGLISH_MACE_DEF"] = "herb_english_mace",
    ["CREEPING_THYME_DEF"] = "herb_creeping_thyme",
    ["CHANTERELLES_DEF"] = "herb_chanterelle",
    ["BAY_BOLETE_DEF"] = "herb_bay_bolete",
}

local SUPPRESSION_WEAROFF_SECONDS = 10 * 60

local popSuppressed = {}

RegisterNetEvent("HERB_POPULATION:Gathered")
AddEventHandler("HERB_POPULATION:Gathered",function(compositeTypeFormatted, indexComposite, index)
	local playerId = source

    if not IsVectorIndexSuppressed(indexComposite, index) then
        local item = toItem[compositeTypeFormatted]
        local amount = math.random(3, 7)
        exports.ox_inventory:AddItem(playerId, item, amount)
        SetVectorIndexSuppressed(indexComposite, index, true)
    end
end)

function IsVectorIndexSuppressed(indexComposite, index)
    return popSuppressed[indexComposite] ~= nil and popSuppressed[indexComposite][index] ~= nil or false
end

function SetVectorIndexSuppressed(indexComposite, index, suppress)
    if suppress then
        if popSuppressed[indexComposite] == nil then
            popSuppressed[indexComposite] = {}
        end

        popSuppressed[indexComposite][index] = os.time() + SUPPRESSION_WEAROFF_SECONDS
    else
        popSuppressed[indexComposite][index] = nil
    end
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1 * 60 * 1000) -- 1 Min

            local timestamp = os.time()

            for indexComposite, v in pairs(popSuppressed) do
                for index, suppression_wearoff_timestamp in pairs(v) do
                    if suppression_wearoff_timestamp <= timestamp then
                        SetVectorIndexSuppressed(indexComposite, index, false)
                    end
                end
            end
        end
    end
)

RegisterNetEvent("FRP:onCharacterLoaded", function(User)
    TriggerClientEvent("HERB_POPULATION:SetPopSuppressed", User:GetSource(), popSuppressed)
end)
