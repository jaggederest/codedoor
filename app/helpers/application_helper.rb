module ApplicationHelper
  def model_has_error?(model, attribute)
    model.errors.has_key?(attribute)
  end

  def model_attribute_class(model, attribute)
    model_has_error?(model, attribute) ? 'error' : ''
  end

  # TODO: Create better way to aggregate error messages (custom_error_messages does not lend itself to inline errors)
  def model_error_message(model, attribute)
    return '' unless model_has_error?(model, attribute)
    full_messages = model.errors.messages[attribute].select{|m| m.first == '^'}.map{|m| m[1..-1]}
    other_messages = model.errors.messages[attribute].reject{|m| m.first == '^'}
    other_messages_text = other_messages.empty? ? '' : "#{attribute.to_s.humanize} #{other_messages.to_sentence}."
    "#{full_messages.join(' ')} #{other_messages_text}"
  end

  def repo_commits_url(username, repo_owner, repo_name)
    "https://github.com/#{repo_owner}/#{repo_name}/commits?author=#{username}"
  end

  def repo_commits_link(username, repo_owner, repo_name, text)
    link_to(text, repo_commits_url(username, repo_owner, repo_name), target: '_blank')
  end
end
