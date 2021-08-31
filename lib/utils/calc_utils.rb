# frozen_string_literal: true

# Calculate any values module
module CalcUtils
  def client_by_id(client_id)
    @client_list.find { |client| client.id == client_id }
  end

  def delete_client_by_id(client_id)
    @client_list.delete_client_if { |client| client.id == client_id }
  end

  def count_calls_by_success
    @client_list.reduce({}) do |count_calls_hash, client|
      count_calls_hash.merge(client.count_status_calls_hash) do |_, old_value, new_value|
        old_value + new_value
      end
    end
  end

  def count_calls
    @client_list.reduce(0) do |sum, client|
      sum + client.count_calls
    end
  end

  def total_calls_duration
    @client_list.reduce(0) do |sum, client|
      sum + client.total_durations_calls
    end
  end

  def seconds_to_hms(sec)
    [sec / 3600, sec / 60 % 60, sec % 60].map { |t| t.to_s.rjust(2, '0') }.join(':')
  end
end
