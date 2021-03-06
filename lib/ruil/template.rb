require 'rubygems'
require 'tenjin'

module Ruil

  # Ruil::TenjinTemplate objects implements the interface nedeed by
  # Ruil::Resource to render the bodies of HTTP responses. That
  # inteface includes the methods: call and media_type.
  class Template

    # The template name.
    attr_reader :name

    # The template key.
    attr_reader :key

    # The template engine.
    attr_reader :engine

    # The template media type.
    attr_reader :media_type

    # Initialize a new template object using the template file name.
    # That file name must follow the pattern "foo.key.tenjin.html",
    # where foo is the name of the template, tipically related with
    # the resource, key is the key that indentify different
    # templates for the same resource and html is the indentifier
    # for the template media type.
    #
    # We use distinct templates for the same resource to send
    # different representations of the resource depending the client
    # user agent and preferences.
    def initialize(file)
      @file = file
      a = File.basename(@file).split('.')
      @name   = a[0]
      @key    = a[1].to_sym
      @engine = case a[2]
                when "tenjin"
                  require "tenjin"
                  Tenjin::Engine.new
                else
                  raise "Template engine unknown #{a[2]}"
                end
      @media_type  = case a[3]
                     when "html"
                       "text/html"
                     else
                       raise "Media type unknow for #{a[3]}"
                     end
    end

    # Creates a resource representation using the template. The
    # options parameter is a hash with the data to fill the template.
    def call(options)
      @engine.render(@file, options)
    end

  end

end
