require 'fileutils'
require 'git'
require 'match'
require 'shellwords'

module Fastlane
  module Actions

    class GitcryptAction < Action

      @@tmp_dir = '.tmp'

      def self.run(params)
        passphrase = params[:passphrase]
        UI.user_error!("A passphrase must be provided.") if passphrase.nil?

        ref = params[:ref] || 'master'

        begin
          case params[:command]
          when "encrypt"
            encrypt(
              git_url: params[:git_url],
              files: params[:files],
              passphrase: passphrase,
              ref: ref
            )
          when "decrypt"
            decrypt(
              git_url: params[:git_url],
              files: params[:files],
              passphrase: passphrase,
              ref: ref
            )
          else
            UI.user_error!("The only availabe commands are 'encrypt' and 'decrypt'")
          end
        rescue
          UI.user_error!("Unable to #{params[:command]}! Please check that your environment variables for Gitcrypt are setup correctly.")
        end
      end

      def self.description
        "This plugin will encrypt/decrypt files and store the encrypted versions in a git repository."
      end

      def self.authors
        ["Ben Sarrazin", "Mat Cartmill"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        self.description
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :command,
            env_name: "GITCRYPT_COMMAND",
            description: "The name of the command to use, either 'encrypt' or 'decrypt'",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :files,
            env_name: "GITCRYPT_FILES",
            description: "The paths of the file to encrypt/decrypt",
            optional: false,
            type: Array
            ),
          FastlaneCore::ConfigItem.new(
            key: :git_url,
            env_name: "GITCRYPT_GIT_URL",
            description: "The URL of the Git repository where to push/pull encrypted files",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :passphrase,
            env_name: "GITCRYPT_PASSPHRASE",
            description: "The passphrase to use during encryption/decryption",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :ref,
            env_name: "GITCRYPT_PUSH",
            description: "The Git reference to use when decrypting files",
            optional: true,
            type: String
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end

      private

      def self.decrypt(git_url: '', files: [], passphrase: '', ref: 'master')
        remove_tmp_dir_if_exists
        UI.message("Decrypting git_url: #{git_url}")
        UI.message("Decrypting git ref: #{ref}")
        UI.message("Decyprting files: #{files}")

        match = Match::Encrypt.new
        git_name = git_url.split('/').last
        git = Git.clone(git_url, git_name, :path => @@tmp_dir)
        git.checkout(ref)
        files.each do |file|
          src = "#{@@tmp_dir}/#{git_name}/#{file}"
          match.gitcrypt_decrypt(path: src, password: passphrase)
          FileUtils.cp(src, file)
        end
        remove_tmp_dir_if_exists
      end

      def self.encrypt(git_url: '', files: [], passphrase: '', ref: 'master')
        remove_tmp_dir_if_exists
        UI.message("Encrypting git_url: #{git_url}")
        UI.message("Encrypting git ref: #{ref}")
        UI.message("Encyprting files: #{files}")

        match = Match::Encrypt.new
        git_name = git_url.split('/').last
        git = Git.clone(git_url, git_name, :path => @@tmp_dir)
        git.branch(ref).checkout
        files.each do |file|
          dst = "#{@@tmp_dir}/#{git_name}/#{file}"
          FileUtils.mkdir_p(File.dirname(dst))
          FileUtils.cp(file, dst)
          match.gitcrypt_encrypt(path: dst, password: passphrase)
        end
        git.add
        git.commit "[Gitcrypt] Updating encrypted files"
        git.push(git.remote('origin'), git.branch(ref))
        remove_tmp_dir_if_exists
      end

      def self.remove_tmp_dir_if_exists
        FileUtils.remove_dir(@@tmp_dir) if Dir.exists?(@@tmp_dir)
      end

    end

  end
end
