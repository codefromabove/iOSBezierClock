iOSBezierClock
==============

I recently stumbled upon Jack Friggard's [Bézier Clock](http://jackf.net/bezier-clock/) web page, which demonstrates his use of [Processing.js](http://processingjs.org/) to show an animated "digital" clock. He links to another page containing his Javascript [code](http://jackf.net/bezier-clock/bezier_clock.pde). All credit for the actual functionality goes to Jack. 

Update: Jack’s original web pages are MIA, but can be found via the [Internet Archive Wayback Machine](http://archive.org/web/) [here](http://web.archive.org/web/20150415161240/http://jackf.net/bezier-clock/) and [here](http://web.archive.org/web/20150409000842/http://jackf.net/bezier-clock/bezier_clock.pde).

I thought it would be fun to see if I could translate this into an iOS app; this GitHub project is the result of that effort. In truth, this is more of a transliteration than a proper translation...I converted it to Objective-C by creating equivalents to Jack's classes, adding some UIViewControllers and UIViews, and pasting his code in. My goal was to try to simultaneously keep his code and algorithms as intact as possible, while writing fairly "proper" Objective-C. So, what you see here is probably not quite what one would do if one started from scratch on iOS.

One other goal of this little excursion was to attempt to do this entirely with Storyboards. Typically, I've tried to use Interface Builder as much as possible, plus some amount of programmatic UI code. Now that Xcode really pushes Storyboards, when I've made little toys/experiments with the Single View template, I've not *really* been using Storyboards -- I just stick some UI into the built-in UIView. There's very little UI in this app -- just a handful of "dialogs", which employ Storyboard Segues for their invocation.

The last goal was to try to avoid anything device-specific. On an iPad, some of the UI would have been nice to show in a popover, but of course these aren't available on iPhones due to Apple policy (you can't use the SDK, but rumor has it that there are open source iPhone-compatible popovers available). For the simple UI in this app, the approach I took is functional, if a bit pedestrian in terms of aesthetics.

Credit is also due to Carlos Vidal, for his [NKOColorPickerView](https://github.com/FWCarlos/NKOColorPickerView-Example-iOS). It's *very* simple, clean, and easy to integrate into a project. I made some minor modifications: replaced the UIView touch interactions with gesture recognizers. Other than that, it dropped into my project in just a few minutes. Thanks, Carlos!
