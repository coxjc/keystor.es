class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end

  def letsencrypt
    render text: 'he0qFOirZ-bP-RadUtMH-ifMY8A0bOCCvYAHdFc1eqI.3QRV_ZlvqAl_HzJdR76jN5pKh9Mm4vinMwaAzG3HoFg' 
  end
end
