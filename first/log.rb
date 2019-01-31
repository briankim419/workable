require 'pry'

access = File.open("../first/access.log")

average_load_time = []
status_404 = {}
database_count = {}
status_302_count = 0
status_503_count = 0

access.each do |line|
  if line.scan(/Load/).length != 0
    load_time = line[/[0-9]?([0-9].[0-9]ms)/].chomp("ms").to_f
    average_load_time << load_time
  end

  if !line[/FROM/].nil?
      database_name = line[/FROM "(.*?")/, 1]
    if database_name == nil
      database_name = line[/FROM (.*?) /, 1].delete"(\")"
    else
      database_name = line[/FROM "(.*?")/, 1].delete"(\")"
    end
    if database_count[database_name]
      database_count[database_name] += 1
    else
      database_count[database_name] = 1
    end
  end

  if !line[/JOIN/].nil?
    database_name = line[/JOIN "(.*?")/, 1]
  if database_name == nil
    database_name = line[/JOIN (.*?) /, 1].delete"(\")"
  else
    database_name = line[/JOIN "(.*?")/, 1].delete"(\")"
  end
    if database_count[database_name]
      database_count[database_name] += 1
    else
      database_count[database_name] = 1
    end
  end

  if line.scan(/status=404/).length != 0
    if !line[/path="(.*?)"/, 1].nil?
      url_path = "www.workabledemo.com" + line[/path="(.*?)"/, 1]
    else !line[/path=(.*?)format/, 1].nil?
      url_path = "www.workabledemo.com" + line[/path=(.*?)format/, 1].split(" ")[0]
    end

    if status_404.has_key?(url_path)
      status_404[url_path] += 1
    else
      status_404[url_path] = 1
    end
  end

  if line[/status=302/]
    status_302_count += 1
  end

  if line[/Service unavailable (503)/] || line[/status=503/]
    status_503_count += 1
  end

end

sum_of_load_time = 0
average_load_time.each do |time|
  sum_of_load_time += time
end
average = sum_of_load_time / average_load_time.length

puts average


# 1. List of URLs that were not found (404 error), including number of times each URL
# was requested
# 2. Average time to serve a page
# 3. Which database table is most frequently loaded?
# 4. Is any URL redirection taking place?
# 5. Are there any server errors? Ideas about possible causes?
    # database_name = line[/FROM (.*?) /, 1].delete"(\")"
    # answer_choices
# ‍‍.*? matches all the characters until the next pattern after .*? is found. But .* just matches all the characters.
