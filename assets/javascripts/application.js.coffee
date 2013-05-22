//= require_directory ./vendor
//= require ./foundation/foundation
//= require_directory ./foundation
//= require_directory ./jparallax

$ ->

  $('.parallax-layer').parallax {
    mouseport: $(".login"),
    xparallax: 0.5,
    yparallax: 0.18,
    xorigin: 0.1,
    yorigin: 0.4,
    frameDuration: 50
  }

  $(document).foundation()

  mixpanel.track_forms("form#login", "Sign in form submission")

  $("tr.file a").click ->
    mixpanel.track("Download file")
