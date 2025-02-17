module("luci.controller.yacd", package.seeall)

function index()
    entry({"admin", "system", "yacd"}, call("action_yacd"), "YACD", 95)
end

function action_yacd()
    local sys = require "luci.sys"
    -- 获取 LAN IP 地址
    local lan_ip = sys.exec("ip addr show dev br-lan | grep inet | awk '{print $2}' | cut -d'/' -f1 | head -n 1")

    -- 记录获取到的 IP 地址
    luci.sys.call("logger -t YACD 'LAN IP: " .. lan_ip .. "'")  -- 记录日志

    -- 构建重定向的 URL，去掉多余空格
    local redirect_url = "http://" .. lan_ip .. ":9090/ui/yacd/?hostname=" .. lan_ip .. "&port=9090&secret=pBwYtZuN"
    
    -- 去除 URL 中的多余空格
    redirect_url = redirect_url:gsub("%s+", "")

    -- 记录重定向的 URL
    luci.sys.call("logger -t YACD 'Redirecting to: " .. redirect_url .. "'")  -- 记录重定向的 URL

    -- 调试：检查服务器是否可以访问
    local check_connection = sys.exec("curl -s --head " .. redirect_url)

    -- 如果 `check_connection` 为 nil，则设置默认值
    if not check_connection or check_connection == "" then
        check_connection = "No response"
    end

    -- 记录连接检查结果
    luci.sys.call("logger -t YACD 'Connection check result: " .. check_connection .. "'")  -- 记录连接检查结果

    -- 重定向到构建好的 URL
    luci.http.redirect(redirect_url)
end
