# ----------------------------------------------
#  Class for Youtube (youtube.com)
#  http://www.youtube.com/watch?v=25AsfkriHQc
# ----------------------------------------------

class VgYoutube

  def initialize(url=nil, options={})
    object = YouTubeIt::Client.new({})
    @url = url
    # This line handles URL like http://www.youtube.com/watch?v=HtAXSpBM8XI
    @video_id = @url.query_param('v')
    # This line handles URL like http://www.youtube.com/v/HtAXSpBM8XI
    @video_id = @url.match(/www.youtube.com\/v\/(?<id>[^?]*)/)[:id] if @video_id.blank?
    begin
      @details = object.video_by(@video_id)
      raise if @details.blank?
      raise ArgumentError, "Embedding disabled by request" unless @details.embeddable?
      @details.instance_variable_set(:@noembed, false)
    rescue
      raise ArgumentError, "Unsuported url or service"
    end
  end

  def title
    @details.title
  end

  def thumbnail
    @details.thumbnails.first.url
  end

  def thumbnails
    @details.thumbnails
  end

  def duration
    @details.duration
  end

  def embed_url params = {}
    "//www.youtube.com/embed/#{@video_id}#{"?#{params.map{|k,v| "#{k}=#{v}"}.join('&')}" unless params.blank?}" if @details.noembed == false
  end

  # Now we use the iframe API which tries to use an html5 player
  # You can read more here: https://developers.google.com/youtube/iframe_api_reference
  def embed_html(width=425, height=344, options={}, params={})
    "<iframe id='#{options[:id] || 'player'}' type='text/html' width='#{width}' height='#{height}' src='#{embed_url params}' frameborder='0'></iframe>" if @details.noembed == false
  end


  def flv
    doc = URI::parse("http://www.youtube.com/get_video_info?&video_id=#{@video_id}").read
    CGI::unescape(doc.split("&url_encoded_fmt_stream_map=")[1]).split("url=").each do |u|
    	u = CGI::unescape(u)
    	unless u.index("x-flv").nil?
    		return u.split("&quality").first
    		break
    	end
    end
  end

  def download_url
    flv
  end

  def service
    "Youtube"
  end

end
