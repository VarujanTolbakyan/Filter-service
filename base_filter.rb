# frozen_string_literal: true

class BaseFilter
  attr_reader :params, :scope

  class << self
    def result(*args)
      new(*args).result
    end

    def define_params_fields_getters(fields)
      fields.each do |field|
        define_method(field) do
          params[field].presence
        end
      end
    end
  end

  private

  def chain_queries(relation, *method_names)
    method_names.each do |m|
      relation = send(m, relation)
    end
    relation
  end

  def relation
    scope.all
  end

  def none_relation
    relation.none
  end
end
