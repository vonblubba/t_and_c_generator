# frozen_string_literal: true

require 'pry'

# Generates a document from a template and dataset
class Generator
  attr_reader :template_path, :template, :clauses, :sections

  def initialize(template_path, clauses, sections)
    @template_path = template_path
    @clauses = clauses
    @sections = sections
  end

  def perform
    return 'error: cannot find template file' unless load_template
    return 'error: invalid clauses' unless check_clauses
    return 'error: invalid sections' unless check_sections
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
end
