defmodule Pers.ModelHelpers do
  require Pers.Web
  Pers.Web.common

  def publish do
    quote do
     def publish(changeset, params) do
       published_at = get_field(changeset, :published_at)
       publish? = get_change(changeset, :published)

       cond do
         !published_at && publish? ->
           changeset
           |> put_change(:published_at, Ecto.DateTime.utc)
         published_at && !publish? ->
           changeset
           |> put_change(:published_at, nil)
         true ->
           changeset
       end
     end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
