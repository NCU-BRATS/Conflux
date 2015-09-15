$(document).on 'page:change', ->
  ga('send', 'pageview')
  amplitude.logEvent('pageview', {
    path: window.location.pathname,
    search: window.location.search
  })
