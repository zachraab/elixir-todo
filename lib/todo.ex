defmodule UserStruct do
	defstruct [:name, :list, :items]
end

defmodule Todo do
	use Application

	def start(_type, _args) do
		users = getAllUsers()

		# Switch to turn off functionality during development
		activeDev = true
		if activeDev do
			input = IO.gets("Hello, what would you like to do? (Valid answers: add item, get all lists): ") |> String.trim() |> String.downcase()

			case input do
				"get all lists" ->
					# Iterate over enumerable users list and set values of tuple to name, list, and list.
					Enum.each(users, fn
						{name, list, items} ->
							getAllUserLists(name, list, items)
						# Catch edge cases
						_ ->
							IO.puts("invalid user structure encountered")
					end)

				"add item" ->
					# Simulate user adding item to their list
					addItem(Enum.at(users, 0))

				_ ->
					IO.puts(:stderr, "Error: Invalid answer provided.")
			end
		end

		Supervisor.start_link([], strategy: :one_for_one)
	end

	def getAllUsers do
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

		newUser = %UserStruct{name: "Uhtred", list: lists.packing, items: []}

		users ++ [{newUser.name, newUser.list, newUser.items}]
	end

	# Get user list
	def getAllUserLists(name, list, items) do
		# The application can suggest commonly added items from this map based on the list
		suggestions = %{
			chores: "sweep",
			groceries: "coffee",
			packing: "socks",
		}

		IO.puts("#{name} has #{if Enum.empty?(items), do: "an empty list", else: "a #{list} list containing the following items: #{Enum.join(items, ", ")}"}. Would you like to add #{suggestions[list]} to your list?")
	end

	# User adds another chore to list
	def addItem(user) do
		{ name, list, items } = user

		IO.puts("Hello #{name}, please provide an item that you would like to add to your #{list} list:")
		input = IO.gets("New item: ") |> String.trim()
		if input != ""  do
			IO.puts("...Success! Adding #{input} to your #{list} list")
			updatedList = items ++ [input]
			IO.puts("#{name}, here is your updated #{list} list: #{Enum.join(updatedList, ", ")}")
		else
			IO.puts(:stderr, "Error: Input not provided.")
		end
	end


	# User removes chore from list upon completion
	def removeItem() do

	end
end
