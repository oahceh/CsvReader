
function string.get(s, index)
    return string.sub(s, index, index)
end

local ParserContext = {
    -- Current start index.
    startIndex = 1,
    -- Current end index.
    endIndex = 1,
    -- Current continuous quotes token.
    curQuotesToken = nil,
    -- Current token.
    curToken = nil,
    -- Is quoted
    isQuoted = false,
    -- Current count of quotes.
    curQuotesCount = 0
}

local function ParseLine(str)
    local s = str

    local ret = {}
    local ctx = ParserContext

    local i = 1
    while i <= #s do
        -- Current character.
        local c = string.get(s, i)

        if i == #s then
            ret[#ret + 1] = ctx.curToken .. c
            break
        end

        if c == ',' then
            -- Current token is not quoted, this token is a 
            -- complete field's value.
            if not ctx.isQuoted then
                ret[#ret + 1] = ctx.curToken
                ctx.startIndex = i + 1
                ctx.curToken = nil
                ctx.curQuotesToken = nil
                ctx.curQuotesCount = 0
            -- Current token is quoted.
            else
                if not ctx.curQuotesToken then
                    ctx.curToken = ctx.curToken .. c
                else
                    if #ctx.curQuotesToken % 2 == 0 then
                        ctx.curToken = ctx.curToken .. c
                    else
                        if ctx.curQuotesCount % 2 == 0 then
                            ret[#ret + 1] = ctx.curToken
                            ctx.startIndex = i + 1
                            ctx.curToken = nil
                            ctx.curQuotesCount = 0
                        else
                            ctx.curToken = ctx.curToken .. c
                        end
                    end
                    ctx.curQuotesToken = nil
                end
            end
            ctx.curQuotesToken = nil
        elseif c == '"' then
            if ctx.startIndex == i then
                ctx.isQuoted = true
            end
            ctx.curQuotesToken = (ctx.curQuotesToken or '') .. c
            ctx.curToken = (ctx.curToken or '') .. c
            ctx.curQuotesCount = ctx.curQuotesCount + 1
        else
            ctx.curToken = (ctx.curToken or '') .. c
            ctx.curQuotesToken = nil
        end
        i = i + 1
    end

    return ret
end

local str = '1999,Chevy,"Venture ""Extended Edition""","",4900.00'

local function PrintList(t)
    for i, v in ipairs(t) do
        print(i, v)
    end
end

PrintList(ParseLine(str))
