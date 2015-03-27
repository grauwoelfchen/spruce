# Spruce

Let's [spruce](https://spruce-tree.net/) up messy thoughts.


## Setup

* Ruby
* Node.js

```
;; e.g. Setup Node.js via Python's virtualenv
% mkvirtualenv spruce
(spruce) % pip install nodeenv
(spruce) % nodeenv -p
```

```
;; Install bundler
(spruce) % gem install bundler

;; Install rubygems via bundler
(spruce) % bundle install --path .bundle/gems

;; Install gulp
(spruce) % npm install gulp -g

;; Install npm packages
(spruce) % npm install

;; Install asset packages via gulp
(spruce) % gulp bower
```

see also `.bowerrc` and `bower.json`


## Boot

```
(spruce) % bundle exec foreman run dev
```

see `Procfile`


## Test

```
;; Run test suit
(spruce) % bundle exec foreman run rake test

;; Run test only for specified file
(spruce) % bundle exec foreman run ruby -I.:test test/models/node_test.rb

;; Watch with gulp (see gulpfile.js)
(spruce) % gulp watch
```
