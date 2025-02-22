module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  def render_index_doc_actions(document, options = {})
    wrapping_class = options.delete(:wrapping_class) || 'documentFunctions'

    content = []
    content << render(
      partial: 'catalog/bookmark_control',
      locals: { document: document }.merge(options)
    ) if has_user_authentication_provider? && current_or_guest_user
    content_tag('div', content.join("\n").html_safe, class: wrapping_class)
  end

  def render_show_doc_actions(document = @document, options = {})
    content = []
    content << render(
      partial: 'catalog/bookmark_control',
      locals: { document: document }.merge(options)
    ) if has_user_authentication_provider? && current_or_guest_user
    content_tag('div', content.join('\n').html_safe, class: 'documentFunctions')
  end

  def link_to_saved_search(params)
    label = title_to_saved_search(params)
    link_to(raw(label), search_catalog_path(params.symbolize_keys)).html_safe
  end

  def title_to_saved_search(params)
    params[:mode] = params[:mode].presence || 'objects'

    "#{params[:mode].to_s.capitalize} (" + [render_search_to_s_q(params), render_search_to_s_filters(params)].reject { |value| value.blank? }.join(", ") + ")"
  end

  # Create a link back to the index screen, keeping the user's facet, query and paging choices intact by using session.
  # @example
  #   link_back_to_catalog(label: 'Back to Search')
  #   link_back_to_catalog(label: 'Back to Search', route_set: my_engine)
  def link_back_to_catalog(opts = { label: nil })
    scope = opts.delete(:route_set) || self
    query_params = current_search_session.try(:query_params) || {}

    if search_session['counter']
      per_page = (search_session['per_page'] || default_per_page).to_i
      counter = search_session['counter'].to_i

      query_params[:per_page] = per_page unless search_session['per_page'].to_i == default_per_page
      query_params[:page] = ((counter - 1) / per_page) + 1
    end

    link_url = if query_params.empty?
                 search_action_path(only_path: true)
               else
                 scope.url_for(query_params)
               end
    label = opts.delete(:label)

    if link_url =~ /bookmarks/
      label ||= t('blacklight.back_to_bookmarks')
    elsif link_url =~ /collections/
      opts[:label] ||= t('blacklight.back_to_collection')
    end

    label ||= t('blacklight.back_to_search')

    link_to label, link_url, opts
  end

  ##
  # Determine whether to render a given field in the show view
  #
  # @param [SolrDocument] document
  # @param [Blacklight::Solr::Configuration::SolrField] solr_field
  # @return [Boolean]
  def should_render_show_field?(document, solr_field)
    field_presenter = Blacklight::FieldPresenter.new(self, document, solr_field)

    unless solr_field.field.include?('description')
      return field_presenter.render_field? && field_presenter.any?
    end

    field_no_tesim = solr_field.field.gsub('_tesim', '')
    split_fields = field_no_tesim.split(/\s*_\s*/)
    if ISO_639.find(split_fields[-1]).nil?
      if (!document[split_fields.join('_') << '_gle_tesim'].nil?)
        return false
      else
        field_presenter.render_field? && field_presenter.any?
      end
    elsif ISO_639.find(split_fields[-1]).include?('eng')
      split_fields.pop
      if !document[split_fields.join('_') << '_gle_tesim'].nil?
        field_presenter.render_field? && field_presenter.any?
      else
        return false
      end
    else
      field_presenter.render_field? && field_presenter.any?
    end
  end

  def query_has_workspace_constraints?(localized_params = params)
    !(localized_params[:q_ws].blank? and localized_params[:f].blank?)
  end

  def render_workspace_constraints_query(localized_params = params)
    # So simple don't need a view template, we can just do it here.
    scope = localized_params.delete(:route_set) || self
    return "".html_safe if localized_params[:q_ws].blank?

    options = localized_params.merge(q_ws: nil, action: 'index')
    options.permit!
    render_constraint_element(
	  constraint_query_label(localized_params),
          localized_params[:q_ws],
          classes: ["query"],
          remove: scope.url_for(options)
    )
  end

  def search_fields_from_config
    @search_fields_from_config ||= blacklight_config.search_fields.values
                                        .select { |field_def| should_render_field?(field_def) }
                                        .collect { |field_def| [label_for_search_field(field_def.key), field_def.key] }
  end

  # @param [Array<Array>] fields
  # @return [Array] blacklight search fields which can be displayed
  def display_search_fields(fields = search_fields_from_config)
    fields.select do |(label, value)|
      blacklight_config.dri_display_search_fields.include?(value.to_sym)
    end
  end

  # @param [Array<Array>] fields
  # @return [Array] translated fields
  def translated_search_fields(fields = search_fields_from_config)
    fields.map do |(label, value)|
      # if translation doesn't exist, fall back to blacklight label
      [t("blacklight.search.fields.label.#{value.pluralize}", default: label), value]
    end
  end

  # @param [Hash<string, config>] fields
  # @return [Hash<string, config>]
  # has side effect of adding translated_label to search_fields_for_advanced_search reference
  # TODO look into making search_fields_for_advanced_search immutable, or removing this side effect
  def translated_search_fields_for_advanced_search(fields = search_fields_for_advanced_search)
    fields.map do |key, field_def|
      trans_key = "blacklight.search.fields.label.#{field_def.field.pluralize}"
      translated_label = t(trans_key, default: field_def.label)
      field_def.translated_label = translated_label
      [key, field_def]
    end.to_h
  end
end
