#!/bin/bash
#####################################
# @author : syomie <158199196@qq.com>
# @created : 2022/1/24
#####################################
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

  if [[ "$1" ]]; then
    local str="$1"
    debug "发现传入内容"
  elif [[ "$issue_body" ]]; then
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
      comment="   没想到这个世界重力如此之强，连斗帝在空中也坚持不了太久，老牌斗帝强者确实很强，不过消炎并不担心被追上来，因为同为斗帝，他的斗气化马比身后斗帝的马快。
    策马奔驰的消炎心思百转，实际上外界不过一瞬间而已，正在此时，身后传来一股可啪的能量波动。
    消炎顿觉毛骨悚然，来不及回头，裆下掏出一个长着兔耳朵的少女人偶，向上祭出。
    说起这个人偶可不简单，这是他第一次跨世界时在异世界一个叫唐门的组织中缴获的战利品，叫做魂环。
    所谓魂环，简单来说：立于头顶，先就不败。
    虽然夸张了点不过确实可怕，当时被身为普通人的唐*立于头顶，居然能抵挡消炎斗帝级的攻击，最后实在没办法，逼的消炎灭了整个唐门,得知消息的唐*气的吐血没拿稳魂环，也才被消炎一口唾沫穿心而亡，威能可想而知，可惜似乎和此方世界冲突，威能大减。

    “居然打破了世界壁，我感受到了来自异世界源的气息！”
    貂蝉是一位帝源师，她收到消息，此地有源的气息，没想到居然见识了这样一场惊天之战，还好她身为帝源师，在拥有源气息的地方都可以使用本源庇护:无敌。
    所谓无敌，只要她不把别人当做敌人，别人就伤不到她，也不会对她产生敌意，甚至主动把她当成最重要的人，可惜只能在有源气息或源所在的地方才能施展，限制太大，不然就真无敌了。

    “还好这里有源的气息，这种好机会可不多，去拿点礼物……”
    这样想着，貂蝉走上前去对骑马追逃的二人施了一礼，心中默念……
    “……无敌……”

    消炎和后方斗帝心头一颤，感觉哪里不对，却不知为何，见少女向他们行礼，纷纷下马走了过来。

    “姑娘可有要事？” x2
    消炎和老牌斗帝一人牵着一匹马，并排而立，想貂蝉问道。

    “小女子欲往异界寻源，恐界遥路远，无至宝护身，还望二位前辈怜悯，将手中宝物借予一二。”
    貂蝉心中自我催眠：“他们是我亲戚……他们是我亲戚……”
    “既然如此，我将我的一半本源借给你吧！”老牌斗帝从心口缓缓取出一团七色光团，满头大汗面色惨白，颤抖着手，将光团递向她。
    “好东西！”貂蝉赶忙接住，看了老牌斗帝一眼，面色平静，“前辈,大恩不言谢，祝您早死早投胎。”
    丢掉一半斗帝本源，这货元气大伤寿元无多，离死不远了，他扭头看向消炎。
    消炎正想着哪里不对，见貂蝉望向自己，也想不出给什么好，便把自己储物戒一摘递给了貂蝉，让她自己拿……
    “多谢前辈厚赐，我还缺个脚力，不如前辈这马也送我吧，对了，我是学生，麻烦加二北块……呸呸呸……麻烦加点斗气……加满”
    和另一个斗帝的一半本源比起来，貂蝉实在看不上储物戒的东西，为旅途做起准备。

    ……

    “又制止了一场灾难，为万界和平做出了贡献那”
    貂蝉骑在马上点了点收获，心花怒放，灿烂心情洋溢在脸上，止不住的笑容更显光艳照人。

    此时，正在貂蝉骑马赶来的路上……
    “唉……走吧，赶紧离开这里！”
    回过神来的老牌斗帝和消炎对视一眼，哪里还有要大打出手的样子，相互搀扶着，二人衣衫褴褛，面色愁苦，一副难兄难弟的模样，至于去抢回来？不敢去啊，没东西送了……

    此时，貂蝉正在骑马赶来的路上……
    请您耐心等待!"
      # comment="正在尝试为您自动生成书源。\n"
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

function update_book_source(){
  debug "聚合所有书源"
  json_dirs=()
  idx=1
  for i in share not_recommend
  do 
    debug "检测目录${i}是否存在..."
    if [[ ! -d ${i}/ ]];then
      debug "创建目录...${i}/"
      mkdir $i
    fi
    debug "检测目录${i}是否需要后续操作..."
    if [[  $(ls ${i}/ | wc -l) > 0 ]];then
      debug "添加目录..."
      json_dirs[$idx]=$i
      idx=$[ $idx + 1 ]
    fi
  done
  debug "聚合所有书源"
  jq -s '.' $(find ${json_dirs[@]} -name "*.json") > bookSource.json
  debug "重置所有书源"
  rm $(find ${json_dirs[@]} -name "*.json")
  debug "重新分割书源"
  python bot/rules_split.py $@
  debug "重新生成书源"
  for i in $json_dirs
  do 
    [[ $(ls ${i}/ | wc -l) > 0 ]] && jq -s '.' $i/*.json > $i.json
  done
  debug "修正书源文件名"
  [[ -f share.json ]] && mv share.json bookSource.json
  debug "书源已更新"
}

function update_readme() {
  debug "进行README更新"
  [[ $GITHUB_WORKSPACE ]] && cd $GITHUB_WORKSPACE
  README=README.md
  time="$(TZ=UTC-8 date +%Y-%m-%d' '%H:%M:%S)"
  t="$(date +%s)"
  sourceCount="$(ls share/ | wc -l)"
  debug "更新README.md"
  sed -r -i \
    -e "s@(书源总数[: -]\s?)[0-9]*@\1$sourceCount@g" \
    -e "s@(更新时间: ).*@\1$time@g" \
    $README
}

debug "所有函数导入成功"
