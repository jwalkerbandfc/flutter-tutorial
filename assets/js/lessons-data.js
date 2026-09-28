window.FlutterTutorial = window.FlutterTutorial || {};

window.FlutterTutorial.GITHUB = {
  owner: 'jwalkerbandfc',
  repo: 'flutter-tutorial',
  // Pinned to a commit SHA rather than 'main'. DartPad's gh_ref embed is
  // fetched through a CDN that caches per (owner, repo, ref, path) — with
  // a branch name as ref, that cache goes stale as soon as main moves,
  // and there is no way to force-purge it. A commit SHA is immutable, so
  // the same URL can be cached forever without ever serving old content.
  // Update this to the new HEAD commit SHA whenever snippets/ changes land
  // on main (a short branch-name-pointing window between merge and this
  // update is expected and harmless — it just means the panel briefly
  // serves the previous commit's snippets until this is bumped).
  ref: '124168274f0c8fc642a3b5982ddec2d16ab70b26',
};

window.FlutterTutorial.LESSONS = [
  {
    id: 'module-1',
    number: 1,
    title: 'Environment Setup',
    icon: '\u{1F680}',
    href: 'modules/module-1.html',
  },
  {
    id: 'module-2',
    number: 2,
    title: 'The Basics',
    icon: '\u{1F9E9}',
    href: 'modules/module-2.html',
  },
  {
    id: 'module-3',
    number: 3,
    title: 'Object-Oriented Architecture',
    icon: '\u{1F3D7}️',
    href: 'modules/module-3.html',
  },
  {
    id: 'module-4',
    number: 4,
    title: 'Game Entities',
    icon: '\u{1F3AE}',
    href: 'modules/module-4.html',
  },
  {
    id: 'module-5',
    number: 5,
    title: 'The Game Loop',
    icon: '\u{1F501}',
    href: 'modules/module-5.html',
  },
];
