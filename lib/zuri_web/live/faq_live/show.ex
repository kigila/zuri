defmodule ZuriWeb.FaqLive.Show do
  use ZuriWeb, :live_view

  alias Zuri.Faqs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end



  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    faq = Faqs.get_faq!(id)
    answer = faq.answer
    changeset = Faqs.answer_faq(faq)
    answers =
      case answer do
        nil ->
          ["No answer yet. Be the first to answer!"]
        %{} ->
          Enum.map(answer, fn {key, value} ->
            "#{key} - #{value}"
          end)
      end

    vote_county =
      case faq.vote_count do
        nil -> 0
        %{} ->
          Enum.reduce(faq.vote_count, 0, fn {_key, value}, acc -> value + acc
        end)
      end


    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:faq, Faqs.get_faq!(id))
     |> assign(:answers, answers)
     |> assign(:changeset, changeset)
     |> assign(:vote_county, vote_county)}

  end

  @impl true
  def handle_event("up_vote", %{"value" => vote, "user_id" => user_id} = _params, socket) do
    user = Zuri.Accounts.get_user!(user_id)
    username = user.username
    faq = socket.assigns.faq
    vote_count = socket.assigns.faq.vote_count
    prev_vote_count =
      case vote_count do
        nil -> %{}
        _ -> vote_count
      end
    current_vote_count = %{"#{username}" => String.to_integer(vote)}

    vote_countx = Map.merge(prev_vote_count, current_vote_count)


    {:ok, updated_faq} = Faqs.update_faq_vote_count(faq, %{vote_count: vote_countx, user_id: user_id})
    {:noreply, assign(socket, :vote_county, Enum.reduce(updated_faq.vote_count, 0, fn {_key, value}, acc -> value + acc end))}
  end

  defp page_title(:show), do: "Show Faq"
  defp page_title(:edit), do: "Edit Faq"
end
