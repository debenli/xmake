--!The Make-like Build Utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2017, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        utils.lua
--

-- load modules
local io        = require("base/io")
local utils     = require("base/utils")
local colors    = require("base/colors")
local try       = require("sandbox/modules/try")
local catch     = require("sandbox/modules/catch")
local vformat   = require("sandbox/modules/vformat")
local raise     = require("sandbox/modules/raise")

-- define module
local sandbox_utils = sandbox_utils or {}

-- inherit the public interfaces of utils
for k, v in pairs(utils) do
    if not k:startswith("_") and type(v) == "function" then
        sandbox_utils[k] = v
    end
end

-- print each arguments
function sandbox_utils._print(...)

    -- format each arguments
    local args = {}
    for _, arg in ipairs({...}) do
        if type(arg) == "string" then
            table.insert(args, vformat(arg))
        else
            table.insert(args, arg)
        end
    end

    -- print multi-variables with raw lua action
    utils._print(unpack(args))
end

-- print format string with newline
-- print builtin-variables with $(var)
-- print multi-variables with raw lua action
--
function sandbox_utils.print(format, ...)

    -- print format string
    if type(format) == "string" and format:find("%", 1, true) then

        local args = {...}
        try
        {
            function ()
                -- attempt to print format string first
                utils._iowrite(vformat(format, unpack(args)) .. "\n")
            end,
            catch 
            {
                function ()
                    -- print multi-variables with raw lua action
                    sandbox_utils._print(format, unpack(args))
                end
            }
        }

    else
        -- print multi-variables with raw lua action
        sandbox_utils._print(format, ...)
    end
end

-- print format string and the builtin variables without newline
function sandbox_utils.printf(format, ...)

    -- done
    utils._iowrite(vformat(format, ...))
end

-- print format string, the builtin variables and colors with newline
function sandbox_utils.cprint(format, ...)

    -- done
    utils._iowrite(colors(vformat(format, ...) .. "\n"))
end

-- print format string, the builtin variables and colors without newline
function sandbox_utils.cprintf(format, ...)

    -- done
    utils._iowrite(colors(vformat(format, ...)))
end

-- assert
function sandbox_utils.assert(value, format, ...)

    -- check
    if not value then
        if format ~= nil then
            raise(format, ...)
        else
            raise("assertion failed!")  
        end
    end

    -- return it 
    return value
end


-- return module
return sandbox_utils

