# frozen_string_literal: true

require 'optparse'

# Command Line Utilities
module CommandLineUtils
  def self.parse_args
    options = OptionParser.new do |opts|
      opts.banner = 'Использование: bin/main.rb PATH_TO_JSON_FILE'
    end.parse!

    if options.empty? || !File.exist?(options[0])
      puts 'Файл с данными о клиентах не найден. Начинаю работу без начальных данных.'
      return nil
    end

    unless File.extname(options[0]) == '.json'
      puts 'Файл с данными о клиентах не в формате ".json". Начинаю работу без начальных данных.'
      return nil
    end

    options[0]
  end
end
