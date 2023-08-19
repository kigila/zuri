defmodule ZuriWeb.WrongLive do
  use ZuriWeb, :live_view

  #alias Zuri.Accounts
  def mount(_params, _session, socket) do
	{:ok, assign(
		socket,
		score: 0,
		message: "Make a guess:",
		time: time(),
		win_numb: win_numb(),
		win: false
		)}
  end
	#session_id: session["live_socket_id"],

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
	~H"""
	<div class="space-y-5">
	<h1>Your score: <%= @score %></h1>
	<h2>
	 <pre>
	  <%= @message %>
	 </pre>
	  It's <%= @time %>
	</h2>
	<h2>
	  <%= for n <- 1..10 do %>
		<.link href="#" phx-click="guess" phx-value-number= {n} phx-value-win_numb={@win_numb} class="bg-cyan-500 text-slate-200 hover:bg-slate-200 hover:text-black">
		<%= n %>
		</.link>
	  <% end %>
	  <pre>
		<%= @current_user.email %>
		<%= @session_id %>
	  </pre>
	</h2>

	<.button :if={@win && @score == 1} phx-click="restart">Restart</.button>
	</div>
	"""
  end


  def handle_event("guess", %{"number" => guess, "win_numb" => win_numb}, socket) do
	case guess == win_numb do
		true ->
			message = "You win"
			win = true
			score = socket.assigns.score + 1
			time = time()
			win_numb =  win_numb()


			{:noreply, assign(socket, message: message, score: score, time: time, win: win, win_numb: win_numb)}
		false ->
			message = "Your guess: #{guess}. Wrong. Guess Again."<>"\n Win number reminder of 2 is #{rem(String.to_integer(win_numb), 2)}, ok! "
			score = socket.assigns.score - 1


			{:noreply, assign(socket, message: message, score: score, time: time())}
	end
  end

  def handle_event("restart", _params, socket) do
	{:noreply, assign(socket, score: 0 , message: "Make a guess:", time: time(), win_numb: win_numb(), win: false)}
  end


  def time() do
	DateTime.utc_now() |> to_string()
  end

  def win_numb() do
	Enum.random(1..10)
  end
end
