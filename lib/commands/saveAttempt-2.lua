--[[
  Save job attempt data

     Input:
      KEYS[1] jobId
      KEYS[2] lock

      ARGV[1] token
      ARGV[*] fields and values
     Output:
      -1 Missing key.
      -2 Missing lock.
]]

-- Check for job
if redis.call("EXISTS", KEYS[1]) ~= 1 then
  return -1
end

-- Check for job lock
local token = redis.call("GET", KEYS[2])
if token and token ~= ARGV[1] then
  return -2
end

-- Dynamically set the fields
local cmd = { "HSET", KEYS[1] }
for i = 2, #ARGV do
  table.insert(cmd, ARGV[i])
end

return redis.pcall(unpack(cmd))
