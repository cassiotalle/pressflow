#!/usr/bin/env ruby
t = Time.now

#same = [['name-a','name-b'],['mr fred','fred']]
same = []
pipe = open('|git log --pretty=format:"A:%an" --shortstat --no-merges')
author = "unknown"
stats = {}

loop do
  line = pipe.readline rescue break
  if line =~ /^A\:(.*)$/
    author = $1
    found = same.detect{|a| a.include?(author)}
    author = found.first if found
    next
  end
  if line =~ /files changed, (\d+) insertions\(\+\), (\d+) deletions/
    stats[author] ||= Hash.new(0)
    stats[author]['+']+=$1.to_i
    stats[author]['-']+=$2.to_i
    print '.'
  end
end

puts "\nGit scores (in LOC):"
puts stats.sort_by{|a,d| -d['+'] }.map{|author, data| "#{author.ljust(20)}: +#{data['+'].to_s.ljust(10)} -#{data['-'].to_s.ljust(10)} " } * "\n"

