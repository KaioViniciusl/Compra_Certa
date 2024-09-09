const imgSlider = document.querySelector('.img-slider');

const nextBtn = document.querySelector('.next-btn');
const prevBtn = document.querySelector('.prev-btn');

let indexSlider = 0;

nextBtn.addEventListener('click', () => {
  indexSlider++;
  console.log('Next Button Clicked, indexSlider:', indexSlider);
  imgSlider.style.transform = `rotate(${indexSlider * -90}deg)`;
});

prevBtn.addEventListener('click', () => {
  indexSlider--;
  console.log('Prev Button Clicked, indexSlider:', indexSlider);
  imgSlider.style.transform = `rotate(${indexSlider * -90}deg)`;
});
