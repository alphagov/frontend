# GOV.UK Browser Data

GOV.UK browser data is served on /govuk-browser-data, which currently needs to be added as a special route. It's built on a flexible page, but has to have its own controller because the content item won't have enough information to build the page.

To update the browser data, you need to get downloads of data from GA4, which will come out as a collection of files of the form: `YYYY-MM-browsers.csv` and `YYYY-MM-browser-os-combos.csv`, where every file is a month's output. These files should be put in `/ga4_exports`, which is a gitignored directory (you don't commit these output files to the repo). When you have them, run:

`bundle exec rake make_browser_data_csvs`

...and the relevant files will be created in `/lib/data/govuk_browser_data`
