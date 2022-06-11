# frozen_string_literal: true

class TemplateNotFoundError < StandardError; end
class InvalidClauseError < StandardError; end
class InvalidSectionError < StandardError; end
class UndefinedClauseError < StandardError; end

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
    load_template
    check_clauses
    check_sections

    # document generation
    replace_clauses
    replace_sections

    document
  end

  private

  def load_template
    raise TemplateNotFoundError unless File.exist?(template_path)

    @template = File.read(template_path)
    @document = template
  end

  def check_clauses
    raise InvalidClauseError, 'clause is of wrong type' unless clauses.is_a?(Array)

    clauses.each do |c|
      raise InvalidClauseError, 'invalid clause format' unless valid_clause?(c)
    end
  end

  def check_sections
    raise InvalidSectionError, 'section is of wrong type' unless sections.is_a?(Array)

    sections.each do |s|
      raise InvalidSectionError, 'invalid section format' unless valid_section?(s)
    end
  end

  def replace_clauses
    clauses.each { |c| @document.gsub!("[CLAUSE-#{c[:id]}]", c[:text]) }
  end

  def replace_sections
    sections.each do |s|
      formatted_section = format_section(s)

      @document.gsub!("[SECTION-#{s[:id]}]", formatted_section)
    end
  end

  def format_section(section)
    required_clauses = []

    section[:clauses_ids].each do |cid|
      selected_clauses = clauses.select { |c| c[:id] == cid }

      # section contains a non existent clause
      raise UndefinedClauseError, "clause #{cid} is undefined" if selected_clauses.empty?

      required_clauses << selected_clauses.first
    end

    required_clauses.compact.map { |c| c[:text] }.compact.join(';')
  end

  def valid_clause?(clause)
    clause.is_a?(Hash) && clause.key?(:id) && clause.key?(:text)
  end

  def valid_section?(section)
    section.is_a?(Hash) && section.key?(:id) && section[:clauses_ids].is_a?(Array)
  end
end
