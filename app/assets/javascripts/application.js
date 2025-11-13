// This file is linked to in the application.
//= require dependencies
//= require main
//= require govuk_publishing_components/dependencies

let deferredPrompt
const btnInstall = document.getElementById('btnInstall')

window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault()
  deferredPrompt = e
  btnInstall.hidden = false
})

btnInstall.addEventListener('click', async () => {
  // Hide the install button
  btnInstall.style.display = 'none'

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
