# 设置 root 用户的密码
root_password="PayCRNTbzRu3ypsXL@892515357"
if [ -n "$root_password" ]; then
  (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
fi

uci set system.@system[0].hostname='XWRT'
