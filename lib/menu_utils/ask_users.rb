# frozen_string_literal: true

# Module menu utils (tty prompt)
module MenuUtils
  def ask_fio
    @prompt.ask('Введите ФИО клиента') do |q|
      q.required true
      q.validate ->(val) { return val.match?(/\A\D*\z/) && val.length < 100 && val.split(' ').size >= 2 }
      q.messages[:valid?] = 'Некорректно указано ФИО'
    end
  end

  def ask_phone_number
    @prompt.ask('Введите номер телефона (ex: +79010523344)') do |q|
      q.required true
      q.validate(/\A[+]\d{1,4}\d{10}\z/)
      q.messages[:valid?] = 'Некорректно указан номер телефона'
    end
  end

  def ask_amount_owed
    @prompt.ask('Введите сумму долга клиента (ex: 1000.32)') do |q|
      q.required true
      q.validate(/\A\d+[.,]*\d*\z/)
      q.messages[:valid?] = 'Некорректно указана сумма долга'
      q.messages[:convert?] = 'Некорректно указана сумма долга'
      q.convert :float
    end
  end

  def ask_call_time
    @prompt.ask('Введите дату и время звонка (ex: 2021-02-23 18:34)') do |q|
      q.required true
      q.validate(/\A\d{4}(-\d{2}){2} \d{2}:\d{2}\z/)
      q.messages[:valid?] = 'Некорректная дата'
    end
  end

  def ask_call_duration
    @prompt.ask('Введите продолжительность звонка в секундах') do |q|
      q.required true
      q.validate(/\A\d{1,3}\z/)
      q.messages[:valid?] = 'Некорректная продолжительость звонка'
    end
  end

  def ask_comment
    @prompt.ask('Введите комментарий, если нужно') do |q|
      q.validate(/\A\w{,1000}\z/)
      q.messages[:valid?] = 'Слишком длинный комментарий'
    end
  end

  # Bad method, rubocop angry
  # def validate_datetime(val)
  #   datetime = val.split(' ')
  #   date = datetime[0].split('-')
  #   time = datetime[1].split(':')
  #
  #   if date[0].to_i >= 1901 && date[0].to_i <= 2021 &&
  #      date[1].to_i >= 1 && date[1].to_i <= 12 &&
  #      date[2].to_i >= 1 && date[2].to_i <= 31 &&
  #      time[0].to_i >= 0 && time[0].to_i <= 23 &&
  #      time[1].to_i >= 0 && time[1].to_i <= 59
  #     true
  #   end
  #   false
  # end
end
