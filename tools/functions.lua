function print_t(t, name, indent, color)
    local color_print = "7BA23FFF"
   
    if t == nil then
        return print(string.format("%s = %s", name or "value", "nil" ))
    end

    --- 数字 字符串 nil 直接打印
    if t == nil or type(t) == "string" or type(t)=="number" then
        return print(string.format("%s = %s", name or "value", t ))
    end

    --- table 或者 function？ 使用方式打印
    local tableList = {}   
    function table_r (t, name, indent, full)   
        local id = not full and name or type(name)~="number" and tostring(name) or '['..name..']'   
        local tag = indent .. id .. ' = '   
        local out = {}  -- result   
        if type(t) == "table" then   
            if tableList[t] ~= nil then   
                table.insert(out, tag .. '{} -- ' .. tableList[t] .. ' (self reference)')   
            else  
                tableList[t]= full and (full .. '.' .. id) or id  
                if next(t) then -- Table not empty   
                    table.insert(out, tag .. '{')   
                    for key,value in pairs(t) do   
                        table.insert(out,table_r(value,key,indent .. '   ',tableList[t]))   
                    end   
                    table.insert(out,indent .. '}')   
                else table.insert(out,tag .. '{}') end   
            end   
        else  
            local val = type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t)   
            table.insert(out, tag .. val)   
        end   
        return table.concat(out, '\n')   
    end

    return print(string.format("%s", tostring(table_r(t,name or 'Value', indent or ''))))
end


do return end

----------------------------------------
require "lfs"

allFilePath = {}

function PrintLfsVersion( ... )
    print_t(lfs._VERSION, "lfs版本号")
end

function PrintCurrrentDir( ... )
    local rootPath = lfs.currentdir()
    print_t(rootPath, "当前路径")
end

-- function PrintDirChildren(rootPath)
--     for entry in lfs.dir(rootPath) do
--         if entry~='.' and entry~='..' then
--             local path = rootPath.."\\"..entry
--             local attr = lfs.attributes(path)
--             assert(type(attr)=="table") --如果获取不到属性表则报错
--             -- PrintTable(attr)
--             if(attr.mode == "directory") then
--                 print("Dir:",path)
--             elseif attr.mode=="file" then
--                 print("File:",path)
--             end
--         end
--     end
-- end

function GetAllFiles(rootPath)
    for entry in lfs.dir(rootPath) do
        if entry~='.' and entry~='..' then
        	print(entry)
            local path = rootPath..[[\]]..entry
            local attr = lfs.attributes(path)
            assert(type(attr)=="table") --如果获取不到属性表则报错
            -- PrintTable(attr)
            if(attr.mode == "directory") then
                -- print("Dir:",path)
                table.insert(allFilePath,path)
                -- GetAllFiles(path) --自调用遍历子目录
            elseif attr.mode=="file" then
                -- print(attr.mode,path)
                table.insert(allFilePath,path)
            end
        end
    end
end

function PrintTable( tbl , level, filteDefault)
  local msg = ""
  filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
  level = level or 1
  local indent_str = ""
  for i = 1, level do
    indent_str = indent_str.."  "
  end

  print(indent_str .. "{")
  for k,v in pairs(tbl) do
    if filteDefault then
      if k ~= "_class_type" and k ~= "DeleteMe" then
        local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
        print(item_str)
        if type(v) == "table" then
          PrintTable(v, level + 1)
        end
      end
    else
      local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
      print(item_str)
      if type(v) == "table" then
        PrintTable(v, level + 1)
      end
    end
  end
  print(indent_str .. "}")
end

