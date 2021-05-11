# lib/sysmon/sound.rb

# Imports
require "alsactl"

# Relative imports
require_relative "./server.rb"

##
# SoundServer implements the AlsaCtl module as
# a server, allowing it to be used for continuous
# monitoring of system sound
module SoundServer
  ##
  # Class to hold the SoundServer object
  class SoundServer < Server::AbstractServer
    ##
    # SoundServer-specific configuration
    def config
      @alsa = AlsaCtl::DefMixer.new
      @alsa.connect
    end # End configuration
    
    ##
    # SoundServer reset method
    def reset
      @alsa.disconnect
      @alsa.connect
    end # End reset
    
    ##
    # Handle events
    def handle(event)
      if !event.nil?
        # Get the type and check for accepted handlers
        etype = event[:type]
        case etype
        when :raise_volume
          nil
        when :lower_volume
          nil
        when :set_volume
          nil
        when :get_volume
          @alsa.send :vget
        when :set_channel
          nil
        when :get_channel
          nil
        # Handle mute requests
        when :mute, :unmute
          @alsa.send etype
        # Handle connection requests
        when :connect, :disconnect, :close
          @alsa.send etype
        when :reset
          reset
        else
          puts "::ERROR:: SoundServer doesn't recognize event type: #{etype}"
        end # End accepted handlers
      else nil end
    end # End event handler
  end # End sound server class
end # End sound server module