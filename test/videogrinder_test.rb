require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'active_support'

$LOAD_PATH << File.dirname(__FILE__) + '/../lib'
# Main class
require 'videogrinder'
# Gems & other herbs
require 'open-uri'
require 'youtube'
# Video classes
require 'vg_youtube'
require 'vg_google'


class VideogrinderTest < Test::Unit::TestCase
  
  context "Instancing Videogrinder" do
    
    context "without any url" do
      should "raise an ArgumentError exception" do
        assert_raise(ArgumentError, "We need a video url") { Videogrinder.new }
      end
    end
    
    context "with an unsupported url" do
      should "raise an ArgumentError exception" do
        assert_raise(ArgumentError, "Unsuported url or service") { Videogrinder.new("http://iwannagothere.net/") }
      end
    end
    
    context "with an existent youtube url" do
      setup do
        @videotron = Videogrinder.new("http://www.youtube.com/watch?v=muLIPWjks_M", "RCofu-vAmeY") # => Ninja cat comes closer while not moving!
      end
      should "initialize a VgYoutube instance" do
        assert_equal VgYoutube, @videotron.instance_values['object'].class
        assert_equal "http://www.youtube.com/watch?v=muLIPWjks_M", @videotron.instance_values['object'].instance_values['url']
        assert_equal "muLIPWjks_M", @videotron.instance_values['object'].instance_values['video_id']
        assert_not_nil @videotron.instance_values['object'].instance_values['details']
      end
      
      should "return the video properties" do
        assert_equal "Ninja cat comes closer while not moving!", @videotron.title
        assert_not_nil @videotron.thumbnail
        assert_not_nil @videotron.embed_url
        assert_not_nil @videotron.embed_html
        assert_not_nil @videotron.flv
        assert_equal Hash, @videotron.video_details.class
      end
    end


    context "with an existent youtube url that can not be embedded" do
      setup do
        @videotron = Videogrinder.new("http://www.youtube.com/watch?v=3Oec8RuwVVs", "RCofu-vAmeY") # => The Killers - Read My Mind
      end
      should "initialize a VgYoutube instance" do
        assert_equal VgYoutube, @videotron.instance_values['object'].class
        assert_equal "http://www.youtube.com/watch?v=3Oec8RuwVVs", @videotron.instance_values['object'].instance_values['url']
        assert_equal "3Oec8RuwVVs", @videotron.instance_values['object'].instance_values['video_id']
        assert_not_nil @videotron.instance_values['object'].instance_values['details']
      end
      
      should "return the video properties" do
        assert_equal "The Killers - Read My Mind", @videotron.title
        assert_not_nil @videotron.thumbnail
        assert_not_nil @videotron.flv
        assert_equal Hash, @videotron.video_details.class
        assert_nil @videotron.embed_url
        assert_nil @videotron.embed_html
        assert_nil @videotron.video_details[:embed_url]
        assert_nil @videotron.video_details[:embed_html]
      end
    end
    
  end
  
end
