defmodule UserStruct do
	defstruct [:name, :list_name, :items]
end

defmodule Todo do
	use Application

	def start(_type, _args) do
		users = get_all_users()

		input = IO.gets("Hello, what would you like to do?\n(select user, get all lists): ") |> String.trim() |> String.downcase()
		case input do
			"select user" ->
				selected_user_name = IO.gets("Please select a user by name: ") |> String.trim() |> String.downcase()

				if selected_user_name != ""  do
					try do
						# Search for the user tuple where the first element matches the provided name
						selected_user = Enum.find(users, fn {name, _, _} -> name == selected_user_name end)

						input = IO.gets("#{elem(selected_user, 0)}, what would you like to do?\n(add item, remove item, get list): ") |> String.trim() |> String.downcase()
						case input do
							"add item" ->
								# Simulate user adding item to their list
								# selected_user = Enum.at(users, 0)
								updated_items = add_item(selected_user)
								{ name, list_name, _items } = selected_user
								# Update users list in get function
								get_user_list(name, list_name, updated_items)

							"remove item" ->
								# Simulate user removing item from their list
								# selected_user = Enum.at(users, 1)
								updated_items = remove_item(selected_user)
								{ name, list_name, _items } = selected_user
								# Update users list in get function
								get_user_list(name, list_name, updated_items)

							"get list" ->
								{name, list_name, items} = selected_user
								get_user_list(name, list_name, items)

							_ ->
								IO.puts(:stderr, "Error: Invalid answer provided.")
						end
					catch # if selected_user was not found
						:error, _ ->
							IO.puts(:stderr, "Error: Provided name does not exist.")
					end

				else
					IO.puts(:stderr, "Error: A name is required.")
				end

			"get all lists" ->
				# Iterate over enumerable users list and set values of tuple to name, list, and list.
				Enum.each(users, fn
					{name, list_name, items} ->
						get_user_list(name, list_name, items)
					# Catch edge cases
					_ ->
						IO.puts("invalid user structure encountered")
				end)

			_ ->
				IO.puts(:stderr, "Error: Invalid answer provided.")
		end

		Supervisor.start_link([], strategy: :one_for_one)
	end

	def get_all_users() do
		lists = %{
			chores: :chores,
			groceries: :groceries,
			packing: :packing
		}

		# Create users list with user tuples
		users = [
			{"zach", lists.chores, ["laundry"]},
			{"erika", lists.groceries, ["milk", "eggs"]},
			{"invalid user", []}
		]

		newUser = %UserStruct{name: "Uhtred", list_name: lists.packing, items: []}

		users ++ [{newUser.name, newUser.list_name, newUser.items}]
	end

	# Get user list
	def get_user_list(name, list_name, items) do
		# The application can suggest commonly added items from this map based on the list
		# suggestions = %{
		# 	chores: "sweep",
		# 	groceries: "coffee",
		# 	packing: "socks",
		# }

		IO.puts("#{name} has #{if Enum.empty?(items), do: "an empty list", else: "a #{list_name} list containing the following items: #{Enum.join(items, ", ")}"}.")
		# input = IO.gets("Would you like to add #{suggestions[list_name]} to your list? ") |> String.trim() |> String.downcase()
		# case input do
		#   "yes" or "y" ->

		#   "no" or "n" ->

		#   _ ->
		# end
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
				updated_items
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
				updated_items
			else
				IO.puts(:stderr, "Error: Unable to remove #{input} because it doesn't exist in your #{list_name} list.")
			end
		else
			IO.puts(:stderr, "Error: Input not provided.")
		end
	end
end
