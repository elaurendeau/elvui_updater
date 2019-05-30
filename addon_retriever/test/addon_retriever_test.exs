defmodule AddonRetrieverTest do
  use ExUnit.Case, async: false

  import Mock

  test "get an invalid response because of http poison error" do
    with_mock HTTPoison,
        [get: fn(_url) -> return_http_poison_error() end] do
      assert AddonRetriever.find_version() == {:error, :request_error}
    end
  end
  test "get a 404 response" do
    with_mock HTTPoison,
        [get: fn(_url) -> return_valid_404_http_poison_response() end] do
      assert AddonRetriever.find_version() == {:error, :request_error}
    end
  end
  test "get a reponse without any tags" do
    with_mock HTTPoison,
        [get: fn(_url) -> return_valid_no_tag_http_poison_response() end] do
      assert AddonRetriever.find_version() == {:error, :no_tag_found}
    end
  end
  test "get a valid addon version" do
    with_mock HTTPoison,
        [get: fn(_url) -> return_valid_http_poison_response() end] do
      assert AddonRetriever.find_version() == {:ok, "v11.11"}
    end
  end

  defp return_valid_404_http_poison_response() do
    {:ok,
    %HTTPoison.Response{
      body: "<!DOCTYPE html>\n<html lang=en>\n  <meta charset=utf-8>\n  <meta name=viewport content=\"initial-scale=1, minimum-scale=1, width=device-width\">\n  <title>Error 404 (Not Found)!!1</title>\n  <style>\n    *{margin:0;padding:0}html,code{font:15px/22px arial,sans-serif}html{background:#fff;color:#222;padding:15px}body{margin:7% auto 0;max-width:390px;min-height:180px;padding:30px 0 15px}* > body{background:url(//www.google.com/images/errors/robot.png) 100% 5px no-repeat;padding-right:205px}p{margin:11px 0 22px;overflow:hidden}ins{color:#777;text-decoration:none}a img{border:0}@media screen and (max-width:772px){body{background:none;margin-top:0;max-width:none;padding-right:0}}#logo{background:url(//www.google.com/images/branding/googlelogo/1x/googlelogo_color_150x54dp.png) no-repeat;margin-left:-5px}@media only screen and (min-resolution:192dpi){#logo{background:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) no-repeat 0% 0%/100% 100%;-moz-border-image:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) 0}}@media only screen and (-webkit-min-device-pixel-ratio:2){#logo{background:url(//www.google.com/images/branding/googlelogo/2x/googlelogo_color_150x54dp.png) no-repeat;-webkit-background-size:100% 100%}}#logo{display:inline-block;height:54px;width:150px}\n  </style>\n  <a href=//www.google.com/><span id=logo aria-label=Google></span></a>\n  <p><b>404.</b> <ins>That’s an error.</ins>\n  <p>The requested URL <code>/oisdjfoisjdf</code> was not found on this server.  <ins>That’s all we know.</ins>\n",
      headers: [
        {"Content-Type", "text/html; charset=UTF-8"},
        {"Referrer-Policy", "no-referrer"},
        {"Content-Length", "1573"},
        {"Date", "Thu, 30 May 2019 22:00:00 GMT"}
      ],
      request: %HTTPoison.Request{
        body: "",
        headers: [],
        method: :get,
        options: [],
        params: %{},
        url: "http://www.google.ca/oisdjfoisjdf"
      },
      request_url: "http://www.google.ca/oisdjfoisjdf",
      status_code: 404
    }}
  end
  defp return_http_poison_error(), do: {:error, %HTTPoison.Error{id: nil, reason: :closed}}
  defp return_valid_no_tag_http_poison_response() do
    {:ok,
    %HTTPoison.Response{
      body: "[]",
      headers: [
        {"Date", "Thu, 30 May 2019 20:57:14 GMT"},
        {"Server", "Apache/2.4.25"},
        {"Cache-Control", "max-age=0, private, must-revalidate"},
        {"Content-Length", "12681"},
        {"Content-Type", "application/json"},
        {"Etag", "W/\"4db49696648de186fe110f7505e0a10a\""},
        {"Link",
         "<https://git.tukui.org/api/v4/projects/495/repository/tags?id=495&order_by=updated&page=1&per_page=20&sort=desc>; rel=\"first\", <https://git.tukui.org/api/v4/projects/495/repository/tags?id=495&order_by=updated&page=1&per_page=20&sort=desc>; rel=\"last\""},
        {"Vary", "Origin"},
        {"X-Content-Type-Options", "nosniff"},
        {"X-Frame-Options", "SAMEORIGIN"},
        {"X-Next-Page", ""},
        {"X-Page", "1"},
        {"X-Per-Page", "20"},
        {"X-Prev-Page", ""},
        {"X-Request-Id", "Y21Gia3QLN2"},
        {"X-Runtime", "0.066506"},
        {"X-Total", "20"},
        {"X-Total-Pages", "1"},
        {"Strict-Transport-Security", "max-age=15768000;includeSubdomains"}
      ],
      request: %HTTPoison.Request{
        body: "",
        headers: [],
        method: :get,
        options: [],
        params: %{},
        url: "https://git.tukui.org/api/v4/projects/495/repository/tags"
      },
      request_url: "https://git.tukui.org/api/v4/projects/495/repository/tags",
      status_code: 200
    }}
  end
  defp return_valid_http_poison_response() do
    {:ok,
    %HTTPoison.Response{
      body: "[{\"name\":\"v11.11\",\"message\":\"\",\"target\":\"41ec2f0f9366ee8d52df504e40dc15742c9448cd\",\"commit\":{\"id\":\"f060f6a6b541f14364a7f0d898898925e37efc26\",\"short_id\":\"f060f6a6\",\"created_at\":\"2019-05-15T02:06:15.000Z\",\"parent_ids\":[\"a2b4e0c4720156aa64360bb39ae7f0f30a7aa699\",\"6075cbbe7fe637034b864439651e99ea529f9fe9\"],\"title\":\"Merge branch 'development'\",\"message\":\"Merge branch 'development'\\n\",\"author_name\":\"Simpy\",\"author_email\":\"kodi03466@hotmail.com\",\"authored_date\":\"2019-05-15T02:06:15.000Z\",\"committer_name\":\"Simpy\",\"committer_email\":\"kodi03466@hotmail.com\",\"committed_date\":\"2019-05-15T02:06:15.000Z\"},\"release\":null},{\"name\":\"v11.10\",\"message\":\"\",\"target\":\"e116c95be44e44ddf4b11fb00285a3fa35f793de\",\"commit\":{\"id\":\"a2b4e0c4720156aa64360bb39ae7f0f30a7aa699\",\"short_id\":\"a2b4e0c4\",\"created_at\":\"2019-04-10T05:14:45.000Z\",\"parent_ids\":[\"002a426c7dff8b4eb2eb838b4ac122c26d42cf6c\",\"895923b9400dac15e1c7b042121fd2c3577ca7cd\"],\"title\":\"Merge branch 'development'\",\"message\":\"Merge branch 'development'\\n\",\"author_name\":\"Simpy\",\"author_email\":\"kodi03466@hotmail.com\",\"authored_date\":\"2019-04-10T05:14:45.000Z\",\"committer_name\":\"Simpy\",\"committer_email\":\"kodi03466@hotmail.com\",\"committed_date\":\"2019-04-10T05:14:45.000Z\"},\"release\":null},{\"name\":\"v11.09\",\"message\":\"\",\"target\":\"e69d1cb618703557a7ef96678c6212eac148273b\",\"commit\":{\"id\":\"002a426c7dff8b4eb2eb838b4ac122c26d42cf6c\",\"short_id\":\"002a426c\",\"created_at\":\"2019-04-09T05:51:04.000Z\",\"parent_ids\":[\"fe53220b613e095f251f58cd9f404d0eda66d042\",\"6c4c6afea0c28e93e8960f5e4e81b039ae2092db\"],\"title\":\"Merge branch 'development'\",\"message\":\"Merge branch 'development'\\n\",\"author_name\":\"Simpy\",\"author_email\":\"kodi03466@hotmail.com\",\"authored_date\":\"2019-04-09T05:51:04.000Z\",\"committer_name\":\"Simpy\",\"committer_email\":\"kodi03466@hotmail.com\",\"committed_date\":\"2019-04-09T05:51:04.000Z\"},\"release\":null}]",
      headers: [
        {"Date", "Thu, 30 May 2019 20:57:14 GMT"},
        {"Server", "Apache/2.4.25"},
        {"Cache-Control", "max-age=0, private, must-revalidate"},
        {"Content-Length", "12681"},
        {"Content-Type", "application/json"},
        {"Etag", "W/\"4db49696648de186fe110f7505e0a10a\""},
        {"Link",
         "<https://git.tukui.org/api/v4/projects/495/repository/tags?id=495&order_by=updated&page=1&per_page=20&sort=desc>; rel=\"first\", <https://git.tukui.org/api/v4/projects/495/repository/tags?id=495&order_by=updated&page=1&per_page=20&sort=desc>; rel=\"last\""},
        {"Vary", "Origin"},
        {"X-Content-Type-Options", "nosniff"},
        {"X-Frame-Options", "SAMEORIGIN"},
        {"X-Next-Page", ""},
        {"X-Page", "1"},
        {"X-Per-Page", "20"},
        {"X-Prev-Page", ""},
        {"X-Request-Id", "Y21Gia3QLN2"},
        {"X-Runtime", "0.066506"},
        {"X-Total", "20"},
        {"X-Total-Pages", "1"},
        {"Strict-Transport-Security", "max-age=15768000;includeSubdomains"}
      ],
      request: %HTTPoison.Request{
        body: "",
        headers: [],
        method: :get,
        options: [],
        params: %{},
        url: "https://git.tukui.org/api/v4/projects/495/repository/tags"
      },
      request_url: "https://git.tukui.org/api/v4/projects/495/repository/tags",
      status_code: 200
    }}
  end
end
