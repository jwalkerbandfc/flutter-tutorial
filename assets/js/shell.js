(function () {
  function rootPrefix() {
    return document.body.getAttribute('data-root') || '';
  }

  function escapeHtml(str) {
    return String(str).replace(/[&<>"']/g, function (ch) {
      return (
        { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[
          ch
        ] || ch
      );
    });
  }

  function buildHeader() {
    var gh = window.FlutterTutorial.GITHUB;
    var repoUrl = 'https://github.com/' + gh.owner + '/' + gh.repo;
    return (
      '<div class="app-header-inner">' +
      '<div class="app-header-text">' +
      '<div class="app-header-title">Flutter Game Tutorial</div>' +
      '<div class="app-header-subtitle">Build a 2D side-scrolling game, live in your browser</div>' +
      '</div>' +
      '<a class="app-header-repo" href="' +
      repoUrl +
      '" target="_blank" rel="noopener">' +
      '<svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor" aria-hidden="true"><path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8z"></path></svg>' +
      '<span>' +
      escapeHtml(gh.owner + '/' + gh.repo) +
      '</span>' +
      '</a>' +
      '</div>'
    );
  }

  function buildSidebar() {
    var root = rootPrefix();
    var lessons = window.FlutterTutorial.LESSONS;
    var progress = window.FlutterTutorial.progress;
    var completed = progress.getCompleted();
    var currentId = document.body.getAttribute('data-lesson') || '';

    var total = lessons.length;
    var doneCount = 0;
    for (var i = 0; i < lessons.length; i++) {
      if (completed.indexOf(lessons[i].id) !== -1) doneCount++;
    }
    var pct = total > 0 ? Math.round((doneCount / total) * 100) : 0;

    var items = lessons
      .map(function (lesson) {
        var isDone = completed.indexOf(lesson.id) !== -1;
        var unlocked = progress.isUnlocked(lesson.id);
        var isCurrent = lesson.id === currentId;

        var stateClass = 'locked';
        var statusIcon =
          '<span class="lesson-status lesson-lock" aria-hidden="true">&#128274;</span>';
        if (isDone) {
          stateClass = 'complete';
          statusIcon =
            '<span class="lesson-status lesson-check" aria-hidden="true">&#10003;</span>';
        } else if (unlocked) {
          stateClass = 'unlocked';
          statusIcon =
            '<span class="lesson-status lesson-number">' +
            lesson.number +
            '</span>';
        }
        if (isCurrent) stateClass += ' current';

        var label =
          '<span class="lesson-icon" aria-hidden="true">' +
          lesson.icon +
          '</span><span class="lesson-title">' +
          escapeHtml(lesson.title) +
          '</span>';

        if (unlocked || isDone) {
          return (
            '<li class="lesson-item ' +
            stateClass +
            '"><a href="' +
            root +
            lesson.href +
            '">' +
            statusIcon +
            label +
            '</a></li>'
          );
        }
        return (
          '<li class="lesson-item ' +
          stateClass +
          '"><span class="lesson-item-disabled">' +
          statusIcon +
          label +
          '</span></li>'
        );
      })
      .join('');

    return (
      '<div class="sidebar-heading">Lessons</div>' +
      '<div class="sidebar-progress">' +
      '<div class="sidebar-progress-track"><div class="sidebar-progress-fill" style="width:' +
      pct +
      '%"></div></div>' +
      '<div class="sidebar-progress-label">' +
      doneCount +
      '/' +
      total +
      ' lessons completed</div>' +
      '</div>' +
      '<ul class="lesson-list">' +
      items +
      '</ul>' +
      '<button class="sidebar-reset" type="button" id="reset-progress-btn">&#8635; Reset progress</button>'
    );
  }

  function initTabs() {
    var tabLesson = document.getElementById('tab-lesson');
    var tabMainDart = document.getElementById('tab-maindart');
    var fullMainDart = document.getElementById('full-main-dart');
    if (!tabLesson || !tabMainDart) return;

    tabLesson.addEventListener('click', function () {
      tabLesson.classList.add('active');
      tabMainDart.classList.remove('active');
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
    tabMainDart.addEventListener('click', function () {
      tabMainDart.classList.add('active');
      tabLesson.classList.remove('active');
      if (fullMainDart) {
        fullMainDart.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  }

  function renderRoadmap(containerId, descriptions) {
    var container = document.getElementById(containerId);
    if (!container) return;

    var root = rootPrefix();
    var lessons = window.FlutterTutorial.LESSONS;
    var progress = window.FlutterTutorial.progress;
    var completed = progress.getCompleted();

    container.innerHTML = lessons
      .map(function (lesson) {
        var isDone = completed.indexOf(lesson.id) !== -1;
        var unlocked = progress.isUnlocked(lesson.id);
        var stateClass = isDone ? 'complete' : unlocked ? 'unlocked' : 'locked';
        var status = isDone
          ? '&#10003;'
          : unlocked
          ? String(lesson.number)
          : '&#128274;';
        var desc = (descriptions && descriptions[lesson.id]) || '';

        var inner =
          '<span class="roadmap-status">' +
          status +
          '</span><span class="roadmap-icon" aria-hidden="true">' +
          lesson.icon +
          '</span><span class="roadmap-text"><strong>Module ' +
          lesson.number +
          ': ' +
          escapeHtml(lesson.title) +
          '</strong><span>' +
          escapeHtml(desc) +
          '</span></span>';

        if (unlocked || isDone) {
          return (
            '<a class="roadmap-item ' +
            stateClass +
            '" href="' +
            root +
            lesson.href +
            '">' +
            inner +
            '</a>'
          );
        }
        return (
          '<div class="roadmap-item ' + stateClass + '">' + inner + '</div>'
        );
      })
      .join('');
  }

  function init() {
    var headerRoot = document.getElementById('app-header-root');
    var sidebarRoot = document.getElementById('sidebar-root');
    if (headerRoot) headerRoot.innerHTML = buildHeader();
    if (sidebarRoot) sidebarRoot.innerHTML = buildSidebar();

    var resetBtn = document.getElementById('reset-progress-btn');
    if (resetBtn) {
      resetBtn.addEventListener('click', function () {
        if (
          window.confirm(
            'Reset your lesson progress? This clears completed lessons on this device.'
          )
        ) {
          window.FlutterTutorial.progress.resetProgress();
          window.location.reload();
        }
      });
    }

    initTabs();

    if (typeof window.FlutterTutorial.onShellReady === 'function') {
      window.FlutterTutorial.onShellReady();
    }
  }

  window.FlutterTutorial = window.FlutterTutorial || {};
  window.FlutterTutorial.renderRoadmap = renderRoadmap;

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
