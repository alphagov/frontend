/* local copy of https://tiles.openfreemap.org/styles/liberty */
window.GOVUK = window.GOVUK || {}
window.GOVUK.mapComponentStyles = { version: 8, sources: { ne2_shaded: { maxzoom: 6, tileSize: 256, tiles: ['https://tiles.openfreemap.org/natural_earth/ne2sr/{z}/{x}/{y}.png'], type: 'raster' }, openmaptiles: { type: 'vector', url: 'https://tiles.openfreemap.org/planet' } }, sprite: 'https://tiles.openfreemap.org/sprites/ofm_f384/ofm', glyphs: 'https://tiles.openfreemap.org/fonts/{fontstack}/{range}.pbf', layers: [{ id: 'background', type: 'background', paint: { 'background-color': '#f8f4f0' } }, { id: 'natural_earth', type: 'raster', source: 'ne2_shaded', maxzoom: 7, paint: { 'raster-opacity': ['interpolate', ['exponential', 1.5], ['zoom'], 0, 0.6, 6, 0.1] } }, { id: 'park', type: 'fill', source: 'openmaptiles', 'source-layer': 'park', paint: { 'fill-color': '#d8e8c8', 'fill-opacity': 0.7, 'fill-outline-color': 'rgba(95, 208, 100, 1)' } }, { id: 'park_outline', type: 'line', source: 'openmaptiles', 'source-layer': 'park', paint: { 'line-color': 'rgba(228, 241, 215, 1)', 'line-dasharray': [1, 1.5] } }, { id: 'landuse_residential', type: 'fill', source: 'openmaptiles', 'source-layer': 'landuse', maxzoom: 12, filter: ['==', ['get', 'class'], 'residential'], paint: { 'fill-color': ['interpolate', ['linear'], ['zoom'], 9, 'hsla(0,3%,85%,0.84)', 12, 'hsla(35,57%,88%,0.49)'] } }, { id: 'landcover_wood', type: 'fill', source: 'openmaptiles', 'source-layer': 'landcover', filter: ['==', ['get', 'class'], 'wood'], paint: { 'fill-antialias': false, 'fill-color': 'hsla(98,61%,72%,0.7)', 'fill-opacity': 0.4 } }, { id: 'landcover_grass', type: 'fill', source: 'openmaptiles', 'source-layer': 'landcover', filter: ['==', ['get', 'class'], 'grass'], paint: { 'fill-antialias': false, 'fill-color': 'rgba(176, 213, 154, 1)', 'fill-opacity': 0.3 } }, { id: 'landcover_ice', type: 'fill', source: 'openmaptiles', 'source-layer': 'landcover', filter: ['==', ['get', 'class'], 'ice'], paint: { 'fill-antialias': false, 'fill-color': 'rgba(224, 236, 236, 1)', 'fill-opacity': 0.8 } }, { id: 'landcover_wetland', type: 'fill', source: 'openmaptiles', 'source-layer': 'landcover', minzoom: 12, filter: ['==', ['get', 'class'], 'wetland'], paint: { 'fill-antialias': true, 'fill-opacity': 0.8, 'fill-pattern': 'wetland_bg_11', 'fill-translate-anchor': 'map' } }, { id: 'landuse_pitch', type: 'fill', source: 'openmaptiles', 'source-layer': 'landuse', filter: ['==', ['get', 'class'], 'pitch'], paint: { 'fill-color': '#DEE3CD' } }, { id: 'landuse_track', type: 'fill', source: 'openmaptiles', 'source-layer': 'landuse', filter: ['==', ['get', 'class'], 'track'], paint: { 'fill-color': '#DEE3CD' } }, { id: 'landuse_cemetery', type: 'fill', source: 'openmaptiles', 'source-layer': 'landuse', filter: ['==', ['get', 'class'], 'cemetery'], paint: { 'fill-color': 'hsl(75,37%,81%)' } }, { id: 'landuse_hospital', type: 'fill', source: 'openmaptiles', 'source-layer': 'landuse', filter: ['==', ['get', 'class'], 'hospital'], paint: { 'fill-color': '#fde' } }, { id: 'landuse_school', type: 'fill', source: 'openmaptiles', 'source-layer': 'landuse', filter: ['==', ['get', 'class'], 'school'], paint: { 'fill-color': 'rgb(236,238,204)' } }, { id: 'waterway_tunnel', type: 'line', source: 'openmaptiles', 'source-layer': 'waterway', filter: ['==', ['get', 'brunnel'], 'tunnel'], paint: { 'line-color': '#a0c8f0', 'line-dasharray': [3, 3], 'line-gap-width': ['interpolate', ['linear'], ['zoom'], 12, 0, 20, 6], 'line-opacity': 1, 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 8, 1, 20, 2] } }, { id: 'waterway_river', type: 'line', source: 'openmaptiles', 'source-layer': 'waterway', filter: ['all', ['==', ['get', 'class'], 'river'], ['!=', ['get', 'brunnel'], 'tunnel']], layout: { 'line-cap': 'round' }, paint: { 'line-color': '#a0c8f0', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 11, 0.5, 20, 6] } }, { id: 'waterway_other', type: 'line', source: 'openmaptiles', 'source-layer': 'waterway', filter: ['all', ['!=', ['get', 'class'], 'river'], ['!=', ['get', 'brunnel'], 'tunnel']], layout: { 'line-cap': 'round' }, paint: { 'line-color': '#a0c8f0', 'line-width': ['interpolate', ['exponential', 1.3], ['zoom'], 13, 0.5, 20, 6] } }, { id: 'water', type: 'fill', source: 'openmaptiles', 'source-layer': 'water', filter: ['!=', ['get', 'brunnel'], 'tunnel'], paint: { 'fill-color': 'rgb(158,189,255)' } }, { id: 'landcover_sand', type: 'fill', source: 'openmaptiles', 'source-layer': 'landcover', filter: ['==', ['get', 'class'], 'sand'], paint: { 'fill-color': 'rgba(247, 239, 195, 1)' } }, { id: 'aeroway_fill', type: 'fill', source: 'openmaptiles', 'source-layer': 'aeroway', minzoom: 11, filter: ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], paint: { 'fill-color': 'rgba(229, 228, 224, 1)', 'fill-opacity': 0.7 } }, { id: 'aeroway_runway', type: 'line', source: 'openmaptiles', 'source-layer': 'aeroway', minzoom: 11, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['==', ['get', 'class'], 'runway']], paint: { 'line-color': '#f0ede9', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 11, 3, 20, 16] } }, { id: 'aeroway_taxiway', type: 'line', source: 'openmaptiles', 'source-layer': 'aeroway', minzoom: 11, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['==', ['get', 'class'], 'taxiway']], paint: { 'line-color': '#f0ede9', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 11, 0.5, 20, 6] } }, { id: 'tunnel_motorway_link_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'motorway'], ['==', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'tunnel']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-dasharray': [0.5, 0.25], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 1, 13, 3, 14, 4, 20, 15] } }, { id: 'tunnel_service_track_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['service', 'track'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#cfcdca', 'line-dasharray': [0.5, 0.25], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 15, 1, 16, 4, 20, 11] } }, { id: 'tunnel_link_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'tunnel']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 1, 13, 3, 14, 4, 20, 15] } }, { id: 'tunnel_street_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['street', 'street_limited'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#cfcdca', 'line-opacity': ['interpolate', ['linear'], ['zoom'], 12, 0, 12.5, 1], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 0.5, 13, 1, 14, 4, 20, 15] } }, { id: 'tunnel_secondary_tertiary_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['secondary', 'tertiary'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 8, 1.5, 20, 17] } }, { id: 'tunnel_trunk_primary_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['primary', 'trunk'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0.4, 6, 0.7, 7, 1.75, 20, 22] } }, { id: 'tunnel_motorway_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'motorway'], ['!=', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'tunnel']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-dasharray': [0.5, 0.25], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0.4, 6, 0.7, 7, 1.75, 20, 22] } }, { id: 'tunnel_path_pedestrian', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['path', 'pedestrian'], true, false]], paint: { 'line-color': 'hsl(0,0%,100%)', 'line-dasharray': [1, 0.75], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 14, 0.5, 20, 10] } }, { id: 'tunnel_motorway_link', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'motorway'], ['==', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'tunnel']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fc8', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12.5, 0, 13, 1.5, 14, 2.5, 20, 11.5] } }, { id: 'tunnel_service_track', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['service', 'track'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fff', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 15.5, 0, 16, 2, 20, 7.5] } }, { id: 'tunnel_link', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'tunnel']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fff4c6', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12.5, 0, 13, 1.5, 14, 2.5, 20, 11.5] } }, { id: 'tunnel_minor', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['minor'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fff', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 13.5, 0, 14, 2.5, 20, 11.5] } }, { id: 'tunnel_secondary_tertiary', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['secondary', 'tertiary'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fff4c6', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 6.5, 0, 7, 0.5, 20, 10] } }, { id: 'tunnel_trunk_primary', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['primary', 'trunk'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fff4c6', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0, 7, 1, 20, 18] } }, { id: 'tunnel_motorway', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'motorway'], ['!=', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'tunnel']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#ffdaa6', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0, 7, 1, 20, 18] } }, { id: 'tunnel_major_rail', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['rail'], true, false]], paint: { 'line-color': '#bbb', 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14, 0.4, 15, 0.75, 20, 2] } }, { id: 'tunnel_major_rail_hatching', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['==', ['get', 'class'], 'rail']], paint: { 'line-color': '#bbb', 'line-dasharray': [0.2, 8], 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14.5, 0, 15, 3, 20, 8] } }, { id: 'tunnel_transit_rail', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['match', ['get', 'class'], ['transit'], true, false]], paint: { 'line-color': '#bbb', 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14, 0.4, 15, 0.75, 20, 2] } }, { id: 'tunnel_transit_rail_hatching', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['==', ['get', 'class'], 'transit']], paint: { 'line-color': '#bbb', 'line-dasharray': [0.2, 8], 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14.5, 0, 15, 3, 20, 8] } }, { id: 'road_area_pattern', type: 'fill', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], paint: { 'fill-pattern': 'pedestrian_polygon' } }, { id: 'road_motorway_link_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 12, filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'motorway'], ['==', ['get', 'ramp'], 1]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 1, 13, 3, 14, 4, 20, 15] } }, { id: 'road_service_track_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['service', 'track'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#cfcdca', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 15, 1, 16, 4, 20, 11] } }, { id: 'road_link_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 13, filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['motorway', 'path', 'pedestrian', 'service', 'track'], false, true], ['==', ['get', 'ramp'], 1]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 1, 13, 3, 14, 4, 20, 15] } }, { id: 'road_minor_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['minor'], true, false], ['!=', ['get', 'ramp'], 1]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#cfcdca', 'line-opacity': ['interpolate', ['linear'], ['zoom'], 12, 0, 12.5, 1], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 0.5, 13, 1, 14, 4, 20, 20] } }, { id: 'road_secondary_tertiary_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['secondary', 'tertiary'], true, false], ['!=', ['get', 'ramp'], 1]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 8, 1.5, 20, 17] } }, { id: 'road_trunk_primary_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['primary', 'trunk'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0.4, 6, 0.7, 7, 1.75, 20, 22] } }, { id: 'road_motorway_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 5, filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'motorway'], ['!=', ['get', 'ramp'], 1]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0.4, 6, 0.7, 7, 1.75, 20, 22] } }, { id: 'road_path_pedestrian', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 14, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['path', 'pedestrian'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': 'hsl(0,0%,100%)', 'line-dasharray': [1, 0.7], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 14, 1, 20, 10] } }, { id: 'road_motorway_link', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 12, filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'motorway'], ['==', ['get', 'ramp'], 1]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#fc8', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12.5, 0, 13, 1.5, 14, 2.5, 20, 11.5] } }, { id: 'road_service_track', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['service', 'track'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#fff', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 15.5, 0, 16, 2, 20, 7.5] } }, { id: 'road_link', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 13, filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'ramp'], 1], ['match', ['get', 'class'], ['motorway', 'path', 'pedestrian', 'service', 'track'], false, true]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#fea', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12.5, 0, 13, 1.5, 14, 2.5, 20, 11.5] } }, { id: 'road_minor', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['minor'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#fff', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 13.5, 0, 14, 2.5, 20, 18] } }, { id: 'road_secondary_tertiary', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['secondary', 'tertiary'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#fea', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 6.5, 0, 8, 0.5, 20, 13] } }, { id: 'road_trunk_primary', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['match', ['get', 'class'], ['primary', 'trunk'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fea', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0, 7, 1, 20, 18] } }, { id: 'road_motorway', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 5, filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'motorway'], ['!=', ['get', 'ramp'], 1]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': ['interpolate', ['linear'], ['zoom'], 5, 'hsl(26,87%,62%)', 6, '#fc8'], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0, 7, 1, 20, 18] } }, { id: 'road_major_rail', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'rail']], paint: { 'line-color': '#bbb', 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14, 0.4, 15, 0.75, 20, 2] } }, { id: 'road_major_rail_hatching', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'rail']], paint: { 'line-color': '#bbb', 'line-dasharray': [0.2, 8], 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14.5, 0, 15, 3, 20, 8] } }, { id: 'road_transit_rail', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'transit']], paint: { 'line-color': '#bbb', 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14, 0.4, 15, 0.75, 20, 2] } }, { id: 'road_transit_rail_hatching', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'transit']], paint: { 'line-color': '#bbb', 'line-dasharray': [0.2, 8], 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14.5, 0, 15, 3, 20, 8] } }, { id: 'road_one_way_arrow', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 16, filter: ['==', ['get', 'oneway'], 1], layout: { 'icon-image': 'arrow', 'symbol-placement': 'line' } }, { id: 'road_one_way_arrow_opposite', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 16, filter: ['==', ['get', 'oneway'], -1], layout: { 'icon-image': 'arrow', 'icon-rotate': 180, 'symbol-placement': 'line' } }, { id: 'bridge_motorway_link_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'motorway'], ['==', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'bridge']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 1, 13, 3, 14, 4, 20, 15] } }, { id: 'bridge_service_track_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['service', 'track'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#cfcdca', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 15, 1, 16, 4, 20, 11] } }, { id: 'bridge_link_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'link'], ['==', ['get', 'brunnel'], 'bridge']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 1, 13, 3, 14, 4, 20, 15] } }, { id: 'bridge_street_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['street', 'street_limited'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': 'hsl(36,6%,74%)', 'line-opacity': ['interpolate', ['linear'], ['zoom'], 12, 0, 12.5, 1], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12, 0.5, 13, 1, 14, 4, 20, 25] } }, { id: 'bridge_path_pedestrian_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['path', 'pedestrian'], true, false]], paint: { 'line-color': 'hsl(35,6%,80%)', 'line-dasharray': [1, 0], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 14, 1.5, 20, 18] } }, { id: 'bridge_secondary_tertiary_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['secondary', 'tertiary'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 8, 1.5, 20, 17] } }, { id: 'bridge_trunk_primary_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['primary', 'trunk'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0.4, 6, 0.7, 7, 1.75, 20, 22] } }, { id: 'bridge_motorway_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'motorway'], ['!=', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'bridge']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#e9ac77', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0.4, 6, 0.7, 7, 1.75, 20, 22] } }, { id: 'bridge_path_pedestrian', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['path', 'pedestrian'], true, false]], paint: { 'line-color': 'hsl(0,0%,100%)', 'line-dasharray': [1, 0.3], 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 14, 0.5, 20, 10] } }, { id: 'bridge_motorway_link', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'motorway'], ['==', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'bridge']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fc8', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12.5, 0, 13, 1.5, 14, 2.5, 20, 11.5] } }, { id: 'bridge_service_track', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['service', 'track'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fff', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 15.5, 0, 16, 2, 20, 7.5] } }, { id: 'bridge_link', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'link'], ['==', ['get', 'brunnel'], 'bridge']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fea', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 12.5, 0, 13, 1.5, 14, 2.5, 20, 11.5] } }, { id: 'bridge_street', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['minor'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fff', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 13.5, 0, 14, 2.5, 20, 18] } }, { id: 'bridge_secondary_tertiary', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['secondary', 'tertiary'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fea', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 6.5, 0, 7, 0.5, 20, 10] } }, { id: 'bridge_trunk_primary', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'brunnel'], 'bridge'], ['match', ['get', 'class'], ['primary', 'trunk'], true, false]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fea', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0, 7, 1, 20, 18] } }, { id: 'bridge_motorway', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'motorway'], ['!=', ['get', 'ramp'], 1], ['==', ['get', 'brunnel'], 'bridge']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fc8', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 5, 0, 7, 1, 20, 18] } }, { id: 'bridge_major_rail', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'rail'], ['==', ['get', 'brunnel'], 'bridge']], paint: { 'line-color': '#bbb', 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14, 0.4, 15, 0.75, 20, 2] } }, { id: 'bridge_major_rail_hatching', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'rail'], ['==', ['get', 'brunnel'], 'bridge']], paint: { 'line-color': '#bbb', 'line-dasharray': [0.2, 8], 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14.5, 0, 15, 3, 20, 8] } }, { id: 'bridge_transit_rail', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'transit'], ['==', ['get', 'brunnel'], 'bridge']], paint: { 'line-color': '#bbb', 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14, 0.4, 15, 0.75, 20, 2] } }, { id: 'bridge_transit_rail_hatching', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['==', ['get', 'class'], 'transit'], ['==', ['get', 'brunnel'], 'bridge']], paint: { 'line-color': '#bbb', 'line-dasharray': [0.2, 8], 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 14.5, 0, 15, 3, 20, 8] } }, { id: 'building', type: 'fill', source: 'openmaptiles', 'source-layer': 'building', minzoom: 13, maxzoom: 14, paint: { 'fill-color': 'hsl(35,8%,85%)', 'fill-outline-color': ['interpolate', ['linear'], ['zoom'], 13, 'hsla(35,6%,79%,0.32)', 14, 'hsl(35,6%,79%)'] } }, { id: 'building-3d', type: 'fill-extrusion', source: 'openmaptiles', 'source-layer': 'building', minzoom: 14, paint: { 'fill-extrusion-base': ['get', 'render_min_height'], 'fill-extrusion-color': 'hsl(35,8%,85%)', 'fill-extrusion-height': ['get', 'render_height'], 'fill-extrusion-opacity': 0.8 } }, { id: 'boundary_3', type: 'line', source: 'openmaptiles', 'source-layer': 'boundary', minzoom: 5, filter: ['all', ['>=', ['get', 'admin_level'], 3], ['<=', ['get', 'admin_level'], 6], ['!=', ['get', 'maritime'], 1], ['!=', ['get', 'disputed'], 1], ['!', ['has', 'claimed_by']]], paint: { 'line-color': 'hsl(0,0%,70%)', 'line-dasharray': [1, 1], 'line-width': ['interpolate', ['linear', 1], ['zoom'], 7, 1, 11, 2] } }, { id: 'boundary_2', type: 'line', source: 'openmaptiles', 'source-layer': 'boundary', filter: ['all', ['==', ['get', 'admin_level'], 2], ['!=', ['get', 'maritime'], 1], ['!=', ['get', 'disputed'], 1], ['!', ['has', 'claimed_by']]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'hsl(248,1%,41%)', 'line-opacity': ['interpolate', ['linear'], ['zoom'], 0, 0.4, 4, 1], 'line-width': ['interpolate', ['linear'], ['zoom'], 3, 1, 5, 1.2, 12, 3] } }, { id: 'boundary_disputed', type: 'line', source: 'openmaptiles', 'source-layer': 'boundary', filter: ['all', ['!=', ['get', 'maritime'], 1], ['==', ['get', 'disputed'], 1]], paint: { 'line-color': 'hsl(248,1%,41%)', 'line-dasharray': [1, 2], 'line-width': ['interpolate', ['linear'], ['zoom'], 3, 1, 5, 1.2, 12, 3] } }, { id: 'waterway_line_label', type: 'symbol', source: 'openmaptiles', 'source-layer': 'waterway', minzoom: 10, filter: ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], layout: { 'symbol-placement': 'line', 'symbol-spacing': 350, 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.2, 'text-max-width': 5, 'text-size': 14 }, paint: { 'text-color': '#74aee9', 'text-halo-color': 'rgba(255,255,255,0.7)', 'text-halo-width': 1.5 } }, { id: 'water_name_point_label', type: 'symbol', source: 'openmaptiles', 'source-layer': 'water_name', filter: ['match', ['geometry-type'], ['MultiPoint', 'Point'], true, false], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.2, 'text-max-width': 5, 'text-size': ['interpolate', ['linear'], ['zoom'], 0, 10, 8, 14] }, paint: { 'text-color': '#495e91', 'text-halo-color': 'rgba(255,255,255,0.7)', 'text-halo-width': 1.5 } }, { id: 'water_name_line_label', type: 'symbol', source: 'openmaptiles', 'source-layer': 'water_name', filter: ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], layout: { 'symbol-placement': 'line', 'symbol-spacing': 350, 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.2, 'text-max-width': 5, 'text-size': 14 }, paint: { 'text-color': '#495e91', 'text-halo-color': 'rgba(255,255,255,0.7)', 'text-halo-width': 1.5 } }, { id: 'poi_r20', type: 'symbol', source: 'openmaptiles', 'source-layer': 'poi', minzoom: 17, filter: ['all', ['match', ['geometry-type'], ['MultiPoint', 'Point'], true, false], ['>=', ['get', 'rank'], 20]], layout: { 'icon-image': ['match', ['get', 'subclass'], ['florist', 'furniture'], ['get', 'subclass'], ['get', 'class']], 'text-anchor': 'top', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-max-width': 9, 'text-offset': [0, 0.6], 'text-size': 12 }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-color': '#ffffff', 'text-halo-width': 1 } }, { id: 'poi_r7', type: 'symbol', source: 'openmaptiles', 'source-layer': 'poi', minzoom: 16, filter: ['all', ['match', ['geometry-type'], ['MultiPoint', 'Point'], true, false], ['>=', ['get', 'rank'], 7], ['<', ['get', 'rank'], 20]], layout: { 'icon-image': ['match', ['get', 'subclass'], ['florist', 'furniture'], ['get', 'subclass'], ['get', 'class']], 'text-anchor': 'top', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-max-width': 9, 'text-offset': [0, 0.6], 'text-size': 12 }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-color': '#ffffff', 'text-halo-width': 1 } }, { id: 'poi_r1', type: 'symbol', source: 'openmaptiles', 'source-layer': 'poi', minzoom: 15, filter: ['all', ['match', ['geometry-type'], ['MultiPoint', 'Point'], true, false], ['>=', ['get', 'rank'], 1], ['<', ['get', 'rank'], 7]], layout: { 'icon-image': ['match', ['get', 'subclass'], ['florist', 'furniture'], ['get', 'subclass'], ['get', 'class']], 'text-anchor': 'top', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-max-width': 9, 'text-offset': [0, 0.6], 'text-size': 12 }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-color': '#ffffff', 'text-halo-width': 1 } }, { id: 'poi_transit', type: 'symbol', source: 'openmaptiles', 'source-layer': 'poi', filter: ['match', ['get', 'class'], ['airport', 'bus', 'rail'], true, false], layout: { 'icon-image': ['to-string', ['get', 'class']], 'icon-size': 0.7, 'text-anchor': 'left', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-max-width': 9, 'text-offset': [0.9, 0], 'text-size': 12 }, paint: { 'text-color': '#2e5a80', 'text-halo-blur': 0.5, 'text-halo-color': '#ffffff', 'text-halo-width': 1 } }, { id: 'highway-name-path', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 15.5, filter: ['==', ['get', 'class'], 'path'], layout: { 'symbol-placement': 'line', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'map', 'text-size': ['interpolate', ['linear'], ['zoom'], 13, 12, 14, 13] }, paint: { 'text-color': 'hsl(30,23%,62%)', 'text-halo-color': '#f8f4f0', 'text-halo-width': 0.5 } }, { id: 'highway-name-minor', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 15, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'class'], ['minor', 'service', 'track'], true, false]], layout: { 'symbol-placement': 'line', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'map', 'text-size': ['interpolate', ['linear'], ['zoom'], 13, 12, 14, 13] }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-width': 1 } }, { id: 'highway-name-major', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 12.2, filter: ['match', ['get', 'class'], ['primary', 'secondary', 'tertiary', 'trunk'], true, false], layout: { 'symbol-placement': 'line', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'map', 'text-size': ['interpolate', ['linear'], ['zoom'], 13, 12, 14, 13] }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-width': 1 } }, { id: 'highway-shield-non-us', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 8, filter: ['all', ['<=', ['get', 'ref_length'], 6], ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'network'], ['us-highway', 'us-interstate', 'us-state'], false, true]], layout: { 'icon-image': ['concat', 'road_', ['get', 'ref_length']], 'icon-rotation-alignment': 'viewport', 'icon-size': 1, 'symbol-placement': ['step', ['zoom'], 'point', 11, 'line'], 'symbol-spacing': 200, 'text-field': ['to-string', ['get', 'ref']], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'viewport', 'text-size': 10 } }, { id: 'highway-shield-us-interstate', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 7, filter: ['all', ['<=', ['get', 'ref_length'], 6], ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'network'], ['us-interstate'], true, false]], layout: { 'icon-image': ['concat', ['get', 'network'], '_', ['get', 'ref_length']], 'icon-rotation-alignment': 'viewport', 'icon-size': 1, 'symbol-placement': ['step', ['zoom'], 'point', 7, 'line', 8, 'line'], 'symbol-spacing': 200, 'text-field': ['to-string', ['get', 'ref']], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'viewport', 'text-size': 10 } }, { id: 'road_shield_us', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 9, filter: ['all', ['<=', ['get', 'ref_length'], 6], ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'network'], ['us-highway', 'us-state'], true, false]], layout: { 'icon-image': ['concat', ['get', 'network'], '_', ['get', 'ref_length']], 'icon-rotation-alignment': 'viewport', 'icon-size': 1, 'symbol-placement': ['step', ['zoom'], 'point', 11, 'line'], 'symbol-spacing': 200, 'text-field': ['to-string', ['get', 'ref']], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'viewport', 'text-size': 10 } }, { id: 'airport', type: 'symbol', source: 'openmaptiles', 'source-layer': 'aerodrome_label', minzoom: 10, filter: ['all', ['has', 'iata']], layout: { 'icon-image': 'airport_11', 'icon-size': 1, 'text-anchor': 'top', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-max-width': 9, 'text-offset': [0, 0.6], 'text-optional': true, 'text-padding': 2, 'text-size': 12 }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-color': '#ffffff', 'text-halo-width': 1 } }, { id: 'label_other', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 8, filter: ['match', ['get', 'class'], ['city', 'continent', 'country', 'state', 'town', 'village'], false, true], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.1, 'text-max-width': 9, 'text-size': ['interpolate', ['linear'], ['zoom'], 8, 9, 12, 10], 'text-transform': 'uppercase' }, paint: { 'text-color': '#333', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_village', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 9, filter: ['==', ['get', 'class'], 'village'], layout: { 'icon-allow-overlap': true, 'icon-image': ['step', ['zoom'], 'circle_11_black', 10, ''], 'icon-optional': false, 'icon-size': 0.2, 'text-anchor': 'bottom', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-max-width': 8, 'text-size': ['interpolate', ['exponential', 1.2], ['zoom'], 7, 10, 11, 12] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_town', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 6, filter: ['==', ['get', 'class'], 'town'], layout: { 'icon-allow-overlap': true, 'icon-image': ['step', ['zoom'], 'circle_11_black', 10, ''], 'icon-optional': false, 'icon-size': 0.2, 'text-anchor': 'bottom', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-max-width': 8, 'text-size': ['interpolate', ['exponential', 1.2], ['zoom'], 7, 12, 11, 14] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_state', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 5, maxzoom: 8, filter: ['==', ['get', 'class'], 'state'], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.2, 'text-max-width': 9, 'text-size': ['interpolate', ['linear'], ['zoom'], 5, 10, 8, 14], 'text-transform': 'uppercase' }, paint: { 'text-color': '#333', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_city', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 3, filter: ['all', ['==', ['get', 'class'], 'city'], ['!=', ['get', 'capital'], 2]], layout: { 'icon-allow-overlap': true, 'icon-image': ['step', ['zoom'], 'circle_11_black', 9, ''], 'icon-optional': false, 'icon-size': 0.4, 'text-anchor': 'bottom', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-max-width': 8, 'text-offset': [0, -0.1], 'text-size': ['interpolate', ['exponential', 1.2], ['zoom'], 4, 11, 7, 13, 11, 18] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_city_capital', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 3, filter: ['all', ['==', ['get', 'class'], 'city'], ['==', ['get', 'capital'], 2]], layout: { 'icon-allow-overlap': true, 'icon-image': ['step', ['zoom'], 'circle_11_black', 9, ''], 'icon-optional': false, 'icon-size': 0.5, 'text-anchor': 'bottom', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Bold'], 'text-max-width': 8, 'text-offset': [0, -0.2], 'text-size': ['interpolate', ['exponential', 1.2], ['zoom'], 4, 12, 7, 14, 11, 20] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_country_3', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 2, maxzoom: 9, filter: ['all', ['==', ['get', 'class'], 'country'], ['>=', ['get', 'rank'], 3]], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Bold'], 'text-max-width': 6.25, 'text-size': ['interpolate', ['linear'], ['zoom'], 3, 9, 7, 17] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_country_2', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', maxzoom: 9, filter: ['all', ['==', ['get', 'class'], 'country'], ['==', ['get', 'rank'], 2]], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Bold'], 'text-max-width': 6.25, 'text-size': ['interpolate', ['linear'], ['zoom'], 2, 9, 5, 17] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_country_1', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', maxzoom: 9, filter: ['all', ['==', ['get', 'class'], 'country'], ['==', ['get', 'rank'], 1]], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Bold'], 'text-max-width': 6.25, 'text-size': ['interpolate', ['linear'], ['zoom'], 1, 9, 4, 17] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }] }

window.GOVUK.gdsTransport = {
  version: 8,
  sources: {
    ne2_shaded: {
      maxzoom: 6,
      tileSize: 256,
      tiles: [
        'https://tiles.openfreemap.org/natural_earth/ne2sr/{z}/{x}/{y}.png'
      ],
      type: 'raster'
    },
    openmaptiles: {
      type: 'vector',
      url: 'https://tiles.openfreemap.org/planet'
    }
  },
  sprite: 'https://tiles.openfreemap.org/sprites/ofm_f384/ofm',
  glyphs: 'https://tiles.openfreemap.org/fonts/{fontstack}/{range}.pbf',
  layers: [
    {
      id: 'background',
      type: 'background',
      paint: {
        'background-color': '#f8f4f0'
      }
    },
    {
      id: 'natural_earth',
      type: 'raster',
      source: 'ne2_shaded',
      maxzoom: 7,
      paint: {
        'raster-opacity': [
          'interpolate',
          ['exponential', 1.5],
          ['zoom'],
          0,
          0.6,
          6,
          0.1
        ]
      }
    },
    {
      id: 'park',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'park',
      paint: {
        'fill-color': '#d8e8c8',
        'fill-opacity': 0.7,
        'fill-outline-color': 'rgba(95, 208, 100, 1)'
      }
    },
    {
      id: 'park_outline',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'park',
      paint: {
        'line-color': 'rgba(228, 241, 215, 1)',
        'line-dasharray': [1, 1.5]
      }
    },
    {
      id: 'landuse_residential',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      maxzoom: 12,
      filter: [
        '==',
        ['get', 'class'],
        'residential'
      ],
      paint: {
        'fill-color': [
          'interpolate',
          ['linear'],
          ['zoom'],
          9,
          'hsla(0,3%,85%,0.84)',
          12,
          'hsla(35,57%,88%,0.49)'
        ]
      }
    },
    {
      id: 'landcover_wood',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      filter: [
        '==',
        ['get', 'class'],
        'wood'
      ],
      paint: {
        'fill-antialias': false,
        'fill-color': 'hsla(98,61%,72%,0.7)',
        'fill-opacity': 0.4
      }
    },
    {
      id: 'landcover_grass',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      filter: [
        '==',
        ['get', 'class'],
        'grass'
      ],
      paint: {
        'fill-antialias': false,
        'fill-color': 'rgba(176, 213, 154, 1)',
        'fill-opacity': 0.3
      }
    },
    {
      id: 'landcover_ice',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      filter: [
        '==',
        ['get', 'class'],
        'ice'
      ],
      paint: {
        'fill-antialias': false,
        'fill-color': 'rgba(224, 236, 236, 1)',
        'fill-opacity': 0.8
      }
    },
    {
      id: 'landcover_wetland',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      minzoom: 12,
      filter: [
        '==',
        ['get', 'class'],
        'wetland'
      ],
      paint: {
        'fill-antialias': true,
        'fill-opacity': 0.8,
        'fill-pattern': 'wetland_bg_11',
        'fill-translate-anchor': 'map'
      }
    },
    {
      id: 'landuse_pitch',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'pitch'
      ],
      paint: { 'fill-color': '#DEE3CD' }
    },
    {
      id: 'landuse_track',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'track'
      ],
      paint: { 'fill-color': '#DEE3CD' }
    },
    {
      id: 'landuse_cemetery',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'cemetery'
      ],
      paint: {
        'fill-color': 'hsl(75,37%,81%)'
      }
    },
    {
      id: 'landuse_hospital',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'hospital'
      ],
      paint: { 'fill-color': '#fde' }
    },
    {
      id: 'landuse_school',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'school'
      ],
      paint: {
        'fill-color': 'rgb(236,238,204)'
      }
    },
    {
      id: 'waterway_tunnel',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'waterway',
      filter: [
        '==',
        ['get', 'brunnel'],
        'tunnel'
      ],
      paint: {
        'line-color': '#a0c8f0',
        'line-dasharray': [3, 3],
        'line-gap-width': [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          0,
          20,
          6
        ],
        'line-opacity': 1,
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          8,
          1,
          20,
          2
        ]
      }
    },
    {
      id: 'waterway_river',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'waterway',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'river'
        ],
        [
          '!=',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-cap': 'round' },
      paint: {
        'line-color': '#a0c8f0',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          11,
          0.5,
          20,
          6
        ]
      }
    },
    {
      id: 'waterway_other',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'waterway',
      filter: [
        'all',
        [
          '!=',
          ['get', 'class'],
          'river'
        ],
        [
          '!=',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-cap': 'round' },
      paint: {
        'line-color': '#a0c8f0',
        'line-width': [
          'interpolate',
          ['exponential', 1.3],
          ['zoom'],
          13,
          0.5,
          20,
          6
        ]
      }
    },
    {
      id: 'water',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'water',
      filter: [
        '!=',
        ['get', 'brunnel'],
        'tunnel'
      ],
      paint: {
        'fill-color': 'rgb(158,189,255)'
      }
    },
    {
      id: 'landcover_sand',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      filter: [
        '==',
        ['get', 'class'],
        'sand'
      ],
      paint: {
        'fill-color': 'rgba(247, 239, 195, 1)'
      }
    },
    {
      id: 'aeroway_fill',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'aeroway',
      minzoom: 11,
      filter: [
        'match',
        ['geometry-type'],
        ['MultiPolygon', 'Polygon'],
        true,
        false
      ],
      paint: {
        'fill-color': 'rgba(229, 228, 224, 1)',
        'fill-opacity': 0.7
      }
    },
    {
      id: 'aeroway_runway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'aeroway',
      minzoom: 11,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'class'],
          'runway'
        ]
      ],
      paint: {
        'line-color': '#f0ede9',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          11,
          3,
          20,
          16
        ]
      }
    },
    {
      id: 'aeroway_taxiway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'aeroway',
      minzoom: 11,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'class'],
          'taxiway'
        ]
      ],
      paint: {
        'line-color': '#f0ede9',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          11,
          0.5,
          20,
          6
        ]
      }
    },
    {
      id: 'tunnel_motorway_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-dasharray': [0.5, 0.25],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'tunnel_service_track_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#cfcdca',
        'line-dasharray': [0.5, 0.25],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15,
          1,
          16,
          4,
          20,
          11
        ]
      }
    },
    {
      id: 'tunnel_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'tunnel_street_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['street', 'street_limited'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#cfcdca',
        'line-opacity': [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          0,
          12.5,
          1
        ],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          0.5,
          13,
          1,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'tunnel_secondary_tertiary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          8,
          1.5,
          20,
          17
        ]
      }
    },
    {
      id: 'tunnel_trunk_primary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'tunnel_motorway_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-dasharray': [0.5, 0.25],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'tunnel_path_pedestrian',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['path', 'pedestrian'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': 'hsl(0,0%,100%)',
        'line-dasharray': [1, 0.75],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          14,
          0.5,
          20,
          10
        ]
      }
    },
    {
      id: 'tunnel_motorway_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fc8',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'tunnel_service_track',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15.5,
          0,
          16,
          2,
          20,
          7.5
        ]
      }
    },
    {
      id: 'tunnel_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff4c6',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'tunnel_minor',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['minor'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          13.5,
          0,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'tunnel_secondary_tertiary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff4c6',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          6.5,
          0,
          7,
          0.5,
          20,
          10
        ]
      }
    },
    {
      id: 'tunnel_trunk_primary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff4c6',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'tunnel_motorway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#ffdaa6',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'tunnel_major_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['rail'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'tunnel_major_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        ['==', ['get', 'class'], 'rail']
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'tunnel_transit_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['transit'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'tunnel_transit_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          '==',
          ['get', 'class'],
          'transit'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'road_area_pattern',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'match',
        ['geometry-type'],
        ['MultiPolygon', 'Polygon'],
        true,
        false
      ],
      paint: {
        'fill-pattern': 'pedestrian_polygon'
      }
    },
    {
      id: 'road_motorway_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 12,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'road_service_track_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#cfcdca',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15,
          1,
          16,
          4,
          20,
          11
        ]
      }
    },
    {
      id: 'road_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 13,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          [
            'motorway',
            'path',
            'pedestrian',
            'service',
            'track'
          ],
          false,
          true
        ],
        ['==', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'road_minor_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['minor'],
          true,
          false
        ],
        ['!=', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#cfcdca',
        'line-opacity': [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          0,
          12.5,
          1
        ],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          0.5,
          13,
          1,
          14,
          4,
          20,
          20
        ]
      }
    },
    {
      id: 'road_secondary_tertiary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ],
        ['!=', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          8,
          1.5,
          20,
          17
        ]
      }
    },
    {
      id: 'road_trunk_primary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'road_motorway_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 5,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'road_path_pedestrian',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 14,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['path', 'pedestrian'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': 'hsl(0,0%,100%)',
        'line-dasharray': [1, 0.7],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          14,
          1,
          20,
          10
        ]
      }
    },
    {
      id: 'road_motorway_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 12,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fc8',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'road_service_track',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15.5,
          0,
          16,
          2,
          20,
          7.5
        ]
      }
    },
    {
      id: 'road_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 13,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        ['==', ['get', 'ramp'], 1],
        [
          'match',
          ['get', 'class'],
          [
            'motorway',
            'path',
            'pedestrian',
            'service',
            'track'
          ],
          false,
          true
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'road_minor',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['minor'],
          true,
          false
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          13.5,
          0,
          14,
          2.5,
          20,
          18
        ]
      }
    },
    {
      id: 'road_secondary_tertiary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          6.5,
          0,
          8,
          0.5,
          20,
          13
        ]
      }
    },
    {
      id: 'road_trunk_primary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'road_motorway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 5,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': [
          'interpolate',
          ['linear'],
          ['zoom'],
          5,
          'hsl(26,87%,62%)',
          6,
          '#fc8'
        ],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'road_major_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        ['==', ['get', 'class'], 'rail']
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'road_major_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        ['==', ['get', 'class'], 'rail']
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'road_transit_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'transit'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'road_transit_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'transit'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'road_one_way_arrow',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 16,
      filter: [
        '==',
        ['get', 'oneway'],
        1
      ],
      layout: {
        'icon-image': 'arrow',
        'symbol-placement': 'line'
      }
    },
    {
      id: 'road_one_way_arrow_opposite',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 16,
      filter: [
        '==',
        ['get', 'oneway'],
        -1
      ],
      layout: {
        'icon-image': 'arrow',
        'icon-rotate': 180,
        'symbol-placement': 'line'
      }
    },
    {
      id: 'bridge_motorway_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'bridge_service_track_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#cfcdca',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15,
          1,
          16,
          4,
          20,
          11
        ]
      }
    },
    {
      id: 'bridge_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'link'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'bridge_street_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['street', 'street_limited'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': 'hsl(36,6%,74%)',
        'line-opacity': [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          0,
          12.5,
          1
        ],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          0.5,
          13,
          1,
          14,
          4,
          20,
          25
        ]
      }
    },
    {
      id: 'bridge_path_pedestrian_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['path', 'pedestrian'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': 'hsl(35,6%,80%)',
        'line-dasharray': [1, 0],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          14,
          1.5,
          20,
          18
        ]
      }
    },
    {
      id: 'bridge_secondary_tertiary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          8,
          1.5,
          20,
          17
        ]
      }
    },
    {
      id: 'bridge_trunk_primary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'bridge_motorway_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'bridge_path_pedestrian',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['path', 'pedestrian'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': 'hsl(0,0%,100%)',
        'line-dasharray': [1, 0.3],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          14,
          0.5,
          20,
          10
        ]
      }
    },
    {
      id: 'bridge_motorway_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fc8',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'bridge_service_track',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15.5,
          0,
          16,
          2,
          20,
          7.5
        ]
      }
    },
    {
      id: 'bridge_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'link'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'bridge_street',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['minor'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          13.5,
          0,
          14,
          2.5,
          20,
          18
        ]
      }
    },
    {
      id: 'bridge_secondary_tertiary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          6.5,
          0,
          7,
          0.5,
          20,
          10
        ]
      }
    },
    {
      id: 'bridge_trunk_primary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'bridge_motorway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fc8',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'bridge_major_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'rail'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'bridge_major_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'rail'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'bridge_transit_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'transit'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'bridge_transit_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'transit'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'building',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'building',
      minzoom: 13,
      maxzoom: 14,
      paint: {
        'fill-color': 'hsl(35,8%,85%)',
        'fill-outline-color': [
          'interpolate',
          ['linear'],
          ['zoom'],
          13,
          'hsla(35,6%,79%,0.32)',
          14,
          'hsl(35,6%,79%)'
        ]
      }
    },
    {
      id: 'building-3d',
      type: 'fill-extrusion',
      source: 'openmaptiles',
      'source-layer': 'building',
      minzoom: 14,
      paint: {
        'fill-extrusion-base': [
          'get',
          'render_min_height'
        ],
        'fill-extrusion-color': 'hsl(35,8%,85%)',
        'fill-extrusion-height': [
          'get',
          'render_height'
        ],
        'fill-extrusion-opacity': 0.8
      }
    },
    {
      id: 'boundary_3',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'boundary',
      minzoom: 5,
      filter: [
        'all',
        [
          '>=',
          ['get', 'admin_level'],
          3
        ],
        [
          '<=',
          ['get', 'admin_level'],
          6
        ],
        ['!=', ['get', 'maritime'], 1],
        ['!=', ['get', 'disputed'], 1],
        ['!', ['has', 'claimed_by']]
      ],
      paint: {
        'line-color': 'hsl(0,0%,70%)',
        'line-dasharray': [1, 1],
        'line-width': [
          'interpolate',
          ['linear', 1],
          ['zoom'],
          7,
          1,
          11,
          2
        ]
      }
    },
    {
      id: 'boundary_2',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'boundary',
      filter: [
        'all',
        [
          '==',
          ['get', 'admin_level'],
          2
        ],
        ['!=', ['get', 'maritime'], 1],
        ['!=', ['get', 'disputed'], 1],
        ['!', ['has', 'claimed_by']]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': 'hsl(248,1%,41%)',
        'line-opacity': [
          'interpolate',
          ['linear'],
          ['zoom'],
          0,
          0.4,
          4,
          1
        ],
        'line-width': [
          'interpolate',
          ['linear'],
          ['zoom'],
          3,
          1,
          5,
          1.2,
          12,
          3
        ]
      }
    },
    {
      id: 'boundary_disputed',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'boundary',
      filter: [
        'all',
        ['!=', ['get', 'maritime'], 1],
        ['==', ['get', 'disputed'], 1]
      ],
      paint: {
        'line-color': 'hsl(248,1%,41%)',
        'line-dasharray': [1, 2],
        'line-width': [
          'interpolate',
          ['linear'],
          ['zoom'],
          3,
          1,
          5,
          1.2,
          12,
          3
        ]
      }
    },
    {
      id: 'waterway_line_label',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'waterway',
      minzoom: 10,
      filter: [
        'match',
        ['geometry-type'],
        [
          'LineString',
          'MultiLineString'
        ],
        true,
        false
      ],
      layout: {
        'symbol-placement': 'line',
        'symbol-spacing': 350,
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-letter-spacing': 0.2,
        'text-max-width': 5,
        'text-size': 14
      },
      paint: {
        'text-color': '#74aee9',
        'text-halo-color': 'rgba(255,255,255,0.7)',
        'text-halo-width': 1.5
      }
    },
    {
      id: 'water_name_point_label',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'water_name',
      filter: [
        'match',
        ['geometry-type'],
        ['MultiPoint', 'Point'],
        true,
        false
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-letter-spacing': 0.2,
        'text-max-width': 5,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          0,
          10,
          8,
          14
        ]
      },
      paint: {
        'text-color': '#495e91',
        'text-halo-color': 'rgba(255,255,255,0.7)',
        'text-halo-width': 1.5
      }
    },
    {
      id: 'water_name_line_label',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'water_name',
      filter: [
        'match',
        ['geometry-type'],
        [
          'LineString',
          'MultiLineString'
        ],
        true,
        false
      ],
      layout: {
        'symbol-placement': 'line',
        'symbol-spacing': 350,
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-letter-spacing': 0.2,
        'text-max-width': 5,
        'text-size': 14
      },
      paint: {
        'text-color': '#495e91',
        'text-halo-color': 'rgba(255,255,255,0.7)',
        'text-halo-width': 1.5
      }
    },
    {
      id: 'poi_r20',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'poi',
      minzoom: 17,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          ['MultiPoint', 'Point'],
          true,
          false
        ],
        ['>=', ['get', 'rank'], 20]
      ],
      layout: {
        'icon-image': [
          'match',
          ['get', 'subclass'],
          ['florist', 'furniture'],
          ['get', 'subclass'],
          ['get', 'class']
        ],
        'text-anchor': 'top',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-max-width': 9,
        'text-offset': [0, 0.6],
        'text-size': 12
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'poi_r7',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'poi',
      minzoom: 16,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          ['MultiPoint', 'Point'],
          true,
          false
        ],
        ['>=', ['get', 'rank'], 7],
        ['<', ['get', 'rank'], 20]
      ],
      layout: {
        'icon-image': [
          'match',
          ['get', 'subclass'],
          ['florist', 'furniture'],
          ['get', 'subclass'],
          ['get', 'class']
        ],
        'text-anchor': 'top',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-max-width': 9,
        'text-offset': [0, 0.6],
        'text-size': 12
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'poi_r1',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'poi',
      minzoom: 15,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          ['MultiPoint', 'Point'],
          true,
          false
        ],
        ['>=', ['get', 'rank'], 1],
        ['<', ['get', 'rank'], 7]
      ],
      layout: {
        'icon-image': [
          'match',
          ['get', 'subclass'],
          ['florist', 'furniture'],
          ['get', 'subclass'],
          ['get', 'class']
        ],
        'text-anchor': 'top',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-max-width': 9,
        'text-offset': [0, 0.6],
        'text-size': 12
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'poi_transit',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'poi',
      filter: [
        'match',
        ['get', 'class'],
        ['airport', 'bus', 'rail'],
        true,
        false
      ],
      layout: {
        'icon-image': [
          'to-string',
          ['get', 'class']
        ],
        'icon-size': 0.7,
        'text-anchor': 'left',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-max-width': 9,
        'text-offset': [0.9, 0],
        'text-size': 12
      },
      paint: {
        'text-color': '#2e5a80',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'highway-name-path',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 15.5,
      filter: [
        '==',
        ['get', 'class'],
        'path'
      ],
      layout: {
        'symbol-placement': 'line',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-rotation-alignment': 'map',
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          13,
          12,
          14,
          13
        ]
      },
      paint: {
        'text-color': 'hsl(30,23%,62%)',
        'text-halo-color': '#f8f4f0',
        'text-halo-width': 0.5
      }
    },
    {
      id: 'highway-name-minor',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 15,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'class'],
          ['minor', 'service', 'track'],
          true,
          false
        ]
      ],
      layout: {
        'symbol-placement': 'line',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-rotation-alignment': 'map',
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          13,
          12,
          14,
          13
        ]
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-width': 1
      }
    },
    {
      id: 'highway-name-major',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 12.2,
      filter: [
        'match',
        ['get', 'class'],
        [
          'primary',
          'secondary',
          'tertiary',
          'trunk'
        ],
        true,
        false
      ],
      layout: {
        'symbol-placement': 'line',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-rotation-alignment': 'map',
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          13,
          12,
          14,
          13
        ]
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-width': 1
      }
    },
    {
      id: 'highway-shield-non-us',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 8,
      filter: [
        'all',
        [
          '<=',
          ['get', 'ref_length'],
          6
        ],
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'network'],
          [
            'us-highway',
            'us-interstate',
            'us-state'
          ],
          false,
          true
        ]
      ],
      layout: {
        'icon-image': [
          'concat',
          'road_',
          ['get', 'ref_length']
        ],
        'icon-rotation-alignment': 'viewport',
        'icon-size': 1,
        'symbol-placement': [
          'step',
          ['zoom'],
          'point',
          11,
          'line'
        ],
        'symbol-spacing': 200,
        'text-field': [
          'to-string',
          ['get', 'ref']
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-rotation-alignment': 'viewport',
        'text-size': 10
      }
    },
    {
      id: 'highway-shield-us-interstate',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 7,
      filter: [
        'all',
        [
          '<=',
          ['get', 'ref_length'],
          6
        ],
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'network'],
          ['us-interstate'],
          true,
          false
        ]
      ],
      layout: {
        'icon-image': [
          'concat',
          ['get', 'network'],
          '_',
          ['get', 'ref_length']
        ],
        'icon-rotation-alignment': 'viewport',
        'icon-size': 1,
        'symbol-placement': [
          'step',
          ['zoom'],
          'point',
          7,
          'line',
          8,
          'line'
        ],
        'symbol-spacing': 200,
        'text-field': [
          'to-string',
          ['get', 'ref']
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-rotation-alignment': 'viewport',
        'text-size': 10
      }
    },
    {
      id: 'road_shield_us',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 9,
      filter: [
        'all',
        [
          '<=',
          ['get', 'ref_length'],
          6
        ],
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'network'],
          ['us-highway', 'us-state'],
          true,
          false
        ]
      ],
      layout: {
        'icon-image': [
          'concat',
          ['get', 'network'],
          '_',
          ['get', 'ref_length']
        ],
        'icon-rotation-alignment': 'viewport',
        'icon-size': 1,
        'symbol-placement': [
          'step',
          ['zoom'],
          'point',
          11,
          'line'
        ],
        'symbol-spacing': 200,
        'text-field': [
          'to-string',
          ['get', 'ref']
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-rotation-alignment': 'viewport',
        'text-size': 10
      }
    },
    {
      id: 'airport',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'aerodrome_label',
      minzoom: 10,
      filter: [
        'all',
        ['has', 'iata']
      ],
      layout: {
        'icon-image': 'airport_11',
        'icon-size': 1,
        'text-anchor': 'top',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-max-width': 9,
        'text-offset': [0, 0.6],
        'text-optional': true,
        'text-padding': 2,
        'text-size': 12
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_other',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 8,
      filter: [
        'match',
        ['get', 'class'],
        [
          'city',
          'continent',
          'country',
          'state',
          'town',
          'village'
        ],
        false,
        true
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-letter-spacing': 0.1,
        'text-max-width': 9,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          8,
          9,
          12,
          10
        ],
        'text-transform': 'uppercase'
      },
      paint: {
        'text-color': '#333',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_village',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 9,
      filter: [
        '==',
        ['get', 'class'],
        'village'
      ],
      layout: {
        'icon-allow-overlap': true,
        'icon-image': [
          'step',
          ['zoom'],
          'circle_11_black',
          10,
          ''
        ],
        'icon-optional': false,
        'icon-size': 0.2,
        'text-anchor': 'bottom',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-max-width': 8,
        'text-size': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          7,
          10,
          11,
          12
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_town',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 6,
      filter: [
        '==',
        ['get', 'class'],
        'town'
      ],
      layout: {
        'icon-allow-overlap': true,
        'icon-image': [
          'step',
          ['zoom'],
          'circle_11_black',
          10,
          ''
        ],
        'icon-optional': false,
        'icon-size': 0.2,
        'text-anchor': 'bottom',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-max-width': 8,
        'text-size': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          7,
          12,
          11,
          14
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_state',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 5,
      maxzoom: 8,
      filter: [
        '==',
        ['get', 'class'],
        'state'
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-letter-spacing': 0.2,
        'text-max-width': 9,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          5,
          10,
          8,
          14
        ],
        'text-transform': 'uppercase'
      },
      paint: {
        'text-color': '#333',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_city',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 3,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'city'
        ],
        ['!=', ['get', 'capital'], 2]
      ],
      layout: {
        'icon-allow-overlap': true,
        'icon-image': [
          'step',
          ['zoom'],
          'circle_11_black',
          9,
          ''
        ],
        'icon-optional': false,
        'icon-size': 0.4,
        'text-anchor': 'bottom',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport'
        ],
        'text-max-width': 8,
        'text-offset': [0, -0.1],
        'text-size': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          4,
          11,
          7,
          13,
          11,
          18
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_city_capital',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 3,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'city'
        ],
        ['==', ['get', 'capital'], 2]
      ],
      layout: {
        'icon-allow-overlap': true,
        'icon-image': [
          'step',
          ['zoom'],
          'circle_11_black',
          9,
          ''
        ],
        'icon-optional': false,
        'icon-size': 0.5,
        'text-anchor': 'bottom',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 8,
        'text-offset': [0, -0.2],
        'text-size': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          4,
          12,
          7,
          14,
          11,
          20
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_country_3',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 2,
      maxzoom: 9,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'country'
        ],
        ['>=', ['get', 'rank'], 3]
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 6.25,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          3,
          9,
          7,
          17
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_country_2',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      maxzoom: 9,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'country'
        ],
        ['==', ['get', 'rank'], 2]
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 6.25,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          2,
          9,
          5,
          17
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_country_1',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      maxzoom: 9,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'country'
        ],
        ['==', ['get', 'rank'], 1]
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 6.25,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          1,
          9,
          4,
          17
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    }
  ],
  id: 'l722aso'
}

