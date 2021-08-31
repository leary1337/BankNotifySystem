# frozen_string_literal: true

# Module Bank operator
module BankNotifySystem
  # Class phone call list of objects PhoneCall class
  class PhoneCallList
    include Enumerable

    def initialize
      @phone_call_list = []
    end

    def each(&block)
      @phone_call_list.each(&block)
    end

    def last_call
      @phone_call_list.max
    end

    def delete_call(&block)
      @phone_call_list.delete_if(&block)
    end

    def add_phone_call(phone_call)
      @phone_call_list.append(phone_call)
    end
  end
end
