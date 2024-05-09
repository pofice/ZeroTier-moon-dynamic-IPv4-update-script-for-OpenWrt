# ZeroTier-moon-dynamic-IPv4-update-script-for-OpenWrt
适用于OpenWrt的ZeroTier moon动态IPv4更新脚本（可用于DDNS）

将脚本放在该目录下
```
/etc/config/zero/
```
使用crontab来定时执行脚本，输入以下命令来编辑当前用户的crontab文件：
```
crontab -e
```
然后在打开的编辑器中添加一行如下的内容，表示每天凌晨4点执行update_moon.sh脚本：
```
0 4 * * * /etc/config/zero/update_moon.sh
```
保存并退出编辑器。这会将指定的命令添加到用户的crontab中，使其每天凌晨2点自动执行。