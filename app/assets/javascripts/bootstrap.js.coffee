jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  for link in $(".navbar .nav a")
    do (link) ->
      if (window.location.pathname == link.pathname && link.getAttribute('href') != '#')
        $(link).parent().toggleClass("active")

