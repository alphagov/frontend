# Debugging in VS Code

If you want to debug within VS Code, you'll need the [VSCode rdbg Ruby Debugger](https://marketplace.visualstudio.com/items?itemName=KoichiSasada.vscode-rdbg) extension, and once that's installed, create a configuration file for it at `.vscode/launch.json` containing the following values

```
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "type": "rdbg",
      "name": "Attach with rdbg",
      "request": "attach",
      "debugPort": "frontend.dev.gov.uk:12345",
      "localfsMap": "/:${userHome}"
    }
  ]
}
```

Then run govuk-docker-up, and use the Run and Debug tab and press the play button next to "Attach with rdbg", at which point you'll be able to set breakpoints in your code.
