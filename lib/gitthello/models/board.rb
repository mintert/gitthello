module Gitthello
  class Board
    attr_reader :trello_helper, :github_helper

    def initialize(board_config)
      @config = board_config.clone
      @colors = board_config.colors
      @list_map = {
        todo: @config.marshal_dump.fetch(:todo, 'To Do'),
        backlog: @config.marshal_dump.fetch(:backlog, 'Backlog'),
        done: @config.marshal_dump.fetch(:done, 'Done')
      }
      @github_helper = GithubHelper.new(Gitthello.configuration.github.token,
                                        @config.repos_to,
                                        @config.repos_from)
      @trello_helper = TrelloHelper.new(Gitthello.configuration.trello.token,
                                        Gitthello.configuration.trello.dev_key,
                                        @config.name,
                                        @list_map)
    end

    def synchronize
      puts "==> Handling Board: #{@config.name}"
      @trello_helper.setup
      @trello_helper.close_issues(@github_helper)
      @trello_helper.move_cards_with_closed_issue(@github_helper)
      @github_helper.retrieve_issues
      @github_helper.new_issues_to_trello(@trello_helper)
      @trello_helper.new_cards_to_github(@github_helper)
    end

    def add_trello_link_to_issues
      @trello_helper.setup
      @trello_helper.add_trello_link_to_issues(@github_helper)
    end

    def name
      @config.name
    end

    def color_for_label(label)
      @colors.each_pair.to_a.select {|p| p[1] === label}.flatten[0]
    end
  end
end
