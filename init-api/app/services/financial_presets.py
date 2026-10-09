"""Editable starter budgets, not measured average retail prices.

Interest references are dated indicators, not current offers or guarantees.
No verified retail-deposit reference means 0% until the user supplies a rate.
"""
from decimal import Decimal

REGIONS = {
    "RU": ("RUB", "13.06", [300, 900, 1200, 250, 700, 1500, 399],
           "CBR · 2026-09 · mean maximum rates of 10 banks",
           "https://www.cbr.ru/press/PR?file=639264511680878877BANK_SECTOR.htm"),
    "US": ("USD", "0", [5, 15, 25, 10, 20, 30, 10], "", ""),
    "ES": ("EUR", "2.14", [3, 12, 20, 6, 15, 25, 10], "ECB · 2026-07 · euro-area household term deposits",
           "https://www.ecb.europa.eu/press/stats/mfi/html/ecb.mir260902~d54675e442.es.html"),
    "FR": ("EUR", "2.14", [4, 15, 25, 12, 20, 30, 10], "ECB · 2026-07 · euro-area household term deposits",
           "https://www.ecb.europa.eu/press/stats/mfi/html/ecb.mir260902~d54675e442.es.html"),
    "DE": ("EUR", "2.14", [4, 15, 25, 9, 20, 30, 10], "ECB · 2026-07 · euro-area household term deposits",
           "https://www.ecb.europa.eu/press/stats/mfi/html/ecb.mir260902~d54675e442.es.html"),
    "BR": ("BRL", "0", [10, 35, 50, 12, 25, 100, 30], "", ""),
    "CN": ("CNY", "0", [25, 40, 50, 25, 30, 150, 25], "", ""),
    "IN": ("INR", "0", [150, 300, 400, 350, 250, 1000, 200], "", ""),
    "SA": ("SAR", "0", [15, 30, 45, 30, 30, 100, 30], "", ""),
    "KZ": ("KZT", "0", [1200, 3500, 5000, 1000, 2000, 7000, 2000], "", ""),
}
NAMES = {
    "RU": ["Кофе навынос", "Кафе и фастфуд", "Доставка еды", "Сигареты", "Такси", "Маркетплейсы", "Ненужная подписка"],
    "US": ["Takeaway coffee", "Café and fast food", "Food delivery", "Cigarettes", "Taxi", "Online shopping", "Unused subscription"],
    "ES": ["Café para llevar", "Cafetería y comida rápida", "Comida a domicilio", "Cigarrillos", "Taxi", "Compras online", "Suscripción sin usar"],
    "FR": ["Café à emporter", "Café et restauration rapide", "Livraison de repas", "Cigarettes", "Taxi", "Achats en ligne", "Abonnement inutilisé"],
    "DE": ["Kaffee zum Mitnehmen", "Café und Fast Food", "Essenslieferung", "Zigaretten", "Taxi", "Online-Shopping", "Ungenutztes Abo"],
    "BR": ["Café para viagem", "Café e fast-food", "Entrega de comida", "Cigarros", "Táxi", "Compras online", "Assinatura sem uso"],
    "CN": ["外带咖啡", "咖啡馆与快餐", "外卖", "香烟", "出租车", "网购", "闲置订阅"],
    "IN": ["टेकअवे कॉफ़ी", "कैफ़े और फ़ास्ट फ़ूड", "खाने की डिलीवरी", "सिगरेट", "टैक्सी", "ऑनलाइन खरीदारी", "अनुपयोगी सदस्यता"],
    "SA": ["قهوة جاهزة", "مقهى ووجبات سريعة", "توصيل الطعام", "سجائر", "سيارة أجرة", "تسوق إلكتروني", "اشتراك غير مستخدم"],
}
ICONS = ("coffee", "restaurant", "delivery", "smoking", "taxi", "shopping", "subscription")
FREQUENCIES = (3, 1, 1, 5, 2, 1, 0)


def default_impulses(region, currency):
    preset_currency, _, amounts, _, _ = REGIONS[region]
    if currency != preset_currency:
        return []  # Never relabel another region's prices as this currency.
    names = NAMES.get(region, NAMES["RU"])
    return [dict(name=name, default_amount=Decimal(amount), icon_key=icon,
                 weekly_frequency=frequency, currency_code=currency)
            for name, amount, icon, frequency in zip(names, amounts, ICONS, FREQUENCIES)]
