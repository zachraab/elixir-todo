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

		# The application can suggest commonly added items from this map based on the list
		suggestions = %{
			chores: "sweep",
			groceries: "coffee",
			packing: "socks",
		}

		# Create users list with user tuples
		users = [
			{"Zach", lists.chores, ["laundry"]},
			{"Erika", lists.groceries, ["milk", "eggs"]}
		]

		newUser = %UserStruct{name: "Uhtred", list: lists.packing, items: []}
		IO.inspect(newUser)

		# Iterate over enumerable users list and set values of tuple to name, list, and list.
		Enum.each(users, fn {name, list, items} ->
			IO.puts("#{name} has a #{list} list containing the following items: #{Enum.join(items, ", ")}. Would you like to add #{suggestions[list]} to your list?")
		end)

		Supervisor.start_link([], strategy: :one_for_one)
	end

	# Get user list
	def getList() do

	end

	# User adds another chore to list
	def addItem() do

	end

	# User removes chore from list upon completion
	def removeItem() do

	end
end
