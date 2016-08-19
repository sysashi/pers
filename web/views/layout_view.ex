defmodule Pers.LayoutView do
  use Pers.Web, :view

  def menu do
     ["home": "/",
      "about me": "/about",
      "notes archive": "/notes",
      "media": "/media"]
  end

  def active?(%Plug.Conn{path_info: []}, path) do
    if path == "" or path == "/" do
      :active
    end
  end

  def active?(%Plug.Conn{path_info: [path_fragment | _]}, path) do
    p = path
    |> String.downcase()
    |> String.trim_leading("/")

    if path_fragment == p do
      :active
    end
  end

  def title(%Plug.Conn{path_info: current_paths}, owner) do
    p = case current_paths do
      [] -> "Home"
      [h | _] -> String.capitalize(h)
    end

    p <> " - #{owner}'s website"
  end
end
