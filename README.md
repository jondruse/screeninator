Screeninator
============

Create an manage screen sessions easily. Inspired by Arthur Chiu's ([Terminitor](http://github.com/achiu/terminitor))

Installation
------------

    $ gem install screeninator
  
Then follow the instructions.  You just have to drop a line in your ~/.bashrc file, similar to RVM if you've used that before:

    if [[ -s $HOME/.screeninator/scripts/screeninator ]] ; then source $HOME/.screeninator/scripts/screeninator ; fi

This will load the alias commands into bash.

Usage
-----
  
### Create a project ###
  
    $ screeninator open project_name
  
This will open your default editor (set through the $EDITOR variable in BASH) and present you with the default config:

    # ~/.screeninator/project_name.yml
    # you can make as many tabs as you wish...

    escape: ``
    project_name: Screeninator
    project_root: ~/code/rails_project
    tabs:
      - shell: git pull
      - database: rails db
      - console: rails c
      - logs: 
        - cd logs
        - tail -f development.log
      - ssh: ssh me@myhost
  

If a tab contains multiple commands, they will be 'joined' together with '&&'.


Starting a project
------------------

    $ start_project_name
  
This will fire up screen with all the tabs you configured.

### Limitations ###

After you create a project, you will have to open a new shell window. This is because Screeninator adds an alias to bash to open screen with the project config.


Example
-------

![Sample](http://img.skitch.com/20100922-b6yny5qxuh159asdekh3mx9quk.png)


Other Commands
--------------

    $ screeninator list
  
List all the projects you have configured

    $ screeninator delete project_name
  
Remove a project

    $ screeninator implode
  
Remove all screeninator configs, aliases and scripts.


Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 Jon Druse. See LICENSE for details.
