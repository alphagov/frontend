# Pin npm packages by running ./bin/importmap

# Pin the default entry point required by javascript_importmap_tags
pin "application", preload: true
pin "components/map/map", preload: true
pin "components/map/index", preload: true
pin "components/map/im-core", preload: true
pin "components/map/im-shell", preload: true
pin "components/map/maplibre", preload: true

pin "@defra/interactive-map", to: "components/map/index.js"
pin "@defra/interactive-map/providers/maplibre", to: "components/map/maplibre.js"
# pin "@defra/interactive-map/plugins/interact", to: "./node_modules/@defra/interactive-map/plugins/interact/dist/esm/index.js"

pin "components/map/asyncToGenerator", preload: true
pin "components/map/defineProperty", preload: true
pin "components/map/objectWithoutProperties", preload: true

# try to avoid errors relating to babel, which is referenced by the defra ESM code
pin "@babel/runtime/helpers/asyncToGenerator", to: "components/map/asyncToGenerator.js"
pin "@babel/runtime/helpers/defineProperty", to: "components/map/defineProperty.js"
pin "@babel/runtime/helpers/objectWithoutProperties", to: "components/map/objectWithoutProperties.js"
