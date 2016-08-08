#Homerolled MVC + ORM Framework

##Description  
A lightweight Ruby web framework that follows the MVC architecture pattern and utilizes basic meta-programming techniques to construct an ORM between Model classes and a PostgreSQL database.

Additionally, I implemented two simple Rack middlewares: Show Exceptions and Static Assets.

##Goals
Improve my understanding of:
 1. The MVC pattern
 2. Rails & ActiveRecord
 3. Client, server, middleware, web app, and database interactions.

##Overview  
###1. ModelBase  
   A superclass your models can inherit from - built to simplify interacting with your database and reduce superfluous code. Search your DB using Ruby (not SQL), map data to Ruby objects for easy manipulation, quickly access related data through associations, and efficiently create reader/writer methods using attr_accessors.

   **Specs:**  
   * Find data related to a given model using Ruby
     * All columns in a model's table have reader & writer methods
     * Search your DB using #where, #find, #all
     * Set up Associations: has_many, belongs_to, has_one_through
   * Modify your database directly with Ruby Objects
     * #save, #insert, #update
   * Quickly define methods using attr_reader, attr_writer, and attr_accessor

###2. ControllerBase  
   A superclass that your controllers can inherit from - used for basic authentication and "smart" communication between your models and views.

   **Specs:**  
   * CSRF protection (::protect_from_forgery)
   * Form authentication (#form_authenticity_token)
   * Access Session, Flash, Flash#now, and Params objects
   * Intelligently render and redirect without specifying a path (similar to Rails)

###3. Router  
   Dynamically creates and processes routes based on input URI and typical HTTP verbs.

   **Specs:**   
   * Creates basic routes for each controller (GET, POST, PUT, DELETE)
   * Matches the URI path and HTTP methods to call the appropriate action on the appropriate controller
   * Creates a Params Object to house request parameters and provides access to it via the Controller

##Extras
###Middlewares  
   1. Show Exceptions  
    * Catches exceptions thrown by an application and renders a custom error page with a stack trace and code snippets from the error source.

   2. Static Assets
    * Renders the appropriate static asset contained in the /public/ file path when a GET request is submitted with a file_name following the hostname.
