  -- DONT TOUCH
local spawned = false

local outfits = {
    ['Male Mechanic Coveralls'] = {
        category = 'Construction',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 0, 0 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 5, 1 },
            { 4, 40, 2 },
            { 5, 1, 1 },
            { 6, 25, 1 },
            { 7, 1, 1 },
            { 8, 16, 1 },
            { 9, 1, 1 },
            { 10, 1, 1 },
            { 11, 67, 2 },
        },
    },
    ['Male Private Contractor'] = {
        category = 'Construction',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 26, 1 },
            { 1, 16, 10 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 64, 1 },
            { 4, 1, 11 },
            { 5, 49, 1 },
            { 6, 13, 1 },
            { 7, 1, 1 },
            { 8, 90, 1 },
            { 9, 4, 1 },
            { 10, 1, 1 },
            { 11, 57, 1 },
        },
    },
    ['Female Private Contractor'] = {
        category = 'Construction',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 54, 1 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 73, 1 },
            { 4, 5, 2 },
            { 5, 49, 1 },
            { 6, 27, 1 },
            { 7, 1, 1 },
            { 8, 57, 1 },
            { 9, 6, 1 },
            { 10, 1, 1 },
            { 11, 50, 1 },
        },
    },
    ['Male Public Worker'] = {
        category = 'Construction',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 61, 2 },
            { 1, 16, 10 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 64, 1 },
            { 4, 50, 4 },
            { 5, 49, 1 },
            { 6, 52, 4 },
            { 7, 1, 1 },
            { 8, 91, 1 },
            { 9, 4, 3 },
            { 10, 1, 1 },
            { 11, 3, 6 },
        },
    },
    ['Female Public Worker'] = {
        category = 'Construction',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 61, 1 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 82, 1 },
            { 4, 5, 2 },
            { 5, 49, 1 },
            { 6, 27, 1 },
            { 7, 1, 1 },
            { 8, 55, 1 },
            { 9, 6, 3 },
            { 10, 1, 1 },
            { 11, 118, 1 },
        },
    },
    ['Male Public Worker Coveralls'] = {
        category = 'Construction',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 61, 1 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 67, 1 },
            { 4, 40, 3 },
            { 5, 1, 1 },
            { 6, 25, 1 },
            { 7, 1, 1 },
            { 8, 16, 1 },
            { 9, 11, 5 },
            { 10, 1, 1 },
            { 11, 67, 3 },
        },
    },
    ['Female Public Worker Coveralls'] = {
        category = 'Construction',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 61, 2 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 76, 1 },
            { 4, 40, 3 },
            { 5, 49, 1 },
            { 6, 27, 1 },
            { 7, 1, 1 },
            { 8, 15, 1 },
            { 9, 1, 1 },
            { 10, 1, 1 },
            { 11, 61, 3 },
        },
    },
}

local function setOutfit(outfit)
    local ped = PlayerPedId()
    RequestModel(outfit.ped)
    while not HasModelLoaded(outfit.ped) do
        Wait(0)
    end
    if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
        SetPlayerModel(PlayerId(), outfit.ped)
    end
    ped = PlayerPedId()

    for _, comp in ipairs(outfit.components) do
       SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
    end
    for _, comp in ipairs(outfit.props) do
        if comp[2] == 0 then
            ClearPedProp(ped, comp[1])
        else
            SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
        end
    end
end

local categoryOutfits = {}

for name, outfit in pairs(outfits) do
    if not categoryOutfits[outfit.category] then
        categoryOutfits[outfit.category] = {}
    end
    categoryOutfits[outfit.category][name] = outfit
end

-- Menu 

local menuPool = NativeUI.CreatePool()
local mainMenu = NativeUI.CreateMenu('SADOT Job', "~g~San Andreas Department of Transportation", 1320, 0)
menuPool:MouseControlsEnabled(false)
menuPool:ControlDisablingEnabled(false)
for name, list in pairs(categoryOutfits) do
    local subMenu = menuPool:AddSubMenu(mainMenu, name, 1320, 0)
    for id, outfit in pairs(list) do
        outfit.item = NativeUI.CreateItem(id, 'Select this job.', "", 1320, 0)
        subMenu:AddItem(outfit.item)
    end
    subMenu.OnItemSelect = function(sender, item, index)
        -- find the outfit
        for _, outfit in pairs(list) do
            if outfit.item == item then
                CreateThread(function()
                    setOutfit(outfit)
					ShowNotification(text)
                end)
            end
        end
    end
end

