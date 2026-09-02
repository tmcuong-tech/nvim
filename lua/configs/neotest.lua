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
