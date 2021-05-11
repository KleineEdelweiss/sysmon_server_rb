# lib/sysmon/server.rb

##
# This module creates an abstracted core server
# implementation to be inherited by the various classes
# that need to run as servers.
module Server
  ##
  # Abstracted server that runs either as a Ractor or
  # thread, depending on Ruby version.
  class AbstractServer
    ##
    # Instance variables
    attr_reader :receiver, :equeue, :cache, :sig_kill
    
    ##
    # Constructor for abstract server
    def initialize(supervisor) 
      @receiver = supervisor # Supervisor should receive response
      @equeue = [] # Event queue, initially empty array
      @cache = {} # Cache is the current data stored on the server
      @sig_kill = false # Keeps the server running, until true
    end # End constructor
    
    ##
    # Add items to the event queue
    def enqueue(event) @equeue << event end
    
    ##
    # Stat the server for the currently-cached data
    def stat() @cache end
      
    ##
    # Kill the server
    def kill
      @equeue.clear
      @sig_kill = true
    end # End kill method
    
    ##
    # Configure the specifics of the server
    def config() raise NotImplementedError end
    
    ##
    # Reset method for the server
    def reset() raise NotImplementedError end
    
    ##
    # Run the server.
    # Default reload is 50 ms, but other
    # values can be passed to servers, as desired
    def run(nap=0.05)
      until @sig_kill
        @equeue.pop.then { |event| handle(event) }
        sleep nap
      end
      puts "#{self.class} has been killed."
    end # End run method
    
    ##
    # Handle events sent to the server.
    # Events should be a hash.
    def handle(event) raise NotImplementedError end
  end # End abstract server class
end # End server module