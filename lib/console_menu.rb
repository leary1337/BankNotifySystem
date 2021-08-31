# frozen_string_literal: true

require 'tty-prompt'
require_relative 'bank_notify_system/client_list'
require_relative 'utils/calc_utils'
require_relative 'utils/sort_utils'
require_relative 'command_line_utils/parse_args'
require_relative 'menu_utils/ask_users'
require_relative 'menu_utils/select_users'

# ConsoleMenu class
class ConsoleMenu
  include CalcUtils
  include SortUtils
  include MenuUtils

  def initialize
    @prompt = TTY::Prompt.new
    @client_list = BankNotifySystem::ClientList.new
    json_filename = CommandLineUtils.parse_args
    @client_list.load_from_file(json_filename) if json_filename
  end

  def show_main_menu
    loop do
      action = select_main_menu

      break if action == :exit

      method(action).call
    end
  end

  def create_client
    fio = ask_fio
    phone_number = ask_phone_number
    amount_owed = ask_amount_owed

    client_id = @client_list.last_client_id + 1
    @client_list.add_client(BankNotifySystem::Client.new(client_id, fio, phone_number, amount_owed))
    puts 'Клиент успешно добавлен!'
  end

  def delete_client
    selected_client_id = select_client_menu
    return if selected_client_id == :back_to_main

    confirm = @prompt.yes?('Вы действительно хотите удалить данного клиента?')
    delete_client_by_id(selected_client_id) if confirm

    puts 'Клиент успешно удален!' if confirm
  end

  def update_client
    selected_client_id = select_client_menu
    return if selected_client_id == :back_to_main

    changed_client = client_by_id(selected_client_id)

    need_field = select_client_field
    case need_field
    when :back_to_main
      nil
    when :change_fio
      changed_client.fio = ask_fio
    when :change_phone
      changed_client.phone_number = ask_phone_number
    else
      changed_client.amount_owed = ask_amount_owed
    end
    puts 'Успешно изменено'
  end

  def search_client
    search_field = select_search_client_field
    return if search_field == :back_to_main

    if search_field == :search_by_fio
      need_fio = ask_fio
      founded_client = @client_list.find { |client| client.fio == need_fio }
    else
      need_phone = ask_phone_number
      founded_client = @client_list.find { |client| client.phone_number == need_phone }
    end

    founded_client.nil? ? (puts 'Такого клиента не существует') : (puts founded_client)
  end

  def add_phone_call
    selected_client_id = select_client_menu
    return if selected_client_id == :back_to_main

    new_phone_call = BankNotifySystem::PhoneCall.new(selected_client_id, ask_phone_number, ask_call_time,
                                                     ask_call_duration, select_success_call, ask_comment)
    need_client = client_by_id(selected_client_id)
    need_client.add_client_phone_call(new_phone_call)
    puts 'Звонок добавлен'
  end

  def delete_phone_call
    selected_client_id = select_client_menu
    return if selected_client_id == :back_to_main

    selected_client = client_by_id(selected_client_id)

    selected_phone_call = select_call_menu(selected_client)
    return if selected_phone_call.is_a?(Symbol)

    confirm = @prompt.yes?('Вы действительно хотите удалить данный звонок?')
    selected_client.delete_client_call { |call| call == selected_phone_call } if confirm

    puts 'Звонок успешно удален!' if confirm
  end

  def show_client_list
    sort_field = select_sort_field

    sorted_clients = []
    case sort_field
    when :back_to_main
      nil
    when :sort_by_lex
      sorted_clients = sort_by_fio
    when :sort_by_amount_owed_down
      sorted_clients = sort_by_amount_owed.reverse!
    when :sort_by_amount_owed_up
      sorted_clients = sort_by_amount_owed
    else
      sorted_clients = sort_by_last_call_date
    end

    puts sorted_clients
  end

  def show_statistic_calls
    need_statistic = select_statistic_field

    case need_statistic
    when :back_to_main
      nil
    when :stat_by_success_call
      calls_by_success = count_calls_by_success
      puts "Количество успешных звонков: #{calls_by_success[1]}\n" \
           "Количество звонков, когда не дозвонились: #{calls_by_success[0]}"
    when :stat_by_call_time_avg
      return if count_calls.zero?

      puts "Средняя длительность звонка: #{seconds_to_hms(total_calls_duration / count_calls)} (Часов:Минут:Секунд)"
    else
      puts "Общая длительность всех звонков: #{seconds_to_hms(total_calls_duration)} (Часов:Минут:Секунд)"
    end
  end
end
