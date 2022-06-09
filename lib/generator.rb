# frozen_string_literal: true

# Generates a document from a template and dataset
class Generator
  attr_reader :template_path, :template, :clauses, :sections, :document

  def initialize(template_path, clauses, sections)
    @template_path = template_path
    @clauses = clauses
    @sections = sections
  end

  def perform
    # data validation
    return document unless load_template
    return document unless check_clauses
    return document unless check_sections

    # document generation
    return document unless replace_clauses
    return document unless replace_sections

    document
  end

  private

  def load_template
    unless File.exist?(template_path)
      @document = 'error: cannot find template file'
      return false
    end

    @template = File.read(template_path)
    @document = template

    true
  end

  def check_clauses
    unless clauses.is_a?(Array)
      @document = 'error: invalid clauses'
      return false
    end

    clauses.each do |c|
      return false unless c.is_a?(Hash)
      return false if c[:id].nil?
      return false if c[:text].nil?
    end

    true
  end

  def check_sections
    unless sections.is_a?(Array)
      @document = 'error: invalid sections'
      return false
    end

    sections.each do |c|
      return false unless c.is_a?(Hash)
      return false if c[:id].nil?
      return false unless c[:clauses_ids].is_a?(Array)
    end

    true
  end

  def replace_clauses
    clauses.each { |c| @document.gsub!("[CLAUSE-#{c[:id]}]", c[:text]) }

    true
  end

  def replace_sections
    sections.each do |s|
      formatted_section = format_section(s)
      return false if formatted_section.nil?

      @document.gsub!("[SECTION-#{s[:id]}]", formatted_section)
    end

    true
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
