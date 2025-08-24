local Scripts = {
    [126509999114328] = "https://raw.githubusercontent.com/Laspard69/Nullware-Hub/refs/heads/main/scripts/99nightsintheforest",
}

local placeId = game.PlaceId
local url = Scripts[placeId]
if not url or url == "" then
    error("[Loader] No script URL configured.")
end

print(("[Loader] PlaceId: %s | Using: %s"):format(placeId, url))

local ok, err = pcall(function()
    loadstring(game:HttpGet(url))()
end)

if not ok then
    warn("[Loader] Script failed to load:", err)
end
