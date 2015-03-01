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

# Rails is Opinionated

Rails is opinionated software. What this means is that decisions have been made as to how things should be done. Going another route is not only difficult, but also actively discouraged. Because of this, in order for our code to work correctly, we need to *park it in the right place*. Otherwise, Rails will not know where to find it or how to use it properly. 

## Directory Structure

Most of our work will be spent in the `app/` directory. The app directory contains: 

1. `assets/` - A directory for images, javascript, and stylesheets.
2. `controllers/` - A directory for our controllers.
3. `helpers/` - A directory for rails views helpers. This directory will contain reusable code (such as headers and footers) that generate HTML. 
4. `mailers/` - A directory for code that sends e-mail messages.
5. `models/` - A directory to hold our models.
6. `views/` - A directory to hold code that generates HTML pages. 

# Git

It is important to configure git properly when using Rails. To configure git, run the following:

> git config --global user.name "Real Name"

> git config --global user.email "real@email.com"

After creating a repository on github.com - making sure not to initialize it through the web interface - directions for initializing a repo from an existing directory will be available. 

## RVM, Gemfile, and bundle

Here is how it all works together. RVM allows us to create a space for our gems to be installed in via gemsets. The Gemfile lists the gems we want to use. Bundler, through `bundle install`, reads the Gemfile and proceeds to install the gems into the gemset, managing dependencies for I in the process. Finally, the Gemfile.lock contains version numbers and dependencies for the gems in our Gemfile.

## Configuration Security

Rails provides the file `config/secrets.yml` for configuration settings. It is *bad* practice to put any actual secrets in this file. If I decide to go against this advice, and put actual passwords and other sensitive data in this file, I have to make sure that it is part of my `.gitignore` so that it will not be uploaded to Github, where others can view it. While some developers like to add the `secrets.yml` file to their .gitignore list anyway, if I have not put any secrets in it, there is no point in doing so. Furthermore, Heroku needs this file - it is easier to simply use enivornmental variables to hold the actual secret.

Configuration settings that must remain private are best placed is *environmental variables*. The way that this works is that, generally, we will use code such as `export GMAIL_USERNAME="username"` in a file such as our `.bash` or `.bash_rc` file, and then point `config/secrets.yml` to those environmental variables. (Look on Google how to do this). Furthermore, it is a good idea to use quotes to surround configuration values (credentials) in the `.bashrc` or `.bash_profile` files. If the value itself contains punctuation characters, then they need to be surrounded by single quotes as well, such as `"'%$@$24'"`. Another tip - make sure that you set the permissions for whatever file contains the sensitive data correctly. For example, in my `.bashrc` file, I have the permissions set to 600 - this allows me to read and write to the file, but not execute. The group owner or other users cannot do anything with this file!  It is important to note that Rails will replace `ENV["VAR_NAME"]` by looking up the variable in the environment. This code can be used anywhere in Rails.

## Connect to an Email Server

In production, for high-volume transactional e-mail and improved deliverabiity, it is best to use a service such as Mandrill or Mailgun to send e-mail. We need to configure rails to use these services, and we do that in the `config/environments/development.rb` file.

Notice the code that we are using to to set feed values into this file that will serve as settings. For example, `user_name: Rails.application.secrets.email_provider_username` clearly points to the `config/secrets.yml` file. The secrets.yml file is reading from our system environmental variables. Those variables are then available to the rest of the system using dot notation as *configuration variables*.

# Static Pages and Routing

The **convention** in rails is to store static pages in the `public/` folder. If we place a file called `index.html` in this directory, and do no further configuration / routing, Rails is smart enough to serve up that page. The Rails router, which we will talk about in more depth later in the tutorial, is responsible for figuring out which controller and action combo to use. The router bases the action it takes on the HTTP verb and the URL. 

If we request the URL `localhost:3000/about`, Rails will automatically try to retrieve the `about.html` page in our public folder. Rails will serve the correct page with `localhost:3000/about.html` as well!

## Introducing Routes

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

## The Request Response Cycle

