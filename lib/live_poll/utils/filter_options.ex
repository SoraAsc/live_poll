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
      %{id: 1, name: "Food"},
      %{id: 3, name: "Movie"},
      %{id: 5, name: "Book"},
    ]
  end
end
