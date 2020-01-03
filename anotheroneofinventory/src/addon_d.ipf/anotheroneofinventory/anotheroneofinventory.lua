-- Anotheroneofinventory
local addonName = "ANOTHERONEOFINVENTORY"
local addonNameLower = string.lower(addonName)
--作者名
local author = 'ebisuke'

--アドオン内で使用する領域を作成。以下、ファイル内のスコープではグローバル変数gでアクセス可
_G['ADDONS'] = _G['ADDONS'] or {}
_G['ADDONS'][author] = _G['ADDONS'][author] or {}
_G['ADDONS'][author][addonName] = _G['ADDONS'][author][addonName] or {}
local g = _G['ADDONS'][author][addonName]
local acutil = require('acutil')
g.version = 0
g.settings = {
    x = 300, y = 300, w = 300, h = 200,
    stik = {
    
    }
}
g.settingsFileLoc = string.format('../addons/%s/settings.json', addonNameLower)
g.personalsettingsFileLoc = ""
g.framename = "anotheroneofinventory"
g.debug = true
g.resizing = nil
g.x = nil
g.y = nil
g.findstr = ""
g.frames = {}
g.filters = {
        
        {name = "Fav", text = "★", tooltip = "Favorites",imagename="aoi_favorites", original = nil},
        {name = "All", text = "All", tooltip = "All",imagename="aoi_all", original = "All"},
        {name = "Equ", text = "Equ", tooltip = "Equip",imagename="aoi_equip", original = "Equip"},
        {name = "Spl", text = "Spl", tooltip = "Comsume Item",imagename="aoi_consume", original = "Consume"},
        {name = "Rcp", text = "Rcp", tooltip = "Recipe",imagename="aoi_recipe", original = "Recipe"},
        {name = "Crd", text = "Crd", tooltip = "Card",imagename="aoi_card", original = "Card"},
        {name = "Etc", text = "Etc", tooltip = "Etc",imagename="aoi_etc", original = "Etc"},
        {name = "Gem", text = "Gem", tooltip = "Gem",imagename="aoi_gem", original = "Gem"},
        {name = "Prm", text = "Prm", tooltip = "Premium",imagename="aoi_premium", original = "Premium"},
        {name = "Lim", text = "Lim", tooltip = "Time Limited",imagename="aoi_timelimited", original = nil},
        {name = "Fnd", text = "Fnd", tooltip = "Find",imagename="aoi_find", original = nil},
}
g.filterbyname = {}
for _, v in ipairs(g.filters) do
    g.filterbyname[v.name] = v
end
g.settings.filter = "All"
g.invitems = {}
local tabsize = 22
local slotsize = 32
g.initialized=false
--ライブラリ読み込み
CHAT_SYSTEM("[AOI]loaded")
local acutil = require('acutil')
function EBI_try_catch(what)
    local status, result = pcall(what.try)
    if not status then
        what.catch(result)
    end
    return result
end
function EBI_IsNoneOrNil(val)
    return val == nil or val == "None" or val == "nil"
end



local function DBGOUT(msg)
    
    EBI_try_catch{
        try = function()
            if (g.debug == true) then
                CHAT_SYSTEM(msg)
                
                print(msg)
                local fd = io.open(g.logpath, "a")
                fd:write(msg .. "\n")
                fd:flush()
                fd:close()
            
            end
        end,
        catch = function(error)
        end
    }

end
local function ERROUT(msg)
    EBI_try_catch{
        try = function()
            CHAT_SYSTEM(msg)
            print(msg)
        end,
        catch = function(error)
        end
    }

end
function ANOTHERONEOFINVENTORY_SAVE_SETTINGS()
    --CAMPCHEF_SAVETOSTRUCTURE()
    acutil.saveJSON(g.settingsFileLoc, g.settings)
end


