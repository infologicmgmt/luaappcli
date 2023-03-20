#!/usr/bin/env lua
-- File: luacliapp.lua
-- Author: Michael Moscovitch
-- Date: 2023/03/19
-- License: MIT
-- Copyright: Michael Moscovitch
-- Description: skeleton program to interpret command line options and load
-- 		configuration from a yaml file
--

-- load libaries
local alt_getopt = require("alt_getopt")
local lyaml   = require "lyaml"
local inspect = require('inspect')

-- define variables
local debug = false
local verbose = false
local test = false
local flags = {}
local cfg = {}

local opts = {}
local shortopts = "dvthc:"
local longopts = {
      debug = "d",
      verbose = "v",
      test = "t",
      config = "c",
      help = "h"
}
local usagetext = [[
Usage:

luaappcli.lua [--debug] [--verbose] [--test] [--help] [--config configfile]
]]

--
-- call at beginning of application
--
function app_begin()
 if verbose then
  print("Begin")
 end
end

--
-- call at end of application
--
function app_end()
 if verbose then
  print("End")
 end
end

--
-- start application
--
function app_run()
 if verbose then
  print("Running")
 end
end

--
-- check value of option
--
function app_check_opt(short_opt, name)
 local v
 v = short_opt[name]
 
 return v
end

--
-- for debugging command line options
--
function app_debug_options(short_opt, optarg)
 local optvalues = {}

 if debug then
  print(inspect(short_opt)) 
 
  for k,v in pairs (short_opt) do
    table.insert (optvalues, k .. ": " .. v .. "\n")
  end

  table.sort (optvalues)
  io.write (table.concat (optvalues))

  for i = optarg,#arg do
     io.write (string.format ("ARGV [%s] = %s\n", i, arg [i]))
  end
 end
end

--
-- process command line options
--
function app_process_options(arg)
 local short_opt, optarg

 short_opt, optarg = alt_getopt.get_opts(arg, shortopts, longopts)

 debug = app_check_opt(short_opt, "d")
 verbose = app_check_opt(short_opt, "v")
 test = app_check_opt(short_opt, "t")

 app_debug_options(short_opt, optarg)

 return short_opt
 
end

function app_readfile(file)

 local f
 local content = nil
 
 if type(file) ~= "string" then
  return nil
 end

 f = io.open(file, "rb")
 if f ~= nil then
  content = f:read("*all")
  f:close()
 end

 return content
end

--
-- local config file
--
function app_config(configfile)
 local t, yamltext

 if type(configfile) ~= "string" then
  return nil
 end
 
 if string.len(configfile) > 2 then
  yamltext = app_readfile(configfile)
  if debug then
    print(yamltext)
  end
 end
 
 t = lyaml.load(yamltext)

 return t
end

--
-- display usage
--
function app_usage()
 print(usagetext)
end

--
-- initialize and load configuration if required
--
function app_init(arg)
 
 flags = app_process_options(arg)

 cfg = app_config(flags.c)

 if app_check_opt(flags, "h") then
  app_usage()
 end
 if debug then
  print("Config: " .. inspect(cfg))
 end

end

--
-- main entrypoint
--
function main()

 app_init(arg)
 
 app_begin()
 app_run()
 app_end()
end


--
-- call entrypoint
--
main()
