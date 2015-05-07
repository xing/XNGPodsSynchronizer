describe Configuration do

  describe "#initialize" do
    it "loads the yaml config at the specified path" do
      config = Configuration.new(path: File.join('spec', 'fixtures', 'config.yml'))
      expect(config.yaml).to_not be_empty
    end

    it "throws an exception if the file at the path does not exist" do
      expect { Configuration.new(path: 'invalid/path') }.to raise_exception
    end
  end

  before :all do
    @config = Configuration.new(path: 'spec/fixtures/config.yml')
  end

  it '#master_repo should exist' do
    expect(@config.master_repo).to eql("https://github.com/CocoaPods/Specs.git")
  end

  describe '#podfiles' do
    it 'should parse the podfiles correctly' do
      expected_result = [
        "https://git.hooli.xyz/ios/moonshot/raw/master/Podfile.lock",
        "https://git.hooli.xyz/ios/nucleus/raw/master/Podfile.lock",
        "https://git.hooli.xyz/ios/bro2bro/raw/master/Podfile.lock"]
      expect(@config.podfiles).to eql(expected_result)
    end
  end

  describe "#mirror" do
    it 'should have the correct @specs_push_url' do
      expect(@config.mirror.specs_push_url).to eql("git@git.hooli.xyz:pods-mirror/Specs.git")
    end

    it 'should have the correct @source_push_url' do
      expect(@config.mirror.source_push_url).to eql("git@git.hooli.xyz:pods-mirror")
    end

    it 'should have the correct @source_clone_url' do
      expect(@config.mirror.source_clone_url).to eql("git://git.hooli.xyz/pods-mirror")
    end

    describe '#github' do
      it 'should have the correct @source_clone_url' do
        expect(@config.mirror.github.access_token).to eql("0y83t1ihosjklgnuioa")
      end

      it 'should have the correct @organisation' do
        expect(@config.mirror.github.organisation).to eql("pods-mirror")
      end

      it 'should have the correct @endpoint' do
        expect(@config.mirror.github.endpoint).to eql("https://git.hooli.xyz/api/v3")
      end
    end
  end

end
