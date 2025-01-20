defmodule UserStruct do
	defstruct [:name, :list, :items]
end

defmodule Todo do
	use Application

	def start(_type, _args) do
		# Todo.addItem()
		# Todo.getList()

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
		users = users ++ [{newUser.name, newUser.list, newUser.items}]

		# Switch to turn off functionality during development
		activeDev = false
		if activeDev do
			# Iterate over enumerable users list and set values of tuple to name, list, and list.
			Enum.each(users, fn
				{name, list, items} ->
					getAllUserLists(name, list, items)
				# Catch edge cases
				_ ->
					IO.puts("invalid user structure encountered")
			end)
		end

		# Simulate user adding item to their list
		addItem(Enum.at(users, 0))

		Supervisor.start_link([], strategy: :one_for_one)
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
		input = IO.gets("New item:") |> String.trim()
		if input != ""  do
			IO.puts("...Success! Adding #{input} to #{list} list")
			updatedList = items ++ [input]
			IO.puts("#{name}, here is your updated #{list} list: #{Enum.join(updatedList, ", ")}")
		else
			IO.puts("Error: Input not provided")
		end
	end


	# User removes chore from list upon completion
	def removeItem() do

	end
end
