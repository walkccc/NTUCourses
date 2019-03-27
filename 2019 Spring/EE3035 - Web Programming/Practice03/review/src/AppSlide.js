import React, { Component } from 'react';

const img = ["img/blog/blog-slider/blog-slide1.png","img/blog/blog-slider/blog-slide2.png","img/blog/blog-slider/blog-slide3.png"];
    
class AppSlide extends Component {
    render() {
        return (
            <div class="owl-carousel owl-theme blog-slider">
                {img.map(e=>{
                    return(
                        <div class="card blog__slide text-center">
                            <div class="blog__slide__img">
                                <img class="card-img rounded-0" src={e} alt="" />
                            </div>
                            <div class="blog__slide__content">
                                <a class="blog__slide__label" href="/#">Fashion</a>
                                <h3><a href="/#">New york fashion week's continued the evolution</a></h3>
                                <p>2 days ago</p>
                            </div>
                        </div>
                    )
                })}
                {img.map(e=>{
                    return(
                        <div class="card blog__slide text-center">
                            <div class="blog__slide__img">
                                <img class="card-img rounded-0" src={e} alt="" />
                            </div>
                            <div class="blog__slide__content">
                                <a class="blog__slide__label" href="/#">Fashion</a>
                                <h3><a href="/#">New york fashion week's continued the evolution</a></h3>
                                <p>2 days ago</p>
                            </div>
                        </div>
                    )
                })}
            </div>
        );
    }
}

export default AppSlide;
