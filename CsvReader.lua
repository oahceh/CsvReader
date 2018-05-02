-- CsvReader.lua
-- Created by hechao 2018-05-02
-- Last modified by hechao 2018-05-02
-- Csv reader.
-- Parse csv char by char.

-- Get a specified character by index.
function string.get(s, index)
    return string.sub(s, index, index)
end

-- Split a line in csv string.
local function SplitLine(str)
    local s = str

    local ret, i = {}, 1
    local quotesToken, quotesCount, token = nil, 0, nil
    while i <= #s do
        -- Current character.
        local c = string.get(s, i)

        -- End of line.
        if i == #s then
            ret[#ret + 1] = token .. c
            break
        end

        -- Case comma
        if c == ',' then
            -- Current token is not quoted, this token is a 
            -- complete field's value.
            if quotesCount == 0 then
                ret[#ret + 1] = token
                token = nil
            -- Current token is quoted.
            else
                if not quotesToken then
                    token = token .. c
                else
                    if #quotesToken % 2 == 0 and #token > 2 then
                        token = token .. c
                    else
                        if quotesCount % 2 == 0 then
                            ret[#ret + 1] = token
                            token = nil
                            quotesCount = 0
                        else
                            token = token .. c
                        end
                    end
                    quotesToken = nil
                end
            end
            quotesToken = nil
        -- Case quote
        elseif c == '"' then
            quotesToken = (quotesToken or '') .. c
            quotesCount = quotesCount + 1
            token = (token or '') .. c
        -- Case else
        else
            token = (token or '') .. c
            quotesToken = nil
        end
        i = i + 1
    end

    return ret
end

local str = '1999,Chevy,"Venture ""Extended Edition""","",4900.00'

print(str)

local function PrintList(t)
    for i, v in ipairs(t) do
        print(i, v)
    end
end

PrintList(SplitLine(str))
