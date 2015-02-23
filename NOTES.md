# Installing Rails

A great resource for installing Rails is the [RailsApp Install Ruby on Rails - Ubuntu Linux](https://railsapps.github.io/installrubyonrails-ubuntu.html).

# Gemsets

A gemset is basically a container that is used to keep gems seperate from each other. A professional Rails developer uses *per-project* gemsets. Every time we are working with Rails (and we are using RVM), we are "inside" a gemset. If we run a command that starts with 'gem', the code that is executed is for that gemset only. There is a blog - [Using RVM to Keep Things Simple](http://keepthingssimple.tumblr.com/post/11274588229/using-rvm-to-keep-things-simple) - that explains the concepts of gemsets in RVM. 

One important piece of the puzzle to remember is that gems installed in the 'global' gemset are available to *all gemsets*. We want to install gems that are common to all our projects in this gemset. A perfect example is the "Nokogiri" gem. Nokogiri takes a long time to install, so we should strive to install it only once. To do that, we need to switch to the global gemset with 'rvm gemset use global'. Then, we can install Nikogiri inside this gemset. *Before* doing so, please take a look at the Faster Gem Installation notes. Then, we can use 'gem install nokogiri' to make Nokogiri available within all our gemsets. Note that, even though most applications will need the rails gemset, developers like to keep the global gemset sparse, and usually install rails in project-specific gemsets. 

Once you create a gemset, install the correct version of the gems in that gemset. Then, whenever you are in a project directory, make sure you are using the correct gemset. 

## Faster Gem Installation

Make sure to add the following code to the '~/.gemrc' file: 'gem: --no-document'. This will prevent gems from installing documentation files, which slow down the installation process very much. 

## New Rails Project 

We can use the following workflow for creating a new Rails project:

> mkdir app_name

> cd app_name

> rvm use ruby-2.2.0@app_name --ruby-version --create

> gem install rails

> rails new.

What we are doing here is creating a project-specific gemset called 'app_name'. The third line in our blockquote is doing several things. First, 'rvm use' is telling RVM to switch to this gemset. The 'ruby-2.2.0@app_name' is telling RVM not only the name of the gemset, but also the ruby version that should be installed in that gemset. Finally, the '--ruby-version' creates two files: '.ruby-version' and '.ruby-gemset'. These files will make it so that, whenever you enter into the directory, rvm will use the correct version of ruby and the correct gemset. Using *this* workflow means that you can forget about having to switch to the correct gemset.

## Logs 

When a browser sends requests to a WEBrick web server, diagnostic messages ae written to the console *and* 'log/development.log'.

### When to Stop WEBrick 

In general, it is only necessary to reload the web server when we make changes to the 'Gemfile' or to configuration files. If I have made changes to the Gemfile, then I need to run 'bundle install' before restarting the web server. 

# Rails is Opinionated #

Rails is opinionated software. What this means is that decisions have been made as to how things should be done. Going another route is not only difficult, but also actively discouraged. Because of this, in order for our code to work correctly, we need to *park it in the right place*. Otherwise, Rails will not know where to find it or how to use it properly. 

## Directory Structure ##

Most of our work will be spent in the 'app/' directory. The app directory contains: 

1. 'assets/' - A directory for images, javascript, and stylesheets.
2. 'controllers/' - A directory for our controllers.
3. 'helpers/' - A directory for rails views helpers. This directory will contain reusable code (such as headers and footers) that generate HTML. 
4. 'mailers/' - A directory for code that sends e-mail messages.
5. 'models/' - A directory to hold our models.
6. 'views/' - A directory to hold code that generates HTML pages. 


# Git #

It is important to configure git properly when using Rails. To configure git, run the following:

> git config --global user.name "Real Name"

> git config --global user.email "real@email.com"

After creating a repository on github.com - making sure not to initialize it through the web interface - directions for initializing a repo from an existing directory will be available. 
