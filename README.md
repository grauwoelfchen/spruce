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

see `Procfile`