window.GOVUK.gdsBlueWater = {
  version: 8,
  sources: {
    ne2_shaded: {
      maxzoom: 6,
      tileSize: 256,
      tiles: [
        'https://tiles.openfreemap.org/natural_earth/ne2sr/{z}/{x}/{y}.png'
      ],
      type: 'raster'
    },
    openmaptiles: {
      type: 'vector',
      url: 'https://tiles.openfreemap.org/planet'
    }
  },
  sprite: 'https://tiles.openfreemap.org/sprites/ofm_f384/ofm',
  glyphs: 'https://tiles.openfreemap.org/fonts/{fontstack}/{range}.pbf',
  layers: [
    {
      id: 'background',
      type: 'background',
      paint: {
        'background-color': '#f8f4f0'
      }
    },
    {
      id: 'natural_earth',
      type: 'raster',
      source: 'ne2_shaded',
      maxzoom: 7,
      paint: {
        'raster-opacity': [
          'interpolate',
          ['exponential', 1.5],
          ['zoom'],
          0,
          0.6,
          6,
          0.1
        ]
      }
    },
    {
      id: 'park',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'park',
      paint: {
        'fill-color': '#d8e8c8',
        'fill-opacity': 0.7,
        'fill-outline-color': 'rgba(95, 208, 100, 1)'
      }
    },
    {
      id: 'park_outline',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'park',
      paint: {
        'line-color': 'rgba(228, 241, 215, 1)',
        'line-dasharray': [1, 1.5]
      }
    },
    {
      id: 'landuse_residential',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      maxzoom: 12,
      filter: [
        '==',
        ['get', 'class'],
        'residential'
      ],
      paint: {
        'fill-color': [
          'interpolate',
          ['linear'],
          ['zoom'],
          9,
          'hsla(0,3%,85%,0.84)',
          12,
          'hsla(35,57%,88%,0.49)'
        ]
      }
    },
    {
      id: 'landcover_wood',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      filter: [
        '==',
        ['get', 'class'],
        'wood'
      ],
      paint: {
        'fill-antialias': false,
        'fill-color': 'hsla(98,61%,72%,0.7)',
        'fill-opacity': 0.4
      }
    },
    {
      id: 'landcover_grass',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      filter: [
        '==',
        ['get', 'class'],
        'grass'
      ],
      paint: {
        'fill-antialias': false,
        'fill-color': 'rgba(176, 213, 154, 1)',
        'fill-opacity': 0.3
      }
    },
    {
      id: 'landcover_ice',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      filter: [
        '==',
        ['get', 'class'],
        'ice'
      ],
      paint: {
        'fill-antialias': false,
        'fill-color': 'rgba(224, 236, 236, 1)',
        'fill-opacity': 0.8
      }
    },
    {
      id: 'landcover_wetland',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      minzoom: 12,
      filter: [
        '==',
        ['get', 'class'],
        'wetland'
      ],
      paint: {
        'fill-antialias': true,
        'fill-opacity': 0.8,
        'fill-pattern': 'wetland_bg_11',
        'fill-translate-anchor': 'map'
      }
    },
    {
      id: 'landuse_pitch',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'pitch'
      ],
      paint: { 'fill-color': '#DEE3CD' }
    },
    {
      id: 'landuse_track',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'track'
      ],
      paint: { 'fill-color': '#DEE3CD' }
    },
    {
      id: 'landuse_cemetery',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'cemetery'
      ],
      paint: {
        'fill-color': 'hsl(75,37%,81%)'
      }
    },
    {
      id: 'landuse_hospital',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'hospital'
      ],
      paint: { 'fill-color': '#fde' }
    },
    {
      id: 'landuse_school',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landuse',
      filter: [
        '==',
        ['get', 'class'],
        'school'
      ],
      paint: {
        'fill-color': 'rgb(236,238,204)'
      }
    },
    {
      id: 'waterway_tunnel',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'waterway',
      filter: [
        '==',
        ['get', 'brunnel'],
        'tunnel'
      ],
      paint: {
        'line-color': '#a0c8f0',
        'line-dasharray': [3, 3],
        'line-gap-width': [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          0,
          20,
          6
        ],
        'line-opacity': 1,
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          8,
          1,
          20,
          2
        ]
      }
    },
    {
      id: 'waterway_river',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'waterway',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'river'
        ],
        [
          '!=',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-cap': 'round' },
      paint: {
        'line-color': '#a0c8f0',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          11,
          0.5,
          20,
          6
        ]
      }
    },
    {
      id: 'waterway_other',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'waterway',
      filter: [
        'all',
        [
          '!=',
          ['get', 'class'],
          'river'
        ],
        [
          '!=',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-cap': 'round' },
      paint: {
        'line-color': '#a0c8f0',
        'line-width': [
          'interpolate',
          ['exponential', 1.3],
          ['zoom'],
          13,
          0.5,
          20,
          6
        ]
      }
    },
    {
      id: 'water',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'water',
      filter: [
        '!=',
        ['get', 'brunnel'],
        'tunnel'
      ],
      paint: {
        'fill-color': '#1d70b8'
      }
    },
    {
      id: 'landcover_sand',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'landcover',
      filter: [
        '==',
        ['get', 'class'],
        'sand'
      ],
      paint: {
        'fill-color': 'rgba(247, 239, 195, 1)'
      }
    },
    {
      id: 'aeroway_fill',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'aeroway',
      minzoom: 11,
      filter: [
        'match',
        ['geometry-type'],
        ['MultiPolygon', 'Polygon'],
        true,
        false
      ],
      paint: {
        'fill-color': 'rgba(229, 228, 224, 1)',
        'fill-opacity': 0.7
      }
    },
    {
      id: 'aeroway_runway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'aeroway',
      minzoom: 11,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'class'],
          'runway'
        ]
      ],
      paint: {
        'line-color': '#f0ede9',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          11,
          3,
          20,
          16
        ]
      }
    },
    {
      id: 'aeroway_taxiway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'aeroway',
      minzoom: 11,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'class'],
          'taxiway'
        ]
      ],
      paint: {
        'line-color': '#f0ede9',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          11,
          0.5,
          20,
          6
        ]
      }
    },
    {
      id: 'tunnel_motorway_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-dasharray': [0.5, 0.25],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'tunnel_service_track_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#cfcdca',
        'line-dasharray': [0.5, 0.25],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15,
          1,
          16,
          4,
          20,
          11
        ]
      }
    },
    {
      id: 'tunnel_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'tunnel_street_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['street', 'street_limited'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#cfcdca',
        'line-opacity': [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          0,
          12.5,
          1
        ],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          0.5,
          13,
          1,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'tunnel_secondary_tertiary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          8,
          1.5,
          20,
          17
        ]
      }
    },
    {
      id: 'tunnel_trunk_primary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'tunnel_motorway_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-dasharray': [0.5, 0.25],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'tunnel_path_pedestrian',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['path', 'pedestrian'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': 'hsl(0,0%,100%)',
        'line-dasharray': [1, 0.75],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          14,
          0.5,
          20,
          10
        ]
      }
    },
    {
      id: 'tunnel_motorway_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fc8',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'tunnel_service_track',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15.5,
          0,
          16,
          2,
          20,
          7.5
        ]
      }
    },
    {
      id: 'tunnel_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff4c6',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'tunnel_minor',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['minor'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          13.5,
          0,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'tunnel_secondary_tertiary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff4c6',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          6.5,
          0,
          7,
          0.5,
          20,
          10
        ]
      }
    },
    {
      id: 'tunnel_trunk_primary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff4c6',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'tunnel_motorway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#ffdaa6',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'tunnel_major_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['rail'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'tunnel_major_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        ['==', ['get', 'class'], 'rail']
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'tunnel_transit_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          'match',
          ['get', 'class'],
          ['transit'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'tunnel_transit_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'tunnel'
        ],
        [
          '==',
          ['get', 'class'],
          'transit'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'road_area_pattern',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'match',
        ['geometry-type'],
        ['MultiPolygon', 'Polygon'],
        true,
        false
      ],
      paint: {
        'fill-pattern': 'pedestrian_polygon'
      }
    },
    {
      id: 'road_motorway_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 12,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'road_service_track_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#cfcdca',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15,
          1,
          16,
          4,
          20,
          11
        ]
      }
    },
    {
      id: 'road_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 13,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          [
            'motorway',
            'path',
            'pedestrian',
            'service',
            'track'
          ],
          false,
          true
        ],
        ['==', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'road_minor_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['minor'],
          true,
          false
        ],
        ['!=', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#cfcdca',
        'line-opacity': [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          0,
          12.5,
          1
        ],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          0.5,
          13,
          1,
          14,
          4,
          20,
          20
        ]
      }
    },
    {
      id: 'road_secondary_tertiary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ],
        ['!=', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          8,
          1.5,
          20,
          17
        ]
      }
    },
    {
      id: 'road_trunk_primary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'road_motorway_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 5,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'road_path_pedestrian',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 14,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['path', 'pedestrian'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': 'hsl(0,0%,100%)',
        'line-dasharray': [1, 0.7],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          14,
          1,
          20,
          10
        ]
      }
    },
    {
      id: 'road_motorway_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 12,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fc8',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'road_service_track',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15.5,
          0,
          16,
          2,
          20,
          7.5
        ]
      }
    },
    {
      id: 'road_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 13,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        ['==', ['get', 'ramp'], 1],
        [
          'match',
          ['get', 'class'],
          [
            'motorway',
            'path',
            'pedestrian',
            'service',
            'track'
          ],
          false,
          true
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'road_minor',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['minor'],
          true,
          false
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          13.5,
          0,
          14,
          2.5,
          20,
          18
        ]
      }
    },
    {
      id: 'road_secondary_tertiary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          6.5,
          0,
          8,
          0.5,
          20,
          13
        ]
      }
    },
    {
      id: 'road_trunk_primary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'road_motorway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 5,
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': [
          'interpolate',
          ['linear'],
          ['zoom'],
          5,
          'hsl(26,87%,62%)',
          6,
          '#fc8'
        ],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'road_major_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        ['==', ['get', 'class'], 'rail']
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'road_major_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        ['==', ['get', 'class'], 'rail']
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'road_transit_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'transit'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'road_transit_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['get', 'brunnel'],
          ['bridge', 'tunnel'],
          false,
          true
        ],
        [
          '==',
          ['get', 'class'],
          'transit'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'road_one_way_arrow',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 16,
      filter: [
        '==',
        ['get', 'oneway'],
        1
      ],
      layout: {
        'icon-image': 'arrow',
        'symbol-placement': 'line'
      }
    },
    {
      id: 'road_one_way_arrow_opposite',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      minzoom: 16,
      filter: [
        '==',
        ['get', 'oneway'],
        -1
      ],
      layout: {
        'icon-image': 'arrow',
        'icon-rotate': 180,
        'symbol-placement': 'line'
      }
    },
    {
      id: 'bridge_motorway_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'bridge_service_track_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#cfcdca',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15,
          1,
          16,
          4,
          20,
          11
        ]
      }
    },
    {
      id: 'bridge_link_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'link'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          1,
          13,
          3,
          14,
          4,
          20,
          15
        ]
      }
    },
    {
      id: 'bridge_street_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['street', 'street_limited'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': 'hsl(36,6%,74%)',
        'line-opacity': [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          0,
          12.5,
          1
        ],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12,
          0.5,
          13,
          1,
          14,
          4,
          20,
          25
        ]
      }
    },
    {
      id: 'bridge_path_pedestrian_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['path', 'pedestrian'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': 'hsl(35,6%,80%)',
        'line-dasharray': [1, 0],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          14,
          1.5,
          20,
          18
        ]
      }
    },
    {
      id: 'bridge_secondary_tertiary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          8,
          1.5,
          20,
          17
        ]
      }
    },
    {
      id: 'bridge_trunk_primary_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'bridge_motorway_casing',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#e9ac77',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0.4,
          6,
          0.7,
          7,
          1.75,
          20,
          22
        ]
      }
    },
    {
      id: 'bridge_path_pedestrian',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['path', 'pedestrian'],
          true,
          false
        ]
      ],
      paint: {
        'line-color': 'hsl(0,0%,100%)',
        'line-dasharray': [1, 0.3],
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          14,
          0.5,
          20,
          10
        ]
      }
    },
    {
      id: 'bridge_motorway_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['==', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fc8',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'bridge_service_track',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['service', 'track'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          15.5,
          0,
          16,
          2,
          20,
          7.5
        ]
      }
    },
    {
      id: 'bridge_link',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'link'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          12.5,
          0,
          13,
          1.5,
          14,
          2.5,
          20,
          11.5
        ]
      }
    },
    {
      id: 'bridge_street',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['minor'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fff',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          13.5,
          0,
          14,
          2.5,
          20,
          18
        ]
      }
    },
    {
      id: 'bridge_secondary_tertiary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['secondary', 'tertiary'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          6.5,
          0,
          7,
          0.5,
          20,
          10
        ]
      }
    },
    {
      id: 'bridge_trunk_primary',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ],
        [
          'match',
          ['get', 'class'],
          ['primary', 'trunk'],
          true,
          false
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fea',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'bridge_motorway',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'motorway'
        ],
        ['!=', ['get', 'ramp'], 1],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      layout: { 'line-join': 'round' },
      paint: {
        'line-color': '#fc8',
        'line-width': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          5,
          0,
          7,
          1,
          20,
          18
        ]
      }
    },
    {
      id: 'bridge_major_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'rail'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'bridge_major_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'rail'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'bridge_transit_rail',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'transit'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14,
          0.4,
          15,
          0.75,
          20,
          2
        ]
      }
    },
    {
      id: 'bridge_transit_rail_hatching',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'transportation',
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'transit'
        ],
        [
          '==',
          ['get', 'brunnel'],
          'bridge'
        ]
      ],
      paint: {
        'line-color': '#bbb',
        'line-dasharray': [0.2, 8],
        'line-width': [
          'interpolate',
          ['exponential', 1.4],
          ['zoom'],
          14.5,
          0,
          15,
          3,
          20,
          8
        ]
      }
    },
    {
      id: 'building',
      type: 'fill',
      source: 'openmaptiles',
      'source-layer': 'building',
      minzoom: 13,
      maxzoom: 14,
      paint: {
        'fill-color': 'hsl(35,8%,85%)',
        'fill-outline-color': [
          'interpolate',
          ['linear'],
          ['zoom'],
          13,
          'hsla(35,6%,79%,0.32)',
          14,
          'hsl(35,6%,79%)'
        ]
      }
    },
    {
      id: 'building-3d',
      type: 'fill-extrusion',
      source: 'openmaptiles',
      'source-layer': 'building',
      minzoom: 14,
      paint: {
        'fill-extrusion-base': [
          'get',
          'render_min_height'
        ],
        'fill-extrusion-color': 'hsl(35,8%,85%)',
        'fill-extrusion-height': [
          'get',
          'render_height'
        ],
        'fill-extrusion-opacity': 0.8
      }
    },
    {
      id: 'boundary_3',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'boundary',
      minzoom: 5,
      filter: [
        'all',
        [
          '>=',
          ['get', 'admin_level'],
          3
        ],
        [
          '<=',
          ['get', 'admin_level'],
          6
        ],
        ['!=', ['get', 'maritime'], 1],
        ['!=', ['get', 'disputed'], 1],
        ['!', ['has', 'claimed_by']]
      ],
      paint: {
        'line-color': 'hsl(0,0%,70%)',
        'line-dasharray': [1, 1],
        'line-width': [
          'interpolate',
          ['linear', 1],
          ['zoom'],
          7,
          1,
          11,
          2
        ]
      }
    },
    {
      id: 'boundary_2',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'boundary',
      filter: [
        'all',
        [
          '==',
          ['get', 'admin_level'],
          2
        ],
        ['!=', ['get', 'maritime'], 1],
        ['!=', ['get', 'disputed'], 1],
        ['!', ['has', 'claimed_by']]
      ],
      layout: {
        'line-cap': 'round',
        'line-join': 'round'
      },
      paint: {
        'line-color': 'hsl(248,1%,41%)',
        'line-opacity': [
          'interpolate',
          ['linear'],
          ['zoom'],
          0,
          0.4,
          4,
          1
        ],
        'line-width': [
          'interpolate',
          ['linear'],
          ['zoom'],
          3,
          1,
          5,
          1.2,
          12,
          3
        ]
      }
    },
    {
      id: 'boundary_disputed',
      type: 'line',
      source: 'openmaptiles',
      'source-layer': 'boundary',
      filter: [
        'all',
        ['!=', ['get', 'maritime'], 1],
        ['==', ['get', 'disputed'], 1]
      ],
      paint: {
        'line-color': 'hsl(248,1%,41%)',
        'line-dasharray': [1, 2],
        'line-width': [
          'interpolate',
          ['linear'],
          ['zoom'],
          3,
          1,
          5,
          1.2,
          12,
          3
        ]
      }
    },
    {
      id: 'waterway_line_label',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'waterway',
      minzoom: 10,
      filter: [
        'match',
        ['geometry-type'],
        [
          'LineString',
          'MultiLineString'
        ],
        true,
        false
      ],
      layout: {
        'symbol-placement': 'line',
        'symbol-spacing': 350,
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-letter-spacing': 0.2,
        'text-max-width': 5,
        'text-size': 14
      },
      paint: {
        'text-color': '#74aee9',
        'text-halo-color': 'rgba(255,255,255,0.7)',
        'text-halo-width': 1.5
      }
    },
    {
      id: 'water_name_point_label',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'water_name',
      filter: [
        'match',
        ['geometry-type'],
        ['MultiPoint', 'Point'],
        true,
        false
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': [
          'GDS Transport Italic'
        ],
        'text-letter-spacing': 0.2,
        'text-max-width': 5,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          0,
          10,
          8,
          14
        ]
      },
      paint: {
        'text-color': '#495e91',
        'text-halo-color': 'rgba(255,255,255,0.7)',
        'text-halo-width': 1.5
      }
    },
    {
      id: 'water_name_line_label',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'water_name',
      filter: [
        'match',
        ['geometry-type'],
        [
          'LineString',
          'MultiLineString'
        ],
        true,
        false
      ],
      layout: {
        'symbol-placement': 'line',
        'symbol-spacing': 350,
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-letter-spacing': 0.2,
        'text-max-width': 5,
        'text-size': 14
      },
      paint: {
        'text-color': '#495e91',
        'text-halo-color': 'rgba(255,255,255,0.7)',
        'text-halo-width': 1.5
      }
    },
    {
      id: 'poi_r20',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'poi',
      minzoom: 17,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          ['MultiPoint', 'Point'],
          true,
          false
        ],
        ['>=', ['get', 'rank'], 20]
      ],
      layout: {
        'icon-image': [
          'match',
          ['get', 'subclass'],
          ['florist', 'furniture'],
          ['get', 'subclass'],
          ['get', 'class']
        ],
        'text-anchor': 'top',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 9,
        'text-offset': [0, 0.6],
        'text-size': 12
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'poi_r7',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'poi',
      minzoom: 16,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          ['MultiPoint', 'Point'],
          true,
          false
        ],
        ['>=', ['get', 'rank'], 7],
        ['<', ['get', 'rank'], 20]
      ],
      layout: {
        'icon-image': [
          'match',
          ['get', 'subclass'],
          ['florist', 'furniture'],
          ['get', 'subclass'],
          ['get', 'class']
        ],
        'text-anchor': 'top',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 9,
        'text-offset': [0, 0.6],
        'text-size': 12
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'poi_r1',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'poi',
      minzoom: 15,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          ['MultiPoint', 'Point'],
          true,
          false
        ],
        ['>=', ['get', 'rank'], 1],
        ['<', ['get', 'rank'], 7]
      ],
      layout: {
        'icon-image': [
          'match',
          ['get', 'subclass'],
          ['florist', 'furniture'],
          ['get', 'subclass'],
          ['get', 'class']
        ],
        'text-anchor': 'top',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 9,
        'text-offset': [0, 0.6],
        'text-size': 12
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'poi_transit',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'poi',
      filter: [
        'match',
        ['get', 'class'],
        ['airport', 'bus', 'rail'],
        true,
        false
      ],
      layout: {
        'icon-image': [
          'to-string',
          ['get', 'class']
        ],
        'icon-size': 0.7,
        'text-anchor': 'left',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 9,
        'text-offset': [0.9, 0],
        'text-size': 12
      },
      paint: {
        'text-color': '#2e5a80',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'highway-name-path',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 15.5,
      filter: [
        '==',
        ['get', 'class'],
        'path'
      ],
      layout: {
        'symbol-placement': 'line',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-rotation-alignment': 'map',
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          13,
          12,
          14,
          13
        ]
      },
      paint: {
        'text-color': 'hsl(30,23%,62%)',
        'text-halo-color': '#f8f4f0',
        'text-halo-width': 0.5
      }
    },
    {
      id: 'highway-name-minor',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 15,
      filter: [
        'all',
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'class'],
          ['minor', 'service', 'track'],
          true,
          false
        ]
      ],
      layout: {
        'symbol-placement': 'line',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-rotation-alignment': 'map',
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          13,
          12,
          14,
          13
        ]
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-width': 1
      }
    },
    {
      id: 'highway-name-major',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 12.2,
      filter: [
        'match',
        ['get', 'class'],
        [
          'primary',
          'secondary',
          'tertiary',
          'trunk'
        ],
        true,
        false
      ],
      layout: {
        'symbol-placement': 'line',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            ' ',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-rotation-alignment': 'map',
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          13,
          12,
          14,
          13
        ]
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-width': 1
      }
    },
    {
      id: 'highway-shield-non-us',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 8,
      filter: [
        'all',
        [
          '<=',
          ['get', 'ref_length'],
          6
        ],
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'network'],
          [
            'us-highway',
            'us-interstate',
            'us-state'
          ],
          false,
          true
        ]
      ],
      layout: {
        'icon-image': [
          'concat',
          'road_',
          ['get', 'ref_length']
        ],
        'icon-rotation-alignment': 'viewport',
        'icon-size': 1,
        'symbol-placement': [
          'step',
          ['zoom'],
          'point',
          11,
          'line'
        ],
        'symbol-spacing': 200,
        'text-field': [
          'to-string',
          ['get', 'ref']
        ],
        'text-font': ['GDS Transport'],
        'text-rotation-alignment': 'viewport',
        'text-size': 10
      }
    },
    {
      id: 'highway-shield-us-interstate',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 7,
      filter: [
        'all',
        [
          '<=',
          ['get', 'ref_length'],
          6
        ],
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'network'],
          ['us-interstate'],
          true,
          false
        ]
      ],
      layout: {
        'icon-image': [
          'concat',
          ['get', 'network'],
          '_',
          ['get', 'ref_length']
        ],
        'icon-rotation-alignment': 'viewport',
        'icon-size': 1,
        'symbol-placement': [
          'step',
          ['zoom'],
          'point',
          7,
          'line',
          8,
          'line'
        ],
        'symbol-spacing': 200,
        'text-field': [
          'to-string',
          ['get', 'ref']
        ],
        'text-font': ['GDS Transport'],
        'text-rotation-alignment': 'viewport',
        'text-size': 10
      }
    },
    {
      id: 'road_shield_us',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      minzoom: 9,
      filter: [
        'all',
        [
          '<=',
          ['get', 'ref_length'],
          6
        ],
        [
          'match',
          ['geometry-type'],
          [
            'LineString',
            'MultiLineString'
          ],
          true,
          false
        ],
        [
          'match',
          ['get', 'network'],
          ['us-highway', 'us-state'],
          true,
          false
        ]
      ],
      layout: {
        'icon-image': [
          'concat',
          ['get', 'network'],
          '_',
          ['get', 'ref_length']
        ],
        'icon-rotation-alignment': 'viewport',
        'icon-size': 1,
        'symbol-placement': [
          'step',
          ['zoom'],
          'point',
          11,
          'line'
        ],
        'symbol-spacing': 200,
        'text-field': [
          'to-string',
          ['get', 'ref']
        ],
        'text-font': ['GDS Transport'],
        'text-rotation-alignment': 'viewport',
        'text-size': 10
      }
    },
    {
      id: 'airport',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'aerodrome_label',
      minzoom: 10,
      filter: [
        'all',
        ['has', 'iata']
      ],
      layout: {
        'icon-image': 'airport_11',
        'icon-size': 1,
        'text-anchor': 'top',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 9,
        'text-offset': [0, 0.6],
        'text-optional': true,
        'text-padding': 2,
        'text-size': 12
      },
      paint: {
        'text-color': '#666',
        'text-halo-blur': 0.5,
        'text-halo-color': '#ffffff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_other',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 8,
      filter: [
        'match',
        ['get', 'class'],
        [
          'city',
          'continent',
          'country',
          'state',
          'town',
          'village'
        ],
        false,
        true
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-letter-spacing': 0.1,
        'text-max-width': 9,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          8,
          9,
          12,
          10
        ],
        'text-transform': 'uppercase'
      },
      paint: {
        'text-color': '#333',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_village',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 9,
      filter: [
        '==',
        ['get', 'class'],
        'village'
      ],
      layout: {
        'icon-allow-overlap': true,
        'icon-image': [
          'step',
          ['zoom'],
          'circle_11_black',
          10,
          ''
        ],
        'icon-optional': false,
        'icon-size': 0.2,
        'text-anchor': 'bottom',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 8,
        'text-size': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          7,
          10,
          11,
          12
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_town',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 6,
      filter: [
        '==',
        ['get', 'class'],
        'town'
      ],
      layout: {
        'icon-allow-overlap': true,
        'icon-image': [
          'step',
          ['zoom'],
          'circle_11_black',
          10,
          ''
        ],
        'icon-optional': false,
        'icon-size': 0.2,
        'text-anchor': 'bottom',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 8,
        'text-size': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          7,
          12,
          11,
          14
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_state',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 5,
      maxzoom: 8,
      filter: [
        '==',
        ['get', 'class'],
        'state'
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-letter-spacing': 0.2,
        'text-max-width': 9,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          5,
          10,
          8,
          14
        ],
        'text-transform': 'uppercase'
      },
      paint: {
        'text-color': '#333',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_city',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 3,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'city'
        ],
        ['!=', ['get', 'capital'], 2]
      ],
      layout: {
        'icon-allow-overlap': true,
        'icon-image': [
          'step',
          ['zoom'],
          'circle_11_black',
          9,
          ''
        ],
        'icon-optional': false,
        'icon-size': 0.4,
        'text-anchor': 'bottom',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 8,
        'text-offset': [0, -0.1],
        'text-size': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          4,
          11,
          7,
          13,
          11,
          18
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_city_capital',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 3,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'city'
        ],
        ['==', ['get', 'capital'], 2]
      ],
      layout: {
        'icon-allow-overlap': true,
        'icon-image': [
          'step',
          ['zoom'],
          'circle_11_black',
          9,
          ''
        ],
        'icon-optional': false,
        'icon-size': 0.5,
        'text-anchor': 'bottom',
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 8,
        'text-offset': [0, -0.2],
        'text-size': [
          'interpolate',
          ['exponential', 1.2],
          ['zoom'],
          4,
          12,
          7,
          14,
          11,
          20
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_country_3',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      minzoom: 2,
      maxzoom: 9,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'country'
        ],
        ['>=', ['get', 'rank'], 3]
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 6.25,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          3,
          9,
          7,
          17
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_country_2',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      maxzoom: 9,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'country'
        ],
        ['==', ['get', 'rank'], 2]
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 6.25,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          2,
          9,
          5,
          17
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    },
    {
      id: 'label_country_1',
      type: 'symbol',
      source: 'openmaptiles',
      'source-layer': 'place',
      maxzoom: 9,
      filter: [
        'all',
        [
          '==',
          ['get', 'class'],
          'country'
        ],
        ['==', ['get', 'rank'], 1]
      ],
      layout: {
        'text-field': [
          'case',
          ['has', 'name:nonlatin'],
          [
            'concat',
            ['get', 'name:latin'],
            '\n',
            ['get', 'name:nonlatin']
          ],
          [
            'coalesce',
            ['get', 'name_en'],
            ['get', 'name']
          ]
        ],
        'text-font': ['GDS Transport'],
        'text-max-width': 6.25,
        'text-size': [
          'interpolate',
          ['linear'],
          ['zoom'],
          1,
          9,
          4,
          17
        ]
      },
      paint: {
        'text-color': '#000',
        'text-halo-blur': 1,
        'text-halo-color': '#fff',
        'text-halo-width': 1
      }
    }
  ],
  id: 'l722aso'
}

