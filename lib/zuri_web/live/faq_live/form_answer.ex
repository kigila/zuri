defmodule ZuriWeb.FaqLive.FormAnswer do
  use ZuriWeb, :live_component

  alias Zuri.Faqs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage faq records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="faq-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <.input field={@form[:answer]} type="text" label="Answer" value="" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Answer</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{faq: faq} = assigns, socket) do
    changeset = Faqs.answer_faq(faq)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"faq" => %{"answer" => answer, "user_id" => user_id}}, socket) do
    user = Zuri.Accounts.get_user!(user_id)
    username = user.username
    changeset =
      socket.assigns.faq
      |> Faqs.answer_faq(%{answer: %{"#{username}" => answer}, user_id: user_id})
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"faq" => %{"answer" => answer, "user_id" => user_id}}, socket) do
    user = Zuri.Accounts.get_user!(user_id)
    username = user.username
    prev_answers =
      case socket.assigns.faq.answer do
        nil -> %{}
        _ -> socket.assigns.faq.answer
      end
    current_answer = %{"#{username}" => answer}


    answerx = Map.merge(prev_answers, current_answer)


    save_faq(socket, socket.assigns.action, %{answer: answerx, user_id: user_id})
  end

  defp save_faq(socket, :show, faq_params) do
    case Faqs.update_faq_answer(socket.assigns.faq, faq_params) do
      {:ok, faq} ->
        notify_parent({:saved, faq})

        {:noreply,
         socket
         |> put_flash(:info, "Faq updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end


  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
