# frozen_string_literal: true

require 'generator'

RSpec.describe Generator, '#perform' do
  subject { Generator.new(template_path, clauses, sections) }

  context 'when provided template path does not exist' do
    let(:template_path) { 'spec/fixtures/files/i_do_not_exist.txt' }
    let(:clauses) do
      [
        { 'id': 1, 'text': 'The quick brown fox' },
        { 'id': 2, 'text': 'jumps over the lazy dog' },
        { 'id': 3, 'text': 'And dies' },
        { 'id': 4, 'text': 'The white horse is white' }
      ]
    end
    let(:expected_document) { 'error: cannot find template file' }
    let(:sections) do
      [
        { 'id': 1, 'clauses_ids': [1, 2] }
      ]
    end

    it 'returns template not found error message' do
      expect(subject.perform).to eq expected_document
    end
  end

  context 'when provided invalid clauses' do
    let(:template_path) { 'spec/fixtures/files/template_00.txt' }
    let(:sections) do
      [
        { 'id': 1, 'clauses_ids': [1, 2] }
      ]
    end

    context 'and clauses is not an array' do
      let(:clauses) { 'invalid' }
      let(:expected_document) { 'error: invalid clauses' }

      it 'returns invalid clause message' do
        expect(subject.perform).to eq expected_document
      end
    end

    context 'and clauses hash is not in expected format' do
      let(:clauses) do
        [
          { 'wrong_key_1': 1, 'wrong_key_2': 'The quick brown fox' }
        ]
      end
      let(:expected_document) { 'error: invalid clause format' }

      it 'returns invalid clause format' do
        expect(subject.perform).to eq expected_document
      end
    end
  end

  context 'when provided invalid sections' do
    let(:template_path) { 'spec/fixtures/files/template_00.txt' }
    let(:clauses) do
      [
        { 'id': 1, 'text': 'The quick brown fox' },
        { 'id': 2, 'text': 'jumps over the lazy dog' },
        { 'id': 3, 'text': 'And dies' },
        { 'id': 4, 'text': 'The white horse is white' }
      ]
    end

    context 'and sections is not an array' do
      let(:expected_document) { 'error: invalid sections' }
      let(:sections) { 'invalid' }

      it 'returns invalid sections message' do
        expect(subject.perform).to eq expected_document
      end
    end

    context 'and section hash is not in expected format' do
      let(:expected_document) { 'error: invalid section format' }
      let(:sections) do
        [
          { 'id': 1, 'clauses_ids': 'worng_value' }
        ]
      end

      it 'returns invalid section format message' do
        expect(subject.perform).to eq expected_document
      end
    end
  end

  context 'when clause in template is missing in dataset' do
    let(:template_path) { 'spec/fixtures/files/template_00.txt' }
    let(:clauses) do
      [
        { 'id': 2, 'text': 'jumps over the lazy dog' },
        { 'id': 3, 'text': 'And dies' },
        { 'id': 4, 'text': 'The white horse is white' }
      ]
    end
    let(:expected_document) { 'error: undefined clause with id 1 in dataset' }
    let(:sections) do
      [
        { 'id': 1, 'clauses_ids': [1, 2] }
      ]
    end

    it 'generates undefined clause error' do
      expect(subject.perform).to eq expected_document
    end
  end

  context 'when provided valid template and dataset' do
    let(:template_path) { 'spec/fixtures/files/template_00.txt' }
    let(:clauses) do
      [
        { 'id': 1, 'text': 'The quick brown fox' },
        { 'id': 2, 'text': 'jumps over the lazy dog' },
        { 'id': 3, 'text': 'And dies' },
        { 'id': 4, 'text': 'The white horse is white' }
      ]
    end
    let(:expected_document) { File.read('spec/fixtures/files/expected_document_00.txt') }
    let(:sections) do
      [
        { 'id': 1, 'clauses_ids': [1, 2] }
      ]
    end

    it 'generates expected document' do
      expect(subject.perform).to eq expected_document
    end
  end
end
