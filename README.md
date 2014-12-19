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

;; Install bower
(spruce) % npm install bower

;; Install asset packages via bower
(spruce) % ./node_modules/.bin/bower install
```

see `.bowerrc` and `bower.json`


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

;; See minitest help
(spruce) % bundle exec foreman run ruby -I.:test test/test_helper.rb --help
minitest options:
    -h, --help                       Display this help.
    -s, --seed SEED                  Sets random seed
    -v, --verbose                    Verbose. Show progress processing files.
    -n, --name PATTERN               Filter test names on pattern (e.g. /foo/)
```
