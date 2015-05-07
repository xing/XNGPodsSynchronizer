describe Git do
  describe Specs do

    before :all do
      @specs_path = File.join('spec', 'fixtures', 'specs')
      @specs = Specs.new(path: @specs_path)
    end

    describe "::commit" do
      it 'commits with a message' do
        class_under_test = @specs.git

        message = "Become a programmer, they said. It'll be fun, they said."
        expect(class_under_test).to receive(:system).with("git add --all")
        expect(class_under_test).to receive(:system).with("git commit -m '#{message}'")
        class_under_test.commit(message: message)
      end
    end

    describe "::create_github_repo" do
      it 'creates a github repo' do
        class_under_test = @specs.git
        expect(class_under_test).to receive(:system).with("curl https://github.com/api/v3/orgs/ios-pods-external/repos?access_token=123 -d '{\"name\":\"mega-pod\"}'")
        class_under_test.create_github_repo(
            access_token: '123',
            org: 'ios-pods-external',
            name: 'mega-pod',
            endpoint: 'https://github.com/api/v3'
          )
      end
    end

    describe "::push" do
      it 'push on default remote "origin master"' do
        class_under_test = @specs.git
        expect(class_under_test).to receive(:system).with("git push origin master")
        class_under_test.push
      end

      it 'push on custom remote "production"' do
        class_under_test = @specs.git
        expect(class_under_test).to receive(:system).with("git push production")
        class_under_test.push(remote: 'production')
      end

      it 'push on custom remote with options' do
        class_under_test = @specs.git
        expect(class_under_test).to receive(:system).with("git push develop --force")
        class_under_test.push(remote: 'develop', options: '--force')
      end

      it 'push on default remote with options' do
        class_under_test = @specs.git
        expect(class_under_test).to receive(:system).with("git push origin master --force")
        class_under_test.push(options: '--force')
      end
    end
  end

end