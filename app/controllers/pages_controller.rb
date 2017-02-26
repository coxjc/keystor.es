class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end

  def letsencrypt
    render text: '-2Ar3qne9wTCBaBDFTETQxl3WUwa_bIt8wOT8KdnqGE
        .3QRV_ZlvqAl_HzJdR76jN5pKh9Mm4vinMwaAzG3HoFg'
  end
end