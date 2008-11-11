require "." / "lib" / "resolvers" / "ssh_key_pair_resolver"

describe WarningShot::SshKeyPairResolver do

  it 'should have tests registered' do
    WarningShot::SshKeyPairResolver.tests.empty?.should be(false)
  end

  it 'should have resolutions registered' do
    WarningShot::SshKeyPairResolver.resolutions.empty?.should be(false)
  end

  def rm_tmp_key_files
    FileUtils.rm_f(@tmp_key_file)          if File.exists?(@tmp_key_file)
    FileUtils.rm_f(@tmp_key_file + ".pub") if File.exists?(@tmp_key_file + ".pub")
  end

  before(:each) do
    @tmp_key_file = File.expand_path($log_root + "/tmp_key")
    rm_tmp_key_files
  end

  after(:each) do
    rm_tmp_key_files
  end

  it 'should detect that a resolution needs to take place and fix it' do
    fd = WarningShot::SshKeyPairResolver.new({:output_keyfile => @tmp_key_file})
    fd.test!
    fd.failed.length.should be(1)

    fd.resolve!
    fd.resolved.length.should be(1)

    fd.test!
    fd.failed.length.should be(0)
  end
  
end