window.GOVUK.positron = { version: 8, sources: { ne2_shaded: { maxzoom: 6, tileSize: 256, tiles: ['https://tiles.openfreemap.org/natural_earth/ne2sr/{z}/{x}/{y}.png'], type: 'raster' }, openmaptiles: { type: 'vector', url: 'https://tiles.openfreemap.org/planet' } }, sprite: 'https://tiles.openfreemap.org/sprites/ofm_f384/ofm', glyphs: 'https://tiles.openfreemap.org/fonts/{fontstack}/{range}.pbf', layers: [{ id: 'background', type: 'background', paint: { 'background-color': 'rgb(242,243,240)' } }, { id: 'park', type: 'fill', source: 'openmaptiles', 'source-layer': 'park', filter: ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], paint: { 'fill-color': 'rgb(230, 233, 229)' } }, { id: 'water', type: 'fill', source: 'openmaptiles', 'source-layer': 'water', filter: ['all', ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], ['!=', ['get', 'brunnel'], 'tunnel']], paint: { 'fill-antialias': true, 'fill-color': 'rgb(194, 200, 202)' } }, { id: 'landcover_ice_shelf', type: 'fill', source: 'openmaptiles', 'source-layer': 'landcover', maxzoom: 8, filter: ['all', ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], ['==', ['get', 'subclass'], 'ice_shelf']], paint: { 'fill-color': 'hsl(0,0%,98%)', 'fill-opacity': 0.7 } }, { id: 'landcover_glacier', type: 'fill', source: 'openmaptiles', 'source-layer': 'landcover', maxzoom: 8, filter: ['all', ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], ['==', ['get', 'subclass'], 'glacier']], paint: { 'fill-color': 'hsl(0,0%,98%)', 'fill-opacity': ['interpolate', ['linear'], ['zoom'], 0, 1, 8, 0.5] } }, { id: 'landuse_residential', type: 'fill', source: 'openmaptiles', 'source-layer': 'landuse', maxzoom: 16, filter: ['all', ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], ['==', ['get', 'class'], 'residential']], paint: { 'fill-color': 'rgb(234, 234, 230)', 'fill-opacity': ['interpolate', ['exponential', 0.6], ['zoom'], 8, 0.8, 9, 0.6] } }, { id: 'landcover_wood', type: 'fill', source: 'openmaptiles', 'source-layer': 'landcover', minzoom: 10, filter: ['all', ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], ['==', ['get', 'class'], 'wood']], paint: { 'fill-color': 'rgb(220,224,220)', 'fill-opacity': ['interpolate', ['linear'], ['zoom'], 8, 0, 12, 1] } }, { id: 'waterway', type: 'line', source: 'openmaptiles', 'source-layer': 'waterway', filter: ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], paint: { 'line-color': 'hsl(195,17%,78%)' } }, { id: 'building', type: 'fill', source: 'openmaptiles', 'source-layer': 'building', minzoom: 12, paint: { 'fill-antialias': true, 'fill-color': 'rgb(234, 234, 229)', 'fill-outline-color': 'rgb(219, 219, 218)' } }, { id: 'tunnel_motorway_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 6, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['==', ['get', 'class'], 'motorway']]], layout: { 'line-cap': 'butt', 'line-join': 'miter' }, paint: { 'line-color': 'rgb(213, 213, 213)', 'line-opacity': 1, 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 5.8, 0, 6, 3, 20, 40] } }, { id: 'tunnel_motorway_inner', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 6, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['==', ['get', 'brunnel'], 'tunnel'], ['==', ['get', 'class'], 'motorway']]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'rgb(234,234,234)', 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 4, 2, 6, 1.3, 20, 30] } }, { id: 'aeroway-taxiway', type: 'line', source: 'openmaptiles', 'source-layer': 'aeroway', minzoom: 12, filter: ['match', ['get', 'class'], ['taxiway'], true, false], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'hsl(0,0%,88%)', 'line-opacity': 1, 'line-width': ['interpolate', ['exponential', 1.55], ['zoom'], 13, 1.8, 20, 20] } }, { id: 'aeroway-runway-casing', type: 'line', source: 'openmaptiles', 'source-layer': 'aeroway', minzoom: 11, filter: ['match', ['get', 'class'], ['runway'], true, false], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'hsl(0,0%,88%)', 'line-opacity': 1, 'line-width': ['interpolate', ['exponential', 1.5], ['zoom'], 11, 6, 17, 55] } }, { id: 'aeroway-area', type: 'fill', source: 'openmaptiles', 'source-layer': 'aeroway', minzoom: 4, filter: ['all', ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], ['match', ['get', 'class'], ['runway', 'taxiway'], true, false]], paint: { 'fill-color': 'rgba(255, 255, 255, 1)', 'fill-opacity': ['interpolate', ['linear'], ['zoom'], 13, 0, 14, 1] } }, { id: 'aeroway-runway', type: 'line', source: 'openmaptiles', 'source-layer': 'aeroway', minzoom: 11, filter: ['all', ['match', ['get', 'class'], ['runway'], true, false], ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'rgba(255, 255, 255, 1)', 'line-opacity': 1, 'line-width': ['interpolate', ['exponential', 1.5], ['zoom'], 11, 4, 17, 50] } }, { id: 'road_area_pier', type: 'fill', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['geometry-type'], ['MultiPolygon', 'Polygon'], true, false], ['==', ['get', 'class'], 'pier']], paint: { 'fill-antialias': true, 'fill-color': 'rgb(242,243,240)' } }, { id: 'road_pier', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'class'], ['pier'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'rgb(242,243,240)', 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 15, 1, 17, 4] } }, { id: 'highway_path', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['==', ['get', 'class'], 'path']], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'rgb(234, 234, 234)', 'line-opacity': 0.9, 'line-width': ['interpolate', ['exponential', 1.2], ['zoom'], 13, 1, 20, 10] } }, { id: 'highway_minor', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 8, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'class'], ['minor', 'service', 'track'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'hsl(0,0%,88%)', 'line-opacity': 0.9, 'line-width': ['interpolate', ['exponential', 1.55], ['zoom'], 13, 1.8, 20, 20] } }, { id: 'highway_major_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 11, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'class'], ['primary', 'secondary', 'tertiary', 'trunk'], true, false]], layout: { 'line-cap': 'butt', 'line-join': 'miter' }, paint: { 'line-color': 'rgb(213, 213, 213)', 'line-dasharray': [12, 0], 'line-width': ['interpolate', ['exponential', 1.3], ['zoom'], 10, 3, 20, 23] } }, { id: 'highway_major_inner', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 11, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'class'], ['primary', 'secondary', 'tertiary', 'trunk'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': '#fff', 'line-width': ['interpolate', ['exponential', 1.3], ['zoom'], 10, 2, 20, 20] } }, { id: 'highway_major_subtle', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', maxzoom: 11, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'class'], ['primary', 'secondary', 'tertiary', 'trunk'], true, false]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'hsla(0,0%,85%,0.69)', 'line-width': 2 } }, { id: 'highway_motorway_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 6, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'motorway']]], layout: { 'line-cap': 'butt', 'line-join': 'miter' }, paint: { 'line-color': 'rgb(213, 213, 213)', 'line-dasharray': [2, 0], 'line-opacity': 1, 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 5.8, 0, 6, 3, 20, 40] } }, { id: 'highway_motorway_inner', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 6, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['match', ['get', 'brunnel'], ['bridge', 'tunnel'], false, true], ['==', ['get', 'class'], 'motorway']]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': ['interpolate', ['linear'], ['zoom'], 5.8, 'hsla(0,0%,85%,0.53)', 6, '#fff'], 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 4, 2, 6, 1.3, 20, 30] } }, { id: 'highway_motorway_subtle', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', maxzoom: 6, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['==', ['get', 'class'], 'motorway']], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'hsla(0,0%,85%,0.53)', 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 4, 2, 6, 1.3] } }, { id: 'railway_transit', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 16, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['==', ['get', 'class'], 'transit'], ['match', ['get', 'brunnel'], ['tunnel'], false, true]]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#dddddd', 'line-width': 3 } }, { id: 'railway_transit_dashline', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 16, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['==', ['get', 'class'], 'transit'], ['match', ['get', 'brunnel'], ['tunnel'], false, true]]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fafafa', 'line-dasharray': [3, 3], 'line-width': 2 } }, { id: 'railway_service', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 16, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['==', ['get', 'class'], 'rail'], ['has', 'service']]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#dddddd', 'line-width': 3 } }, { id: 'railway_service_dashline', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 16, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['==', ['get', 'class'], 'rail'], ['has', 'service']], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fafafa', 'line-dasharray': [3, 3], 'line-width': 2 } }, { id: 'railway', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 13, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['!', ['has', 'service']], ['==', ['get', 'class'], 'rail']]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#dddddd', 'line-width': ['interpolate', ['exponential', 1.3], ['zoom'], 16, 3, 20, 7] } }, { id: 'railway_dashline', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 13, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['!', ['has', 'service']], ['==', ['get', 'class'], 'rail']]], layout: { 'line-join': 'round' }, paint: { 'line-color': '#fafafa', 'line-dasharray': [3, 3], 'line-width': ['interpolate', ['exponential', 1.3], ['zoom'], 16, 2, 20, 6] } }, { id: 'highway_motorway_bridge_casing', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 6, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['==', ['get', 'brunnel'], 'bridge'], ['==', ['get', 'class'], 'motorway']]], layout: { 'line-cap': 'butt', 'line-join': 'miter' }, paint: { 'line-color': 'rgb(213, 213, 213)', 'line-dasharray': [2, 0], 'line-opacity': 1, 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 5.8, 0, 6, 5, 20, 45] } }, { id: 'highway_motorway_bridge_inner', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', minzoom: 6, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['all', ['==', ['get', 'brunnel'], 'bridge'], ['==', ['get', 'class'], 'motorway']]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': ['interpolate', ['linear'], ['zoom'], 5.8, 'hsla(0,0%,85%,0.53)', 6, '#fff'], 'line-width': ['interpolate', ['exponential', 1.4], ['zoom'], 4, 2, 6, 1.3, 20, 30] } }, { id: 'boundary_3', type: 'line', source: 'openmaptiles', 'source-layer': 'boundary', minzoom: 8, filter: ['all', ['>=', ['get', 'admin_level'], 3], ['<=', ['get', 'admin_level'], 6], ['!=', ['get', 'maritime'], 1], ['!=', ['get', 'disputed'], 1], ['!', ['has', 'claimed_by']]], paint: { 'line-color': 'hsl(0,0%,70%)', 'line-dasharray': [1, 1], 'line-width': ['interpolate', ['linear', 1], ['zoom'], 7, 1, 11, 2] } }, { id: 'boundary_2', type: 'line', source: 'openmaptiles', 'source-layer': 'boundary', filter: ['all', ['==', ['get', 'admin_level'], 2], ['!=', ['get', 'maritime'], 1], ['!=', ['get', 'disputed'], 1], ['!', ['has', 'claimed_by']]], layout: { 'line-cap': 'round', 'line-join': 'round' }, paint: { 'line-color': 'hsl(0,0%,70%)', 'line-opacity': ['interpolate', ['linear'], ['zoom'], 0, 0.4, 4, 1], 'line-width': ['interpolate', ['linear'], ['zoom'], 3, 1, 5, 1.2, 12, 3] } }, { id: 'boundary_disputed', type: 'line', source: 'openmaptiles', 'source-layer': 'boundary', filter: ['all', ['!=', ['get', 'maritime'], 1], ['==', ['get', 'disputed'], 1]], paint: { 'line-color': 'hsl(0,0%,70%)', 'line-dasharray': [1, 2], 'line-width': ['interpolate', ['linear'], ['zoom'], 3, 1, 5, 1.2, 12, 3] } }, { id: 'waterway_line_label', type: 'symbol', source: 'openmaptiles', 'source-layer': 'waterway', minzoom: 10, filter: ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], layout: { 'symbol-placement': 'line', 'symbol-spacing': 350, 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.2, 'text-max-width': 5, 'text-size': 14 }, paint: { 'text-color': 'hsl(0,0%,66%)', 'text-halo-color': 'rgba(255,255,255,0.7)', 'text-halo-width': 1.5 } }, { id: 'water_name_point_label', type: 'symbol', source: 'openmaptiles', 'source-layer': 'water_name', filter: ['match', ['geometry-type'], ['MultiPoint', 'Point'], true, false], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.2, 'text-max-width': 5, 'text-size': ['interpolate', ['linear'], ['zoom'], 0, 10, 8, 14] }, paint: { 'text-color': '#495e91', 'text-halo-color': 'rgba(255,255,255,0.7)', 'text-halo-width': 1.5 } }, { id: 'water_name_line_label', type: 'symbol', source: 'openmaptiles', 'source-layer': 'water_name', filter: ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], layout: { 'symbol-placement': 'line', 'symbol-spacing': 350, 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.2, 'text-max-width': 5, 'text-size': 14 }, paint: { 'text-color': '#495e91', 'text-halo-color': 'rgba(255,255,255,0.7)', 'text-halo-width': 1.5 } }, { id: 'highway-name-path', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 15.5, filter: ['==', ['get', 'class'], 'path'], layout: { 'symbol-placement': 'line', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'map', 'text-size': ['interpolate', ['linear'], ['zoom'], 13, 12, 14, 13] }, paint: { 'text-color': 'hsl(30,0%,62%)', 'text-halo-color': '#f8f4f0', 'text-halo-width': 0.5 } }, { id: 'highway-name-minor', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 15, filter: ['all', ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'class'], ['minor', 'service', 'track'], true, false]], layout: { 'symbol-placement': 'line', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'map', 'text-size': ['interpolate', ['linear'], ['zoom'], 13, 12, 14, 13] }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-width': 1 } }, { id: 'highway-name-major', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 12.2, filter: ['match', ['get', 'class'], ['primary', 'secondary', 'tertiary', 'trunk'], true, false], layout: { 'symbol-placement': 'line', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], ' ', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'map', 'text-size': ['interpolate', ['linear'], ['zoom'], 13, 12, 14, 13] }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-width': 1 } }, { id: 'highway-shield-non-us', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 11, filter: ['all', ['<=', ['get', 'ref_length'], 6], ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'network'], ['us-highway', 'us-interstate', 'us-state'], false, true]], layout: { 'icon-image': ['concat', 'road_', ['get', 'ref_length']], 'icon-rotation-alignment': 'viewport', 'icon-size': 1, 'symbol-placement': ['step', ['zoom'], 'point', 11, 'line'], 'symbol-spacing': 200, 'text-field': ['to-string', ['get', 'ref']], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'viewport', 'text-size': 10 } }, { id: 'highway-shield-us-interstate', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 11, filter: ['all', ['<=', ['get', 'ref_length'], 6], ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'network'], ['us-interstate'], true, false]], layout: { 'icon-image': ['concat', ['get', 'network'], '_', ['get', 'ref_length']], 'icon-rotation-alignment': 'viewport', 'icon-size': 1, 'symbol-placement': ['step', ['zoom'], 'point', 7, 'line', 8, 'line'], 'symbol-spacing': 200, 'text-field': ['to-string', ['get', 'ref']], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'viewport', 'text-size': 10 } }, { id: 'road_shield_us', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 12, filter: ['all', ['<=', ['get', 'ref_length'], 6], ['match', ['geometry-type'], ['LineString', 'MultiLineString'], true, false], ['match', ['get', 'network'], ['us-highway', 'us-state'], true, false]], layout: { 'icon-image': ['concat', ['get', 'network'], '_', ['get', 'ref_length']], 'icon-rotation-alignment': 'viewport', 'icon-size': 1, 'symbol-placement': ['step', ['zoom'], 'point', 11, 'line'], 'symbol-spacing': 200, 'text-field': ['to-string', ['get', 'ref']], 'text-font': ['Noto Sans Regular'], 'text-rotation-alignment': 'viewport', 'text-size': 10 } }, { id: 'airport', type: 'symbol', source: 'openmaptiles', 'source-layer': 'aerodrome_label', minzoom: 11, filter: ['all', ['has', 'iata']], layout: { 'icon-image': 'airport_11', 'icon-size': 1, 'text-anchor': 'top', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-max-width': 9, 'text-offset': [0, 0.6], 'text-optional': true, 'text-padding': 2, 'text-size': 12 }, paint: { 'text-color': '#666', 'text-halo-blur': 0.5, 'text-halo-color': '#ffffff', 'text-halo-width': 1 } }, { id: 'label_other', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 8, filter: ['match', ['get', 'class'], ['city', 'continent', 'country', 'state', 'town', 'village'], false, true], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.1, 'text-max-width': 9, 'text-size': ['interpolate', ['linear'], ['zoom'], 8, 9, 12, 10], 'text-transform': 'uppercase' }, paint: { 'text-color': '#333', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_village', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 9, filter: ['==', ['get', 'class'], 'village'], layout: { 'icon-allow-overlap': true, 'icon-image': ['step', ['zoom'], 'circle_11_black', 10, ''], 'icon-optional': false, 'icon-size': 0.2, 'text-anchor': 'bottom', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-max-width': 8, 'text-size': ['interpolate', ['exponential', 1.2], ['zoom'], 7, 10, 11, 12] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_town', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 6, filter: ['==', ['get', 'class'], 'town'], layout: { 'icon-allow-overlap': true, 'icon-image': ['step', ['zoom'], 'circle_11_black', 10, ''], 'icon-optional': false, 'icon-size': 0.2, 'text-anchor': 'bottom', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-max-width': 8, 'text-size': ['interpolate', ['exponential', 1.2], ['zoom'], 7, 12, 11, 14] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_state', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 5, maxzoom: 8, filter: ['==', ['get', 'class'], 'state'], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Italic'], 'text-letter-spacing': 0.2, 'text-max-width': 9, 'text-size': ['interpolate', ['linear'], ['zoom'], 5, 10, 8, 14], 'text-transform': 'uppercase' }, paint: { 'text-color': '#333', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_city', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 3, filter: ['all', ['==', ['get', 'class'], 'city'], ['!=', ['get', 'capital'], 2]], layout: { 'icon-allow-overlap': true, 'icon-image': ['step', ['zoom'], 'circle_11_black', 9, ''], 'icon-optional': false, 'icon-size': 0.4, 'text-anchor': 'bottom', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Regular'], 'text-max-width': 8, 'text-offset': [0, -0.1], 'text-size': ['interpolate', ['exponential', 1.2], ['zoom'], 4, 11, 7, 13, 11, 18] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_city_capital', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 3, filter: ['all', ['==', ['get', 'class'], 'city'], ['==', ['get', 'capital'], 2]], layout: { 'icon-allow-overlap': true, 'icon-image': ['step', ['zoom'], 'circle_11_black', 9, ''], 'icon-optional': false, 'icon-size': 0.5, 'text-anchor': 'bottom', 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Bold'], 'text-max-width': 8, 'text-offset': [0, -0.2], 'text-size': ['interpolate', ['exponential', 1.2], ['zoom'], 4, 12, 7, 14, 11, 20] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_country_3', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', minzoom: 2, maxzoom: 9, filter: ['all', ['==', ['get', 'class'], 'country'], ['>=', ['get', 'rank'], 3]], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Bold'], 'text-max-width': 6.25, 'text-size': ['interpolate', ['linear'], ['zoom'], 3, 9, 7, 17] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_country_2', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', maxzoom: 9, filter: ['all', ['==', ['get', 'class'], 'country'], ['==', ['get', 'rank'], 2]], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Bold'], 'text-max-width': 6.25, 'text-size': ['interpolate', ['linear'], ['zoom'], 2, 9, 5, 17] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }, { id: 'label_country_1', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', maxzoom: 9, filter: ['all', ['==', ['get', 'class'], 'country'], ['==', ['get', 'rank'], 1]], layout: { 'text-field': ['case', ['has', 'name:nonlatin'], ['concat', ['get', 'name:latin'], '\n', ['get', 'name:nonlatin']], ['coalesce', ['get', 'name_en'], ['get', 'name']]], 'text-font': ['Noto Sans Bold'], 'text-max-width': 6.25, 'text-size': ['interpolate', ['linear'], ['zoom'], 1, 9, 4, 17] }, paint: { 'text-color': '#000', 'text-halo-blur': 1, 'text-halo-color': '#fff', 'text-halo-width': 1 } }] }

window.GOVUK.mapThemes = { default: window.GOVUK.mapComponentStyles, gdsTransport: window.GOVUK.gdsTransport, gdsBlueWater: window.GOVUK.gdsBlueWater, positron: window.GOVUK.positron }
