require 'ostruct'

module Gitthello
  class Configuration
    attr_reader :boards, :trello, :github, :colors, :users

    def initialize
      # read config file from root dir
      @config = YAML.load(File.read(File.expand_path('../../../../config.yml', __FILE__)))
      @trello = OpenStruct.new(:dev_key => @config['trello']['dev_key'],
                               :token => @config['trello']['member_token'])
      @github = OpenStruct.new(:token => @config['github']['access_token'])
      @users  = OpenStruct.new(@config['github']['members'])
      @boards = @config['trello']['boards'].map {|board| OpenStruct.new(board) }
    end

  end
end
