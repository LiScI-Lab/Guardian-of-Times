# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Export
The export uses wkhtmltopdf (https://wkhtmltopdf.org).
It should be included as a binary gem using bundler.
If this fails, install wkhtmltopdf using your distribution and tell wicked_pdf (https://github.com/mileszs/wicked_pdf)  where the local installation is.
Tell bundler to install without the binary by running `bundle install --without wk_binary`.
