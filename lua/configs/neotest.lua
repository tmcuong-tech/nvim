local neotest = require "neotest"

local adapters = {}

if vim.fn.executable "python" == 1 or vim.fn.executable "python3" == 1 then
  table.insert(adapters, require "neotest-python")
end

if vim.fn.executable "go" == 1 then
  table.insert(adapters, require "neotest-golang")
end

if vim.fn.executable "java" == 1 then
  table.insert(adapters, require "neotest-java")
end

if vim.fn.executable "node" == 1 then
  table.insert(adapters, require "neotest-jest")
  table.insert(adapters, require "neotest-vitest")
end

if vim.fn.executable "cargo" == 1 then
  table.insert(adapters, require "neotest-rust")
end

neotest.setup {
  adapters = adapters,
}

-- Run nearest test
vim.keymap.set("n", "<leader>tt", function()
  neotest.run.run()
end, {
  desc = "Test: Run nearest",
})

-- Run entire file
vim.keymap.set("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand "%")
end, {
  desc = "Test: Run file",
})

-- Stop test
vim.keymap.set("n", "<leader>tS", function()
  neotest.run.stop()
end, {
  desc = "Test: Stop",
})

-- Toggle test summary
vim.keymap.set("n", "<leader>ts", function()
  neotest.summary.toggle()
end, {
  desc = "Test: Summary",
})

-- Open test output
vim.keymap.set("n", "<leader>to", function()
  neotest.output.open {
    enter = true,
  }
end, {
  desc = "Test: Output",
})
