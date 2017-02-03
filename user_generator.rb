# coding UTF-8
def create_error(str, symbols)
  case rand(3)
  when 0
    str.insert(rand(str.size), symbols[rand(symbols.size)])
  when 1
    str[rand(str.size)] = symbols[rand(symbols.size)]
  when 2
    str.slice!(rand(str.size))
  end
end

def generator(item, locale)
  item = File.open("db/#{locale}/#{locale}_#{item}.txt").read
  item = item.split("\r\n")
end

def apartment_number
  if rand(2) > 0
    rand(1000).to_s.concat('-').concat(rand(1000).to_s)
  else
    rand(1000).to_s
  end
end

if ARGV.size != 3
  input_error = true
else
  if ['en.US', 'en.GB', 'ru.RU', 'by.BY'].include?(ARGV[0])
    locale = (ARGV[0][3] + ARGV[0][4]).downcase
  else
    input_error = true
  end
  if ARGV[1].to_i > 0 && ARGV[1].to_i < 10_000_001
    records_count = ARGV[1].to_i
  else
    input_error = true
  end
  if ARGV[2].to_f > 0
    errors_count = ARGV[2].to_f
  else
    input_error = true
  end
end
if input_error
  puts('wrong input ([lang.Locale],[recordCount],[errCount])')
  exit(0)
end

symbols = 'a'..'z'.to_a + '0'..'9'.to_a + 'A".."Z'.to_a
names = generator('names_m', locale)
surnames = generator('surnames_m', locale)
country = { 'us' => 'USA', 'gb' => 'Great Britain', 'ru' => 'Россия', 'by' => 'Беларусь' }
city = generator('cities', locale)
address = generator('streets', locale)
numbers = generator('numbers', locale)
arr_of_record = []

errors_count, error_count_for_record = errors_count.divmod(1)
if error_count_for_record.nonzero?
  error_count_for_record = (records_count * error_count_for_record).to_i
end
q_err = errors_count
current_count_of_error = 0
for i in 0..records_count do
  str = "#{names.sample} #{surnames.sample}; #{country[locale]}, #{city.sample}, #{address.sample}, #{apartment_number}, #{numbers.sample} "
  errors_count.times{ createError(str, symbols) }
  if rand(3) == 2 && current_count_of_error < error_count_for_record then
    createError(str, symbols)
    current_count_of_error += 1
  end
  puts str.lstrip

end

