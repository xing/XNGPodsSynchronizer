describe Specs do

  before :all do
    @specs_path = File.join('spec', 'fixtures', 'specs')
    @other_specs_path = File.join('spec', 'fixtures', 'specs_other')
  end

  describe '::new' do
    it 'should init with a path' do
      class_under_test = Specs.new(path: @specs_path)
      expect(class_under_test.path).to eql(@specs_path)
    end
  end

  describe '#pods' do
    it 'should fetch all pods' do
      class_under_test = Specs.new(path: @specs_path)
      expect(class_under_test.pods.count).to eql(3)
      expect(class_under_test.pods.map(&:name)).to eql(['NBNRealmBrowser', 'XNGAPIClient', 'XNGOAuth1Client'])
    end

    it 'should fetch 1 pod from whitelist' do
      class_under_test = Specs.new(path: @specs_path, whitelist: ['XNGAPIClient'])
      expect(class_under_test.pods.count).to eql(1)
      expect(class_under_test.pods.map(&:name)).to eql(['XNGAPIClient'])
    end

    it 'should fetch 2 pods from whitelist' do
      class_under_test = Specs.new(path: @specs_path, whitelist: ['XNGAPIClient', 'XNGOAuth1Client'])
      expect(class_under_test.pods.count).to eql(2)
      expect(class_under_test.pods.map(&:name)).to eql(['XNGAPIClient', 'XNGOAuth1Client'])
    end

    it 'should fetch no pods that are not on the whitelist' do
      class_under_test = Specs.new(path: @specs_path, whitelist: ['PodThatDoesntExist'])
      expect(class_under_test.pods.count).to eql(0)
    end
  end

  describe '#merge_pods' do
    it 'should add all pods from one spec to another' do
      specs = Specs.new(path: @specs_path)
      other_specs = Specs.new(path: @other_specs_path, whitelist: ['NBNPhotoChooser'])
      expected_path = File.join(@other_specs_path, 'NBNPhotoChooser')

      expect(FileUtils).to receive(:cp_r).with(expected_path, specs.path)
      specs.merge_pods(other_specs.pods)
    end
  end

end