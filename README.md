# Spruce

## Development

* Node.js via virtualenv

```
% mkvirtualenv spruce
(spruce) % pip install nodeenv
(spruce) % nodeenv -p
```

### Setup

```
(spruce) % bundle install --path .bundle/gems
(spruce) % npm install bower
(spruce) % ./node_modules/.bin/bower install
```

see `.bowerrc` and `bower.json`

### Boot

```
(spruce) % bundle exec foreman run dev
```

### Test

```
;; suit
(spruce) % bundle exec foreman run rake test
;; run file
(spruce) % bundle exec foreman run ruby -I.:test test/models/node_test.rb
;; see minitest help
(spruce) % bundle exec foreman run ruby -I.:test test/test_helper.rb --help
minitest options:
    -h, --help                       Display this help.
    -s, --seed SEED                  Sets random seed
    -v, --verbose                    Verbose. Show progress processing files.
    -n, --name PATTERN               Filter test names on pattern (e.g. /foo/)
```
