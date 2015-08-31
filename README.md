Unobtrusive File Upload adapter for jQuery UJS and Rails
-
This gem takes care about file uploads for remote form.
It is a simple alternative for [remotipart](https://github.com/JangoSteve/remotipart) gem for rails.
But instead of using iframe for file uploads this gem uses the base64 encoding to send the file to the server.

Installing
-
Add it to your Gemfile:

```ruby
gem 'ufujs-rails'
```

Then run `bundle install` to update your application's bundle.

And in `application.js` under the `jquery_ujs`:

```javascript
//= require jquery_ufujs
```

Usage
-
This gem encode the base64 string on the client side and handle the decoding in middleware, so we will get already decoded string in params on server side.

Data format
-
The string with the encoded data, should be prefixed with Data URI scheme format:

`data:image/jpg;base64,(base64 encoded data)`

Browser Compatibility
-

![ie10](http://www.browserbadge.com/ie/10/75px)
![chrome](http://www.browserbadge.com/chrome/75px)
![firefox](http://www.browserbadge.com/firefox/75px)
![opera](http://www.browserbadge.com/opera/75px)
![safari](http://www.browserbadge.com/safari/5/75px)

If you care about IE9 and lower, don't worry we are sure that you will have the white line in your life soon.

For IE9 and lower form will be submitted as `HTML`.
You just have to add the `authenticity_token` option to your form

```slim
= form_for @record, remote: true, authenticity_token: true do
```

Copyright© Alex Galushka
