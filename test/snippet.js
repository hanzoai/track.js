(function(window, document, src) {
  var analytics, first, fn, i, len, method, ref, script;
  if (window.analytics != null) {
    return;
  }
  analytics = [];
  analytics.methods = ['ab', 'alias', 'group', 'identify', 'off', 'on', 'once', 'page', 'pageview', 'ready', 'track', 'trackClick', 'trackForm', 'trackLink', 'trackSubmit'];
  ref = analytics.methods;
  fn = function(method) {
    analytics[method] = function() {
      var event;
      event = Array.prototype.slice.call(arguments);
      event.unshift(method);
      analytics.push(event);
      return analytics;
    };
  };
  for (i = 0, len = ref.length; i < len; i++) {
    method = ref[i];
    fn(method);
  }
  script = document.createElement('script');
  script.async = true;
  script.type = 'text/javascript';
  script.src = src;
  first = document.getElementsByTagName('script')[0];
  first.parentNode.insertBefore(script, first);
  return window.analytics = analytics;
})(window, document, 'analytics.js');