The web is nothing more than a web browser *requesting* files from a web server. If the HTML file contains the appropriate code, the web browser will also request CSS, JavaScript, and image files. Nowadays, some web pages including streaming music and video, which require an open "pipe" between the web browser and the web server. However, even in those cases, the setup for the stream is done via a simple response-request cycle. 

We can reduce the complexity of the web to this request-response cycle. The developer tools that are available in most browsers allow us to see the actual information passing between the web browser and web server.  


## Document Object Model

Modern browsers load files asynchronously. This means that, no matter where the files appear within the HTML, the browser will try to download all files before rendering the page. Once all files are downloaded and the browser renders the page, it fires a `DOM ready` even. The DOM is an API that provides a structural representation of the HTML document. This allows me to modify the document with a scripting language such as JavaScript. 

## The Model-View-Controller Design Pattern

The MVC is a central organizing principle of Rails. When a web requests comes into my Rails application, the router is responsible for routing that request to a controller. (The router does this by analyzing the HTTP method and URL of the request). The controller executes code based on the action that was passed down from the router. This code takes care of reaching out to the Model (which contains our database) if it has to in order to collect the appropriate data. The View provides the structure and layout. The controller then combines the layout from the View with the data from the Model to create a web page. This *dynamically created web page* is then passed to the browser.

Rails applications can, and often do, have multiple controllers, models, and views. A Rails developer has to create the code that will combine each of these components correctly. However, each of the components inherets methods from superclasses defined in Rails. This means there is less code for the developer to write. 

### The Model

In most cases, the model retrieves data from a database. However, it is also possible for the model to retrieve data from a remote resource such as Twitter or Facebook.

### The Controller

A controller can, and often does, have more than one action. Each action corresponds to a method defined in that controller file. In practice, Rails developers **try to limit themselves** to seven standard actions in their controllers:

1. index
2. show
3. new
4. create
5. edit
6. update
7. destroy

A controller that implements these seven actions is said to be *RESTful*. 

### The View

A view file combines Ruby code (the default is embedded Ruby) with HTML markup. It is good practice to limit **Ruby code** in view files to only displaying data. Anything else belongs in the controller. Because one controller typically has several views, Rails typically uses an entirely new folder for each controller. 

## The Name Game

Much of the art of programming lies in choosing suitable names for our creation. It is important because it makes the logic easier to follow. From this flows a host of benefits: the code is easier to mantain, easier to pass down to others, logical errors are easier to catch, and refraction is also easier as a result. 

## Naming Conventions

Rails is picky about class name and file names. This is because of the "convention over configuration" principle. By *forcing* developers to use certain naming patterns, Rails is able to avoid complex configuration. In Rails, it is important to observe the following conventions:

1. `class Visitor` - The name is capitalized and singular
2. `VisitorsController < ApplicationController` - models are in capitalized Camel Case
3. `the_file_name` - files are lowercase, snake case

The controller file name follows the controller class name, but in snake_case: `app/controllers/visitors_controller.rb`

The model file name follows the model class name, but lower case: `app/models/visitor.rb`

The view folder matches the model class name, but plural and lowercase: `app/views/visitors`

## Creating a New Application

Because they are detailed, the errors we encounter when building a Rails application can help us build it. We start with modifying the router, and then attempting to request the new route. The errors that pop up will ensure that we have the minimum code necessary to make our application work. 

# Troubleshooting

The following are a few resources for troubleshooting Rails applications. 

## Interactive Ruby

To run snippets of Ruby code, we can use Interactive Ruby by typing `irb` at the command line. IRB will let me execute Ruby code and receive a response in real time, making it perfect for use as an experimentation tool, or simply for checking the logic and syntax of small snippets of code.   

IRB can handle multiple lines of code; it uses the keyword `end` to determine when it should start executing the code. 

Also, it is important to remember that we can load code into IRB from a file using `load 'path/to/file.rb'`. 

**Quitting* IRB is done with ctrl+d or typing `exit` at the command prompt. 

## Rails console

