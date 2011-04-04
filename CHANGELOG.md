1.0.2 / 2011-03-18
------------------

* 1 bugfix
  
  * fix whitespace issue in status line
  
* 4 enhancements

  * added help command. shows available commands and explanation
  * broke list -v into its own command called info
  * update command can now take a list of configs to update, leave blank to update all
  * modified bash aliases to attach an already running screen config instead of starting a new one
  * tests!

1.0.1 / 2010-10-29
------------------

* 2 enhancements

  * Screeninator now does a better job of cleaning up after itself, removing screen configs when you delete projects
  * re-factored some code into a helper making the CLI code much better to look at


0.1.2 / 2010-10-12
------------------

* 1 minor enhancements

  * add copy method.  allow users to copy an existing config into a new config.

0.1.1 / 2010-09-28
------------------

* 1 bugfix

  * allow opening VIM on Fedora / Linux

* 1 minor enhancements

  * allow users to define their own default config