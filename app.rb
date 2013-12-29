require 'sinatra'
require 'RMagick'

# http://www.imagemagick.org/RMagick/doc/usage.html

LOCATIONS = {
  "Jon White" => "Seattle",
  "Hubot"     => "ENCOM"
}

FONTS = [
  "AvantGarde-Book",
  "AvantGarde-BookOblique",
  # "AvantGarde-Demi", # Too boring
  "AvantGarde-DemiOblique",
  "Bookman-Demi",
  "Bookman-DemiItalic",
  "Bookman-Light",
  "Bookman-LightItalic", "Bookman-LightItalic",
  # "Courier", # Too wide
  # "Courier-Bold", # Too wide
  # "Courier-BoldOblique", # Too wide
  # "Courier-Oblique", # Too wide
  "Helvetica",
  # "Helvetica-Bold", # Too boring
  "Helvetica-BoldOblique",
  "Helvetica-Narrow",
  "Helvetica-Narrow-Bold",
  "Helvetica-Narrow-BoldOblique",
  "Helvetica-Narrow-Oblique",
  "Helvetica-Oblique",
  "NewCenturySchlbk-Bold",
  "NewCenturySchlbk-BoldItalic",
  "NewCenturySchlbk-Italic", "NewCenturySchlbk-Italic",
  "NewCenturySchlbk-Roman",
  "Palatino-Bold",
  "Palatino-BoldItalic", "Palatino-BoldItalic",
  "Palatino-Italic",
  "Palatino-Roman",
  "Symbol", "Symbol",
  # "Times-Bold", # boring
  "Times-BoldItalic", "Times-BoldItalic",
  "Times-Italic",
  # "Times-Roman" # boring
]


get '/' do
  if params[:name] && !params[:name].empty?
    "#{params[:name]} fucking blows."
  else
    "You fucking blow."
  end
end

get '/:key' do
  content_type 'image/png'

  subject   = params[:text].to_s.gsub(/\.png$/, "")
  speaker   = params[:name].to_s.gsub(/\.png$/, "")

  image   = Magick::Image.read("images/#{params[:key]}.png")[0]
  message_text    = Magick::Draw.new
  credit_text     = Magick::Draw.new

  if !subject.empty?
    message = "\"#{subject}\n fucking blows!\""

    font = params[:font] || FONTS.sample
    $stdout.puts font

    message_text.annotate(image, 200, 200, 30, 100, message) do
      message_text.gravity = Magick::NorthWestGravity

      self.font               = font
      self.pointsize          = 72
      self.interline_spacing  = 10

      self.fill     = "white"
      self.stroke   = "transparent"
    end
  end

  if !speaker.empty?
    location  = LOCATIONS[speaker] || "Los Angeles"
    credit    = "#{speaker}, #{location}"

    credit_text.annotate(image, 200, 200, 30, 275, credit) do
      credit_text.gravity = Magick::NorthWestGravity

      self.font         = "AvantGarde-BookOblique"
      self.pointsize    = 30
      self.font_weight  = Magick::BoldWeight

      self.fill     = "white"
      self.stroke   = 'transparent'
    end
  end

  image.to_blob
end
