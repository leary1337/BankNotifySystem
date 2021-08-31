# frozen_string_literal: true

module BankNotifySystem
  # Class phone call
  class PhoneCall
    include Comparable

    attr_reader :call_time, :is_success_call, :call_duration

    def initialize(client_id, phone_number, call_time, call_duration, is_success_call, comment)
      @client_id = client_id.to_i
      @phone_number = phone_number
      @call_time = call_time
      @call_duration = call_duration.to_i
      @is_success_call = is_success_call.to_i
      @comment = comment.nil? ? '' : comment
    end

    def <=>(other)
      return 1 if other == '0'

      convert_datetime_string <=> other.convert_datetime_string
    end

    def convert_datetime_string
      @call_time.sub(/(\d+)-(\d+)-(\d+) (\d+):(\d+)/) do
        format('%<year>4d%<mth>02d%<day>02d%<hour>02d%<min>02d',
               year: Regexp.last_match(1), mth: Regexp.last_match(2),
               day: Regexp.last_match(3), hour: Regexp.last_match(4), min: Regexp.last_match(5)).to_i
      end
    end

    def to_s
      "Клиент ##{@client_id}, #{@phone_number}, " \
      "#{@call_time}, Продолжительность: #{@call_duration} сек, " \
      "Статус дозвона: #{@is_success_call}, Комментарий: #{@comment}"
    end
  end
end
