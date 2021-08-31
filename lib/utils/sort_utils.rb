# frozen_string_literal: true

# Sort by any conditions
module SortUtils
  def sort_by_fio
    @client_list.sort_by(&:fio)
  end

  def sort_by_amount_owed
    @client_list.sort_by(&:amount_owed)
  end

  def sort_by_last_call_date
    @client_list.sort_by { |client| client.client_last_call.nil? ? '0' : client.client_last_call }.reverse!
  end
end
