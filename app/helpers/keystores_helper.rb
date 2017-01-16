module KeystoresHelper

  def get_download_url(obj_path)
    obj = S3_BUCKET.objects[obj_path]
    return obj.url_for(:get, {:expires => 3.minutes.from_now, :secure =>
        true, :signature_version => :v4}).to_s
  end

  def delete_obj(obj_path)
    obj = S3_BUCKET.objects[obj_path]
    obj.delete
  end

end