function ANOTHERONEOFINVENTORY_LOAD_SETTINGS()
    DBGOUT("LOAD_SETTING")
    g.settings = {}
    local t, err = acutil.loadJSON(g.settingsFileLoc, g.settings)
    if err then
        --設定ファイル読み込み失敗時処理
        DBGOUT(string.format('[%s] cannot load setting files', addonName))
        g.settings = {x = 300, y = 300, w = 300, h = 200}
    else
        --設定ファイル読み込み成功時処理
        g.settings = t
        if (not g.settings.version) then
            g.settings.version = 0
        
        end
    end
    
    ANOTHERONEOFINVENTORY_UPGRADE_SETTINGS()
    ANOTHERONEOFINVENTORY_SAVE_SETTINGS()

end


function ANOTHERONEOFINVENTORY_UPGRADE_SETTINGS()
    local upgraded = false
    return upgraded
end

--マップ読み込み時処理（1度だけ）
function ANOTHERONEOFINVENTORY_ON_INIT(addon, frame)
    EBI_try_catch{
        try = function()
            frame = ui.GetFrame(g.framename)
            g.addon = addon
            g.frame = frame
            --g.personalsettingsFileLoc = string.format('../addons/%s/settings_%s.json', addonNameLower,tostring(CAMPCHEF_GETCID()))
            acutil.addSysIcon('AOI', 'sysmenu_inv', 'another one of inventory', 'ANOTHERONEOFINVENTORY_TOGGLE_FRAME')
            addon:RegisterMsg('GAME_START_3SEC', 'AOI_INIT')
            --ccするたびに設定を読み込む
            if not g.loaded then
                
                g.loaded = true
            end
            
            acutil.setupHook(AOI_UPDATE_INVENTORY_EXP_ORB, "UPDATE_INVENTORY_EXP_ORB")
            acutil.setupHook(AOI_UPDATE_INVENTORY_TOGGLE_ITEM, "TOGGLE_ITEM_SLOT_INVEN_ON_MSG")
            addon:RegisterMsg('INV_ITEM_ADD', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('INV_ITEM_REMOVE', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('INV_DRAW_MONEY_TEXT', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('UPDATE_ITEM_REPAIR', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('UPDATE_ITEM_APPRAISAL', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('SWITCH_GENDER_SUCCEED', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('RESET_ABILITY_UP', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('ACCOUNT_UPDATE', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterOpenOnlyMsg('INV_ITEM_LIST_GET', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterOpenOnlyMsg('ITEM_PROP_UPDATE', 'AOI_INVENTORY_ON_MSG');
            --addon:RegisterMsg('GAME_START', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('EQUIP_ITEM_LIST_GET', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('EQUIP_ITEM_LIST_UPDATE', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('UPDATE_LOCK_STATE', 'AOI_INVENTORY_ON_MSG');
            addon:RegisterMsg('UPDATE_TRUST_POINT', 'AOI_INVENTORY_ON_MSG');
            --  --コンテキストメニュー
            frame:SetEventScript(ui.RBUTTONDOWN, "AOI_ON_RCLICK")
            -- --ドラッグ
            frame:SetEventScript(ui.LBUTTONUP, "AOI_SAVE_POSITION")
            
            
            ANOTHERONEOFINVENTORY_LOAD_SETTINGS()
            frame:SetOffset(g.settings.x, g.settings.y)
            frame:Resize(g.settings.w, g.settings.h)
            
            g.frame:SetSkinName("None")
            g.frame:ShowWindow(1)

        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function ANOTHERONEOFINVENTORY_SHOW(frame)
    frame = ui.GetFrame(g.framename)
    frame:ShowWindow(1)
end
function ANOTHERONEOFINVENTORY_CLOSE(frame)
    frame = ui.GetFrame(g.framename)
    frame:ShowWindow(0)
end
function ANOTHERONEOFINVENTORY_TOGGLE_FRAME(frame)
    ui.ToggleFrame(g.framename)

end

function AOI_UPDATE_INVENTORY_TOGGLE_ITEM(frame)
    local ret = UPDATE_INVENTORY_TOGGLE_ITEM_OLD(frame)
    frame = ui.GetFrame(g.framename)
    if g.frame:IsVisible() == 0 or not g.initialized then
        return;
    end
    
    local slt = GET_CHILD_RECURSIVELY(frame, "aoi_slt")
    AUTO_CAST(slt)
    for i = 0, slt:GetSlotCount() - 1 do
        local slot = slt:GetSlotByIndex(i)
        if slot ~= nil and slot:IsVisible() == 1 then
            if slt:GetHeight() == 0 then
                return 1;
            end
            
            if slot:IsVisibleRecursively() == true then
                slot:PlayUIEffect("I_sys_item_slot", 2.2, "Inventory_TOGGLE_ITEM", true);
            end
        end
    end
    return ret
end
function AOI_UPDATE_INVENTORY_EXP_ORB(frame, ctrl, num, str, time)
    local ret = UPDATE_INVENTORY_EXP_ORB_OLD(frame, ctrl, num, str, time)
    if g.frame:IsVisible() == 0 or not g.initialized then
        return ret;
    end
    local invenframe = ui.GetFrame("inventory")
    frame = ui.GetFrame(g.framename)
    local itemGuid = invenframe:GetUserValue("EXP_ORB_EFFECT");
    if itemGuid == "None" then
        return ret;
    end
    
    local slt = GET_CHILD_RECURSIVELY(frame, "aoi_slt")
    AUTO_CAST(slt)
    local gboxslot = GET_CHILD_RECURSIVELY(frame, "aoi_gboxslt")
    AUTO_CAST(gboxslot)
    if slt:GetHeight() == 0 then
        return ret;
    end
    local iesid = nil
    local slot
    for i = 0, slt:GetSlotCount() - 1 do
        slot = slt:GetSlotByIndex(i)
        if slot ~= nil and slot:IsVisible() == 1 then
            iesid = slt:GetIcon():GetInfo():GetIESID()
            break
        end
    end
    if (not iesid) then
        return ret
    end
    
    local offset = invenframe:GetUserConfig("EFFECT_DRAW_OFFSET");
    if slot:GetDrawY() <= gboxslot:GetDrawY() or gboxslot:GetDrawY() + gboxslot:GetHeight() - offset <= slot:GetDrawY() then
        return ret;
    end
    if slot:IsVisibleRecursively() == true then
        slot:PlayUIEffect("I_sys_item_slot", 2.2, "Inventory_Exp_ORB", true);
    end
    return ret
end


function AOI_INIT()
    EBI_try_catch{
        try = function()
            local frame = g.frame
            frame:EnableMove(1)
            frame:SetSkinName("chat_window")
            frame:EnableHittestFrame(1)
            frame:SetGravity(ui.LEFT, ui.BOTTOM)
            frame:EnableResize(1)
            frame:EnableHide(0)
            frame:SetLayerLevel(80)
            local slotgbox = frame:CreateOrGetControl("groupbox", "aoi_gboxslt", tabsize + 10, 25, 0, 0)
            tolua.cast(slotgbox, "ui::CGroupBox")
            local slt = slotgbox:CreateOrGetControl("slotset", "aoi_slt", 0, 0, 0, 0)
            tolua.cast(slt, "ui::CSlotSet")
            local gbox = frame:CreateOrGetControl("groupbox", "aoi_gboxtab", 3, 3, 0, 0)
            tolua.cast(gbox, "ui::CGroupBox")
            local resizer = frame:GetChild("aoi_resize")
            local labelfind = frame:CreateOrGetControl("richtext", "aoi_finderlabel", 3, 5, 50, 24)
            AUTO_CAST(labelfind)
            labelfind:SetMargin(0, 0, 30 + 100 + 5, 5)
            labelfind:SetGravity(ui.RIGHT, ui.TOP)
            labelfind:SetText("{ol}{s14}Search:")
            labelfind:EnableHitTest(0)
            local editfind = frame:CreateOrGetControl("edit", "aoi_finder", 3, 5, 100, 24)
            AUTO_CAST(editfind)
            editfind:SetMargin(0, 0, 30, 5)
            editfind:SetGravity(ui.RIGHT, ui.TOP)
            editfind:SetTextTooltip("Pattern matching supported.(ignore case)")
            --editfind:SetSkinName("test_weight_skin")
            editfind:SetFontName("white_12_ol")
            editfind:SetEventScript(ui.ENTERKEY, "AOI_INV_FIND")
            editfind:EnableHitTest(1)
            frame:SetEventScript(ui.RESIZE, "AOI_ON_RESIZE")
            --scrollbar hiding trick
            gbox:EnableScrollBar(0)
            gbox:EnableScrollBar(1)
            gbox:EnableHittestGroupBox(true)
            gbox:EnableResizeByParent(0)
            slotgbox:EnableScrollBar(1)
            slotgbox:EnableResizeByParent(0)
            
            --generate buttons
            local btn
            local ox = 0
            local oy = 0
            local sx = tabsize
            local sy = tabsize
            local my = 5
            local prefix = "{ol}{s12}"
            
            for _, v in ipairs(g.filters) do
                btn = gbox:CreateOrGetControl("button", "aoi_btn" .. v.name, ox, oy, sx, sy)
                AUTO_CAST(btn)
                btn:SetText(prefix .. v.text)
                btn:SetEventScript(ui.LBUTTONUP, "AOI_TAB_ON_CLICK")
                btn:SetEventScriptArgString(ui.LBUTTONUP, v.name)
                btn:SetTextTooltip(v.tooltip)
                btn:SetSkinName("None")
                if(v.imagename)then
                    btn:SetText("")
                    btn:SetImage(v.imagename)
                    btn:EnableImageStretch(1)
                end
                oy = oy + sy + my
            end
            local timer = GET_CHILD(frame, "aoi_addontimer", "ui::CAddOnTimer");
            timer:SetUpdateScript("AOI_ON_TIMER");
            timer:Start(0.01);
            
            
            
            AOI_TAB_HIGHLIGHT()
            AOI_RESIZE()
            AOI_INV_REFRESH()
            AOI_INIT_FIND()
            frame:SetOffset(g.settings.x, g.settings.y)
            frame:Resize(g.settings.w, g.settings.h)
            g.initialized=true
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_TAB_HIGHLIGHT()
    local frame = g.frame
    for _, v in ipairs(g.filters) do
        local gbox = frame:GetChild("aoi_gboxtab")
        AUTO_CAST(gbox)
        local btn = gbox:GetChild("aoi_btn" .. v.name)
        AUTO_CAST(btn)
        local prefix = "{ol}{s12}"
        if (v.name == g.settings.filter) then
            prefix = "{b}{ol}{s12}{#FF4444}"
        end
        btn:SetText(prefix .. v.text)
    
    end
end
function AOI_RESIZE()
    EBI_try_catch{
        try = function()
            local frame = g.frame
            local gboxslot = GET_CHILD_RECURSIVELY(frame, "aoi_gboxslt")
            AUTO_CAST(gboxslot)
            local slt = GET_CHILD_RECURSIVELY(frame, "aoi_slt")
            AUTO_CAST(slt)
            local gbox = frame:GetChild("aoi_gboxtab")
            AUTO_CAST(gbox)
            
            
            
            gboxslot:Resize(frame:GetWidth() - tabsize - 8, frame:GetHeight() - 30)
            slt:Resize(gboxslot:GetWidth() - 15, frame:GetHeight() - 30)
            --lt:SetSlotCount(math.floor(slt:GetWidth() / slotsize) * math.floor(slt:GetHeight() / slotsize))--currently
            gbox:Resize(tabsize + 2, frame:GetHeight() - 0)
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end


function AOI_TAB_ON_CLICK(frame, msg, argStr, argNum)
    g.settings.filter = argStr
    local frame = g.frame
    local slt = GET_CHILD_RECURSIVELY(frame, "aoi_slt")
    local gbox = GET_CHILD_RECURSIVELY(frame, "aoi_gboxslt")
    AUTO_CAST(gbox)
    gbox:SetScrollPos(0)
    AOI_INIT_FIND()
    AOI_INV_REFRESH()
    AOI_TAB_HIGHLIGHT()
    ANOTHERONEOFINVENTORY_SAVE_SETTINGS()
end
function AOI_INIT_FIND()
    EBI_try_catch{
        try = function()
            if g.settings.filter == "Fnd" then
                local frame = g.frame
                frame:GetChild("aoi_finderlabel"):ShowWindow(1)
                frame:GetChild("aoi_finder"):ShowWindow(1)
            
            else
                local frame = g.frame
                frame:GetChild("aoi_finderlabel"):ShowWindow(0)
                frame:GetChild("aoi_finder"):ShowWindow(0)
            
            end
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_INV_FIND(frame, ctrl, argStr, argNum)
    EBI_try_catch{
        try = function()
            local findstr = ctrl:GetText()
            if (not findstr or findstr == "") then
                return
            end
            g.findstr = string.lower(findstr)
            AOI_TAB_ON_CLICK(nil, nil, "Fnd", nil)
        
        end,
        catch = function(error)
            ERROUT(error)
        end
    }

end
--MSGS
function AOI_INVENTORY_ON_MSG(frame, msg, argStr, argNum)
    EBI_try_catch{
        try = function()
            if(g.initialized==false)then
                return
            end
            if msg == "INV_ITEM_ADD" then
                AOI_INV_REFRESH()
            elseif msg == 'INV_ITEM_REMOVE' then
                AOI_INV_REMOVE(argStr)
                ReserveScript("AOI_INV_REFRESH()",0.15)
            elseif msg == 'ITEM_PROP_UPDATE' or msg == "INV_ITEM_CHANGE_COUNT" then
                if(not AOI_INV_ITEM_UPDATE(argStr))then
                    AOI_INV_REFRESH()
                end
            elseif msg=="INV_ITEM_LIST_GET"then
                AOI_INV_REFRESH()
            elseif msg~="INV_DRAW_MONEY_TEXT"then
                AOI_INV_REFRESH()
            end
        end,
        catch = function(error)
            ERROUT(error)
        end
    }

end
function AOI_INV_ITEM_UPDATE(argStr)
    return EBI_try_catch{
        try = function()
            local frame = g.frame
            local slt = GET_CHILD_RECURSIVELY(frame, "aoi_slt")
            if(slt)then
                AUTO_CAST(slt)
                --find
                for i = 0, slt:GetSlotCount() - 1 do
                    local slot = slt:GetSlotByIndex(i)
                    local icon = slot:GetIcon();
                    if(icon==nil)then
                        
                    else
                        local iconInfo = icon:GetInfo();
                        local slotItem =  session.GetInvItemByGuid(iconInfo:GetIESID())
                        if(slotItem==nil)then
                            
                        else
                            if(slotItem.type ~= 900011 )then
                                local itemCls = GetIES(slotItem:GetObject())
                                if(itemCls==nil)then
                                    return false
                                end
                                
                                if slotItem and slotItem:GetIESID() == argStr and session.GetInvItemByGuid(slotItem:GetIESID() ) then
                                    INV_SLOT_UPDATE(ui.GetFrame("inventory"), slotItem, slot)
                                    local invItem=slotItem
                                    
                                    SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemCls, invItem.count, "{s14}{ol}{#FFFFFF}");
                                 
                                    
                                end
                            end
                        end
                    end
                end
            end
            return true
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_INV_FILTER(invItem)
    return EBI_try_catch{
        try = function()
            local filter = g.settings.filter or "All"
            if (filter == "All") then
                return true
            end
            if (filter == "Lim") then
                --時間制限付きか判定
                if (invItem.hasLifeTime == true) then
                    return true
                else
                    return false
                end
            end
            if (filter == "Fnd") then
                --検索
                local itemCls = GetIES(invItem:GetObject())
                local itemname = string.lower(dictionary.ReplaceDicIDInCompStr(itemCls.Name));
                if (itemname:find(g.findstr)) then
                    return true
                else
                    return false
                end
            end
            local filterdata = g.filterbyname[filter]
            if (filterdata.original) then
                local baseidcls = GET_BASEID_CLS_BY_INVINDEX(invItem.invIndex)
                
                local titleName = baseidcls.ClassName
                if baseidcls.MergedTreeTitle ~= "NO" then
                    titleName = baseidcls.MergedTreeTitle
                end
                local typeStr = GET_INVENTORY_TREEGROUP(baseidcls)
                if filterdata.original == typeStr then
                    return true
                else
                    return false
                end
            end
        
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_INV_REMOVE(guid)
    return EBI_try_catch{
        try = function()
            local frame = g.frame
            local slt = GET_CHILD_RECURSIVELY(frame, "aoi_slt")
            if(slt)then
                AUTO_CAST(slt)
                --find
                for i = 0, slt:GetSlotCount() - 1 do
                    local slot = slt:GetSlotByIndex(i)
                    AUTO_CAST(slot)
                    local icon = slot:GetIcon();
                    if(icon==nil)then
                        slot:RemoveAllChild()
                        slot:ClearIcon()
                    else
                        local iconInfo = icon:GetInfo();
                        local slotItem =  session.GetInvItemByGuid(iconInfo:GetIESID())
                        if(slotItem==nil)then
                            slot:RemoveAllChild()
                            slot:ClearIcon()
                        else
                            local itemCls = GetIES(slotItem:GetObject())
                            if(itemCls==nil)then
                                slot:RemoveAllChild()
                                slot:ClearIcon()
                            else
                            
                                if slotItem:GetIESID() == guid then
                                    slot:RemoveAllChild()
                                    slot:ClearIcon()
                                end
                            end
                        end
                    end
                end
            end
            
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_INV_REFRESH()
    return EBI_try_catch{
        try = function()
            local frame = g.frame
            local slt = GET_CHILD_RECURSIVELY(frame, "aoi_slt")
            AUTO_CAST(slt)
            local gboxslot = GET_CHILD_RECURSIVELY(frame, "aoi_gboxslt")
            AUTO_CAST(gboxslot)
            slt:RemoveAllChild()
            
            
            session.BuildInvItemSortedList();
            local sortedList = session.GetInvItemSortedList();
            local invItemCount = sortedList:size();
            local slotidx = 0
            local count = invItemCount
            local baseidclslist, baseidcnt = GetClassList("inven_baseid");
            local wlimit = math.floor((slt:GetWidth()) / slotsize)
            slt:SetSlotSize(slotsize, slotsize)
            slt:SetSpc(0, 0)
            
            slt:SetColRow(math.min(wlimit, count), math.max(1, math.ceil(count / wlimit)))
            
            
            slt:CreateSlots()
            slt:EnableDrag(1)
            slt:EnableDrop(1)
            slt:EnablePop(1)
            
            local sortedList = session.GetInvItemSortedList();
            local invItemCount = sortedList:size();
            g.invitems = {}
            for i = 0, invItemCount - 1 do
                
                local invItem = sortedList:at(i);
                if invItem ~= nil and (invItem.type ~= 900011) then --ignore silver
                    
                    local itemObj = GetIES(invItem:GetObject())
                    if(itemObj~=nil)then
                        local itemCls = GetClassByType("Item", invItem.type);
                        local useLv = TryGetProp(itemCls, "UseLv") or 1;
                        local rarity = TryGetProp(itemCls, "ItemGrade");
                        local itemLv = TryGetProp(itemCls, "ItemLv") or 1;
                        local gemLv= itemObj.ItemExp or 0
                        g.invitems[#g.invitems + 1] = {
                            item = invItem,
                            name = string.lower(dictionary.ReplaceDicIDInCompStr(itemCls.Name)),
                            amount = invItem.count,
                            level = math.max(useLv, itemLv,gemLv or 1),
                            rarity = rarity
                        }
                    end
                end
            end
            --ソート
            if (g.settings.sortby) then
                
                if (g.settings.sortorder~=0) then
                    table.sort(g.invitems, function(a, b)
                            
                            local compareresult
                            for _, v in ipairs(g.settings.sortby) do
                                local eq = false
                               
                                compareresult = a[v] < b[v]
                                eq = a[v] == b[v]
                                
                                if (not eq) then
                                    return compareresult
                                end
                            end
                            return compareresult
                    end)
                else
                    table.sort(g.invitems, function(a, b)
                        local compareresult = 0
                        for _, v in ipairs(g.settings.sortby) do
                            local eq = false
                            
                            compareresult = a[v] > b[v]
                            eq = a[v] == b[v]
                            
                            if (not eq) then
                                return compareresult
                            end
                        end
                        return compareresult
                    end)
                end
            end
            g.invrefresher = 1
            g.invrefresh = true
            g.invrefresheridx = 0
            g.invrefreshcooldown=10
            return 0
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_INV_REFRESHENER()
    local frame = g.frame
    local sortedList = session.GetInvItemSortedList();
    local invItemCount = sortedList:size();
    local slotidx = g.invrefresheridx or 0
    local slt = GET_CHILD_RECURSIVELY(frame, "aoi_slt")
    
    local cancel = false
    local limit = 30
    for i = g.invrefresher, #g.invitems do
        local slot = slt:GetSlotByIndex(slotidx)
        local invItem = g.invitems[i].item
        if (slotidx >= #g.invitems) then
            cancel = true
            break
        end
        
        local itemCls = GetIES(invItem:GetObject())
        
        
        if (itemCls~= nil and AOI_INV_FILTER(invItem)) then
            --local remainInvItemCount = GET_REMAIN_INVITEM_COUNT(invItem);
            UPDATE_INVENTORY_SLOT(slot, invItem, itemCls);
            
            INV_SLOT_UPDATE(ui.GetFrame("inventory"), invItem, slot);
            local slotFont = frame:GetUserConfig("TREE_SLOT_TEXT_FONT")
            
            if ui.GetFrame("oblation_sell"):IsVisible() == 1 then
                SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemCls, invItem.count, "{s14}{ol}{#FFFFFF}");
            else
                SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemCls, invItem.count, "{s14}{ol}{#FFFFFF}");
            end
            
            --minify itemlock
            local lock = GET_CHILD(slot, "itemlock")
            if (lock) then
                local img = GET_CHILD(lock, "image", "ui::CPicture")
                img:Resize(img:GetWidth() / 2, img:GetHeight() / 2)
                img:SetEnableStretch(1)
                img:SetGravity(ui.RIGHT, ui.TOP)
            end
            --minify itemtext
            local text=slot:GetText()
            if(text and text:find("LV"))then
                text=text:gsub("{s.*}LV.(%d*)","{s14}{ol}{#FFFFFF}{b}L%1")
                slot:SetText(text)
            end
            g.originalfunc = slot:GetEventScript(ui.LBUTTONDOWN)
            slot:SetEventScript(ui.LBUTTONDOWN, "AOI_SLOT_ON_LBUTTTONDOWN");
            slot:EnableDrag(1)
            
            slotidx = slotidx + 1
            g.invrefresheridx = slotidx
            limit = limit - 1
        
        end
        
        g.invrefresher = i
        if (limit == 0) then
            break
        end
    end
    if (g.invrefresher >= (invItemCount - 1) or cancel) then
        g.invrefresh = false
    end
end
function AOI_ON_TIMER()
    EBI_try_catch{
        try = function()
            if (g.invrefresh) then
                if(g.invrefreshcooldown>0)then
                    g.invrefreshcooldown=g.invrefreshcooldown-1
                else
                    AOI_INV_REFRESHENER()
                end
            end
            if (g.resizing == 1) then
                if mouse.IsLBtnPressed() == 0 then
                    AOI_RESIZE()
                    AOI_INV_REFRESH()
                    g.resizing = 0
                end
            end
            if mouse.IsLBtnPressed() ~= 0 then
                g.liftdelay = 3
            else
                --recover
                if (g.lifticon) then
                    
                    if (g.liftdelay > 0) then
                        
                        g.liftdelay = g.liftdelay - 1
                    else
                        
                        g.lifticon = false
                        g.liftslot:EnableDrag(0)
                        g.liftdelay = nil
                        g.frame:SetName(g.framename)
                        g.invenframe = ui.GetFrame("inventory")
                        local original = ui.GetFrame("inventory")
                        original:SetName("inventory")
                    end
                end
            end
        
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end

function AOI_SLOT_ON_LBUTTTONDOWN(frame, ctrl, argstr, argnum)
    EBI_try_catch{
        try = function()
            
            --AUTO_CAST(ctrl)
            
            -- pretend frame trick
            g.lifticon = true
            g.liftslot = ctrl
            
            _G[g.originalfunc](g.invenframe, ctrl, argstr, argnum)
            ReserveScript("AOI_SLOT_STARTDRAG()", 0.01)
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_SLOT_STARTDRAG()
    EBI_try_catch{
        try = function()
            local frame = g.frame
            local original = ui.GetFrame("inventory")
            g.frame:SetName("inventory")
            original:SetName("inventory")
        
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_CHECK_FRAME()
    local frames = {
        "warehouse",
        "accountwarehouse",
        "itemcraft",
        "reinforce_by_mix",
        "reinforce_by_mix_certific",
        "shop",
        "oblation_sell",
        "legendcardupgrade",
    
    }
    for _, v in ipairs(frames) do
        if ui.IsFrameVisible(v) then
            return ui.GetFrame(v)
        end
    end
    return nil
end
function AOI_ON_RESIZE()
    g.resizing = 1
    AOI_SAVE_POSITION()
end
function AOI_SAVE_POSITION()
    EBI_try_catch{
        try = function()
            local frame = ui.GetFrame(g.framename)
        
            g.settings.x = frame:GetX()
            g.settings.y = frame:GetY()
            g.settings.w = frame:GetWidth()
            g.settings.h = frame:GetHeight()
            ANOTHERONEOFINVENTORY_SAVE_SETTINGS()
           
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end
function AOI_CHANGE_SORT_DESCENDING(dsc)
    g.settings.sortorder = dsc
    g.settings.sortby = g.settings.sortby or {"name"}
    AOI_INV_REFRESH()
    ANOTHERONEOFINVENTORY_SAVE_SETTINGS()
end
function AOI_CHANGE_SORT_BY(names)
    g.settings.sortby = names
    g.settings.sortorder = g.settings.sortorder or 0
    AOI_INV_REFRESH()
    ANOTHERONEOFINVENTORY_SAVE_SETTINGS()
end
function AOI_ON_RCLICK()
    EBI_try_catch{
        try = function()
            local frame = ui.GetFrame(g.framename)
            local context = ui.CreateContextMenu("aoi_contextmenu", "", 0, 0, 300, 100);
            ui.AddContextMenuItem(context, "Sort Ascending", "AOI_CHANGE_SORT_DESCENDING(0)");
            ui.AddContextMenuItem(context, "Sort Descending", "AOI_CHANGE_SORT_DESCENDING(1)");
            ui.AddContextMenuItem(context, "Sort by Name", "AOI_CHANGE_SORT_BY({'name'})");
            ui.AddContextMenuItem(context, "Sort by Level", "AOI_CHANGE_SORT_BY({'level','name'})");
            ui.AddContextMenuItem(context, "Sort by Rarity", "AOI_CHANGE_SORT_BY({'rarity','name')}");
            ui.AddContextMenuItem(context, "Sort by Level-Rarity", "AOI_CHANGE_SORT_BY({'level','rarity','name'})");
            
            context:Resize(200, context:GetHeight());
            ui.OpenContextMenu(context);
        end,
        catch = function(error)
            ERROUT(error)
        end
    }
end

AOI_VALUES = g
