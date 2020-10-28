(function() {
  const textfield = document.getElementById('comment');
  const count = document.getElementById('count');

  const updateCount = () => {
    count.innerText = textfield.value.length;
  };

  textfield.addEventListener('change', updateCount);
  textfield.addEventListener('keydown', updateCount);
  textfield.addEventListener('keyup', updateCount);
})();
