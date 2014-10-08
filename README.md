# Twitter iOS App for CodePath (Redux)

This is part 2 of the iOS demo Twitter application. You can read tweets from people you follow, submit your own tweets, and view user's profiles.

Time spent: ~15 hours spent in total

Completed user stories:

* [x] Dragging anywhere in the view should reveal the menu.
* [x] The menu should include links to your profile, the home timeline, and the mentions view.
* [x] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.
* [x] Contains the user header view
* [x] Contains a section with the users basic stats: # tweets, # following, # followers
* [x] Tapping on a user image should bring up that user's profile page
* [x] Optional: Pulling down the profile page should blur and resize the header image.
* [ ] Optional: Implement the paging view for the user description.
* [ ] Optional: As the paging view moves, increase the opacity of the background screen.
* [ ] Optional: Long press on tab bar to bring up Account view with animation
* [ ] Optional: Tap account to switch to
* [ ] Optional: Include a plus button to Add an Account
* [ ] Optional: Swipe to delete an account

Notes:

I found the profile header blurring to be an interesting problem, and spent most of my extra time exploring the CoreImage and NSOperationQueue APIs. I ended up using [GPUImage](https://github.com/BradLarson/GPUImage) and caching a series of blurred images in a background queue to make the interaction smooth.

Walkthrough of all user stories:

![Video Walkthrough](walkthrough.gif)
