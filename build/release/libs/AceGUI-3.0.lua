-- AceGUI-3.0 stub
local AceGUI = {}
AceGUI.WidgetRegistry = {}
AceGUI.LayoutRegistry = {}

function AceGUI:New()
    return {}
end

function AceGUI:RegisterWidgetType(name, constructor)
    self.WidgetRegistry[name] = constructor
end

function AceGUI:RegisterLayout(name, layout)
    self.LayoutRegistry[name] = layout
end

AceGUI.WidgetBase = {}
AceGUI.WidgetContainer = {}
AceGUI.WidgetInteractive = {}

_G.AceGUI = AceGUI
