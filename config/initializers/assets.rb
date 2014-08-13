# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( application.scss )

# This block includes all js/css files, including gems,
# under: app/assets, vendor/assets, lib/assets
# and excluding partial files (e.g. "_file.sass")

include_paths = [
"bootstrap/dist/js/bootstrap.min",
"slimscroll/jquery.slimscroll.min",
"gritter/js/jquery.gritter",
"flot/jquery.flot.min",
"flot/jquery.flot.time.min",
"flot/jquery.flot.resize.min",
"flot/jquery.flot.pie.min",
"sparkline/jquery.sparkline",
"jquery-jvectormap/jquery-jvectormap-1.2.2.min",
"jquery-jvectormap/jquery-jvectormap-world-mill-en",
"bootstrap-datepicker/js/bootstrap-datepicker",
"pixel_admin/js/dashboard.min.js",
"pixel_admin/js/apps.js",
"angular/angular",
'bootstrap/dist/css/bootstrap.css',
'bootstrap/dist/css/bootstrap-theme.css',
'font-awesome-4.1.0/css/font-awesome.css',
'pixel_admin/css/animate.css',
'pixel_admin/css/style.min.css',
'pixel_admin/css/style-responsive.min.css',
'bootstrap-datepicker/css/datepicker.css',
'bootstrap-datepicker/css/datepicker3.css',
'gritter/css/jquery.gritter.css'
]


Rails.application.config.assets.precompile << Proc.new { |path|
  if path =~ /\.(css|js)\z/
    full_path = Rails.application.assets.resolve(path).to_path
    include_paths.any?{|a| full_path.match(a)}
  else
    false
  end
}