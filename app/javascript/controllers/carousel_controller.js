import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
export default class extends Controller {
  connect() {
    const imgSlider = document.querySelector('.img-slider');

    const nextBtn = document.querySelector('.next-btn');
    const prevBtn = document.querySelector('.prev-btn');

    let indexSlider = 0;

    nextBtn.addEventListener('click', () => {
      console.log("Click no botão")
      indexSlider++;
      imgSlider.style.transform = `rotate(${indexSlider * -90}deg)`;
    });

    prevBtn.addEventListener('click', () => {
      indexSlider--;
      imgSlider.style.transform = `rotate(${indexSlider * -90}deg)`;
    });
    console.log("Teste");
  }
}
