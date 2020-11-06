function printTable(t)
    function printTableRecursive(t, record, depth)
        record[t] = true
    
        local tabs = ""
        for i = 1,depth do 
            tabs = tabs.."\t" 
        end    
        local tabsChild = tabs.."\t"
    
        if depth == 0 then
            print(tabs..tostring(t).." {")
        end
    
        for k,v in pairs(t) do
            local element = tabsChild.."k=("..type(k)..")"..tostring(k)..", v=("..type(v)..")"..tostring(v)
            if type(v) == "table" then
                if record[v] then
                    print(element..": skip exist...")
                else
                    print(element.." {")                
                    printTableRecursive(v, record, depth + 1)
                end
            else
                print(element)
            end
        end    
        print(tabs.."}")
    end

    record = {}
    printTableRecursive(t, record, 0)
end