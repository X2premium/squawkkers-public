<h1 align="center"> Squawker </h1>
<br>
<p align="center">
  <a href="https://github.com/X2premium/squawkkers-public">
    <img alt="Squawker" title="Squawker" src="fastlane/metadata/android/en-US/images/icon.png" width="144">
  </a>
</p>
<p align="center">
  Maintaining the <a href="https://github.com/jonjomckay/fritter">Fritter</a> feed, originally by <a href="https://github.com/TheHCJ/Quacker">Quacker</a>
</p>

<p align="center">
  <a href="https://github.com/X2premium/squawkkers-public/releases" alt="GitHub release"><img src="https://img.shields.io/github/release/X2premium/squawkkers-public.svg?style=for-the-badge" ></a>
  <a href="https://f-droid.org/packages/org.ca.squawker" alt="GitHub release"><img src="https://img.shields.io/f-droid/v/org.ca.squawker?label=release%20(f-droid)&style=for-the-badge" ></a>
  <a href="https://github.com/X2premium/squawkkers-public/blob/master/LICENSE" alt="License: MIT"><img src="https://img.shields.io/badge/License-MIT-red.svg?style=for-the-badge"></a>
  <a href="https://github.com/X2premium/squawkkers-public/actions" alt="Build Status"><img src="https://img.shields.io/github/actions/workflow/status/X2premium/squawkkers-public/ci.yml?style=for-the-badge"></a>
  <a href="https://hosted.weblate.org/engage/squawker/" alt="Translation Status"><img src="https://img.shields.io/weblate/progress/squawker?label=Translated%20(squawker)&style=for-the-badge"></a>
</p>
<p align="center">
  <a href="https://f-droid.org/packages/org.ca.squawker">
    <img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="80">
  </a>
</p>

## Download (Public Release)

* Latest release page: https://github.com/X2premium/squawkkers-public/releases/latest
* Latest universal APK: https://github.com/X2premium/squawkkers-public/releases/latest/download/squawkkers-universal.apk
* Current app version: `3.8.9` (build `52`)

<p align="center">
  There is also an alternate F-Droid repository that allows updates for Squawker to be available faster than on the default F-Droid repository.
</p>
<p align="left">
  Scan the QR code below or click this <a href="https://apkrep.creativaxion.org/fdroid/repo?fingerprint=443DA0A316DFB86BFD05D0123951855E7CD8724969FAD66D6E62EB801299744A">link</a> and process it with your F-Droid client. Here's the full link text for easy viewing:<br>
    https://apkrep.creativaxion.org/fdroid/repo?fingerprint=443DA0A316DFB86BFD05D0123951855E7CD8724969FAD66D6E62EB801299744A
</p>
<p align="left">
  <img src="https://apkrep.creativaxion.org/fdroid/repo/index.png" width="80">
</p>
<p align="center">
 <sub>Important note: In case Squawker is already installed on your device and you want to reinstall it or want to install a version from another repository (from F-Droid to github or from F-Droid to the alternate F-Droid repository for instance), make sure to backup your application data (Settings/Data, tap Export, select all items then tap the save icon) and uninstall Squawker before proceeding.
  After you have reinstalled Squawker from the new repository, import your backup (Settings/Data, tap Import).</sub>
</p>

## This Fork: Fixes & Enhancements

Compared to the original Fritter/Quacker baseline, this fork includes:

* Full Android UI refresh with a modern Material 3 design language (updated typography, spacing, cards, and surfaces)
* Theme readability fixes across screens (removed hardcoded white text and low-contrast UI states)
* Improved tweet card and menu styling for consistent dark/light contrast
* Video/media download reliability fixes (options-sheet context fix, HTTP fallback headers, and save dialog fallback when storage permission is denied)
* Subscription import improvements (supports `@username`, profile URLs, and safer comma-separated parsing with lookup fallback)
* Subscription refresh stability improvements (graceful handling when user lookup endpoints fail)
* Thread parsing fixes for home timeline chains and reply handling correctness
* Rate-limit handling fixes in account selection/recovery flows
* X account header flow fixes (consistent auth header usage on requests)
* Safer network behavior for transaction-id provider calls (HTTPS + app HTTP client path)
* Sensitive logging cleanup (removed auth header/token leak prints)
* Profile credential storage hardening with backward-compatible password encryption at rest
* Translation cache read-path fix to avoid unnecessary repeat network calls
* Update-check version comparison fix (semantic version-aware instead of lexicographic string compare)
* Swipe physics tuning to prevent non-stop/looping horizontal slide behavior
* Android package migration to `com.x2premium.squawkkers` and updated launcher icon colors/assets
* About screen and update-check links updated to this repository (`X2premium/squawkkers-public`)
* Profile bio text readability fix in light mode (removed white-on-light description rendering)
* Profile tab behavior fixes for Tweets / Tweets & Replies / Media routing and state isolation
* Profile header/tab overlap fix (tab labels no longer merge into profile bio/metadata)
* Media timeline parsing hardening for additional X timeline entry formats
* Replies timeline fallback improvements when upstream query shapes vary
* Saved tab duplication-loop fix (no infinite repeated saved tweets while scrolling)
* Retry callback fixes on profile/saved tab error states
 
## Features:

* Privacy: No tracking, with all data local
* No ads: Not clogged by multiple ads
* Feed: View all your subscriptions in a chronological feed
* Subscriptions: Follow and group accounts
* Search: Find users and tweets
* Bookmarks: Save tweets locally and offline
* Trends: See what's trending in the world
* Polls: View results without needing to vote
* Light and Dark themes: Protect your eyes
* And more!
  
## Screenshots

| <img alt="Screenshot 1" src="https://i.ibb.co/JFn3NFz0/Screenshot-2026-02-25-17-20-46-532-com-x2premium-squawkkers.jpg" width="218"/> | <img alt="Screenshot 2" src="https://i.ibb.co/VYmpRG4x/Screenshot-2026-02-25-17-20-51-364-com-x2premium-squawkkers.jpg" width="218"/> | <img alt="Screenshot 3" src="https://i.ibb.co/S4xPyZRt/Screenshot-2026-02-25-17-20-56-535-com-x2premium-squawkkers.jpg" width="218"/> |

## Contribute
If you'd like to help make Squawker even better, here are a just a few of the ways you can help!

### Report a bug
If you've found a bug in Squawker, open a [new issue](https://github.com/X2premium/squawkkers-public/issues/new/choose), but please make sure to check that someone else hasn't reported it first on Fritter or on Squawker.

### Fix a bug
If you're looking for something to dip your toes into the codebase, check if there are any issues labelled good first issue. Otherwise, if you see another issue you'd like to tackle, go for it - just fork the repository, push to a branch, and create a PR detailing your changes. We'll review it and merge it in, once it meets all our checks and balances!

### Translations
Most of Squawker's translations have come from [Weblate](https://hosted.weblate.org/engage/squawker/)

### Acknowledgments
Duck Icon: <a href="https://www.vecteezy.com/free-vector/bathroom">Bathroom Vectors by Vecteezy</a>
