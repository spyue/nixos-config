return {
  {
    "spyue/habit.nvim",
    dev = true,
    cmd = "HabitInsert",
    opts = {
      tasks = { "task 1", "task 2", "task 3" },
    },
    keys = {
      {
        "<leader>ht",
        function()
          require("habit").insert()
        end,
        desc = "Insert habit tracker",
      },
    },
  },
}
