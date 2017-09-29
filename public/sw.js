importScripts('workbox-sw.prod.v2.0.2-rc1-2.0.2-rc1.0.js');
importScripts('workbox-routing.dev.v0.0.2.js');

const workboxSW = new self.WorkboxSW();
const contentUrl = "https://www.gov.uk/api/content/contact-the-dvla";

const router = new workbox.routing.Router();

router.setDefaultHandler({
  handler: ({event}) => {
    const url = new URL(event.request.url);
    const params = url.searchParams;
    const response = params.getAll("response").filter(r => r)

    if (response.length > 0) {
      const path = [url.pathname].concat(response).join("/");

      return event.respondWith(
        new Response(path, {
          status: 302,
          headers: {
            Location: path
          }
        })
      );
    }

    return fetch(event.request);
  },
});

const lookup = (slug, key, nodes) => {
	const node = nodes.filter(node => {
		return node.slug === key;
	})[0];

	const options = node.options || [];

	return options.reduce((array, option) => {
		return array.concat(lookup(`${slug}/${option.slug}`, option.next_node, nodes));
	}, [slug]);
};

const buildManifest = data => {
	const nodes = data.details.nodes;
	const paths = lookup("/contact-the-dvla/y", "question-1", nodes);

	const manifest = paths.map(path => {
		return { "url": path, "revision": "1" };
	});

  workboxSW.precache(manifest.concat([
    {
      "url": contentUrl,
      "revision": "1"
    },
    {
      "url": "/frontend/application.self-bd2db477506efe6f5d4c0187780771d074cbdbb8d00b3acfc14b52152b2ea5e2.css?body=1",
      "revision": "1"
    },
    {
      "url": "https://assets.publishing.service.gov.uk/static/govuk-template-2775f99eaec64ff8121bfbfb3eb67b0c2b4b7c3fc78d25da30e12db2a09d30d6.css",
      "revision": "1"
    },
    {
      "url": "https://assets.publishing.service.gov.uk/static/fonts-5ff8c53913434afd0072a480d7cfca67cace4c8d03f6ef96b78a4455728ce745.css",
      "revision": "1"
    },
    {
      "url": "https://assets.publishing.service.gov.uk/static/static-f713dc6fe85321a977bfa3ba1f704b7430403d7c9375be6caa15c52148ba92d1.css",
      "revision": "1"
    }
  ]));

  workboxSW._revisionedCacheManager.install();
};

fetch(contentUrl)
.then(response => response.json())
.then(buildManifest)
