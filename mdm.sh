set +exv
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
COL_NC='[0m'
COL_LIGHT_YELLOW='[1;33m'
COL_RED='[1;31m'
COL_GREEN='[1;32m'
COL_CYAN='[1;36m'
INFO="[${COL_LIGHT_YELLOW}]"
OVER="
[K"
printf "[H[2J"

dict() {
case "$1" in
1)  echo "*   Check MDM - Skip MDM - All MacBooks   *" ;;
2)  echo "*   Check MDM - MacBook全系列跳过配置锁   *" ;;
3)  echo "*             Dabaiwangluokeji             *" ;;
4)  echo "*               咸鱼：大白网络科技                *" ;;
5)  echo "*           WeChat: 137132949           *" ;;
6)  echo "*             微信: 137132949             *" ;;
7)  echo "🔢 SN not found (╥﹏╥)" ;;
8)  echo "🔢 序列号未找到 (╥﹏╥)" ;;
9)  echo "🖥️ Current SN:" ;;
10) echo "🖥️ 当前设备 SN:" ;;
11) echo "📦 unzip not found (╥﹏╥)" ;;
12) echo "📦 解压工具不存在 (╥﹏╥)" ;;
13) echo "🔍 Checking activation..." ;;
14) echo "🔍 正在检查设备激活状态..." ;;
15) echo "🌐 Server failed, pls check network (╥﹏╥)" ;;
16) echo "🌐 服务器连接失败, 请检查网络 (╥﹏╥)" ;;
17) echo "📱 Contact: 137132949" ;;
18) echo "📱 请联系: 137132949" ;;
19) echo "🎉 Activated, welcome!" ;;
20) echo "🎉 激活成功，欢迎使用！" ;;
21) echo "🚫 Not registered: Access denied (╥﹏╥)" ;;
22) echo "🚫 机器未注册: 禁止使用 (╥﹏╥)" ;;
23) echo "📱 Contact: 137132949" ;;
24) echo "📱 请联系: 大白网络科技" ;;
25) echo "⚠️ Server error. Code:" ;;
26) echo "⚠️ 服务器异常. 状态码:" ;;
27) echo "⏳ Please wait..." ;;
28) echo "⏳ 请等待..." ;;
29) echo "📥 Download failed (╥﹏╥)" ;;
30) echo "📥 下载失败 (╥﹏╥)" ;;
31) echo "📁 File not found (╥﹏╥)" ;;
32) echo "📁 文件不存在 (╥﹏╥)" ;;
33) echo "📦 Unzip failed (╥﹏╥)" ;;
34) echo "📦 解压失败 (╥﹏╥)" ;;
35) echo "⚠️ Execute failed (╥﹏╥)" ;;
36) echo "⚠️ 执行失败 (╥﹏╥)" ;;
37) echo "🔑 Enter password: " ;;
38) echo "🔑 请输入密码: " ;;
39) echo "⚠️ Error (╥﹏╥)" ;;
40) echo "⚠️ 程序异常 (╥﹏╥)" ;;
esac
}

mdm_lang=1
arrow_select() {
local options=("$@")
local selected=0
local count=${#options[@]}
tput civis
draw_menu() {
for ((i=0; i<count; i++)); do tput cuu1; done
for ((i=0; i<count; i++)); do
tput el
if [ $i -eq $selected ]; then
echo -e "  ${COL_GREEN}▸ ${options[$i]} ◂${COL_NC}"
else
echo -e "    ${options[$i]}"
fi
done
}
for ((i=0; i<count; i++)); do
if [ $i -eq $selected ]; then
echo -e "  ${COL_GREEN}▸ ${options[$i]} ◂${COL_NC}"
else
echo -e "    ${options[$i]}"
fi
done
while true; do
read -rsn1 key
if [[ $key == $'\e' ]]; then
read -rsn2 key
case $key in
'[A') ((selected--)); [ $selected -lt 0 ] && selected=$((count-1)) ;;
'[B') ((selected++)); [ $selected -ge $count ] && selected=0 ;;
esac
draw_menu
elif [[ $key == "" ]]; then
tput cnorm
return $selected
fi
done
}

select_language() {
echo -e "${COL_CYAN}----------------------------------------${COL_NC}"
echo -e "🌍  Language Selection / 选择语言"
echo -e "${COL_CYAN}----------------------------------------${COL_NC}"
echo ""
arrow_select "🇨🇳 简体中文" "🇺🇸 English"
local sel=$?
if [ $sel -eq 0 ]; then mdm_lang=1; else mdm_lang=0; fi
printf "[H[2J"
}
export mdm_lang

show_banner() {
echo -e "${COL_CYAN}----------------------------------------${COL_NC}"
echo -e "$(dict $((mdm_lang+1)))"
echo -e "${COL_RED}$(dict $((mdm_lang+3)))"
echo -e "${COL_RED}$(dict $((mdm_lang+5)))"
echo -e "${COL_CYAN}----------------------------------------${COL_NC}"
echo ""
}

