Flight
======

NOT FINAL.. 

Use flight to make your page transitions super smooth for web based mobile applications. 

Flight has been written with [Backbone.js](http://backbonejs.org) in mind.  

	flight = new Flight();
	flight.goto('#page-id');

## How to use

Include the css file. blah blah

Setup a scrollable section:

	<div class="page hidden" id="test" data-transition="slide">
		<header>
			<a class="back btn left"><button>Back</button></a> 
			<h1>Test</h1>
		</header>
		<section>
			<div class="page-content">
				<div class="scroll-area">
				</div>
			</div>
		</section>
	</div>		

## Technical stuff

Flight makes use of hardware acceleration works best on IOS devices but runs well on Android 2.3 and above depending on the device. 

### Dependencies

- NoClickDelay.js

