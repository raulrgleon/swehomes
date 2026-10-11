# SWE Homes — app iOS

App nativa para iPhone (SwiftUI) que muestra el catálogo de propiedades de
[SWE Homes](https://swehomes.com): casas, terrenos y locales comerciales en Texas (y algunos en
Tennessee), muchos con
financiación directa del propietario (*owner financing*).

Funciona sin conexión para los datos (vienen incrustados en la app) y descarga las fotos desde
swehomes.com.

## Funcionalidades

- **Home / Search**: categorías Residential, Commercial y Land; venta (Sale) o renta mensual
  (Lease); búsqueda por dirección, ciudad o código postal; carrusel *Hot Deals* con las ofertas
  disponibles más económicas; mapa con todas las propiedades filtradas y listado completo.
- **Filtros**: rango de precio, habitaciones, baños, solo con financiación del propietario e
  incluir vendidas/no disponibles (por defecto se ocultan).
- **Detalle**: galería de fotos a pantalla completa, estado del anuncio (Available, Sale Pending,
  Sold, Leased, Unavailable), enganche y cuota mensual publicados, calculadora de hipoteca,
  mapa 3D de la ubicación, abrir en Apple Maps, llamar o escribir a SWE Homes, pedir visita,
  compartir y abrir la ficha original en swehomes.com.
- **Saved**: favoritos guardados en el dispositivo (persisten entre sesiones).
- **Profile**: búsquedas recientes (persistentes), contacto de la oficina, ajustes de
  notificaciones y volver a ver el onboarding.
- **Notificaciones locales** de Hot Deals (10:00 y 14:30) y notificaciones de prueba.

## Requisitos

- macOS con **Xcode 26** o superior.
- iOS **26.5** (deployment target del proyecto).
- Python 3 (solo para regenerar los datos).
- Para instalar en un iPhone: cuenta de Apple Developer (vale la gratuita) iniciada en Xcode.

No hay variables de entorno, claves de API ni secretos: la app no usa backend. Por eso no existe
`.env.example`.

## Puesta en marcha

```bash
git clone https://github.com/raulrgleon/swehomes.git
cd swehomes
open Real_State.xcodeproj
```

En Xcode elige el esquema `Real_State` y un simulador o tu iPhone, y pulsa Run.

### Compilar e instalar desde la terminal

```bash
# Simulador
xcodebuild -project Real_State.xcodeproj -scheme Real_State \
  -destination 'generic/platform=iOS Simulator' build CODE_SIGNING_ALLOWED=NO

# iPhone conectado (firma automática con el equipo configurado en el proyecto)
xcrun devicectl list devices
xcodebuild -project Real_State.xcodeproj -scheme Real_State \
  -destination 'id=<UDID del iPhone>' -allowProvisioningUpdates \
  -derivedDataPath build build
xcrun devicectl device install app --device <identificador> \
  build/Build/Products/Debug-iphoneos/Real_State.app
```

Firma: `CODE_SIGN_STYLE = Automatic`, equipo `CNU4S77L2K`, bundle id `com.raulgarcia.RealState`.
Con una cuenta gratuita el perfil caduca a los 7 días y hay que reinstalar. La primera vez, en el
iPhone: Ajustes › General › VPN y gestión de dispositivos › confiar en el desarrollador.

## Datos de propiedades

Los datos salen de un export de swehomes.com (`Real_State/export.csv`, 231 propiedades) y se
convierten a Swift en tiempo de desarrollo:

```bash
cd Real_State/Scripts
python3 geocode_properties.py    # coordenadas reales (OpenStreetMap / Nominatim), con caché
python3 generate_properties.py   # genera Real_State/Generated/PropertiesFromCSV.swift
```

- `geocode_properties.py` geocodifica cada dirección (y, si no la encuentra, el código postal o la
  ciudad) respetando el límite de 1 petición/segundo de Nominatim. Guarda el resultado en
  `Scripts/geocode_cache.json` (versionado) y solo consulta las direcciones nuevas.
- `generate_properties.py`:
  - Mapea `property_status` al estado del anuncio.
  - Precio menor de 5.000 $ = renta mensual (Lease); el resto, venta.
  - ID estable de cada propiedad = UUIDv5 de su URL, para que los favoritos sobrevivan a cambios
    del CSV.
  - Incluye enganche, cuota mensual, tamaño de parcela, código postal, URL original y hasta
    8 fotos.

Para actualizar el catálogo: reemplaza `export.csv`, ejecuta los dos scripts y compila.

## Arquitectura

```
Real_State/
├── Real_StateApp.swift          # Entrada: onboarding → login → ContentView
├── ContentView.swift            # TabView: Home, Search, Saved, Profile
├── Models/                      # Property (+ ListingStatus), Agent (contacto), UserProfile
├── ViewModels/
│   ├── AppState.swift           # Favoritos e historial (UserDefaults), EnvironmentObject
│   └── ExploreViewModel.swift   # Filtros, búsqueda y Hot Deals
├── Services/
│   ├── PropertyRepository.swift         # Capa de datos (lista para cambiar a una API)
│   └── HotDealsNotificationService.swift
├── MockData/MockData.swift      # Contacto de la oficina, perfil invitado, ajustes
├── Generated/                   # Código generado desde export.csv (no editar a mano)
├── Views/                       # Explore, Search, PropertyDetail, Map, Filter, Saved, Profile,
│                                # Login, Onboarding y componentes compartidos
├── Theme/                       # Colores y tipografía
├── Assets.xcassets              # Icono, logo e imagen local
├── Scripts/                     # Geocodificación y generación de datos
└── export.csv                   # Export de swehomes.com
```

Persistencia local (`UserDefaults`): `savedPropertyIds`, `searchHistory`, `hasSeenOnboarding`,
`isLoggedIn` y `hotDealsNotificationsEnabled`.

## Servicios externos

| Servicio | Uso |
|---|---|
| swehomes.com | Fotos de las propiedades y enlace a cada ficha |
| OpenStreetMap Nominatim | Geocodificación, solo al regenerar datos |
| Apple Maps / MapKit | Mapas y navegación |
| Teléfono / Mensajes | Contacto con SWE Homes: +1 (713) 413-1000 |

## Limitaciones conocidas

- El **login es simulado**: los botones de Apple y Google dan acceso sin autenticar. El perfil es
  de invitado.
- Todas las propiedades se dirigen al contacto general de la oficina; el export no incluye un
  agente asignado.
- Las coordenadas son tan precisas como lo que encuentra Nominatim. Algunas direcciones rurales
  o de lotes caen en el centro de su código postal o ciudad.
- El catálogo está incrustado; para ver cambios de swehomes.com hay que regenerar y publicar una
  nueva versión.

## Copias de seguridad

Todo el código y los datos están versionados en GitHub (`raulrgleon/swehomes`). El commit
`d347aee` es un punto de restauración anterior a las mejoras visuales.
