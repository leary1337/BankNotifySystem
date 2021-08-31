# frozen_string_literal: true

# Module menu utils (tty prompt)
module MenuUtils
  def select_main_menu
    main_menu_choices = [
      { name: 'Добавить клиента', value: :create_client },
      { name: 'Удалить клиента', value: :delete_client },
      { name: 'Поиск клиента по номеру телефона или ФИО', value: :search_client },
      { name: 'Обновить информацию о клиенте', value: :update_client },
      { name: 'Добавить информацию о звонке', value: :add_phone_call },
      { name: 'Удалить информацию о звонке', value: :delete_phone_call },
      { name: 'Вывести на экран список клиентов', value: :show_client_list },
      { name: 'Вывести на экран статистику звонков', value: :show_statistic_calls },
      { name: 'Завершить работу', value: :exit }
    ]
    @prompt.select('Выберите действие', main_menu_choices, cycle: true, enum: ')')
  end

  def select_client_field
    change_fields = [
      { name: 'ФИО', value: :change_fio },
      { name: 'Номер телефона', value: :change_phone },
      { name: 'Сумма долга', value: :change_amount_owed },
      { name: 'Вернуться в главное меню', value: :back_to_main }
    ]
    @prompt.select('Выберите поле', change_fields)
  end

  def select_client_menu
    array_of_clients = []
    @client_list.each do |client|
      array_of_clients.append({ name: client.to_s, value: client.id })
    end
    array_of_clients.append({ name: 'Вернуться в главное меню', value: :back_to_main })
    @prompt.select('Выберите клиента', array_of_clients)
  end

  def select_call_menu(client)
    array_of_calls = []
    client.each_by_call do |call|
      array_of_calls.append({ name: call.to_s, value: call })
    end
    array_of_calls.append({ name: 'Вернуться в главное меню', value: :back_to_main })
    @prompt.select('Выберите звонок', array_of_calls)
  end

  def select_search_client_field
    search_fields = [
      { name: 'ФИО', value: :search_by_fio },
      { name: 'Номер телефона', value: :search_by_phone },
      { name: 'Вернуться в главное меню', value: :back_to_main }
    ]
    @prompt.select('Выберите поле по которому будем искать клиента', search_fields)
  end

  def select_success_call
    success_call_fields = [
      { name: 'Да', value: 1 },
      { name: 'Нет', value: 0 }
    ]
    @prompt.select('Удалось дозвониться?', success_call_fields)
  end

  def select_sort_field
    sort_fields = [
      { name: 'В лексикографическом порядке', value: :sort_by_lex },
      { name: 'В порядке убывания долга', value: :sort_by_amount_owed_down },
      { name: 'В порядке возрастания долга', value: :sort_by_amount_owed_up },
      { name: 'По дате последнего звонка', value: :sort_by_date_last_call },
      { name: 'Вернуться в главное меню', value: :back_to_main }
    ]
    @prompt.select('В каком порядке вывести?', sort_fields)
  end

  def select_statistic_field
    statistic_fields = [
      { name: 'Количество звонков для каждого статуса дозвона', value: :stat_by_success_call },
      { name: 'Средняя длительность звонка', value: :stat_by_call_time_avg },
      { name: 'Общая длительность всех звонков', value: :stat_by_total_call_time },
      { name: 'Вернуться в главное меню', value: :back_to_main }
    ]
    @prompt.select('Выберите статистику, которую нужно показать', statistic_fields)
  end
end
