# require Inesita
require 'inesita'
require 'inesita-router'

# require additional libraries
require 'opal'        # Our host runtime for Ruby
require 'jquery'      # venerable JQuery library
require 'opal-jquery' # JQuery Wrapper for Ruby giving us the Element object
require 'nestable2'   # Nested Drag and Drop

# require main parts of application
require 'router'
require 'store'

# require all components
require_tree './components'

# when document is ready render application to <body>

class Application
  include Inesita::Component

  inject Router
  inject Store

  def render
    div class: 'container' do
      component NavBar
      component router
    end

    # TODO: way to check for development mode?
    component DevTimeTravel
  end
end

Inesita::Browser.ready? do
  Application.mount_to(Inesita::Browser.body)
end
