// This file is linked to in the application.
//= require dependencies
//= require main
//= require govuk_publishing_components/dependencies

let deferredPrompt
const govukAppBanner = document.getElementById('govukAppBanner')
const govukAppBannerButton = document.getElementById('govukAppBannerButton')

window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault()
  deferredPrompt = e
  govukAppBanner.hidden = false
})

govukAppBannerButton.addEventListener('click', async () => {
  // Hide the install button
  govukAppBannerButton.style.display = 'none'

  if (deferredPrompt) {
    deferredPrompt.prompt()
    const { outcome } = await deferredPrompt.userChoice
    console.log(
      outcome === 'accepted'
        ? 'User accepted the install prompt'
        : 'User dismissed the install prompt'
    )
    deferredPrompt = null // Only one prompt per event
  }
})
