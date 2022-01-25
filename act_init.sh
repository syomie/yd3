#!/bin/bash
#####################################
# @author : syomie <158199196@qq.com>
# @created : 2022/1/24
#####################################
function set_env() {
  # 设置管理变量
  # set_env 键 值
  echo "$1=$2" >>$GITHUB_ENV
}

function set_output() {
  # 设置步骤输出
  # set_output 键 值
  echo "::set-output name=$1::$2"
}

function echo_end(){
  echo "::endgroup::"
}

function echo_start(){
  # 日志分组显示 分组名称
  # 配合 echo_end使用
  echo "::group::$1"
}

function debug() {
  # 输出debug信息
  # 基础日志需要仓库设置机密ACTIONS_RUNNER_DEBUG true
  # 步骤级别日志需要仓库设置机密ACTIONS_STEP_DEBUG true
  echo "::debug::$1"
}

function check() {
  # 检查需要的变量
  for i in $@; do
    [[ "$i" ]] && break
    debug "缺少参数。"
  done
}

function issue_comment() {
  # 提交问题评论
  # args: 回复内容
  check $GITHUB_TOKEN $issue_id "$1"
  gh issue comment $issue_id -b "$1"
}

function issue_set_label() {
  # 添加问题标签 args: 要添加的标签 要移除的标签
  # 仓库已存在的标签 多个标签以","分割
  check $GITHUB_TOKEN $issue_id "$issue_body" "$1"
  if [[ $1 && $2 ]]; then
    gh issue edit $issue_id --add-label "$1" --remove-label "$2"
  elif [[ $2 ]]; then
    gh issue edit $issue_id --remove-label "$2"
  else
    gh issue edit $issue_id --add-label "$1"
  fi
}

function issue_close() {
  # 关闭指定指定的问题
  check $GITHUB_TOKEN "$1"
  gh issue close "$1"
}

function git_set_bot() {
  # git设置机器人信息
  git config user.name 'github-actions'
  git config user.email 'github-actions@users.noreply.github.com'
}

function auto_labels() {
  # 问题自动贴标
  # 对比$1或当前提问正文贴标签

  echo_start 自动处理提问
  check $GITHUB_TOKEN $issue_id

  # 0 不回复
  # 1 和书源相关
  # 2 和替换相关
  local comment=""
  local type=()

  if [[ "$1" ]] ;then
    local str="$1"
    debug "发现传入内容"
  elif [[ "$issue_body" ]];then
    local str="$issue_body"
    debug "默认分析正文"
  else
    debug "没有需要分析的内容"
    echo_end
    return true
  fi

  debug "开始对以下内容进行关键字匹配:"
  debug "$str"

  if [[ "$str" =~ "书源" ]]; then
    issue_set_label $issue_num "书源"
    type+="书源"
  fi

  if [[ "$str" =~ "替换规则" ]]; then
    issue_set_label $issue_num "替换"
    type+="替换"
  fi

  if [[ "$str" =~ "作http|添加http|新增http" ]]; then
    issue_set_label $issue_num "新增"
    if [[ $type =~ "新增" ]]; then
      comment="正在尝试为您自动生成书源。\n"
      # @TODO 自动生成书源
    fi
  fi

  if [[ "$str" =~ "失效|不能用了" ]]; then
    issue_set_label $issue_num "失效"
    [[ $type =~ "书源" ]] && comment+="您可能想要反馈失效书源，已帮您通知 @syomie ，请您耐心等待。\n"
    [[ $type =~ "替换" ]] && comment+="您可能想要反馈规则失效，已帮您通知 @syomie ，请您耐心等待。\n"
  fi

  [[ $comment ]] && issue_comment "$comment"

  if [[ ${#type} -gt 0 ]]; then
    debug "设置了${#type}个标签。"
  else
    debug "没有找到合适的标签。"
  fi
  echo_end
}

debug "所有函数导入成功"