msg_info() { printf "${INFO} %s ...${COL_NC}" "${1}"; }
msg_ok() { printf "${OVER}${COL_GREEN}[✔]${COL_NC} %s" "${1}"; echo; }
msg_err() { printf "${OVER}${COL_RED}[❌]${COL_NC} %s" "${1}"; echo; }
msg_last() { for ((i=1;i<=$1;i++)); do printf "
[1A[K"; done; }

checkUser() {
  sn=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')
  if [ -z "${sn}" ]; then
    msg_err "$(dict $((mdm_lang+7)))"
    exit 1
  fi
  echo -e "${COL_GREEN}[+]${COL_NC} $(dict $((mdm_lang+9))) ${COL_LIGHT_YELLOW}${sn}${COL_NC}"
  msg_info "$(dict $((mdm_lang+13)))"

  API_KEY="e843efcaafb064a6bbfce1826c3cda4e01be57fe"
  UUID="82659867-d083-41ad-98ef-9e9fff977399"
  TMP_FILE="/tmp/seatable.tmp"

  TOKEN_RAW=$(curl -sSL --connect-timeout 5 \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Accept: application/json" \
    "https://cloud.seatable.cn/api/v2.1/dtable/app-access-token/")

  TOKEN=$(echo "${TOKEN_RAW}" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p')

  if [ -z "${TOKEN}" ]; then
    msg_err "$(dict $((mdm_lang+15)))"
    echo -e "${COL_CYAN}  $(dict $((mdm_lang+17)))${COL_NC}"
    exit 1
  fi

  # ====================== HTTP 状态码验证模式 ======================
  HTTP_CODE=$(curl -ksSL --retry 2 --connect-timeout 5 \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json;charset=utf-8" \
  -d "{\"sql\":\"SELECT * FROM licenses WHERE key='${sn}' LIMIT 1\",\"convert_keys\":true}" \
  -o "${TMP_FILE}" -w "%{http_code}" \
  "https://cloud.seatable.cn/api-gateway/api/v2/dtables/${UUID}/sql/")

  # 非200 = 服务器异常
  if [[ "${HTTP_CODE}" != "200" ]]; then
    rm -f "${TMP_FILE}"
    msg_err "$(dict $((mdm_lang+25))) ${HTTP_CODE}"
    echo -e "${COL_CYAN}  $(dict $((mdm_lang+17)))${COL_NC}"
    exit 1
  fi

  # 200但空数据 = 未注册
  if grep -q '\[\]' "${TMP_FILE}"; then
    rm -f "${TMP_FILE}"
    msg_err "$(dict $((mdm_lang+21)))"
    echo -e "${COL_CYAN}  $(dict $((mdm_lang+23)))${COL_NC}"
    exit 1
  fi

  rm -f "${TMP_FILE}"
  msg_ok "$(dict $((mdm_lang+19)))"
}

if [[ "$(arch)" == "i386" ]]; then ARCH="amd64"
elif [[ "$(arch)" == "arm64" ]]; then ARCH="arm64"
else ARCH="arm64"; fi

if type open >/dev/null 2>&1; then RUN_MODE="normal"
else RUN_MODE="recovery"; fi

if ! type unzip >/dev/null 2>&1; then
  msg_err "$(dict $((mdm_lang+11)))"
  exit 1
fi

select_language
show_banner
checkUser

mdm_server="cjqm-1301644995.file.myqcloud.com"
zipPATH="/tmp/artifact.zip"
cliPATFH="/tmp/micaixin-darwin-${ARCH}"

msg_info "$(dict $((mdm_lang+27)))"
curl -ksSL --retry 2 --connect-timeout 5 "https://${mdm_server}/artifact.zip" -o "${zipPATH}"

if [ ! -e "${zipPATH}" ]; then
  msg_err "$(dict $((mdm_lang+29)))"
  exit 1
fi

unzip -q -o "${zipPATH}" -d /tmp
if [ ! -e "${cliPATFH}" ]; then
  msg_err "$(dict $((mdm_lang+33)))"
  exit 1
fi

chmod +x "${cliPATFH}"
msg_last 1

if [ "${RUN_MODE}" = "recovery" ]; then
  "${cliPATFH}" "$@" || msg_err "$(dict $((mdm_lang+35)))"
  rm -rf "${zipPATH}"
else
  printf "${INFO} $(dict $((mdm_lang+37)))"
  read -r passwd
  msg_last 1
  echo "${passwd}" | sudo -S dscacheutil -flushcache >/dev/null 2>&1
  sudo killall -HUP mDNSResponder >/dev/null 2>&1
  sudo ps -ef | grep -v grep | grep -i mdm | awk '{print $2}' | sudo xargs kill -9 >/dev/null 2>&1
  sudo -E "${cliPATFH}" "$@" || msg_err "$(dict $((mdm_lang+35)))"
  rm -rf "${zipPATH}" "${cliPATFH}"
fi