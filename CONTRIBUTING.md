# CONTRIBUTING

Frontend is a Ruby on Rails application and should follow [our Rails app conventions].

In addition, a code structure was agreed in [RFC 175].

## Code structure

All new features added to frontend should have the following structure:

```
├── app
│   ├── assets
│   ├── controllers
│   ├── helpers
│   ├── models
│   ├── presenters
│   ├── views
├── config
│   ├── locales
├── lib
│   ├── tasks
└── .gitignore
```

Under `/app`:

`helpers`
- General utility methods for a view.

`models`
- Frontend apps do not have database records, so models here are created to store data received from api calls (eg content items from content store), process data that will be written to apis (eg feedback items to zendesk), and information ingested from YAML/JSON/CSVs.

`presenters`
- Presentation related transformations on model data. It is a wrapper around a model for use in a view.

Under `/lib`

`tasks`
- Rake tasks

Use `lib` rather than `app/lib` for custom code that enhances the app but doesn’t fit into a directory in `app`

Under `/config`

`locales`
- Static content like lists of contact information should ideally be stored in the locale files to promote localisation.

Namespaces should be used to group functionality e.g. for StepBySteps, and resources in the routes file.

### When should a model be used?

If you are modelling data injested from a source e.g. an API response, or data file, you should be using a model.

### When should a helper or presenter be used?

If you creating presentation code, for example transforming the data by applying translation keys, then you should be using a helper or a presenter.

Helpers should be generic. They shouldn't need to know about the structure of a content item. E.g. applying date formatting to supplied date. 

If your presentation code relies on the structure of a content item, you should be using a presenter.

### Data files
We should **avoid using data files** - where possible, all information required for rendering should come from the content item or other APIs or be a static part of the app. For that reason they have been left out of the directory structure. However, if data files are required they should be co-located.

## Testing

Frontend uses the [RSpec testing framework] to test Ruby code. 

When adding tests, more [modern tests] should be used, e.g. request tests should be used rather than controller tests, and system tests rather than feature tests.

The convention for test structure is for the top-level descriptor to use `RSpec.describe` and all of the other blocks to in the test file to either use `describe` if describing a method name, or `context` if describing a scenario. 


[our Rails app conventions]: https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html
[RFC 175]: https://github.com/alphagov/govuk-rfcs/blob/main/rfc-175-frontend-fewer-apps.md#code-structure
[RSpec testing framework]: https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html#testing-utilities
[modern tests]: https://github.com/rspec/rspec-rails?tab=readme-ov-file#system-specs-feature-specs-request-specswhats-the-difference