local submenu = menuPool:AddSubMenu(mainMenu, "Job Vehicles", "", 0)
local Item3 = NativeUI.CreateItem("CAT 660 Truck", "")
    Item3.Activated = function(ParentMenu, SelectedItem)
    SpawnVehicle('ct660')
	spawned = true
end
submenu:AddItem(Item3)	
local Item3 = NativeUI.CreateItem("CAT 660 Dumptruck", "")
    Item3.Activated = function(ParentMenu, SelectedItem)
    SpawnVehicle('ct660dump')
	spawned = true
end
submenu:AddItem(Item3)	
local Item3 = NativeUI.CreateItem("CAT Motorgrader", "")
    Item3.Activated = function(ParentMenu, SelectedItem)
    SpawnVehicle('motorgrader')
	spawned = true
end
submenu:AddItem(Item3)	
local Item3 = NativeUI.CreateItem("CAT 259 Skid Steer", "")
    Item3.Activated = function(ParentMenu, SelectedItem)
	SpawnVehicle('motorgrader')
    spawned = true
end
submenu:AddItem(Item3)	
local Item3 = NativeUI.CreateItem("CAT 745C", "")
    Item3.Activated = function(ParentMenu, SelectedItem)
	SpawnVehicle('cat745c')
    spawned = true
end
submenu:AddItem(Item3)	
local Item3 = NativeUI.CreateItem("excavator", "")
    Item3.Activated = function(ParentMenu, SelectedItem)
	SpawnVehicle('excavator')
    spawned = true
end
submenu:AddItem(Item3)	
local Item3 = NativeUI.CreateItem("DOT Silverado", "")
    Item3.Activated = function(ParentMenu, SelectedItem)
	SpawnVehicle('dump')
    spawned = true
end
submenu:AddItem(Item3)	
local Item3 = NativeUI.CreateItem("Reset Vehicle", "")
    Item3.Activated = function(ParentMenu, SelectedItem)
    spawned = false
end
submenu:AddItem(Item3)
menuPool:Add(mainMenu)
menuPool:RefreshIndex()
menuPool:MouseControlsEnabled(false)
menuPool:ControlDisablingEnabled(false)

-- Threads

-- Clockin Coords
local coords2 = {
    {x=2746.02, y=2788.93, z=35.46, h=43.62}, -- Quarry GTA5 Mods
    --{x=318.24, y=-365.27, z=5.46, h=102.01} -- Liberty City
}


AddEventHandler('onClientMapStart', function()
    blipenable()
end)

function blipenable()
    for _, info in pairs(coords2) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, 477)
		SetBlipAsShortRange(info.blip, true)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 1.0)
		SetBlipColour(info.blip, 5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Construction Job")
		EndTextCommandSetBlipName(info.blip)
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(coords2) do
            -- Draw Marker Here --
            DrawMarker(2, coords2[k].x, coords2[k].y, coords2[k].z, 0, 0, 0, 0, 0, 0, 0.501, 1.0001, 0.5001, 255, 255, 255, 200, 0, 0, 0, 1)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(coords2) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, coords2[k].x, coords2[k].y, coords2[k].z)
            if dist <= 1.2 then
			DrawText3D(coords2[k].x, coords2[k].y, coords2[k].z, "~r~Press E to open menu.")
				if IsControlJustPressed(1,51) then -- "E"
					mainMenu:Visible(not mainMenu:Visible())
				end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        menuPool:ProcessMenus()
    end
end)	
	
-- Functions

-- Shows a notification on the player's screen 
function ShowNotification(text)
	myname = NetworkPlayerGetName(PlayerId())
	SetNotificationTextEntry("STRING");
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "~r~Welcome Back", myname .. ".");
	DrawNotification(false, false)
end

function ShowNotification2(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

DrawText3D = function(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  
	local scale = 0.45
   
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0150, 0.030 + factor , 0.030, 66, 66, 66, 150)
	end
end

function SpawnVehicle(Model)
	Model = GetHashKey(Model)
	if IsModelValid(Model) and spawned == false then
		RequestModel(Model)
		while not HasModelLoaded(Model) do
			Citizen.Wait(0)
		end
		local veh = CreateVehicle(Model, 302.89, -355.45, 4.9, 298.32, true, true)
		SetVehicleHasBeenOwnedByPlayer(veh, false)
		-- SetEntityAsMissionEntity(Model)
		SetModelAsNoLongerNeeded(Model)
		Wait(1000)
		ShowNotification2('~r~Vehicle Spawned.')
		spawned = true
	elseif spawned == true then
			ShowNotification2('~r~Already Spawned, Press Reset.')
		return
	end
end