IRB does not know Rails - it only knows Ruby. The Rails console, which we can get to by typing `rails console` in our Rails application root directory, is a tool like IRB, but with "knowledge" of Ruby. In fact, Rails console loads my entire Ruby application - it has access not only to pre-defined Rails methods, but also to objects, methods, models, and logic that I created as part of coding my Rails project.

## Rails Logger

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

## The Stack Trace

The stack trace is displayed by our Rails application when something goes wrong. The stack trace will show everything that happened up to the point where Rails encountered the error. (Note, while Rails has a default stack trace, the `better_errors` gem is installed in our application to modify the default behavior). 

### Raising an Exception

Instead of adding variables that Rails does not understand in order to "throw an error", we can "raise" an exception through code such as: `raise "Error message"`. Rails and Ruby provide a set of methods to raise and handle exceptions. Rails exception handlers can also be modified so that they display useful information to the viewer.  

## A Little Bit of Ruby

### Symbols

Symbols are used very frequently in Ruby. Symbols are special in Ruby - they are immutable, meaning that they cannot be changed. Because symbols are immutable, they are **not** variables. We cannot use them on the "left side" of an assignemtn. The code `:symbol = "Steven"` would throw an error. However, we *can* do `steven = :symbol`.

## Attributes

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


### Instance Variables

Inside an object, ordinary variables only "exist" in the method in which they appear. This is called the scope of the variable. If two methods use the same variable name, the two variables are distinct one from the other. They are not linked. However, the scope of instance variables is the entire instance of that object. That means that that particular variable exists for all the methods in that object. Instance variables are denotated by a leading "@". Specifically, **in Rails** we use an instance variable in the controller when we want that variable to be available to the *view*.  

### "||="

The set of symbols above are called the *conditional operator*. I will take the example: `@honorific ||= "Esteemed"`. The assignment will only execute if @honorific is not alreayd assigned. Conditional assignment is often used to assign a default value in the absence of an explicit assignment.  

