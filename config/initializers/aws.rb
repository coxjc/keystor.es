AWS.config(
    :access_key_id => ENV['ACCESS_KEY_ID'],
    :secret_access_key => ENV['SECRET_ACCESS_KEY']
)

S3_BUCKET = AWS::S3.new.buckets[ENV['S3_BUCKET_NAME']]