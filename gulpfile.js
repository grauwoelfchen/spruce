var sys = require('sys');

var gulp  = require('gulp')
  , bower = require('gulp-bower')
  , watch = require('gulp-watch')
  , shell = require('gulp-shell')

gulp.task('watch', function() {
  watch('./test/**/*_test.rb', {
    read:          false
  , readDelay:     5
  , ignoreInitial: true
  , events:        ['add', 'change']
  }, function(file) {
    sys.puts('--');
    sys.puts('[' + file.event + ']');
    sys.puts(file.path);
  })
  .pipe(shell([
    'bundle exec foreman run ruby -I.:test <%= file.path %>'
  ]));
});

gulp.task('bower', function() {
  // see also .bowerrc
  return bower('./vendor/assets/components');
});

gulp.task('default', ['bower']);
