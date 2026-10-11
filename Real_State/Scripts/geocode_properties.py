#!/usr/bin/env python3
"""
Geocodifica las direcciones de export.csv con Nominatim (OpenStreetMap) y guarda
los resultados en geocode_cache.json para que generate_properties.py use
coordenadas reales. Solo consulta las direcciones que aún no están en caché.

Uso: python3 geocode_properties.py
"""
import csv
import json
import os
import re
import subprocess
import time
import urllib.parse

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(SCRIPT_DIR, '..', 'export.csv')
CACHE_PATH = os.path.join(SCRIPT_DIR, 'geocode_cache.json')
USER_AGENT = 'SWEHomesApp/1.0 (github.com/raulrgleon/swehomes)'


def clean_address(addr):
    return re.sub(r'\s+,', ',', re.sub(r'\s+', ' ', addr)).strip()


def query(params):
    url = 'https://nominatim.openstreetmap.org/search?' + urllib.parse.urlencode(
        {**params, 'format': 'json', 'limit': 1, 'countrycodes': 'us'})
    # curl en lugar de urllib: el Python de python.org en macOS no trae certificados raíz
    out = subprocess.run(['curl', '-sf', '--max-time', '20', '-A', USER_AGENT, url],
                         capture_output=True, text=True, check=True).stdout
    data = json.loads(out)
    time.sleep(1.1)  # Política de uso de Nominatim: máximo 1 petición por segundo
    if data:
        return float(data[0]['lat']), float(data[0]['lon'])
    return None


def geocode(row):
    addr = clean_address(row.get('address') or row.get('title') or '')
    if addr:
        hit = query({'q': addr})
        if hit:
            return {'lat': hit[0], 'lon': hit[1], 'precision': 'address'}
    zipcode = (row.get('zipcode') or '').strip()
    if zipcode:
        hit = query({'postalcode': zipcode})
        if hit:
            return {'lat': hit[0], 'lon': hit[1], 'precision': 'zipcode'}
    city = (row.get('city') or '').strip()
    if city:
        hit = query({'city': city, 'state': 'Texas'})
        if hit:
            return {'lat': hit[0], 'lon': hit[1], 'precision': 'city'}
    return None


def main():
    cache = {}
    if os.path.exists(CACHE_PATH):
        with open(CACHE_PATH, encoding='utf-8') as f:
            cache = json.load(f)

    with open(CSV_PATH, encoding='utf-8') as f:
        rows = list(csv.DictReader(f))

    pending = [r for r in rows if r['url'] not in cache]
    print(f'{len(rows)} propiedades, {len(pending)} por geocodificar')
    for i, row in enumerate(pending, 1):
        try:
            result = geocode(row)
        except Exception as exc:
            print(f'  error en {row["url"]}: {exc}')
            continue
        if result:
            cache[row['url']] = result
        print(f'  [{i}/{len(pending)}] {row["address"][:60]} -> {result and result["precision"]}')
        if i % 20 == 0:
            with open(CACHE_PATH, 'w', encoding='utf-8') as f:
                json.dump(cache, f, indent=1, sort_keys=True)

    with open(CACHE_PATH, 'w', encoding='utf-8') as f:
        json.dump(cache, f, indent=1, sort_keys=True)
    print(f'Caché guardada en {CACHE_PATH} ({len(cache)} entradas)')


if __name__ == '__main__':
    main()
