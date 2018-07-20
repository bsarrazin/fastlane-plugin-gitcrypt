describe Fastlane::Actions::GitcryptAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The gitcrypt plugin is working!")

      Fastlane::Actions::GitcryptAction.run(nil)
    end
  end
end
