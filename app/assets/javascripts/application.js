// This file is linked to in the application.
//= require dependencies
//= require main
//= require govuk_publishing_components/dependencies
//= require govuk_web_banners/dependencies

var toggles = document.querySelectorAll('.js-toggle')
toggles.forEach(toggle => {
  console.log(toggle.children)
  const child1 = toggle.querySelector('.js-1')
  child1.style.display = 'block';
  const child2 = toggle.querySelector('.js-2')
  child2.style.display = 'none';

  const button = document.createElement('span')
  button.classList.add('toggle-button')
  toggle.append(button)

  button.addEventListener('click', function () {
    const child1 = toggle.querySelector('.js-1')
    const child2 = toggle.querySelector('.js-2')

    if (child1.style.display == 'block') {
      child1.style.display = 'none';
      child2.style.display = 'block';
    } else {
      child2.style.display = 'none';
      child1.style.display = 'block';
    }
  })
})
