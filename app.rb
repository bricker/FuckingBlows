require 'sinatra'
require 'RMagick'

# http://www.imagemagick.org/RMagick/doc/usage.html

get '/' do
  if params[:name] && !params[:name].empty?
    "#{params[:name]} fucking blows."
  else
    "You fucking blow."
  end
end

get '/:key' do
  content_type 'image/png'

  subject = params[:text].to_s.gsub(/\.png$/, "")
  speaker = params[:name].to_s.gsub(/\.png$/, "")

  image = Magick::Image.read("images/#{params[:key]}.png")[0]
  text = Magick::Draw.new

  if !subject.empty?
    text.annotate(image, 290, 170, 0, 0, subject) do
      text.gravity = Magick::SouthEastGravity
      self.pointsize = 72
      self.font_weight = Magick::BoldWeight
      self.stroke = "black"
      self.fill = "red"
    end
  end

  if !speaker.empty?
    text.annotate(image, 220, 280, 0, 0, speaker) do
      text.gravity = Magick::SouthEastGravity
      self.pointsize = 30
      self.font_weight = Magick::BoldWeight
      self.stroke = "black"
      self.fill = "red"
    end
  end

  image.to_blob
end
