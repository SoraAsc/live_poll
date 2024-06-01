defmodule LivePoll.Utils.FilterOptions do
  def filter_names do
    [
      %{id: 0, name: "Name"},
      %{id: 1, name: "Date"},
      %{id: 2, name: "Vote"},
    ]
  end

  def categories do
    [
      %{id: 0, name: "Food"},
      %{id: 1, name: "Movie"},
    ]
  end
end
