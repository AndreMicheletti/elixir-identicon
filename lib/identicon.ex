defmodule Identicon do
  @moduledoc """
   Generates a "identity icon", which is an image 250x250, using a token as seed
  """

  def generate(token) do
    token
    |> hash_string
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(token)
  end

  def save_image(%Identicon.Image{image_binary: bin}, token) do
    :egd.save(bin, "#{token}.png")
  end

  @doc """
    Generate a Integer list based on the input string, which will always have a length of 16
  """
  def hash_string(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  @doc """
    Generate a Integer list based on the input string, which will always have a length of 16
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail ]} = image) do
    %Identicon.Image{ image | color: {r, g, b}}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid = 
      hex_list 
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    new_grid = 
      Enum.filter grid, fn({value, _index }) -> 
        rem(value, 2) == 0
      end

    %Identicon.Image{image | grid: new_grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = 
      Enum.map grid, fn {_, index} ->
        x = rem(index, 5) * 50
        y = div(index, 5) * 50

        top_left = {x, y}
        bottom_right = {x + 50, y + 50}
        {top_left, bottom_right}
      end
    
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{pixel_map: pixel_map, color: color} = image) do
    img = :egd.create(250, 250)
    color = :egd.color(color)

    Enum.each pixel_map, fn {point1, point2} ->
      :egd.filledRectangle(img, point1, point2, color)
    end
    bin = :egd.render(img)

    %Identicon.Image{image | image_binary: bin}
  end
end
