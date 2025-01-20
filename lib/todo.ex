defmodule UserStruct do
	defstruct [:name, :list_name, :items]
end

defmodule Todo do
	use Application

	def start(_type, _args) do
		users = get_all_users()

		input = IO.gets("Hello, what would you like to do?\n(Valid answers: add item, remove item, get all lists): ") |> String.trim() |> String.downcase()
		case input do
			"add item" ->
				# Simulate user adding item to their list
				add_item(Enum.at(users, 0))

			"remove item" ->
				# Simulate user removing item from their list
				remove_item(Enum.at(users, 1))

			"get all lists" ->
				# Iterate over enumerable users list and set values of tuple to name, list, and list.
				Enum.each(users, fn
					{name, list_name, items} ->
						get_all_user_lists(name, list_name, items)
					# Catch edge cases
					_ ->
						IO.puts("invalid user structure encountered")
				end)

			_ ->
				IO.puts(:stderr, "Error: Invalid answer provided.")
		end

		Supervisor.start_link([], strategy: :one_for_one)
	end

	def get_all_users do
		lists = %{
			chores: :chores,
			groceries: :groceries,
			packing: :packing
		}

		# Create users list with user tuples
		users = [
			{"Zach", lists.chores, ["laundry"]},
			{"Erika", lists.groceries, ["milk", "eggs"]},
			{"Invalid user", []}
		]

		newUser = %UserStruct{name: "Uhtred", list_name: lists.packing, items: []}

		users ++ [{newUser.name, newUser.list_name, newUser.items}]
	end

	# Get user list
	def get_all_user_lists(name, list_name, items) do
		# The application can suggest commonly added items from this map based on the list
		suggestions = %{
			chores: "sweep",
			groceries: "coffee",
			packing: "socks",
		}

		IO.puts("#{name} has #{if Enum.empty?(items), do: "an empty list", else: "a #{list_name} list containing the following items: #{Enum.join(items, ", ")}"}. Would you like to add #{suggestions[list_name]} to your list?")
	end

	# User adds another chore to list
	def add_item(user) do
		{ name, list_name, items } = user

		IO.puts("Hello #{name}, please provide an item that you would like to add to your #{list_name} list.\n(Current items: #{Enum.join(items, ", ")})")
		input = IO.gets("New item: ") |> String.trim() |> String.downcase()

		if input != ""  do
			if Enum.member?(items, input) do
				IO.puts(:stderr, "Error: #{input} is already in your #{list_name} list.")
			else
				IO.puts("...Success! Adding #{input} to your #{list_name} list")
				updated_items = items ++ [input]
				IO.puts("#{name}, here is your updated #{list_name} list: #{Enum.join(updated_items, ", ")}")
			end
		else
			IO.puts(:stderr, "Error: Input not provided.")
		end
	end


	# User removes chore from list upon completion
	def remove_item(user) do
		{name, list_name, items} = user
		IO.puts("Hello #{name}, which item would you like to remove from your #{list_name} list?\n(#{Enum.join(items, ", ")})")
		input = IO.gets("Remove item: ") |> String.trim() |> String.downcase()

		if input != "" do
			remove_item = Enum.find(items, fn
				item -> item == input
			end)

			if remove_item do
				updated_items = List.delete(items, remove_item)
				IO.puts("...Success! #{name}, here is your updated list:\n(#{updated_items})")
			else
				IO.puts(:stderr, "Error: Unable to remove #{input} because it doesn't exist in your #{list_name} list.")
			end
		else
			IO.puts(:stderr, "Error: Input not provided.")
		end
	end
end
