require 'sinatra'
require 'rmagick'

# http://www.imagemagick.org/RMagick/doc/usage.html

get '/:key' do
  content_type 'image/png'

  image = Magick::Image.read("images/#{params[:key]}.png")[0]
  text = Magick::Draw.new

  text.annotate(image, 290, 170, 0, 0, params[:text].to_s) do
    text.gravity = Magick::SouthEastGravity
    self.pointsize = 72
    self.font_weight = Magick::BoldWeight
    self.stroke = "black"
    self.fill = "red"
  end

  text.annotate(image, 220, 280, 0, 0, params[:name].to_s) do
    text.gravity = Magick::SouthEastGravity
    self.pointsize = 30
    self.font_weight = Magick::BoldWeight
    self.stroke = "black"
    self.fill = "red"
  end

  image.to_blob
end
