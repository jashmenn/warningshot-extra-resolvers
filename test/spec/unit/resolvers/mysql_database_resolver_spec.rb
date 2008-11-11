require "." / "lib" / "resolvers" / "ssh_key_pair_resolver"

describe WarningShot::MysqlDatabaseResolver do

  it 'should have tests registered' do
    WarningShot::MysqlDatabaseResolver.tests.empty?.should be(false)
  end

  it 'should have resolutions registered' do
    WarningShot::MysqlDatabaseResolver.resolutions.empty?.should be(false)
  end

  before(:each) do
    # @tmp_key_file = File.expand_path($log_root + "/tmp_key")
    # FileUtils.rm_f(@tmp_key_file) if File.exists?(@tmp_key_file)
  end

  after(:each) do
    # FileUtils.rm_f(@tmp_key_file) if File.exists?(@tmp_key_file)
  end

  it 'should detect that a resolution needs to take place and fix it' do
    fd = WarningShot::MysqlDatabaseResolver.new({
      :host        => "localhost", 
      :database    => "applesauce", 
      :user        => "jerrys", 
      :password    => "kids", 
      :user_host   => "localhost", 
      :permissions => "ALL"}
    })

    fd.test!
    fd.failed.length.should be(1)

    fd.resolve!
    fd.resolved.length.should be(1)

    fd.test!
    fd.failed.length.should be(0)
  end
  
end
