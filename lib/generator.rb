# frozen_string_literal: true

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
  end

  private

  def load_template
    return false unless File.exist?(template_path)

    @template = File.read(template_path)
  end
end
