defmodule AddonRetriever.VersionRetriever do

  def find_version() do
    HTTPoison.get("https://git.tukui.org/api/v4/projects/495/repository/tags")
    |> process_tag_call()
  end

  defp process_tag_call({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Poison.decode(body)
    |> get_version_from_tags()
  end
  defp process_tag_call(_), do: {:error, :request_error}

  defp get_version_from_tags({:ok, body}) do
    body
    |> Enum.map(&(Map.get(&1, "name")))
    |> Enum.reduce(
      {:error, :no_tag_found},
       fn tag, accumulator -> compare_two_versions({:ok, tag}, accumulator) end
    )
  end
  defp get_version_from_tags(_), do: {:error, :invalid_body}

  defp compare_two_versions(left, {:error, _}), do: left
  defp compare_two_versions({:error, _}, right), do: right
  defp compare_two_versions(left = {:ok, "v" <> left_version}, right = {:ok, "v" <> right_version}) do
    left_formatted = Float.parse(left_version)
    right_formatted = Float.parse(right_version)

    if left_formatted >= right_formatted, do: left, else: right
  end

end
