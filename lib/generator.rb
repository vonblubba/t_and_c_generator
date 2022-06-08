# frozen_string_literal: true

require 'pry'

# Generates a document from a template and dataset
class Generator
  attr_reader :template_path, :template, :clauses, :sections, :document

  def initialize(template_path, clauses, sections)
    @template_path = template_path
    @clauses = clauses
    @sections = sections
  end

  def perform
    return 'error: cannot find template file' unless load_template
    return 'error: invalid clauses' unless check_clauses
    return 'error: invalid sections' unless check_sections

    replace_clauses
    replace_sections

    document
  end

  private

  def load_template
    return false unless File.exist?(template_path)

    @template = File.read(template_path)
  end

  def check_clauses
    return false unless clauses.is_a?(Array)

    clauses.each do |c|
      return false unless c.is_a?(Hash)
      return false if c[:id].nil?
      return false if c[:text].nil?
    end

    true
  end

  def check_sections
    return false unless sections.is_a?(Array)

    sections.each do |c|
      return false unless c.is_a?(Hash)
      return false if c[:id].nil?
      return false unless c[:clauses_ids].is_a?(Array)
    end

    true
  end

  def replace_clauses
    @document = template

    clauses.each { |c| @document.gsub!("[CLAUSE-#{c[:id]}]", c[:text]) }
  end

  def replace_sections
    sections.each do |s|
      formatted_section = format_section(s)
      return false if formatted_section.nil?

      @document.gsub!("[SECTION-#{s[:id]}]", formatted_section)
    end
  end

  def format_section(section)
    required_clauses = []

    section[:clauses_ids].each do |cid|
      selected_clauses = clauses.select { |c| c[:id] == cid }

      # section contains a non existent clause
      if selected_clauses.empty?
        @document = "error: undefined clause with id #{cid} in dataset"
        return nil
      end

      required_clauses << selected_clauses.first
    end

    required_clauses.compact.map { |c| c[:text] }.compact.join(';')
  end
end
