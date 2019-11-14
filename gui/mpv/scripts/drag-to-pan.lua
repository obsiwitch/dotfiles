-- simplified https://github.com/occivink/mpv-image-viewer
function drag_to_pan(table)
    if table["event"] == "down" then
        local mxold, myold = mp.get_mouse_pos()
        mp.add_forced_key_binding(
            "mouse_move", "gallery-mouse-move", function()
                local mxnew, mynew = mp.get_mouse_pos()
                local dpx = (mxnew - mxold) / mp.get_property("osd-width")
                local dpy = (mynew - myold) / mp.get_property("osd-height")
                mp.command("no-osd add video-pan-x " .. dpx)
                mp.command("no-osd add video-pan-y " .. dpy)
                mxold, myold = mxnew, mynew
            end
        )
    elseif table["event"] == "up" then
        mp.remove_key_binding("gallery-mouse-move")
    end
end

mp.add_key_binding(nil, "drag-to-pan", drag_to_pan, {complex = true})
