defmodule StormchatWeb.TokenView do
  use StormchatWeb, :view

  # inclused the id and name of the token user
  def render("token.json", %{user: user, token: token}) do
    %{
      user_id: user.id,
      token: token
    }
  end
end
