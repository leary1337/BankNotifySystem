# frozen_string_literal: true

require 'json'
require_relative 'client'
require_relative 'phone_call_list'
require_relative 'phone_call'

module BankNotifySystem
  # Class client list of objects Client class
  class ClientList
    include Enumerable

    def initialize
      @client_list = []
    end

    def add_client(client)
      @client_list.append(client)
    end

    def delete_client_if(&block)
      @client_list.delete_if(&block)
    end

    def each(&block)
      @client_list.each(&block)
    end

    def load_from_file(path_to_json)
      json_data = File.read(path_to_json, encoding: 'utf-8')
      client_objects = JSON.parse(json_data)
      client_objects.each do |client|
        client_id = last_client_id + 1
        calls_history = read_phone_calls(client_id, client['phone_calls'])
        new_client = Client.new(client_id, client['fio'], client['phone_number'], client['amount_owed'], calls_history)
        add_client(new_client)
      end
    end

    def read_phone_calls(client_id, phone_calls)
      phone_call_list = PhoneCallList.new
      phone_calls.each do |call|
        new_phone_call = PhoneCall.new(client_id, call['phone_number_call'], call['call_time'],
                                       call['call_duration_sec'], call['success_call'], call['comment'])
        phone_call_list.add_phone_call(new_phone_call)
      end
      phone_call_list
    end

    def last_client_id
      @client_list.empty? ? 0 : @client_list[-1].id
    end
  end
end
