import { TweenMax } from 'gsap';

document.addEventListener('DOMContentLoaded', () => {
  const notice = document.querySelector('.alerts');

  if (notice) {
    setTimeout(() => {
      TweenMax.fromTo(
        notice,
        1,
        { opacity: 1 },
        {
          opacity: 0,
          onComplete: () => {
            notice.remove();
          }
        }
      );
    }, 3000);
  }
});
