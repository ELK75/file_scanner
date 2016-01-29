require "open-uri"

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end


Dir.chdir("/home/ek/")
file_hash = Hash.new([0, 0])
Dir.glob("**/*").each do |sub_file|
	current_key = file_hash[File.extname(sub_file)]
	current_count = current_key[0] + 1
	number_of_bytes = File.size(sub_file)
	current_bytes = current_key[1] + number_of_bytes
	file_hash[File.extname(sub_file)] = [current_count, current_bytes]
end

file_hash.delete("")

text_file = "/home/ek/Odin_Project/Ruby Projects/TextAnalyzer/text.txt"

File.open(text_file, "w") do |f|
	f.puts "Filetype             Count               Bytes"
	file_hash.each do |type, number|
		count_indent = ' '*(20-type.length)
		byte_indent = ' '*(20-number[0].to_s.length)
		f.puts "#{type}:#{count_indent}#{number[0]}#{byte_indent}#{number[1]}"
	end
end

percentages = Hash.new(0)
total_files = 0
file_hash.each {|key, val| total_files += val[0]}
file_hash.each do |file_type, file_info|
	number_of_files = file_info[0]
	percent = number_of_files.percent_of(total_files)
	percentages[file_type] = percent
end

file_array = []
percent_array = []
percentages.each do |key, val| 
	file_array.push(key)
	percent_array.push(val)
end

url = "https://chart.googleapis.com/chart?cht=p&chd=t:#{percent_array.join(",")}&chs=500x300&chl=#{file_array.join("|")}"

open(url) do |f|
	image_storage_path = "/home/ek/Odin_Project/Ruby Projects/TextAnalyzer/google_api.png"
	File.open(image_storage_path,"wb") do |file|
		file.puts f.read
	end
end