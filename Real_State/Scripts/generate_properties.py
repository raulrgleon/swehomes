#!/usr/bin/env python3
"""
Genera Generated/PropertiesFromCSV.swift a partir de export.csv (export de swehomes.com).

Uso:
    python3 geocode_properties.py   # opcional: actualiza geocode_cache.json con coordenadas reales
    python3 generate_properties.py
"""
import csv
import json
import os
import re
import uuid

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(SCRIPT_DIR, '..', 'export.csv')
CACHE_PATH = os.path.join(SCRIPT_DIR, 'geocode_cache.json')
OUTPUT_PATH = os.path.join(SCRIPT_DIR, '..', 'Generated', 'PropertiesFromCSV.swift')

# Precio por debajo de este umbral = renta mensual (el CSV no distingue venta/renta)
LEASE_PRICE_THRESHOLD = 5000
HOUSTON = (29.7604, -95.3698)

STATUS_CASES = {
    'Available': 'available',
    'Sale Pending': 'salePending',
    'Sold': 'sold',
    'Leased': 'leased',
    'Unavailable': 'unavailable',
}


def escape(s):
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', ' ').replace('\r', '')


def clean_address(s):
    return re.sub(r'\s+,', ',', re.sub(r'\s+', ' ', s)).strip()


def parse_money(s):
    s = (s or '').replace('$', '').replace(',', '').strip()
    try:
        return int(round(float(s)))
    except ValueError:
        return 0


def parse_float(s):
    s = (s or '').replace(',', '').strip()
    try:
        return float(s)
    except ValueError:
        return 0.0


def optional_int(value):
    return str(value) if value > 0 else 'nil'


def main():
    cache = {}
    if os.path.exists(CACHE_PATH):
        with open(CACHE_PATH, encoding='utf-8') as f:
            cache = json.load(f)

    with open(CSV_PATH, encoding='utf-8') as f:
        rows = list(csv.DictReader(f))

    lines = [
        '// Auto-generated from export.csv by Scripts/generate_properties.py - DO NOT EDIT',
        'import Foundation',
        'import CoreLocation',
        '',
        'extension PropertyCSVData {',
        '    static let properties: [Property] = [',
    ]
    missing_coords = 0

    for i, row in enumerate(rows):
        pt = (row.get('property_type') or '').strip()
        if pt == 'Residential':
            cat, ptype = 'residential', 'house'
        elif pt == 'Commercial':
            cat, ptype = 'commercial', 'office'
        else:
            cat, ptype = 'land', 'lot'

        url = (row.get('url') or '').strip()
        city = (row.get('city') or 'Houston').strip()
        state = (row.get('state') or 'TX').replace('Texas', 'TX').strip()
        address = escape(clean_address(row.get('address') or row.get('title') or '')[:150])
        title = escape(clean_address(row.get('title') or '')[:120]) or address
        desc = escape((row.get('description') or 'Property available.')[:600])
        price = parse_money(row.get('price'))
        listing = 'lease' if 0 < price < LEASE_PRICE_THRESHOLD else 'sale'
        status = STATUS_CASES.get((row.get('property_status') or '').strip(), 'available')
        beds = int(parse_float(row.get('bedrooms') or row.get('beds')))
        baths = parse_float(row.get('bathrooms') or row.get('baths'))
        sqft = int(parse_float(row.get('property_sqft') or row.get('sqft')))
        lot = int(parse_float(row.get('lot_size')))
        down = parse_money(row.get('downpayment'))
        monthly = parse_money(row.get('monthly_payment'))

        geo = cache.get(url)
        if geo:
            lat, lon = geo['lat'], geo['lon']
        else:
            missing_coords += 1
            lat, lon = HOUSTON

        imgs = row.get('images') or ''
        url_list = [u.strip() for u in imgs.split('|')
                    if u.strip() and 'facebook' not in u and 'tr?id' not in u][:8]
        img_str = '["' + '", "'.join(escape(u) for u in url_list) + '"]' if url_list else 'nil'

        # ID estable derivado de la URL: los favoritos guardados sobreviven a cambios de orden del CSV
        prop_id = uuid.uuid5(uuid.NAMESPACE_URL, url or f'row-{i}')

        lines.append(f'''        Property(
            id: UUID(uuidString: "{prop_id}")!,
            title: "{title}",
            address: "{address}",
            city: "{escape(city)}",
            state: "{state}",
            price: {price},
            bedrooms: {beds},
            bathrooms: {baths},
            squareFeet: {sqft},
            listingType: .{listing},
            category: .{cat},
            propertyType: .{ptype},
            description: "{desc}",
            amenities: [],
            coordinate: CLLocationCoordinate2D(latitude: {lat:.6f}, longitude: {lon:.6f}),
            agentId: MockData.officeContact.id,
            status: .{status},
            zipcode: "{escape((row.get('zipcode') or '').strip())}",
            lotSize: {optional_int(lot)},
            downPayment: {optional_int(down)},
            monthlyPayment: {optional_int(monthly)},
            sourceURL: {('"' + escape(url) + '"') if url else 'nil'},
            imageStyleIndex: {i % 6},
            imageURLs: {img_str}
        ),''')

    lines += ['    ]', '}', '']

    os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
    with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print(f'Generado {OUTPUT_PATH} con {len(rows)} propiedades '
          f'({missing_coords} sin coordenadas en caché, centradas en Houston)')


if __name__ == '__main__':
    main()
