defmodule AddonRetriever do
  defdelegate find_version(), to: AddonRetriever.VersionRetriever, as: :find_version
end
