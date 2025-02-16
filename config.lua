Config = {}

-- Framework seçimi ('esx' veya 'qb')
Config.Framework = 'qb'

-- Target sistemi seçimi ('qtarget', 'qb-target' veya false)
Config.UseTarget = 'qb-target'

-- Envanter sistemi ('ox_inventory', 'qb-inventory', 'esx_inventory')
Config.Inventory = 'qb-inventory'

-- Notify sistemi ('ox_lib', 'esx', 'qb', 'custom')
Config.Notify = 'qb'

-- Dil seçimi
Config.Locale = 'tr'

Config.CopKutusuMesafe = 2.0 -- Çöp kutusuna ne kadar yakın olunca etkileşime geçilebilir
Config.AramaZamani = 5000 -- Arama animasyonu süresi (ms)
Config.EsyaBulmaSansi = 70 -- Eşya bulma şansı (%)

-- Bekleme süreleri (ms)
Config.Bekleme = {
    AyniCop = 120000,  -- Aynı çöp kutusu için bekleme süresi (2 dakika)
    FarkliCop = 30000  -- Farklı çöp kutusu için bekleme süresi (30 saniye)
}

-- Karıştırılmış çöp kutuları için tablo
Config.KaristirilmisCoplar = {}

-- Bulunabilecek eşyalar ve şansları
Config.Esyalar = {
    {isim = "water_bottle", label = "Su Şişesi", sans = 30, miktar = {min = 1, max = 3}},
    {isim = "tosti", label = "Tost", sans = 50, miktar = {min = 1, max = 4}},
}

-- Karıştırılabilir çöp kutusu propları
Config.CopKutusuProplari = {
    -- Çöp konteynerleri
    `prop_dumpster_01a`,
    `prop_dumpster_02a`,
    `prop_dumpster_02b`,
    `prop_dumpster_3a`,
    `prop_dumpster_4a`,
    `prop_dumpster_4b`,

    -- Küçük çöp kutuları
    `prop_bin_01a`,
    `prop_bin_03a`,
    `prop_bin_04a`,
    `prop_bin_07a`,
    `prop_bin_08a`,
    `prop_bin_08open`,
    `prop_bin_12a`,

    -- Geri dönüşüm kutuları
    `prop_recyclebin_01a`,
    `prop_recyclebin_02_c`,
    `prop_recyclebin_02_d`,
    `prop_recyclebin_02a`,
    `prop_recyclebin_03_a`,
    `prop_recyclebin_04_a`,
    `prop_recyclebin_04_b`,
    `prop_recyclebin_05_a`,
}

-- Her prop için özel offset değerleri (prop yüksekliği için)
Config.PropOffsets = {
    [`prop_dumpster_01a`] = 1.5,
    [`prop_dumpster_02a`] = 1.5,
    [`prop_dumpster_02b`] = 1.5,
    [`prop_dumpster_3a`] = 1.5,
    [`prop_dumpster_4a`] = 1.5,
    [`prop_dumpster_4b`] = 1.5,
    [`prop_bin_01a`] = 1.0,
    [`prop_bin_03a`] = 1.0,
    [`prop_bin_04a`] = 1.0,
    [`prop_bin_07a`] = 1.0,
    [`prop_bin_08a`] = 1.0,
    [`prop_bin_08open`] = 1.0,
    [`prop_bin_12a`] = 1.0,
    [`prop_recyclebin_01a`] = 1.0,
    [`prop_recyclebin_02_c`] = 1.0,
    [`prop_recyclebin_02_d`] = 1.0,
    [`prop_recyclebin_02a`] = 1.0,
    [`prop_recyclebin_03_a`] = 1.0,
    [`prop_recyclebin_04_a`] = 1.0,
    [`prop_recyclebin_04_b`] = 1.0,
    [`prop_recyclebin_05_a`] = 1.0,
}