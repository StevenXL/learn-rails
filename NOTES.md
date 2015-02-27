# Installing Rails

A great resource for installing Rails is the [RailsApp Install Ruby on Rails - Ubuntu Linux](https://railsapps.github.io/installrubyonrails-ubuntu.html).

# Gemsets

A gemset is basically a container that is used to keep gems seperate from each other. A professional Rails developer uses *per-project* gemsets. Every time we are working with Rails (and we are using RVM), we are "inside" a gemset. If we run a command that starts with 'gem', the code that is executed is for that gemset only. There is a blog - [Using RVM to Keep Things Simple](http://keepthingssimple.tumblr.com/post/11274588229/using-rvm-to-keep-things-simple) - that explains the concepts of gemsets in RVM. 

One important piece of the puzzle to remember is that gems installed in the 'global' gemset are available to *all gemsets*. We want to install gems that are common to all our projects in this gemset. A perfect example is the "Nokogiri" gem. Nokogiri takes a long time to install, so we should strive to install it only once. To do that, we need to switch to the global gemset with 'rvm gemset use global'. Then, we can install Nikogiri inside this gemset. *Before* doing so, please take a look at the Faster Gem Installation notes. Then, we can use 'gem install nokogiri' to make Nokogiri available within all our gemsets. Note that, even though most applications will need the rails gemset, developers like to keep the global gemset sparse, and usually install rails in project-specific gemsets. 

Once you create a gemset, install the correct version of the gems in that gemset. Then, whenever you are in a project directory, make sure you are using the correct gemset. 

Each time I update the Gemset file, I have to run `bundle install` for bundle to install the gems properly. 

## Faster Gem Installation

Make sure to add the following code to the `~/.gemrc` file: `gem: --no-document`. This will prevent gems from installing documentation files, which slow down the installation process very much. 

## New Rails Project 

We can use the following workflow for creating a new Rails project:

> mkdir app_name

> cd app_name

> rvm use ruby-2.2.0@app_name --ruby-version --create

> gem install rails

> rails new.

What we are doing here is creating a project-specific gemset called `app_name`. The third line in our blockquote is doing several things. First, `rvm use` is telling RVM to switch to this gemset. The `ruby-2.2.0@app_name` is telling RVM not only the name of the gemset, but also the ruby version that should be installed in that gemset. Finally, the `--ruby-version` creates two files: `.ruby-version` and `.ruby-gemset`. These files will make it so that, whenever you enter into the directory, rvm will use the correct version of ruby and the correct gemset. Using *this* workflow means that you can forget about having to switch to the correct gemset.

## Logs 

When a browser sends requests to a WEBrick web server, diagnostic messages ae written to the console *and* `log/development.log`.

### When to Stop WEBrick 

In general, it is only necessary to reload the web server when we make changes to the `Gemfile` or to configuration files. If I have made changes to the Gemfile, then I need to run `bundle install` before restarting the web server. 

# Rails is Opinionated #

Rails is opinionated software. What this means is that decisions have been made as to how things should be done. Going another route is not only difficult, but also actively discouraged. Because of this, in order for our code to work correctly, we need to *park it in the right place*. Otherwise, Rails will not know where to find it or how to use it properly. 

## Directory Structure ##

Most of our work will be spent in the `app/` directory. The app directory contains: 

1. `assets/` - A directory for images, javascript, and stylesheets.
2. `controllers/` - A directory for our controllers.
3. `helpers/` - A directory for rails views helpers. This directory will contain reusable code (such as headers and footers) that generate HTML. 
4. `mailers/` - A directory for code that sends e-mail messages.
5. `models/` - A directory to hold our models.
6. `views/` - A directory to hold code that generates HTML pages. 

# Git #

It is important to configure git properly when using Rails. To configure git, run the following:

> git config --global user.name "Real Name"

> git config --global user.email "real@email.com"

After creating a repository on github.com - making sure not to initialize it through the web interface - directions for initializing a repo from an existing directory will be available. 

## RVM, Gemfile, and bundle ##

Here is how it all works together. RVM allows us to create a space for our gems to be installed in via gemsets. The Gemfile lists the gems we want to use. Bundler, through `bundle install`, reads the Gemfile and proceeds to install the gems into the gemset, managing dependencies for I in the process. Finally, the Gemfile.lock contains version numbers and dependencies for the gems in our Gemfile.

## Configuration Security ##

Rails provides the file `config/secrets.yml` for configuration settings. It is *bad* practice to put any actual secrets in this file. If I decide to go against this advice, and put actual passwords and other sensitive data in this file, I have to make sure that it is part of my `.gitignore` so that it will not be uploaded to Github, where others can view it. While some developers like to add the `secrets.yml` file to their .gitignore list anyway, if I have not put any secrets in it, there is no point in doing so. Furthermore, Heroku needs this file - it is easier to simply use enivornmental variables to hold the actual secret.

Configuration settings that must remain private are best placed is *environmental variables*. The way that this works is that, generally, we will use code such as `export GMAIL_USERNAME="username"` in a file such as our `.bash` or `.bash_rc` file, and then point `config/secrets.yml` to those environmental variables. (Look on Google how to do this). Furthermore, it is a good idea to use quotes to surround configuration values (credentials) in the `.bashrc` or `.bash_profile` files. If the value itself contains punctuation characters, then they need to be surrounded by single quotes as well, such as `"'%$@$24'"`. Another tip - make sure that you set the permissions for whatever file contains the sensitive data correctly. For example, in my `.bashrc` file, I have the permissions set to 600 - this allows me to read and write to the file, but not execute. The group owner or other users cannot do anything with this file!  It is important to note that Rails will replace `ENV["VAR_NAME"]` by looking up the variable in the environment. This code can be used anywhere in Rails.

## Connect to an Email Server ##

In production, for high-volume transactional e-mail and improved deliverabiity, it is best to use a service such as Mandrill or Mailgun to send e-mail. We need to configure rails to use these services, and we do that in the `config/environments/development.rb` file.

Notice the code that we are using to to set feed values into this file that will serve as settings. For example, `user_name: Rails.application.secrets.email_provider_username` clearly points to the `config/secrets.yml` file. The secrets.yml file is reading from our system environmental variables. Those variables are then available to the rest of the system using dot notation as *configuration variables*.

# Static Pages and Routing #

The **convention** in rails is to store static pages in the `public/` folder. If we place a file called `index.html` in this directory, and do no further configuration / routing, Rails is smart enough to serve up that page. The Rails router, which we will talk about in more depth later in the tutorial, is responsible for figuring out which controller and action combo to use. The router bases the action it takes on the HTTP verb and the URL. 

If we request the URL `localhost:3000/about`, Rails will automatically try to retrieve the `about.html` page in our public folder. Rails will serve the correct page with `localhost:3000/about.html` as well!

## Introducing Routes ##

Rails provides a configuration file to control web request routing in `config/routes.rb`. In this file, we can control what action Rails takes based on the URL that the browser is attempting to access.

For example, if we edit delete our `public/index.html` file and edit the routes.rb file, we can set the the root of the application to go to about.html:

**routes.rb**
`root to: redirect("/about")`

What I just witnessed was a bit of Rails magic, and the following paragraph from the tutorial is important enough that it deserves to be quoted verbatim:

> Some developers complain that the "convention over configuration" principle is **black magic**.
> It is **not** obvious why pages are delivered from teh `public` folder; it just happens.
> If you do not know the convention, you could be left scratching your head and looking for the code that maps http://localhost:3000/ to the `public/index.html` file.
> The code is buried deep in the rails framework.
> **However, if you know the convention and the technique for overriding it, you have both convenience and power at your disposal. **

## The Request Response Cycle ##

The web is nothing more than a web browser *requesting* files from a web server. If the HTML file contains the appropriate code, the web browser will also request CSS, JavaScript, and image files. Nowadays, some web pages including streaming music and video, which require an open "pipe" between the web browser and the web server. However, even in those cases, the setup for the stream is done via a simple response-request cycle. 

We can reduce the complexity of the web to this request-response cycle. The developer tools that are available in most browsers allow us to see the actual information passing between the web browser and web server.  


## Document Object Model ##

Modern browsers load files asynchronously. This means that, no matter where the files appear within the HTML, the browser will try to download all files before rendering the page. Once all files are downloaded and the browser renders the page, it fires a `DOM ready` even. The DOM is an API that provides a structural representation of the HTML document. This allows me to modify the document with a scripting language such as JavaScript. 

## The Model-View-Controller Design Pattern ##

The MVC is a central organizing principle of Rails. When a web requests comes into my Rails application, the router is responsible for routing that request to a controller. (The router does this by analyzing the HTTP method and URL of the request). The controller executes code based on the action that was passed down from the router. This code takes care of reaching out to the Model (which contains our database) if it has to in order to collect the appropriate data. The View provides the structure and layout. The controller then combines the layout from the View with the data from the Model to create a web page. This *dynamically created web page* is then passed to the browser.

Rails applications can, and often do, have multiple controllers, models, and views. A Rails developer has to create the code that will combine each of these components correctly. However, each of the components inherets methods from superclasses defined in Rails. This means there is less code for the developer to write. 

### The Model ###

In most cases, the model retrieves data from a database. However, it is also possible for the model to retrieve data from a remote resource such as Twitter or Facebook.

### The Controller ###

A controller can, and often does, have more than one action. Each action corresponds to a method defined in that controller file. In practice, Rails developers **try to limit themselves** to seven standard actions in their controllers:

1. index
2. show
3. new
4. create
5. edit
6. update
7. destroy

A controller that implements these seven actions is said to be *RESTful*. 

### The View ###

A view file combines Ruby code (the default is embedded Ruby) with HTML markup. It is good practice to limit **Ruby code** in view files to only displaying data. Anything else belongs in the controller. Because one controller typically has several views, Rails typically uses an entirely new folder for each controller. 

## The Name Game ##

Much of the art of programming lies in choosing suitable names for our creation. It is important because it makes the logic easier to follow. From this flows a host of benefits: the code is easier to mantain, easier to pass down to others, logical errors are easier to catch, and refraction is also easier as a result. 

## Naming Conventions ##

Rails is picky about class name and file names. This is because of the "convention over configuration" principle. By *forcing* developers to use certain naming patterns, Rails is able to avoid complex configuration. In Rails, it is important to observe the following conventions:

1. `class Visitor` - The name is capitalized and singular
2. `VisitorsController < ApplicationController` - models are in capitalized Camel Case
3. `the_file_name` - files are lowercase, snake case

The controller file name follows the controller class name, but in snake_case: `app/controllers/visitors_controller.rb`

The model file name follows the model class name, but lower case: `app/models/visitor.rb`

The view folder matches the model class name, but plural and lowercase: `app/views/visitors`

## Creating a New Application ##

Because they are detailed, the errors we encounter when building a Rails application can help us build it. We start with modifying the router, and then attempting to request the new route. The errors that pop up will ensure that we have the minimum code necessary to make our application work. 

# Troubleshooting #

The following are a few resources for troubleshooting Rails applications. 

## Interactive Ruby ##

To run snippets of Ruby code, we can use Interactive Ruby by typing `irb` at the command line. IRB will let me execute Ruby code and receive a response in real time, making it perfect for use as an experimentation tool, or simply for checking the logic and syntax of small snippets of code.   

IRB can handle multiple lines of code; it uses the keyword `end` to determine when it should start executing the code. 

Also, it is important to remember that we can load code into IRB from a file using `load 'path/to/file.rb'`. 

**Quitting* IRB is done with ctrl+d or typing `exit` at the command prompt. 

## Rails console ##

IRB does not know Rails - it only knows Ruby. The Rails console, which we can get to by typing `rails console` in our Rails application root directory, is a tool like IRB, but with "knowledge" of Ruby. In fact, Rails console loads my entire Ruby application - it has access not only to pre-defined Rails methods, but also to objects, methods, models, and logic that I created as part of coding my Rails project.

## Rails Logger ##

The Rails application has a server log file located at `log/development.log` or `log/production.log`, depending on what environment it is running in. In our controller, we can define messages that are logged to our server log file. This is helpful (kind of like printf debugging in C, for example). The code to so would look like:

> Rails.logger.debug "DEBUG: Owner name is #{@owner.name}"

I can add logging messages to models, controllers, and views (via erb). 

Messages added via `logger.debug` will show up in development, but not in production - hence the debug name. However, messages that use other logger methods will show up in production. These include:

1. `logger.info`
2. `logger.warn`
3. `logger.error`
4. `logger.fatal`

I can add color to my messages, but that topic is best explored at a later time. 

The Rails logger is useful for displaying **program flow** or variable values. 

## The Stack Trace ##

The stack trace is displayed by our Rails application when something goes wrong. The stack trace will show everything that happened up to the point where Rails encountered the error. (Note, while Rails has a default stack trace, the `better_errors` gem is installed in our application to modify the default behavior). 

### Raising an Exception ###

Instead of adding variables that Rails does not understand in order to "throw an error", we can "raise" an exception through code such as: `raise "Error message"`. Rails and Ruby provide a set of methods to raise and handle exceptions. Rails exception handlers can also be modified so that they display useful information to the viewer.  

## A Little Bit of Ruby ##

### Symbols ###

Symbols are used very frequently in Ruby. Symbols are special in Ruby - they are immutable, meaning that they cannot be changed. Because symbols are immutable, they are **not** variables. We cannot use them on the "left side" of an assignemtn. The code `:symbol = "Steven"` would throw an error. However, we *can* do `steven = :symbol`.

## Attributes ##

Data that is inside an object cannot be accessed, unless we expose the data as an **attribute / property**.

In Ruby, we use the accessor methods to expose data as attributes: `attr_accessor :name` means that @name can now be set from outside the object and it can be retrieved from outside the object. 

What happens when we use the accessor methods? There is a great explanation on [Stackoverflow](http://stackoverflow.com/questions/4370960/what-is-attr-accessor-in-ruby). Basically, when we write `attr_accessor :name` Ruby writes the following code:

> def name
>   @name
> end

as well as:

> def name=(str)
>   @name = str
> end

The first block of code exposes @name through the method `Object#name`. The second block of code allows the instance variable @name to be set from the outside through the method `Object#name=`. Notice that `name` and `name=` are two different methods. That is the shortcut of the accessor methods. If we want to use only one of those blocks and not both, we can use attr_reader and attr_writer, respectively.  


### Instance Variables ###

Inside an object, ordinary variables only "exist" in the method in which they appear. This is called the scope of the variable. If two methods use the same variable name, the two variables are distinct one from the other. They are not linked. However, the scope of instance variables is the entire instance of that object. That means that that particular variable exists for all the methods in that object. Instance variables are denotated by a leading "@". Specifically, **in Rails** we use an instance variable in the controller when we want that variable to be available to the *view*.  

### "||=" ###

The set of symbols above are called the *conditional operator*. I will take the example: `@honorific ||= "Esteemed"`. The assignment will only execute if @honorific is not alreayd assigned. Conditional assignment is often used to assign a default value in the absence of an explicit assignment.  

## Ruby Golf ##
[Ruby Golf](http://www.sitepoint.com/ruby-golf/) is the sport (art?) of writing Ruby code with as few characters as possible. 

## Access Control ##

Sometimes, we define helper methods within a class to be used by other methods in that same class. If I do not want others to be able to access these methods from outside the class, then we need to add the method after the keyword `private`. If we do this, then the method that are defined after the word private are not accessible by other methods in the class, or by methods in a sub-class. 

For example:

> private
> def class_name
> end

In the example above, I would not be able to call the class_name method by running `Object#class_name`. It could only be called by another method within the class. 

*Note: Ruby provides protected methods as well. The difference between protected and private are subtle. Protected are not seen often in Rails.*
