Quick guide for pull requests!

1. Fork the repo.
2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate.
3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, a test
would be great!
4. Make the test pass.
5. Push to your fork and submit a pull request.

At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within three business days (and, typically, one business
day). We may suggest some changes or improvements or alternatives.

Also, some coding conventions:

Update the documentation, the surrounding one, examples elsewhere, guides,
whatever is affected by your contribution.
Two spaces, no tabs (for indentation).
No trailing whitespace. Blank lines should not have any spaces.
Indent after private/protected.
Use Ruby >= 1.9 syntax for hashes. Prefer { a: :b } over { :a => :b }.
Prefer &&/|| over and/or.
Use a = b and not a=b.
Prefer method { do_stuff } instead of method{do_stuff} for single-line blocks.
Follow the conventions in the source you see used already.
