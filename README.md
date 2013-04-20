pinboard
========

Perfectly fit a group of photos in your browser.
- Dynamially adjusts tile sizes to cover every pixel in your browser
- Zooms in on a couple photos to draw focus.

Built by [Ryhan](https://github.com/ryhan) for a demo. You probably shouldn't use it for anything serious.

## Demo
Check out the `/demo` folder for sample html, javascript, and content.

![Demo](http://f.cl.ly/items/1a2x043E2r2n2m0c1g3Z/Screen%20Shot%202013-04-20%20at%204.37.50%20AM.png)

## Usage

### Includes
- jQuery
- Underscore.js
- pin.js
- pinboard.js

```html
<!-- Include jQuery and Underscore.js -->
<script src="jquery.js"></script>
<script src="underscore.js"></script>

<!-- Include pin.js and pinboard.js -->
<script src="pin.js"></script>
<script src="pinboard.js"></script>
```

### JavaScript
- Create an array of "pins" (single tiles of content)
- Create a pinboard object, and attach its html to your document
- Update the pinboard object

```javascript
// Create an array of things you want to showcase
var pins = [ ]

// Each pin can have text and/or a photo,
// and you can also attach a click handler.
pins.push(new Pin(
  {text: "My Beautiful Photo", photo: "photos/7.jpg"}, 
  {click: function(e){ /* do something on click */ }}
));

// Create a pinboard, and attach it somewhere.
var pinboard = new Pinboard(pins);
$('body').append(pinboard.html);

// Update the content inside the pinboard.
pinboard.update();
```
