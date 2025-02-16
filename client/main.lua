local Framework = nil
local aramaDurumu = false
local sonAramaZamani = 0
local sonAramaProp = nil

-- Framework başlatma
Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        while Framework == nil do
            TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)
            Citizen.Wait(0)
        end
    elseif Config.Framework == 'qb' then
        Framework = exports['qb-core']:GetCoreObject()
    end
end)

-- Notify fonksiyonu
function SendNotification(message, type)
    if Config.Notify == 'ox_lib' then
        lib.notify({
            title = 'Çöp Karıştırma',
            description = message,
            type = type
        })
    elseif Config.Notify == 'esx' then
        Framework.ShowNotification(message)
    elseif Config.Notify == 'qb' then
        Framework.Functions.Notify(message, type)
    end
end

-- Prop kontrolü için fonksiyon
function IsValidTrashProp(prop)
    for _, validProp in ipairs(Config.CopKutusuProplari) do
        if GetEntityModel(prop) == validProp then
            return true
        end
    end
    return false
end

-- Target sistemini başlat
Citizen.CreateThread(function()
    if Config.UseTarget then
        -- Prop tabanlı target sistemi
        if Config.UseTarget == 'qtarget' then
            exports.qtarget:AddTargetModel(Config.CopKutusuProplari, {
                options = {
                    {
                        icon = "fas fa-dumpster",
                        label = _U('cop_karistir'),
                        action = function()
                            CopKaristir()
                        end
                    },
                },
                distance = 2.0
            })
        elseif Config.UseTarget == 'qb-target' then
            exports['qb-target']:AddTargetModel(Config.CopKutusuProplari, {
                options = {
                    {
                        type = "client",
                        icon = "fas fa-dumpster",
                        label = _U('cop_karistir'),
                        action = function()
                            CopKaristir()
                        end
                    },
                },
                distance = 2.0
            })
        end
    else
        -- Target sistemi kapalıysa prop kontrolü yap
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local closestObject, closestDistance = nil, 999999.9

                for _, propHash in ipairs(Config.CopKutusuProplari) do
                    local prop = GetClosestObjectOfType(coords.x, coords.y, coords.z, 2.0, propHash, false, false, false)
                    if prop ~= 0 then
                        local propCoords = GetEntityCoords(prop)
                        local distance = #(coords - propCoords)

                        if distance < closestDistance then
                            closestObject = prop
                            closestDistance = distance
                        end
                    end
                end

                if closestObject and closestDistance < Config.CopKutusuMesafe and not aramaDurumu then
                    local propModel = GetEntityModel(closestObject)
                    local offset = Config.PropOffsets[propModel] or 1.0
                    local propCoords = GetEntityCoords(closestObject)

                    DrawMarker(2, propCoords.x, propCoords.y, propCoords.z + offset,
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        0.3, 0.3, 0.3, 255, 255, 255, 100,
                        false, true, 2, nil, nil, false)

                    Framework.ShowHelpNotification(_U('cop_karistir'))

                    if IsControlJustReleased(0, 38) then
                        SetEntityHeading(playerPed, GetEntityHeading(closestObject))
                        CopKaristir()
                    end
                end
            end
        end)
    end
end)

function CopKaristir()
    if aramaDurumu then return end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local simdikiZaman = GetGameTimer()

    -- Genel bekleme süresi kontrolü
    if (simdikiZaman - sonAramaZamani) < Config.Bekleme.FarkliCop then
        local kalanSure = math.ceil((Config.Bekleme.FarkliCop - (simdikiZaman - sonAramaZamani)) / 1000)
        SendNotification(string.format("Başka bir çöp aramak için %d saniye beklemelisin!", kalanSure), 'error')
        return
    end

    -- En yakın çöp kutusunu bul
    local closestObject = nil
    local closestDistance = 999999.9

    for _, propHash in ipairs(Config.CopKutusuProplari) do
        local prop = GetClosestObjectOfType(coords.x, coords.y, coords.z, 2.0, propHash, false, false, false)
        if prop ~= 0 then
            local propCoords = GetEntityCoords(prop)
            local distance = #(coords - propCoords)

            if distance < closestDistance then
                closestObject = prop
                closestDistance = distance
            end
        end
    end

    if closestObject then
        local propNetId = NetworkGetNetworkIdFromEntity(closestObject)

        -- Aynı çöp kutusu kontrolü
        if Config.KaristirilmisCoplar[propNetId] then
            local gecenSure = simdikiZaman - Config.KaristirilmisCoplar[propNetId]
            if gecenSure < Config.Bekleme.AyniCop then
                local kalanDakika = math.ceil((Config.Bekleme.AyniCop - gecenSure) / 60000)
                SendNotification(string.format("Bu çöpü tekrar karıştırmak için %d dakika beklemelisin!", kalanDakika), 'error')
                return
            end
        end

        aramaDurumu = true
        sonAramaZamani = simdikiZaman
        sonAramaProp = propNetId

        -- Oyuncuyu çöp kutusuna doğru yönlendir
        local propCoords = GetEntityCoords(closestObject)
        TaskTurnPedToFaceEntity(playerPed, closestObject, -1)
        Wait(1000)

        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

        if Config.Notify == 'ox_lib' then
            if lib.progressBar({
                duration = Config.AramaZamani,
                label = _U('cop_arama'),
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
            }) then
                FinishSearch(propNetId)
            else
                aramaDurumu = false
                ClearPedTasks(playerPed)
            end
        else
            SendNotification(_U('cop_arama'), 'info')
            Citizen.Wait(Config.AramaZamani)
            FinishSearch(propNetId)
        end
    end
end

function FinishSearch(propNetId)
    ClearPedTasks(PlayerPedId())

    if math.random(100) <= Config.EsyaBulmaSansi then
        TriggerServerEvent('cop_karistirma:esyaBul')
        -- Çöp kutusunun son arama zamanını kaydet
        Config.KaristirilmisCoplar[propNetId] = GetGameTimer()
    else
        SendNotification(_U('cop_bos'), 'error')
    end

    aramaDurumu = false
    Citizen.Wait(1000)
end

-- Çöp kutusu zamanlarını temizleme
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        local simdikiZaman = GetGameTimer()

        for propNetId, sonZaman in pairs(Config.KaristirilmisCoplar) do
            if (simdikiZaman - sonZaman) > Config.Bekleme.AyniCop then
                Config.KaristirilmisCoplar[propNetId] = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    if GetCurrentResourceName() ~= 'zenith_copkaristir' then
        print('^1[HATA] Script ismi değiştirilmiş! Lütfen scriptin ismini "zenith_copkaristir" olarak değiştirin.^0')
        return
    end
end)