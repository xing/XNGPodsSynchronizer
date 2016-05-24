describe PodSynchronize::Command::Synchronize do

  before :all do
    @sync = PodSynchronize::Command::Synchronize.new(CLAide::ARGV.new(['./spec/fixtures/api_client_config.yml']))
    Dir.mktmpdir { |dir| @sync.setup(temp_path: dir) }
  end

  describe "#dependencies" do
    it "resolves the dependencies correctly" do
      expected_result = [
        "AFNetworking",
        "Expecta",
        "OCMock",
        "OHHTTPStubs",
        "XNGAPIClient",
        "XNGOAuth1Client",
        "Google-Mobile-Ads-SDK",
      ]
      expect(@sync.dependencies).to eql(expected_result)
    end
  end

end
