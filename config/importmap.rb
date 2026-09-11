# Pin npm packages by running ./bin/importmap

# Pin the default entry point required by javascript_importmap_tags
pin "application", preload: true

pin "@defra/interactive-map", to: "./node_modules/@defra/interactive-map/dist/esm/index.js"
pin "@defra/interactive-map/providers/maplibre", to: "./node_modules/@defra/interactive-map/providers/maplibre/dist/esm/index.js"
pin "@defra/interactive-map/plugins/interact", to: "./node_modules/@defra/interactive-map/plugins/interact/dist/esm/index.js"
pin "components/map", to: "components/map.js"
