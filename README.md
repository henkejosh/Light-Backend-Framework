#Homerolled MVC + ORM Framework

##Description
A lightweight Ruby web framework that utilizes the MVC architecture pattern and uses basic meta-programming techniques to construct an ORM between Model classes and a PostgreSQL database.

Additionally, I implemented two middlewares for running on Rack: Show Exceptions and Static Assets.

###Overview
1. ModelBase
   A superclass your models can inherit from - built to simplify interacting with your database. Search your DB using Ruby (not SQL), map data to Ruby objects for easy manipulation, quickly access related data through associations, and efficiently create reader/writer methods using attr_accessors.

   Specs:
   * Easily find data related to a given model
     1. All columns in a model's table have reader & writer methods
     2. Search your DB using #where, #find, #all
     3. Associations: has_many, belongs_to, has_one_through
   * Modify DB data using Ruby Objects
     1. #insert, #update, #save
   * Define methods using attr_reader, attr_writer, and attr_accessor

2. ControllerBase  
   A superclass that your controllers can inherit from - used for communicating between your models and views.

   Specs:
   * Basic CSRF protection
   * Session, Flash, Flash#now, and Params hashes
   * Uses RegEx (similar to Rails) to intelligently render and redirect without needing a fully specified path

3. Router

####Object Relational Mapping




####Middlewares
1. Show Exceptions
* Catches exceptions thrown by an application and renders a custom error page with a stack trace and code snippets from the error source.

2. Static Assets
* Renders the appropriate static asset contained in the /public/ file path when a GET request is submitted with a file_name following the hostname.
