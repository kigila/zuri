defmodule Zuri.FaqsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zuri.Faqs` context.
  """

  @doc """
  Generate a faq.
  """
  def faq_fixture(attrs \\ %{}) do
    {:ok, faq} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        question: "some question",
        vote_count: 42
      })
      |> Zuri.Faqs.create_faq()

    faq
  end
end
