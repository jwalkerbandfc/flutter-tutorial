(function () {
  function dartpadEmbedUrl(ghPath) {
    var g = window.FlutterTutorial.GITHUB;
    return (
      'https://dartpad.dev/embed-flutter.html?gh_owner=' +
      encodeURIComponent(g.owner) +
      '&gh_repo=' +
      encodeURIComponent(g.repo) +
      '&gh_path=' +
      encodeURIComponent(ghPath) +
      '&gh_ref=' +
      encodeURIComponent(g.ref) +
      '&theme=dark&split=60'
    );
  }

  function dartpadOpenUrl(ghPath) {
    var g = window.FlutterTutorial.GITHUB;
    return (
      'https://dartpad.dev/?gh_owner=' +
      encodeURIComponent(g.owner) +
      '&gh_repo=' +
      encodeURIComponent(g.repo) +
      '&gh_path=' +
      encodeURIComponent(ghPath) +
      '&gh_ref=' +
      encodeURIComponent(g.ref) +
      '&theme=dark'
    );
  }

  function loadExample(ghPath, label) {
    var iframe = document.getElementById('dartpad-iframe');
    var labelEl = document.getElementById('dartpad-panel-label');
    var openLink = document.getElementById('open-in-dartpad-link');
    if (!iframe) return;

    iframe.setAttribute('data-gh-path', ghPath);
    iframe.src = dartpadEmbedUrl(ghPath);
    if (labelEl) labelEl.textContent = label || '';
    if (openLink) openLink.href = dartpadOpenUrl(ghPath);

    var buttons = document.querySelectorAll('.run-in-panel-btn');
    for (var i = 0; i < buttons.length; i++) {
      var isActive = buttons[i].getAttribute('data-gh-path') === ghPath;
      buttons[i].classList.toggle('active', isActive);
    }
  }

  function init() {
    var buttons = document.querySelectorAll('.run-in-panel-btn');
    buttons.forEach(function (btn) {
      btn.addEventListener('click', function () {
        loadExample(
          btn.getAttribute('data-gh-path'),
          btn.getAttribute('data-label')
        );
      });
    });

    var reloadBtn = document.getElementById('reload-example-btn');
    if (reloadBtn) {
      reloadBtn.addEventListener('click', function () {
        var iframe = document.getElementById('dartpad-iframe');
        var labelEl = document.getElementById('dartpad-panel-label');
        if (iframe) {
          var path = iframe.getAttribute('data-gh-path');
          if (path) loadExample(path, labelEl ? labelEl.textContent : '');
        }
      });
    }

    if (buttons.length > 0) {
      loadExample(
        buttons[0].getAttribute('data-gh-path'),
        buttons[0].getAttribute('data-label')
      );
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  window.FlutterTutorial = window.FlutterTutorial || {};
  window.FlutterTutorial.dartpad = {
    dartpadEmbedUrl: dartpadEmbedUrl,
    dartpadOpenUrl: dartpadOpenUrl,
    loadExample: loadExample,
  };
})();
