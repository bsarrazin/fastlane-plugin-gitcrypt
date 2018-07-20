module Fastlane
  module Helper
    class GitcryptHelper
      # class methods that you define here become available in your action
      # as `Helper::GitcryptHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the gitcrypt plugin helper!")
      end
    end
  end
end

module Match
  class Encrypt
    def gitcrypt_encrypt(path: nil, password: nil)
      encrypt(path: path, password: password)
    end
    def gitcrypt_decrypt(path: nil, password: nil)
      decrypt(path: path, password: password)
    end
  end
end
