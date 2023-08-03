require("core.set")
require("core.remap")

function R(name)
    require("plenary.reload").reload_module(name)
end
