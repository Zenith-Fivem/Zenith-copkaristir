Locales = {}

Locales['tr'] = {
    ['cop_arama'] = 'Çöp karıştırılıyor...',
    ['cop_bos'] = 'Hiçbir şey bulamadın!',
    ['envanter_dolu'] = 'Envanterin dolu!',
    ['esya_bulundu'] = '%d adet %s buldun!',
    ['cop_karistir'] = 'Çöp Karıştır',
    ['cop_karistir_aciklama'] = 'Çöpü karıştırarak değerli eşyalar bulabilirsin',
}

function _U(str, ...)
    local args = {...}
    if Locales[Config.Locale] then
        if Locales[Config.Locale][str] then
            if #args > 0 then
                return string.format(Locales[Config.Locale][str], table.unpack(args))
            else
                return Locales[Config.Locale][str]
            end
        else
            return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
        end
    else
        return 'Locale [' .. Config.Locale .. '] does not exist'
    end
end