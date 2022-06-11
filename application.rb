# frozen_string_literal: true

require 'json'
require_relative 'lib/generator'

abort('Cannot find template file') unless File.exist? ARGV[0]
abort('Cannot find clauses file') unless File.exist? ARGV[1]
abort('Cannot find sections file') unless File.exist? ARGV[2]

clauses_file = File.read ARGV[1]
clauses = JSON.parse clauses_file, symbolize_names: true

sections_file = File.read ARGV[2]
sections = JSON.parse sections_file, symbolize_names: true

begin
  generator = Generator.new(ARGV[0], clauses, sections)
  puts generator.perform
rescue => e
  puts e.message
end
