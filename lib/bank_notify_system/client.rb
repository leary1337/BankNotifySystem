# frozen_string_literal: true

module BankNotifySystem
  # Class client of bank_notify_system
  class Client
    attr_reader :id
    attr_accessor :fio, :phone_number, :amount_owed

    def initialize(id, fio, phone_number, amount_owed, calls_history = PhoneCallList.new)
      @id = id.to_i
      @fio = fio
      @phone_number = phone_number
      @amount_owed = amount_owed.to_f
      @calls_history = calls_history
    end

    def client_last_call
      @calls_history.last_call
    end

    def each_by_call(&block)
      @calls_history.each(&block)
    end

    def count_status_calls_hash
      @calls_history.map(&:is_success_call).tally
    end

    def count_calls
      @calls_history.count
    end

    def total_durations_calls
      @calls_history.reduce(0) { |s, call| s + call.call_duration }
    end

    def add_client_phone_call(new_phone_call)
      @calls_history.add_phone_call(new_phone_call)
    end

    def delete_client_call(&block)
      @calls_history.delete_call(&block)
    end

    def to_s
      last_call_time = client_last_call
      last_call_time = last_call_time.nil? ? 'Нет звонков' : last_call_time.call_time
      "##{@id} #{@fio}; #{@phone_number}; Сумма долга: #{@amount_owed}; Дата последнего звонка: #{last_call_time}"
    end
  end
end
