
# !/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Amelia Getty
# gettyamelia@gmail.com
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = 'Amelia Getty'

def cleanup_title(str)
  extract = /%.{41}.*<SEP>/
  extracted = str.gsub(extract, '')
  superfluous = /(feat.)?[_\-`+=\(\[\{\\\/:\"\*].*/
  unsuperfluous = extracted.gsub(superfluous, '')
  punctuation = /[\?¿!¡\.;&@%#|]/
  title = unsuperfluous.gsub(punctuation, '')
  foreign = /[^\x00-\x7F]/
  if foreign =~ title
    title = ''
  else
    title = title.downcase
    count_bigrams title
  end
  title
end

def count_bigrams(str)
  song = str.split(/\s/)
  i = 0
  if song.length > 1
    until i == song.length - 1
      word = song[i]
      i += 1
      word2 = song[i]
      if $bigrams.key?(word)
        if $bigrams[word].key?(word2)
          $bigrams[word][word2] += 1
        else
          $bigrams[word][word2] = 1
        end
      else
        $bigrams[word] = {word2 => 1}
      end
    end
  end
end

def mcw(word)
  if $bigrams.key?(word)
    most_common = 'most common word'
    highest_value = 0
    $bigrams[word].each do |key, value|
      if value >= highest_value
        highest_value = value
        most_common = key
      end
    end
    most_common
  else
    none = 'none'
  end
end

# function to process each line of a file and extract the song titles
def process_file(file_name)
  puts 'Processing File.... '

  begin
    if RUBY_PLATFORM.downcase.include? 'mswin'
      file = File.open(file_name)
      unless file.eof?
        file.each_line do |line|
          title = cleanup_title line
        end
      end
      puts $bigrams
      puts mcw('love')
      file.close
    else
      IO.foreach(file_name, encoding: 'utf-8') do |line|
        title = cleanup_title line
      end
      puts $bigrams
      puts mcw('love')
    end

    puts "Finished. Bigram model built.\n"
  rescue
    STDERR.puts 'Could not open file'
    exit 4
  end
end

# Executes the program
def main_loop
  puts "CSCI 305 Ruby Lab submitted by #{$name}"

  if ARGV.empty?
    puts 'You must specify the file name as the argument.'
    exit 4
  end

  # process the file
  process_file(ARGV[0])

  # Get user input
end

if __FILE__== $0
  main_loop
end
