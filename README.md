Screeninator
============

Create an manage screen sessions easily. Inspired by Arthur Chiu's ([Terminitor](http://github.com/achiu/terminitor))

Installation
------------

    $ gem install screeninator
  
Then follow the instructions.  You just have to drop a line in your ~/.bashrc file, similar to RVM if you've used that before:

    if [[ -s $HOME/.screeninator/scripts/screeninator ]] ; then source $HOME/.screeninator/scripts/screeninator ; fi

Editor
------

Screeninator uses your shell's default editor for opening files.  If you're not sure what that is type:
  
    $ echo $EDITOR
    
For me that produces "mate -w"  
If you want to change your default editor simple put a line in ~/.bashrc that changes it. Mine looks like this:

    export EDITOR='mate -w'

Usage
-----
  
### Create a project ###
  
    $ screeninator open project_name
  
Create or edit your projects with this command. Your default editor ($EDITOR) is used to open the file. If this is a new project you will see this default config:

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

If you want to have your own default config, place it into $HOME/.screeninator/default.yml


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

    $ screeninator copy existing_project new_project

Copy an existing project.


    $ screeninator update_scripts

Re-create the screen scripts and aliases from the configs. Use this only if you edit your project configs outside of screeninator, i.e. not using "screeninator open xxx".


    $ screeninator list
  
List all the projects you have configured

    $ screeninator delete project_name
  
Remove a project

    $ screeninator implode
  
Remove all screeninator configs, aliases and scripts.


Questions? Comments? Feature Request?
-------------------------------------

I would love to hear your feedback on this project!  Send me a message!

For realtime feedback check out the #screeninator channel on irc.freenode.com


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
