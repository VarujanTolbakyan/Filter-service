class CategoriesFilter < BaseFilter
  FIELDS = %i[name_query plugin_type].freeze

  define_params_fields_getters(FIELDS)

  def initialize(params, scope = Category)
    @params = params || {}
    @scope = scope
  end

  def result
    @result ||= chain_queries(relation, :filter_by_name, :filter_by_plugin_type, :order)
  end

  private

  def filter_by_name(relation)
    return relation unless name_query

    relation.where('name ILIKE :name', name: "%#{name_query}%")
  end

  def filter_by_plugin_type(relation)
    return relation unless plugin_type

    type = Type.find_by(name: plugin_type)

    relation.where(type: type)
  end

  def order(relation)
    relation.order(name: :asc)
  end
end

# Example
#
# CategoriesFilter.result({ name_query: 'some name', plugin_type: 'some type' }, Category.all)
# 
# filter result returns ActiveRecord::Relation
