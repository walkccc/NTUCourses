function OpenPicture() {
    document.getElementById("AllPictures").style.display = "block";
}

function ClosePicture() {
    document.getElementById("AllPictures").style.display = "none";
}

var slideIndex = 1;
showSlides(slideIndex);

function plusSlides(n) {
    showSlides(slideIndex += n);
}

function currentSlide(n) {
    showSlides(slideIndex = n);
}

function showSlides(n) {
    var i;
    var pause = document.getElementsByClassName("mySlides_loading");
    var slides = document.getElementsByClassName("mySlides");
    var dots = document.getElementsByClassName("demo");
    var captionText = document.getElementById("caption");
    if (n > slides.length) {
        slideIndex = slides.length;
        document.getElementById("content_next").innerHTML = "&#10006";
    } else {

        document.getElementById("content_next").innerHTML = "&#10095";
    }

    if (n < 1) {

        slideIndex = 1;
        document.getElementById("content_prev").innerHTML = "&#10006";

    } else {

        document.getElementById("content_prev").innerHTML = "&#10094";
    }

    for (i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";
    }
    for (i = 0; i < dots.length; i++) {
        dots[i].className = dots[i].className.replace(" active", "");
    }

    pause[0].style.display = "block";
    slides[slideIndex - 1].style.display = "block";
    pause[0].style.display = "none";
    dots[slides.length - slideIndex].className += " active";
    captionText.innerHTML = dots[slides.length - slideIndex].alt;
}