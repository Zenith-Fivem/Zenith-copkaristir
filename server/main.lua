if GetCurrentResourceName() ~= 'zenith_copkaristir' then
    print('^1[HATA] Script ismi değiştirilmiş! Lütfen scriptin ismini "zenith_copkaristir" olarak değiştirin.^0')
    return
end

local Framework = nil

-- Framework başlatma
if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
    Framework = ESX
elseif Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = QBCore
end

-- Item verme fonksiyonu
local function AddItem(source, item, count)
    local src = source

    if Config.Inventory == 'ox_inventory' then
        return exports.ox_inventory:AddItem(src, item, count)
    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem(item, count)
            return true
        end
    elseif Config.Framework == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.AddItem(item, count)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
            return true
        end
    end
    return false
end

-- Envanter kontrol fonksiyonu
local function CheckCanCarryItem(source, item, count)
    local src = source

    if Config.Inventory == 'ox_inventory' then
        return exports.ox_inventory:CanCarryItem(src, item, count)
    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            return true -- ESX genelde weight sistemi kullanır
        end
    elseif Config.Framework == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player and Player.Functions.CanCarryItem then
            return Player.Functions.CanCarryItem(item, count)
        end
    end
    return true
end

-- Notify fonksiyonu
local function SendNotification(source, message, type)
    if Config.Notify == 'ox_lib' then
        TriggerClientEvent('ox_lib:notify', source, {
            description = message,
            type = type
        })
    elseif Config.Framework == 'esx' then
        TriggerClientEvent('esx:showNotification', source, message)
    elseif Config.Framework == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, message, type)
    end
end

RegisterServerEvent('cop_karistirma:esyaBul')
AddEventHandler('cop_karistirma:esyaBul', function()
    local src = source
    local toplamSans = 0
    local rastgeleSayi = math.random(100)

    for _, esya in pairs(Config.Esyalar) do
        toplamSans = toplamSans + esya.sans

        if rastgeleSayi <= toplamSans then
            local miktar = math.random(esya.miktar.min, esya.miktar.max)

            if CheckCanCarryItem(src, esya.isim, miktar) then
                if AddItem(src, esya.isim, miktar) then
                    -- Notify mesajını doğrudan gönder
                    SendNotification(src, string.format("%d adet %s buldun!", miktar, esya.label), 'success')
                end
            else
                SendNotification(src, _U('envanter_dolu'), 'error')
            end
            break
        end
    end
end)