## Ruby Golf
[Ruby Golf](http://www.sitepoint.com/ruby-golf/) is the sport (art?) of writing Ruby code with as few characters as possible. 

## Access Control

Sometimes, we define helper methods within a class to be used by other methods in that same class. If I do not want others to be able to access these methods from outside the class, then we need to add the method after the keyword `private`. If we do this, then the method that are defined after the word private are not accessible by other methods in the class, or by methods in a sub-class. 

For example:

> private
> def class_name
> end

In the example above, I would not be able to call the class_name method by running `Object#class_name`. It could only be called by another method within the class. 

*Note: Ruby provides protected methods as well. The difference between protected and private are subtle. Protected are not seen often in Rails.*


# The Application Layout File

The application layout files lives in `app/views/layouts` folder. Static pages delivered from the `public/` folder do not use the `application.html.erb` file, but pages delivered from the `app/views` folder do.

We can change the default behavior of Rails, in terms of which / how it combines views with layouts. Remember, implicit in the controller is the following line of code `render "visitors/new"`. The render method is used as the last line of a controller method to render the view. We can pass arguments to the render method to modify the behavior. For example, if we do not want the view to include the application layout, we can include `render "visitors/new", :layout => false`. What we are doing here is simply calling the render method with two arguments instead of one. The second argument is a hash. The render method will check if the value of the symbol :layout is false. If it is, then it will not add the application layout to the rendered page. 

We can also create a new layout in our layouts folder, and pass a relative path (relative to the `app/views/layouts` folder) as a second argument to the render method:

> render "visitors/new", :layout => 'special'

The above would look for our layout in `app/views/layouts/special.html.new`.

## How Does the Layout File Work? 

Taking a look at the contents of `application.html.erb`, I can see the following line of code: `<%= yield %>`. The view is inserted in the place of this code. Professional Rails developers use the yield functionality to add distinct regions (sidebars, footers) that contain their own blocks of code. The [RailsGuides: Layouts and Rendering in Rails](http://guides.rubyonrails.org/layouts_and_rendering.html) has more information on how to perform these functions.

*Note to self: yield is a keyword in Ruby that passes program execution flow to the block. This piece of code, and its behavior, leads me to believe that the view file is passed in as a block.*

## View Helpers

A Rails *view helper* can be thought of as *macros* that expand into longer strings of HTML tags and content. In Rails, for example, the view helper `<%= csrf_meta_tags %>` expands into:

> <meta content="authenticity_token" name="csrf-param" />
> <meta content="kanfionLKnPOJiNnFPw=" name="csrf-token" />

This cryptic code is a security feature in Rails that helps prevent cross-site request forgery. 

## The Rails Layout Gem

We are going to be using the rails_layout gem to add some basic layouts to our application. The gem uses the Rails generate command to run a script - creating, deleting, and updating files. The command to use is: `rails generate layout:install --force`. The `--force` flag will force the deletion of `app/views/layouts/application.html.erb`. 

Professional web developers normally have a boilerplate file that they use to create static web pages. They use this file to avoid re-writing the same "scaffold" code to each web page they create. The well-known [HTML5 Boilerplate Project](https://html5boilerplate.com/) provides best practices for websites. Rails already incorporates most of that project. If we are interested in the relevant suggestions from that project, there is a [RailsApps article](https://railsapps.github.io/rails-html5-boilerplate.html/) discussing what Rails developers need to know. 

## A Good Boilerplate 

It is a good idea to have the following in an HTML5 web page:

1. **The Viewport Metatag** - this metatag improves the presentation of web pages on mobile devices. 
2. **A Title Tag** - Google will often use the title value of a website on its search engine.
3. **Description Metatag** - Again, Google might use this as a snippet on a result page. 

# Rails Asset Pipeline

When building a website by hand, web masters include JavaScript in a web page using the <script> tag in the <head> section of the HTML document. For CSS files, web masters would use the <link> tag. They would have to create a new tag for each file they wanted to include. 

The **Asset Pipeline** consists of two folders: `app/assets/javascript` and `app/assets/stylesheets`. The files added to these two folders are automatically included in every web page, as two files: one for JavaScript and one for CSS. By combining the files, Rails eliminates the overhead of request multiple files form the server.

# Introducing Partials

Partials are just like any view file, with the exception that their filename beings with a leading underscore. Like a view file, partils consist of HTML mixed with ERB. The partial **has to be placed in a views** folder. Once that is done, we can use the render function to include partials in our view files. The code within the view file would look like this: `<%= render "layouts/footer" %>`. Notice that the argument to the render function *does not* include the leading underscore in the path. Rails knows that footer refers to a file named _footer.html.erb. Furthermore, the argument to render is a *relative path* - i.e., relative to the `app/views` folder. 

## Link Helpers

Rails *link_to* helper is the preferred method of adding HTML links to our web pages. While there is nothing stopping us from using raw HTML, by using the link_to helper, Rails will update our links autmoatically as long as we correctly configure our router. In other words, I will not have to worry about link maintenance. 

The *link_to* helper takes two arguments - the first argument is the text that we want to display. The second parameter is the route, as configured in our routes.rb file. For example: `<%= link_to 'Home', root_path %>`

Partials can be nested. In other words, one partial can include another partial! 

## Introducing Flash

Rails has a standard way to display alerts to the user called *flash messages*. Flash messages are created in the controller. For example, in our `visitors_controller.rb` file, we can add the following to the `new` action:

> flash[:notice] = "Welcome!"
> flash[:alert] = "My birthday is soon"

Depending on which type of flash message we use (alert vs. notice), our CSS can style them differently. Rails provides other types of flash messages, but most Rails developers stick with these two. 

Note that the simple form `flash` has to be used when a user *is redirected*. The simple form persists through a redirect to the next page. However, if the user is *not* redirected (i.e., the render method is called implicitly), then we can use `flash.now[:symbol]` so that our flash message does not persist on to other pages. 

### How does the flash method work? 

The *flash* object is a hash. When we write `flash[:notice] = "Msg"`, what we are doing is adding the key / value pair of :notice / "Msg" to that hash. This object is made available to the next action that the controller takes. From the Ruby API documentation: 

> Anything you place in the flash will be exposed to the very next action and then cleared out.

In our messages partial, we have the following code:

> <% flash.each do |name, msg| %>
>  <% if msg.is_a?(String) %>
>    <%= content_tag :div, msg, :class => "flash_#{name}" %>
>  <% end %>
> <% end %>

I can tell right away that this is going to iterate through each key / value pair in the flash hash. Then, it is going to use the Rail content_tag to create the HTML. How does the content_tag work? Per the Rails API, the content_tag is a method that takes a name argument, a content argument, an options hash (and an escape argument):

> content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)

The *name* argument will be the tag we are creating. The *content* argument will be the content inside the tag. Finally, the *options hash* is going to be used to set HTML attributes. The code in our messages partils gives each message the class of "flash_#{name}", where name will be, in our case, either notice or alert. Notice that the *name* is passed in as a symbol. Also, notice that in our message partial, we **do not** use curly braces to enclose our options hash. In Ruby, if the options hash is the last argument in the method, we can avoid the curly braces.  

In conclusion, flash in Rails works as follows:

1. We create a flash hash in our controller. 
2. Our application.html.erb contains code to include our message partial: `<%= render 'layouts/messages' %>. 
3. Our messages partial contains code to iterate through the flash hash, and uses the content_tag method to create the HTML that will ultimately be sent to the browser. 

## HTML5 Elements 

### <header> 

The <header> tag is normally used to wrap navigation or branding.

### <main>

The <main> tag is used for content that is **unique** to that particular page. It would exclude header and footer content that is repeated across several pages. This division would hold our messages and yield content. 

### <footer>

The <footer> tag is normally used to wrap links to copyright information, legal disclaimers, or contact information. 

## The rails_layout gem 

The rails_layout gem has created all of the "scaffolding" above for me. I do not have to create it by hand, but it pays for a Rails developer to understand what is going on under the hood. The rails_layout gem added:

1. A viewport metatag, a title, and a description
2. Partials for navigation and flash messages
3. HTML5 structural elements such as <header> and <main>

# Front-end Frameworks

A website *front end* is all the code that runs in the browser - everything that controlls the appearance of the website. This includes page layout (HTML), CSS stylesheets, and JavaScript. 

## CSS Frameworks

There are dozens of CSS frameworks, but Zurb Foundations and Bootstrap are particularly popular. 

## JavaScript Libraries

Just as there are dozens of CSS frameworks, there are many JavaScript libraries. jQuery has become the most popular due to its modular plugins that implement a wide range of effects and widgets. jQuery is used to add visual effects and interactivity to a website. This includes drop-down menus, modal windows, tabbed panels, autocompletion search forms, and sliders / carousels for images.  jQuery is **included by default** in Rails. 

Another class of JavaScript frameworks exists as fully-featured web application frameworks. They allow developers to build applications that communicate with the server only to read and write data. These frameworks allow applications to function closer to a desktop application than a web page, and are termed as single-page applications. Examples include Ember.js, AngularJS, and Backbone.js. 

## Front-end Frameworks

Front-end Frameworks provide pre-built CSS and JavaScript. Bootstrap and Zurb Foundation are the most popular among Rails developers. 

*Bootstrap* has a larger developer community than *Zurb Foundation* - more third-party projects use it.

Without extensive customization, most Bootstrap or Zurb Foundation sites start to look the same. They look good, but it is difficult to differentiate a site. However, a whole industry has sprung up around selling themes for Wordpress, Tumblr, Droopla, or Joomla. Few sell themes for Rails, since it is difficult to customize a theme for a Rails application. One of those few is [RailsTheme](https://railsthemes.com/).

## Zurb Foundation

Zurb Foundation is packaged as a gem. As long as I included it in my Gemfile, it will be available. (The gem is called `foundation-rails`). The Zurb Foundation website provides [instructions](http://foundation.zurb.com/docs/applications.html) on how to install Zurb Foundation on a Rails app. It is very easy, but in this guide we will be using a different approach.

In this guide, I will be using the `rails_layout` gem. The reason why we use these instructions is because we will be loading the Foundation JavaScript files using the *asset pipeline*. This is a best practice. Furthermore, we will be using the jQuery to load Foundation only after a "DOM Ready" event; this ensures that Foundation remains compatible with other jQuery plug-ins. 

`rails generate layout:install foundation5 --force`

The above command will do the following: 

### Rename `application.css to `application.css.scss`

This will make the application.css.scss file run through the SCSS preprocessing engine. (Note, the [Sass Basics Screencast](http://railscasts.com/episodes/268-sass-basics) on RailsCast is a great introduction). The file itself serves two purposes. First, we can add any CSS that we want to use directly to this file. Note that this is bad practice, unless the CSS is extremely simple. It is better to seperate CSS files in order to provide better organization and structure. Secondly, the file serves as a *manifest*. It tells Rails what other stylesheets need to be combined and then sent to the browser. 

The first purposes is executed through this code within the file itself: `*=require_self`. The second purpose is executed through the code `*=require_tree .`. Notice that the dot notation will include the directory of the file itself as well as any subfolders. 

### Create `framework_and_overrides.css.scss`

This file is created in the same folder as `application.css.scss`, and therefore will be combined and sent to the browser as a single CSS file.

### Modify `application.js`

Within the `assets/javascript` folder, the generate command we ran above will modify the `application.js` file specifically for Zurb Foundation. This serves the same purpose in regards to JavaScript as the `application.css.scss` file does in regards to CSS.

### Modify `_messages.html.erb`

The generate command will also modify the messages partial so that it uses Zurb Foundation-specific classes and IDs. 

### Modify `_navigation.html.erb`

The purpose for modifying the navigation partial is the same as for modifying the messages partial. 

### Modify `application.html.erb`

Same as above. 

# Zurb Foundation 

Now that I have installed Zurb Foundation, let us figure out how to use it. First, remember that the CSS for Foundation is imported into our code through the `@import 'foundation'` line in our `framework_and_override.css.scss` file. The CSS that we see directly in this file are called Saas mixins, which I will explore in a later part of the tutorial.

Using Foundation is all about using the appopriate CSS classes and IDs. The Foundation CSS itself does all of the styling. The [Foundation documentation](http://foundation.zurb.com/docs/) provides access to what the entire framework can offer. 

# Foundation Grid System 

The Foundation grid system is fundamental to how Foundation works. By default, Foundation grids are 12 columns across. The reason that this framework is responsive is because the grid changes based on *breakpoints* in the device size. For example, a section that is 12 columns across in a "large" view format will collapse to 4 columns in a "small" view format. This change is implemented through changing the class attribute(s). 

We can set up a footer in our web page by using the <footer> tag. Furthermore, I can set this footer section to have two columns:

> <footer class="row">
>   <section class="small-4-columns"
>     Copyright 2014
>   </section>
>   <section class="small-8-columns"
>     All rights reserved.  
>   </section>
> </footer>
 
## What is this code doing? 
 
 1. It is creating a footer. 
 2. The "row" class is creating a horizontal break. 
 3. I am then creating a section with the content "Copyright 2014" that is 4 columns wide in a small viewport. 
 4. I then create a section that is 8 columns wide in a small viewport. 
 5. Finally, I close the footer. 

 However, the above is not a responsive design. Let me look at this code:

> <footer class="row">
>   <section class="small-12 medium-4 columns"
>     Copyright 2014
>   </section>
>   <section class="small-12 medium-8 columns"
>     All rights reserved.  
>   </section>
> </footer>

What is this code doing? It is the same as the code above, except that is it now *responsive*. What this means is that, in a medium viewport, we are creating a footer section with two side-by-side sections. The first section will be 4 columns wide, and the second section will be 8 columns wide. 

What happens in a small viewport? Well, both sections inside the footer section are 12 columns wide. Because the entire length of the grid is 12 columns, these two sections no longer fit side-by-side. In fact, in the small viewport, our two sections will be stacked one on top of the other!

Why did we code the small screen first? The Foundation website has a section specifically discussing [the Foundation grid system](http://foundation.zurb.com/docs/components/grid.html):

Foundation is mobile-first. Code for small screens first, and larger devices will inherit those styles. Customize for larger screens as necessary.

(Note that, because we did not define a large viewport, the large viewport and medium viewport will look the same. Think of the code as saying "for medium or larger viewports"). 

# Sass Mixins and Foundation 

Foundation classes often use a mix of *semantic* and *presentational* names. What is the difference? *Semantic* names describe *function*, while *presentational* names describe *appearance*. For long-term mantainability, it is important to use semantic naming. In order to do this, we can use Sass Mixins with Foundation. Mixins allow me to create my own class names and map them to Foundation class names. I would use my own class names while using Foundation styling.

Mixins are used within Sass files to create new CSS classes from existing CSS classes. Let me take a look at some code to better understand this:

> @mixin twelve-columns {
>   @extend .small-12;
>   @extend .columns;
>   }

We have now created a new CSS class called "twelve-columns". This class has the stylings of the "small-12" and "columns" classes that are defined in the Foundation framework. Now, I can use `class="twelve-columns"` and it is equivalent to using `class="small-12 columns"`. The `@mixin` directive creates a new CSS class. The `@extend` directive means that the new CSS class *inherits* (here I use the term loosely) from existing CSS rules. Finally, we can use the `@include` directive to add existing mixins:

> main {
>  @include twelve-columns;
>  background-color: #eee;
>  }

# Set up SimpleForm with Zurb Foundation

Although Rails provides [Form Helpers](http://guides.rubyonrails.org/form_helpers.html), most Rails developers use SimpleForm. SimpleForm comes packaged as a gem, and I can install it using `rails generate simple_form:install --foundation`. The last flag in that command will direct SimpleForm to install using settings for Zurb Foundation. 

# Adding Pages

So far, we have seen 2 types of pages in Rails:

1. Static pages served from the `public` folder
2. Dynamic pages compiled using our views, partials, and assets

However, there is a third type of web page: a static view that uses the application layout. Remember that the first type of page *does not* use the asset pipeline. It will not have access to the CSS and JavaScript files that pages rendered dynamically have. We can add these files to a static page itself, but then we are duplicating code and dynamically generated content (such as dynamic paths) cannot be used. 

Because of the limitations of putting this third type of web page in the `public` folder, Rails developers normally create a dynamic page that has no model and a nearly empty controller to serve this third type of web page. This is the solution for *static views that use the application layout*. The **high_voltage** gem provides this functionality, since it is used so often by Rails developers. 

## Using the high_voltage Gem

The high_voltage gem provides default routing, such that any URL with the form http://localhost:3000/pages/about will obtain a view from the `app/views/pages` directory.

First, we have to create a new folder: `app/views/pages`. Then create the view: `about.html.erb`. Remember that any folder / files we add to this directory will be created dynamically as far as Rails is concerned. It will therefore have access to the asset pipeline. That is the whole point of why we are creating a static page this way instead of using the `public/` folder. 

If we want to use a Rails route helper to create a link to a view within our `app/views/pages` directory, we would use code like this: `link_to "About", page_path("about")`.

# ActiveModel vs. ActiveRecord

When building database-backed applications, Rails developers create full-fledge models that inherit behavior from ActiveRecord. However, if our application does not need all of that functionality, I can create a model that "mixes" in behavior from *ActiveModel*. The code on the model would look like this:

> class Contact
>  include ActiveModel::Model
>
> attr_accessor :name, :string
>  attr_accessor :email, :string
>  attr_accessor :content, :string
>
>  validates_presence_of :name
>  validates_presence_of :email
>  validates_presence_of :content
>
>  validates_format_of :email,
>  :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
>
>  validates_length_of :content, :maximum => 500
> end

Now, we have a modle that will validate information sent to it from a web page. Let us walk through the code to explain it:

`class Contact` give the model the name of Contact.
`include ActiveModel::Model` allows our class to include the functionality of the ActiveModel:Model module. This module includes pre-written code for validation and conversion of data, such as validates_prescence_of, validates_format_of, and validates_length_of. (Note that there is a whole module - ActiveModel::Validations::HelperMethods - on the Rails API that goes deep into how this works).

Notice that we create attributes for the model using the Ruby attr_accessor. The attribute matches the name of the fields in the form, and they contain the *type* of the field. 

The model would go in `app/models/contact.rb`.

# Contacts Page

Once I have completed the model that will validate the contact page, I have to create a contact page view. Like other views, we have to create this in a folder called `app/views/contacts`. Remember, we are basically creating an entire MVC framework for our contacts page. Even though it is not database driven, this ensures two things: 

1. **Asset Pipeline** - Our asset pipeline (CSS, JavaScript) will be available to this page.
2. **Validation** - By using a model that inherits functionality from ActiveModel::Model, we can use pre-written validation code on our form. 

## SimpleForm

SimpleForm configures itself if we provide a model that inherits from ActiveRecord. SimpleForm will give the form a name that matches the model name, and SimpleForm will generate a URL based on the model name. 

# The Seven Standard Controller Actions

In order to manage **any** list, we need the following capabilities:

1. **index** - Display a list of all the items in our list
2. **show** - Display a record of *one* item. This usually includes details on that item that we would not include in the **index** view. 
3. **new** - Display a form in order to create a new item.
4. **create** - This functionality works in conjunction with our **new** functionality. It takes the data from the **new** form and saves the item in our database. 
5. **edit** - Edit a particular item.
6. **update** - This functionality works in conjunction with the **edit** functionality. It takes the updated information in the **edit** form and saves it to our database.
7. **destroy** - Delete a record.

It is plain to see that not all functions will have their own view. The **create** functionality typically redicrects to the **show** view; the **update** functionality typically redirects to the **show** view, and the **destroy** functionality typically redirects to the **index** view. So while we have seven functions, we only have four views. 

Note that there are several other functions that add convenience but not new capabilities. These would be:

1. **pagination** - Display only a portion of a list (a modified **show** function)
2. **sort** - Display the information in a particular way (a modified **show** function that can also include **pagination**)
3. **bulk edit** - Edit multiple items at once (a modified **edit** function)

When our controller inherits from ActiveController, we get these seven standard actions *for free*. What does this mean? It means that the controller, by default, will render a view called *new.html.erb*, that lives in the appropriate sub-folder inside of `app/views` when we call the action **new**. 

A controller that uses these actions is said to be RESTful. 

## Tying This Back to Our Form

By default, our controller will render the new.html.erb view when the new method is called. Furthermore, SimpleForm will create a destination URL back to the controller, asking for the *create* method. I will have to implement this action. 

## Creating the controller

We have created the Model (`app/models/contact.rb`), we have created the view (`app/views/contacts/new.html.erb`), and now I need to create the Controller (`app/controllers/contact_controller.rb`).

# Mass-Assignment Vulnerabilities

Rails protects us from *mass-assignment vulnerabilities*. For example, let me assume I have a database with users. This database has a flag attribute that determines if that user is an administrator or not. A hacker can send in a form with data that sets this attribute to "true", compromising the security of my site. Rails forces us to *whitelist* the attributes that can be set when creating a new entry in the database.

How does Rails do this? In our create method, within our contacts controller, we have the following code:

>  def create
>    @contact = Contact.new(secure_params)
>    .
>    .
>    .
>  end

Within the same controller, I define secure_params as follows:

>  def secure_params
>    params.require(:contact).permit(:name, :email, :content)
>  end

What I am doing here is going into the *params* hash, requiring that the hash contact a key called ":contact", and permitting only the keys ":name", ":email", and ":content" to be set as attributes in our database. Furthermore, remember that we validated that these inputs conform to our standards in our model.  

# Routing

At this point, I have added my Model (`app/models/contact.rb`); I have added my View (`app/views/contacts/new.html.erb`); and I have added by controller (`app/controllers/contacts_controller.rb`).

However, there is no way yet for anyone to access this MVC network, since I have not yet configured the router. 

I can do this by adding the following to the router: `resources :contacts, only: [:new, :create]`. If I had not added the `only: [:new, :create]` code, then Rails would have added routes for an entire RESTful model - i.e., all seven functions. 
