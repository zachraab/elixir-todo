defmodule ToDoListWeb.ErrorHTML do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on HTML requests.

  See config/config.exs.
  """
  use ToDoListWeb, :html

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/to_do_list_web/controllers/error_html/404.html.heex
  #   * lib/to_do_list_web/controllers/error_html/500.html.heex
  #
  # embed_templates "error_html/*"

  # The default is to render a plain text page based on
  # the template name. For example, "404.html" becomes
  # "Not Found".
  embed_templates "error_html/*"

  def render(template, assigns) do
    case template do
      "404.html" -> render("404", assigns)
      _ -> Phoenix.Controller.status_message_from_template(template)
    end
  end
end
