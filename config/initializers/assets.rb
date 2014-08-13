# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( application.scss )

# This block includes all js/css files, including gems,
# under: app/assets, vendor/assets, lib/assets
# and excluding partial files (e.g. "_file.sass")
config.assets.precompile << Proc.new { |path|
  if path =~ /\.(css|js)\z/
    full_path = Rails.application.assets.resolve(path).to_path
    asset_paths = %w( app/assets vendor/assets/components lib/assets)
    if ((asset_paths.any? {|ap| full_path.include? ap})
         && !path.starts_with?('_'))
      puts "\tIncluding: " + full_path
      true
    else
      puts "\tExcluding: " + full_path
      false
    end
  else
    false
  end
}