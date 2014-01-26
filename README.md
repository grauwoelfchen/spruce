# Ash

## Development

* Node.js via virtualenv

```
% mkvirtualenv ash
% pip install nodeenv
% nodeenv -p
```

### Setup

```
% bundle install --path .bundle/gems
% npm install bower
% ./node_modules/.bin/bower install
```

see `.bowerrc` and `bower.json`

### Boot

```
% bundle exec foreman run dev
```

see `Procfile`
