package.path = 'modules/?/?.lua;'..package.path
package.path = 'modules/hump/?.lua;'..package.path

function love.conf(t)
    t.window.title = ''
    t.window.fullscreen = false
    t.window.resizable = false
    t.window.vsync = true
    t.window.width = 640
    t.window.height = 400
end
