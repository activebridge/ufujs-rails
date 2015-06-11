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
gem 'carrierwave-base64'
```

Then run `bundle install` to update your application's bundle.

And in `application.js` under the `jquery_ujs`:

```javascript
//= require jquery_ufujs
```

Usage
-

This gem encode the base64 string on the client side.
Use [carrierwave-base64](https://github.com/lebedev-yury/carrierwave-base64) to handle the decoding on the server side.

Active Record
=

Mount the uploader: `mount_base64_uploader :image, ImageUploader`

Filter Parameters
=
To keep your logs clean you can add the filter with name of you attribute to `config/initializers/filter_paremeter_logging.rb`:

```ruby
config.filter_parameters += [:image]
```

Browser Compatibility
-

![ie10](http://browserbadge.com/ie/10)
![chrome](http://browserbadge.com/chrome)
![firefox](http://browserbadge.com/firefox)
![opera](http://browserbadge.com/opera)
![safari](http://browserbadge.com/safari/5)

If you care about IE9 and lower, don't worry I am sure that you will have the white line in your life soon.

For IE9 and lower form will be submited as `HTML`.
You just have to add the `authenticity_token` option to your form

```slim
= form_for @record, remote: true, authenticity_token: true do
```

Copyright© Alex Galushka
