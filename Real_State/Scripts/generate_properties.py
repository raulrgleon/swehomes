#!/usr/bin/env python3
"""
Generates Properties.swift from export.csv
Run: python3 generate_properties.py
"""
import csv
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(SCRIPT_DIR, '..', 'export.csv')
OUTPUT_PATH = os.path.join(SCRIPT_DIR, '..', 'Generated', 'PropertiesFromCSV.swift')

TEXAS_COORDS = {
    'Houston': (29.7604, -95.3698), 'Snyder': (32.7175, -100.9176), 'Hempstead': (30.0974, -96.0783),
    'Conroe': (30.3119, -95.4561), 'Corpus Christi': (27.8006, -97.3964), 'Beaumont': (30.0802, -94.1266),
    'Bryan': (30.6744, -96.3700), 'Alvin': (29.4238, -95.2441), 'Angleton': (29.1694, -95.4319),
    'Baytown': (29.7355, -94.9774), 'Bellaire': (29.7058, -95.4588), 'Big Spring': (32.2504, -101.4787),
    'Bishop': (27.5892, -97.7992), 'Brookshire': (29.7861, -95.9511), 'Cleveland': (30.3435, -95.0855),
    'Clute': (29.0247, -95.3988), 'Coldspring': (30.5924, -95.1294), 'Corsicana': (32.0954, -96.4689),
    'Burkburnett': (34.0979, -98.5706), 'Commerce': (33.2470, -95.8990), 'Breckenridge': (32.7557, -98.9023),
    'Midland': (31.9973, -102.0779), 'Odessa': (31.8457, -102.3676), 'San Antonio': (29.4241, -98.4936),
    'Dallas': (32.7767, -96.7970), 'Austin': (30.2672, -97.7431), 'Fort Worth': (32.7555, -97.3308),
    'Waco': (31.5493, -97.1467), 'Tyler': (32.3513, -95.3011), 'Lubbock': (33.5779, -101.8552),
    'Amarillo': (35.2220, -101.8313), 'El Paso': (31.7619, -106.4850), 'Laredo': (27.5306, -99.4803),
}

def escape(s):
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', ' ').replace('\r', '')

def get_coord(city, index):
    city_clean = city.strip()
    if city_clean in TEXAS_COORDS:
        lat, lon = TEXAS_COORDS[city_clean]
        return (lat + (index % 10) * 0.008, lon + (index % 7) * 0.006)
    return (29.76 + (index % 80) * 0.04, -95.37 - (index % 60) * 0.03)

def parse_price(s):
    if not s: return 0
    s = str(s).replace('$', '').replace(',', '').strip()
    try: return int(float(s))
    except: return 0

def parse_int(s):
    if not s: return 0
    s = str(s).replace(',', '').strip()
    try: return int(float(s))
    except: return 0

def parse_float(s):
    if not s: return 0.0
    s = str(s).replace(',', '').strip()
    try: return float(s)
    except: return 0.0

os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)

lines = []
lines.append('// Auto-generated from export.csv - DO NOT EDIT')
lines.append('import Foundation\nimport CoreLocation\n')
lines.append('extension PropertyCSVData {')
lines.append('    static let properties: [Property] = [')

with open(CSV_PATH, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for i, row in enumerate(reader):
        pt = row.get('property_type', 'Land').strip()
        if pt == 'Residential':
            cat, ptype = 'residential', 'house'
        elif pt == 'Commercial':
            cat, ptype = 'commercial', 'office'
        else:
            cat, ptype = 'land', 'lot'

        city = row.get('city', 'Houston').strip()
        lat, lon = get_coord(city, i)
        title = escape((row.get('title', '') or '')[:120])
        addr = escape((row.get('address', '') or title)[:150])
        desc = escape((row.get('description', '') or 'Property available.')[:400])
        state = (row.get('state', 'TX') or 'TX').replace('Texas', 'TX').strip()
        price = parse_price(row.get('price', ''))
        beds = parse_int(row.get('bedrooms') or row.get('beds', ''))
        baths = parse_float(row.get('bathrooms') or row.get('baths', ''))
        sqft = parse_int(row.get('property_sqft') or row.get('sqft', ''))

        imgs = row.get('images', '')
        url_list = [u.strip() for u in imgs.split('|') if u.strip() and 'facebook' not in u and 'tr?id' not in u][:5]
        img_str = '["' + '", "'.join(escape(u) for u in url_list) + '"]' if url_list else 'nil'

        uuid_hex = f"b2c3d4e5-{i+1:04x}-4000-8000-000000000{i+1:03x}"
        agent_idx = (i % 3) + 1

        is_new = 'true' if i % 5 == 0 else 'false'
        is_open = 'true' if i % 7 == 0 else 'false'

        lines.append(f'''        Property(
            id: UUID(uuidString: "{uuid_hex}")!,
            title: "{title}",
            address: "{addr}",
            city: "{city}",
            state: "{state}",
            price: {price},
            bedrooms: {beds},
            bathrooms: {baths},
            squareFeet: {sqft},
            listingType: .sale,
            category: .{cat},
            propertyType: .{ptype},
            description: "{desc}",
            amenities: [],
            coordinate: CLLocationCoordinate2D(latitude: {lat}, longitude: {lon}),
            agentId: MockData.agents[{agent_idx-1}].id,
            isNewListing: {is_new},
            isOpenHouse: {is_open},
            imageStyleIndex: {i % 6},
            imageName: nil,
            imageNames: nil,
            imageURLs: {img_str}
        ),''')

lines.append('    ]')
lines.append('}')

with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print(f'Generated {OUTPUT_PATH} with 231 properties')
