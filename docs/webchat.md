# Webchat

Frontend supports the HMPO webchat at `/government/organisations/hm-passport-office/contact/hm-passport-office-webchat`. A JS module embedded in the page updates the page contents on the client side based on whether the service is open and/or advisers are available.

## How it works

[/app/controllers/webchat_controller.rb](/app/controllers/webchat_controller.rb) - sets up the model
[/app/models/webchat.rb](/app/models/webchat.rb) - contains the urls for the availability endpoint and the link to open a webchat.
[/app/views/webchat/show.html.erb](/app/views/webchat/show.html.erb) - urls/links are inserted into the view as data attributes, along with the collection of possible status messages.
[/app/assets/javascripts/modules/webchat.js](/app/assets/javascripts/modules/webchat.js) - in the client, calls the availability endpoint and then updates the status message blocks based on the returned value.

## How to update the webchat provider

You will need to edit the following values in `/app/models/webchat.rb`:

### @availability_url

This URL is used to check the availability of agents at regular intervals.

|  Function  |  Required |
|-----------|-----------|
| Request Method  | GET  |
| Response Format | JSON/JSONP (Default to JSONP) |
| Request Example | {"status":"success","response":"BUSY"}  |
| Valid statuses | ["BUSY", "UNAVAILABLE", "AVAILABLE","ONLINE", "OFFLINE", "ERROR"] |

## @csp_connect_src

For a webchat provider to integrate with GOV.UK it needs permissions from the [Content Security Policy](https://docs.publishing.service.gov.uk/manual/content-security-policy.html).

This will be set-up for a provider by the `csp_connect_src` option which configures the `connect-src` directive, however other providers may need additional configuration, such as `script-src`. This configuration should be done in the same manner as `csp_connect_src` to only affect resources that embed webchat. This should be in the form of a hostname, ideally with a scheme.

### @open_url

This url is used to start a webchat session. It should not include session ids or require anything specific parameters to be generated.

### @redirect_attribute

By default the chat session would open in an a separate browser window. Setting this to true keeps it in the current window.
