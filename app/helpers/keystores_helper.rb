module KeystoresHelper

  def get_download_url(obj_path)
    obj = S3_BUCKET.objects[obj_path]
    return obj.url_for(:get, {:expires => 5.minutes.from_now, :secure =>
        true, :signature_version => :v4}).to_s
  end

end
