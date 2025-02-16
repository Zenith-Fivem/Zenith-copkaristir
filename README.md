# Çöp Karıştırma Scripti
Oyuncuların şehirdeki çöp kutularını karıştırarak eşya bulabilecekleri bir FiveM scripti.

## Özellikler
- 🎯 QB-Target ve QTarget desteği
- 📦 QB-Core, ESX ve OX Inventory desteği
- 🔔 QB, ESX ve OX Lib notify desteği
- ⏲️ Çöp kutusu başına bekleme süresi
- ⌛ Genel arama bekleme süresi
- 🗑️ Tüm çöp kutusu propları ile uyumlu
- 📋 Detaylı config dosyası
- 🌍 Çoklu dil desteği

## Kurulum
1. Scripti `resources` klasörüne atın
2. `server.cfg` dosyasına `ensure zenith_copkaristir` satırını ekleyin
3. Config dosyasından framework ve diğer ayarları yapın
4. Sunucuyu yeniden başlatın

## Config Ayarları
Config.Framework = 'qb' -- 'qb' veya 'esx'
Config.UseTarget = 'qb-target'-- 'qb-target', 'qtarget' veya false
Config.Inventory = 'qb' -- 'qb', 'esx' veya 'ox_inventory'
Config.Notify = 'qb' -- 'qb', 'esx' veya 'ox_lib'

## Dependencies
- QB-Core veya ESX
- QB-Target veya QTarget (opsiyonel)
- OX Lib

## Geliştirici
`.Zenith`

## Lisans
Bu script MIT lisansı altında dağıtılmaktadır.

## Destek
Herhangi bir sorun için Discord üzerinden iletişime geçebilirsiniz.

## Güncelleme Notları
v1.0.0
- İlk sürüm yayınlandı
- Framework desteği eklendi
- Target sistemi entegre edildi
- Bekleme süreleri eklendi
