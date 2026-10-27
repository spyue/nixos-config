return {
  "hsteinshiromoto/todo.nvim",
  config = function()
    require("todo-nvim").setup({
      keymaps = {
        add_todo = "<localleader>ta",
        toggle_todo = "<localleader>td",
        open_todo_list = "<localleader>tl",
      },
    })
  end,
}
