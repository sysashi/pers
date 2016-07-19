defmodule Pers.ErrorView do
  use Pers.Web, :view

  # code seen in hex_web/web/views/error_view.ex
  def render(<<status::binary-3>> <> ".html", assigns) do
    render "error.html", 
      message: message(status),
      status: status,
      conn: assigns.conn
  end

  # Json errors
  def render(<<status::binary-3>> <> ".json", assigns) do
    assigns
    |> Map.take([:message, :errors]) # ensure to take subset of a map
    |> Map.put(:status, String.to_integer(status))
    |> Map.put_new(:message, message(status))
  end


  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end

  defp message("500") do
   "Internal server error" 
  end
  defp message("404") do
    "Page not found"
  end
  defp message(_) do
    message("500")
  end
end
