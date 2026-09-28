(function () {
  var STORAGE_KEY = 'flutter-tutorial-progress';

  function getCompleted() {
    try {
      var raw = localStorage.getItem(STORAGE_KEY);
      return raw ? JSON.parse(raw) : [];
    } catch (e) {
      return [];
    }
  }

  function isComplete(id) {
    return getCompleted().indexOf(id) !== -1;
  }

  function isUnlocked(lessonId) {
    var lessons = window.FlutterTutorial.LESSONS;
    var index = -1;
    for (var i = 0; i < lessons.length; i++) {
      if (lessons[i].id === lessonId) {
        index = i;
        break;
      }
    }
    if (index <= 0) return true;
    return isComplete(lessons[index - 1].id);
  }

  function markComplete(id) {
    var completed = getCompleted();
    if (completed.indexOf(id) === -1) {
      completed.push(id);
      try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(completed));
      } catch (e) {
        // Ignore write failures (private browsing, storage disabled, etc).
      }
    }
  }

  function resetProgress() {
    try {
      localStorage.removeItem(STORAGE_KEY);
    } catch (e) {
      // Ignore.
    }
  }

  window.FlutterTutorial.progress = {
    getCompleted: getCompleted,
    isComplete: isComplete,
    isUnlocked: isUnlocked,
    markComplete: markComplete,
    resetProgress: resetProgress,
  };
})();
