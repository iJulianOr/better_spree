Rails.application.configure do
  config.serviceworker.routes.draw do
    match "/sw.js", pack: true
    match "/manifest.json"
  end
end
