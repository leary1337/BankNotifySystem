# frozen_string_literal: true

require_relative '../lib/console_menu'

def main
  ConsoleMenu.new.show_main_menu
end

main if __FILE__ == $PROGRAM_NAME
