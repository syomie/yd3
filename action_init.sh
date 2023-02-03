#!/bin/bash

function set_env() {
  # 设置管理变量
  # set_env 键 值
  echo "$1=$2" >> $GITHUB_ENV
}

function set_output() {
  # 设置步骤输出
  # set_output 键 值
  echo "::set-output name=$1::$2"
}

function echo_end() {
  echo "::endgroup::"
}

function echo_start() {
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
  gh issue close "$1"
}

function git_set_bot() {
  # git设置机器人信息
  git config user.name 'github-actions'
  git config user.email 'github-actions@users.noreply.github.com'
}

function update_readme() {
  debug "进行README更新"
  [[ $GITHUB_WORKSPACE ]] && cd $GITHUB_WORKSPACE
  README=README.md
  time="$(TZ=UTC-8 date +%Y-%m-%d' '%H:%M:%S)"
  t="$(date +%s)"
  debug "更新README.md"
  sed -r -i "s@(更新时间: ).*@\1$time@g" $README
}

debug "所有函数导入成功"
