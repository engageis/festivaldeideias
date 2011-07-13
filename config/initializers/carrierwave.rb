if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
elsif Rails.env.production?
  CarrierWave.configure do |config|
    access_key = Configuration.find_by_name('aws_access_key')
    access_key = access_key ? access_key.value : ''
    secret_key = Configuration.find_by_name('aws_secret_key')
    secret_key = secret_key ? secret_key.value : ''
    fog_directory = Configuration.find_by_name('fog_directory')
    fog_directory = fog_directory ? fog_directory.value : ''
    
    config.fog_credentials = {
      :provider               => 'AWS',            # required
      :aws_access_key_id      => access_key,       # required
      :aws_secret_access_key  => secret_key        # required
      # :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
    }
    config.storage = :s3
    config.fog_directory  = fog_directory                             # required
    # config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
    # config.fog_public     = false                                   # optional, defaults to true
    # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end